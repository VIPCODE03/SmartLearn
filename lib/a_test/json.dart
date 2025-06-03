String jsonTest = '''
[
  {
    "tag": "OneChoiceQuiz",
    "question": "What widget is used for layout in Flutter to align children vertically or horizontally?",
    "answers": ["Row", "Stack", "Expanded", "Container"],
    "correctAnswer": "Row"
  },
  {
    "tag": "MultiChoiceQuiz",
    "question": "Which of the following are state management solutions in Flutter?",
    "answers": ["Provider", "Bloc", "Redux", "SQLite"],
    "correctAnswer": ["Provider", "Bloc", "Redux"]
  },
  {
    "tag": "OneChoiceQuiz",
    "question": "Which widget is immutable and does not rebuild when data changes?",
    "answers": ["StatelessWidget", "StatefulWidget", "InheritedWidget", "StreamBuilder"],
    "correctAnswer": "StatelessWidget"
  },
  {
    "tag": "OneChoiceQuiz",
    "question": "Which Flutter command is used to compile the app for release?",
    "answers": ["flutter run", "flutter clean", "flutter build apk", "flutter pub get"],
    "correctAnswer": "flutter build apk"
  },
  {
    "tag": "MultiChoiceQuiz",
    "question": "Which of the following are true about hot reload?",
    "answers": [
      "Hot reload preserves app state",
      "It rebuilds the widget tree",
      "It restarts the app",
      "It requires full recompilation"
    ],
    "correctAnswer": ["Hot reload preserves app state", "It rebuilds the widget tree"]
  },
  {
    "tag": "OneChoiceQuiz",
    "question": "Which file is used to declare dependencies in Flutter?",
    "answers": ["pubspec.yaml", "main.dart", "build.gradle", "manifest.xml"],
    "correctAnswer": "pubspec.yaml"
  },
  {
    "tag": "OneChoiceQuiz",
    "question": "Which keyword is used to define asynchronous functions in Dart?",
    "answers": ["await", "async", "future", "stream"],
    "correctAnswer": "async"
  },
  {
    "tag": "MultiChoiceQuiz",
    "question": "Which widgets can be used for user input?",
    "answers": ["TextField", "Checkbox", "Slider", "ListView"],
    "correctAnswer": ["TextField", "Checkbox", "Slider"]
  },
  {
    "tag": "OneChoiceQuiz",
    "question": "Which layout widget allows for overlapping children?",
    "answers": ["Stack", "Column", "Row", "ListView"],
    "correctAnswer": "Stack"
  },
  {
    "tag": "OneChoiceQuiz",
    "question": "What is the purpose of the 'setState' method?",
    "answers": [
      "To navigate to another page",
      "To fetch data from an API",
      "To update the UI when data changes",
      "To initialize variables"
    ],
    "correctAnswer": "To update the UI when data changes"
  }
]

''';