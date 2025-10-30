import 'package:flutter/material.dart';
import '../../../model/question.dart';
import 'question_widget.dart';
import 'answer_widget.dart';
import 'answer_field_widget.dart';
import '../../shared/shared.dart';

class QuestionAnswerCard extends StatefulWidget {
  final Question question;
  final Function(String)? onAnswer;

  const QuestionAnswerCard({
    super.key,
    required this.question,
    this.onAnswer,
  });

  @override
  State<QuestionAnswerCard> createState() => _QuestionAnswerCardState();
}

class _QuestionAnswerCardState extends State<QuestionAnswerCard> {
  bool _expanded = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAnswerPressed() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _onSubmitPressed() async {
    final answer = _controller.text.trim();
    if (answer.isEmpty) {
      CustomModal.show(
        context,
        text: 'Por favor, digite uma resposta',
        buttonText: 'OK',
      );
      return;
    }

    try {
      if (widget.onAnswer != null) {
        widget.onAnswer!(answer);
        CustomModal.show(
          context,
          text: 'Resposta enviada com sucesso!',
          buttonText: 'OK',
        );
      }
      setState(() {
        _expanded = false;
        _controller.clear();
      });
    } catch (e) {
      CustomModal.show(
        context,
        text: 'Erro ao enviar resposta. Tente novamente.',
        buttonText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool answered = widget.question.answer != null && widget.question.answer!.isNotEmpty;
    
    if (!answered) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionWidget(
                userId: widget.question.userId,
                date: widget.question.date,
                time: widget.question.time,
                text: widget.question.description,
              ),
              if (!_expanded && widget.onAnswer != null)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD5DAE0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC3C8CE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F82B2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _onAnswerPressed,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            'Responder',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_expanded)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD5DAE0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: AnswerFieldWidget(
                      controller: _controller,
                      onSubmit: _onSubmitPressed,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuestionWidget(
              userId: widget.question.userId,
              date: widget.question.date,
              time: widget.question.time,
              text: widget.question.description,
            ),
            AnswerWidget(
              userId: widget.question.answeredByUserId ?? widget.question.userId,
              date: widget.question.answerDate ?? widget.question.date,
              time: widget.question.answerTime ?? widget.question.time,
              answer: widget.question.answer!,
            ),
          ],
        ),
      );
    }
  }
}
