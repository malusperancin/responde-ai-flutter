import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/question.dart';
import '../model/user.dart';

class FirestoreProvider {
  static FirestoreProvider helper = FirestoreProvider._();
  FirestoreProvider._();

  final CollectionReference questionsCollection = 
      FirebaseFirestore.instance.collection("questions");
  
  final CollectionReference usersCollection = 
      FirebaseFirestore.instance.collection("users");

  final StreamController<List<Question>> _questionsController = 
      StreamController<List<Question>>.broadcast();

  Stream<List<Question>> get questionsStream => _questionsController.stream;

  final Map<String, String> _nameCache = {};

  Future<void> insertQuestion(Question question) async {
    try {
      await questionsCollection.add(question.toJson());
      await loadQuestions();
    } catch (e) {
      throw Exception('Erro ao inserir pergunta: $e');
    }
  }

  Future<void> answerQuestion(String questionId, String answer, String userId) async {
    try {
      final now = DateTime.now();
      await questionsCollection.doc(questionId).update({
        'answer': answer,
        'answeredByUserId': userId,
        'answerDate': '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}',
        'answerTime': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      });
      await loadQuestions();
    } catch (e) {
      throw Exception('Erro ao responder pergunta: $e');
    }
  }

  Future<void> loadQuestions() async {
    try {
      QuerySnapshot snapshot = await questionsCollection
          .orderBy('timestamp', descending: true)
          .get();

      List<Question> questions = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Question.fromJson(data);
      }).toList();

      _questionsController.add(questions);
    } catch (e) {
      throw Exception('Erro ao carregar perguntas: $e');
    }
  }

  Future<List<Question>> getUserQuestions(String userId) async {
    try {
      QuerySnapshot snapshot = await questionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Question.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar perguntas do usuário: $e');
    }
  }

  Future<void> saveUser(User user) async {
    try {
      await usersCollection.doc(user.uid).set(
        user.toFirestore(),
        SetOptions(merge: true),
      );
      if (user.name.isNotEmpty) {
        _nameCache[user.uid] = user.name;
      }
    } catch (e) {
      throw Exception('Erro ao salvar usuário: $e');
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        final user = User.fromFirestore(doc);
        if (user.name.isNotEmpty) {
          _nameCache[uid] = user.name;
        }
        return user;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  Future<String> getUserName(String uid) async {
    if (_nameCache.containsKey(uid)) {
      return _nameCache[uid]!;
    }

    try {
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final name = data?['name'] as String? ?? 'Usuário';
        _nameCache[uid] = name;
        return name;
      }
      return 'Usuário';
    } catch (e) {
      return 'Usuário';
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(uid).update(data);
      if (data.containsKey('name')) {
        _nameCache[uid] = data['name'];
      }
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  void clearCache() {
    _nameCache.clear();
  }

  void dispose() {
    _questionsController.close();
  }
}