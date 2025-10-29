# 🔥 Firebase Configuration

Este projeto usa diferentes arquivos de configuração do Firebase para diferentes ambientes.

## 📁 Estrutura dos Arquivos

```
lib/
├── firebase_options.dart          # ✅ Público - Usa String.fromEnvironment()
├── firebase_options_dev.dart      # 🚫 Privado - Configurações de desenvolvimento
└── firebase_options_prod.dart     # 🚫 Privado - Configurações de produção
```

## 🚀 Como Usar

### Desenvolvimento Local:
```dart
// main.dart
import 'firebase_options_dev.dart'; // 👈 Para desenvolvimento
```

### Produção:
```dart
// main.dart
import 'firebase_options_prod.dart'; // 👈 Para produção
```

### Com Variáveis de Ambiente:
```dart
// main.dart
import 'firebase_options.dart'; // 👈 Usa String.fromEnvironment()
```

## 🔒 Segurança

- `firebase_options_dev.dart` e `firebase_options_prod.dart` estão no `.gitignore`
- Apenas `firebase_options.dart` é commitado (sem credenciais hardcoded)

## 🛠️ Scripts Disponíveis

```bash
# Desenvolvimento com suas credenciais
flutter run -d chrome
```