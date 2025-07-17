// lib/core/models/exam_models.dart

// Estrutura para os valores de Músculos-chave. Ex: { 'C5': '5', 'C6': '4*' }
typedef MotorValues = Map<String, String>;
// Estrutura para os valores de Pontos Sensoriais. Ex: { 'C2': '2', 'C3': '1' }
typedef SensoryValues = Map<String, String>;

// Corresponde à interface `ExamSide` da documentação
class ExamSide {
  final MotorValues motor;
  final SensoryValues lightTouch;
  final SensoryValues pinPrick;
  final String? lowestNonKeyMuscleWithMotorFunction;

  ExamSide({
    required this.motor,
    required this.lightTouch,
    required this.pinPrick,
    this.lowestNonKeyMuscleWithMotorFunction,
  });
}

// Corresponde à interface `Exam` da documentação
class Exam {
  final ExamSide right;
  final ExamSide left;
  final String voluntaryAnalContraction; // 'Yes', 'No', ou 'NT'
  final String deepAnalPressure; // 'Yes', 'No', ou 'NT'

  Exam({
    required this.right,
    required this.left,
    required this.voluntaryAnalContraction,
    required this.deepAnalPressure,
  });
}
