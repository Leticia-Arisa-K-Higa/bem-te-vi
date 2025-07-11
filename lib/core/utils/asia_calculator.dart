// lib/core/utils/praxis_asia_calculator.dart

import 'package:bem_te_vi/core/models/exam_models.dart';
import 'package:bem_te_vi/core/models/results__models.dart';

// Classe auxiliar para o resultado do cálculo de nível, incluindo o asterisco de comprometimento
class _LevelResult {
  final String level;
  final bool wasImpaired;
  _LevelResult(this.level, this.wasImpaired);
}

class PraxisIscnsciCalculator {
  final Exam exam;

  PraxisIscnsciCalculator(this.exam);

  // Constantes baseadas no padrão ISNCSCI
  static const _sensoryLevels = ['C2','C3','C4','C5','C6','C7','C8','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12','L1','L2','L3','L4','L5','S1','S2','S3','S4_5'];
  static const _motorLevels = ['C5','C6','C7','C8','T1','L2','L3','L4','L5','S1'];
  static const _uemsLevels = ['C5', 'C6', 'C7', 'C8', 'T1'];
  static const _lemsLevels = ['L2', 'L3', 'L4', 'L5', 'S1'];

  /// Função principal que orquestra todos os cálculos.
  IscnsciResult calculate() {
    // Passo 1 e 2: Determinar Níveis Sensoriais e Motores para cada lado
    final rightSensory = _determineSensoryLevel(exam.right);
    final leftSensory = _determineSensoryLevel(exam.left);
    final rightMotor = _determineMotorLevel(exam.right);
    final leftMotor = _determineMotorLevel(exam.left);

    // Passo 3: Determinar Nível Neurológico da Lesão (NNL)
    final nliResult = _determineNli([rightSensory, leftSensory, rightMotor, leftMotor]);

    // Passo 4: Determinar se a lesão é completa ou incompleta
    final isSensoryIncomplete = _isSensoryIncomplete();
    final isMotorIncomplete = _isMotorIncomplete();
    final isComplete = !(isSensoryIncomplete || isMotorIncomplete);

    // Passo 5: Determinar a Escala de Deficiência ASIA (AIS)
    final aisGrade = _determineAisGrade(
      isComplete: isComplete,
      isMotorIncomplete: isMotorIncomplete,
      nli: nliResult.level,
    );

    // Passo 6: Determinar Zonas de Preservação Parcial (ZPP)
    // ZPP só é calculada para AIS 'A'
    final zpp = _determineZpp(
      aisGrade: aisGrade,
      isMotorIncomplete: isMotorIncomplete,
    );

    // Propagação do asterisco de comprometimento para o resultado final do AIS
    final examIsImpaired = _isAnyValueImpaired();
    final finalAis = examIsImpaired && aisGrade != 'A' && aisGrade != 'B' ? '$aisGrade*' : aisGrade;

    // Calcular os totais para os scores
    final totals = _calculateTotals();

    return IscnsciResult(
      classification: ClassificationResult(
        neurologicalLevels: NeurologicalLevels(
          sensoryRight: rightSensory.level + (rightSensory.wasImpaired ? '*' : ''),
          sensoryLeft: leftSensory.level + (leftSensory.wasImpaired ? '*' : ''),
          motorRight: rightMotor.level + (rightMotor.wasImpaired ? '*' : ''),
          motorLeft: leftMotor.level + (leftMotor.wasImpaired ? '*' : ''),
        ),
        neurologicalLevelOfInjury: nliResult.level + (nliResult.wasImpaired ? '*' : ''),
        injuryComplete: isComplete ? 'C' : 'I',
        asiaImpairmentScale: finalAis,
        zoneOfPartialPreservations: zpp,
      ),
      totals: totals,
    );
  }

  // #######################################################################
  // SEÇÃO DE CÁLCULO DE CLASSIFICAÇÃO
  // #######################################################################

  /// Determina o nível sensorial para um lado do corpo.
  _LevelResult _determineSensoryLevel(ExamSide side) {
    String? lowestNormalLevel;
    bool isImpaired = false;

    for (final level in _sensoryLevels.reversed) {
      final key = level.replaceAll('-', '_');
      final ltValue = side.lightTouch[key] ?? '';
      final ppValue = side.pinPrick[key] ?? '';

      if (_isNormal(ltValue, isMotor: false) && _isNormal(ppValue, isMotor: false)) {
        if (_areAllRostralLevelsNormal(side, level, isMotor: false)) {
          lowestNormalLevel = level;
          isImpaired = _isLevelImpairedAtOrAbove(side, level, isMotor: false);
          break;
        }
      }
    }
    // Se o nível mais baixo com função normal for S4-5, o nível sensorial é considerado "INT" (Intacto).
    if (lowestNormalLevel == 'S4_5') {
      return _LevelResult('INT', isImpaired);
    }
    return _LevelResult(lowestNormalLevel ?? 'N/A', isImpaired);
  }

  /// Determina o nível motor para um lado do corpo.
  _LevelResult _determineMotorLevel(ExamSide side) {
    String? lowestMotorLevel;
    bool isImpaired = false;

    for (final level in _motorLevels.reversed) {
      final score = _getNumericValue(side.motor[level] ?? '');
      if (score != null && score >= 3) {
        if (_areAllRostralLevelsNormal(side, level, isMotor: true)) {
          lowestMotorLevel = level;
          isImpaired = _isLevelImpairedAtOrAbove(side, level, isMotor: true);
          break;
        }
      }
    }
    // CORREÇÃO: Diferente do sensorial, não há conceito de "INT" para o nível motor no algoritmo.
    // O nível mais baixo é S1. Se ele atender aos critérios, o nível é S1.
    return _LevelResult(lowestMotorLevel ?? 'N/A', isImpaired);
  }

  /// Determina o Nível Neurológico da Lesão (NNL) a partir dos 4 níveis calculados.
  _LevelResult _determineNli(List<_LevelResult> levels) {
    if (levels.every((l) => l.level == 'INT')) return _LevelResult('INT', false);

    _LevelResult? mostRostralLevel;
    int highestIndex = -1;

    for (final result in levels) {
      if (result.level != 'N/A' && result.level != 'INT') {
        final index = _sensoryLevels.indexOf(result.level);
        if (mostRostralLevel == null || index < highestIndex) {
          highestIndex = index;
          mostRostralLevel = result;
        }
      }
    }
    // Se nenhum nível foi encontrado, o NNL é C1 por padrão.
    return mostRostralLevel ?? _LevelResult('C1', false);
  }

  /// Determina a escala AIS.
  String _determineAisGrade({
    required bool isComplete,
    required bool isMotorIncomplete,
    required String nli,
  }) {
    if (_isNormalExam()) return 'E';
    if (isComplete) return 'A';

    // Se a lesão é incompleta...
    if (isMotorIncomplete) {
      // Incompleto Motor: AIS C ou D
      final motorScoreBelowNli = _getMotorScoreBelowNli(nli);
      final numMuscles = motorScoreBelowNli.length;
      final numMusclesGrade3OrMore = motorScoreBelowNli.where((s) => s >= 3).length;

      if (numMuscles > 0 && numMusclesGrade3OrMore >= (numMuscles / 2)) {
        return 'D';
      }
      return 'C';
    } else {
      // Incompleto Sensorial Apenas: AIS B
      return 'B';
    }
  }

  /// Determina as Zonas de Preservação Parcial (ZPP).
  /// ZPP só é relevante para lesões AIS 'A'. Para outras, o valor é 'NA'.
  ZoneOfPartialPreservations _determineZpp({
    required String aisGrade,
    required bool isMotorIncomplete,
  }) {
    if (aisGrade != 'A') {
      return ZoneOfPartialPreservations(
        sensoryRight: 'NA', sensoryLeft: 'NA', motorRight: 'NA', motorLeft: 'NA',
      );
    }

    // Helper para encontrar o nível mais caudal com qualquer função (> 0).
    String findLowestLevelWithFunction(ExamSide side, bool isMotor) {
      final levels = isMotor ? _motorLevels : _sensoryLevels;
      for (final level in levels.reversed) {
        final key = level.replaceAll('-', '_');
        if (isMotor) {
          if ((_getNumericValue(side.motor[key] ?? '') ?? 0) > 0) return level;
        } else {
          final lt = _getNumericValue(side.lightTouch[key] ?? '') ?? 0;
          final pp = _getNumericValue(side.pinPrick[key] ?? '') ?? 0;
          if (lt > 0 || pp > 0) return level;
        }
      }
      return 'Nenhum';
    }
    
    String motorRightZpp = 'NA';
    String motorLeftZpp = 'NA';
    // ZPP motora só é calculada se NÃO houver função motora sacral (VAC).
    if (!isMotorIncomplete) {
       motorRightZpp = findLowestLevelWithFunction(exam.right, true);
       motorLeftZpp = findLowestLevelWithFunction(exam.left, true);
    }
     // Caso especial: se a Contração Anal Voluntária (VAC) não for testável (NT).
    if (exam.voluntaryAnalContraction.toUpperCase() == 'NT') {
      motorRightZpp = 'NA';
      motorLeftZpp = 'NA';
    }
    
    return ZoneOfPartialPreservations(
      sensoryRight: findLowestLevelWithFunction(exam.right, false),
      sensoryLeft: findLowestLevelWithFunction(exam.left, false),
      motorRight: motorRightZpp,
      motorLeft: motorLeftZpp,
    );
  }
  
  // #######################################################################
  // SEÇÃO DE TOTAIS E HELPERS
  // #######################################################################

  /// Calcula a soma dos pontos para cada grupo de músculos e sensibilidade.
  TotalsResult _calculateTotals() {
    dynamic calc(Map<String, String> values) {
      if (values.values.any((v) => v.toUpperCase().startsWith('NT'))) return 'ND';
      return values.values.fold(0, (sum, v) => sum + (_getNumericValue(v) ?? 0));
    }
    return TotalsResult(
      upperExtremityRight: calc(Map.fromEntries(exam.right.motor.entries.where((e) => _uemsLevels.contains(e.key)))),
      upperExtremityLeft: calc(Map.fromEntries(exam.left.motor.entries.where((e) => _uemsLevels.contains(e.key)))),
      lowerExtremityRight: calc(Map.fromEntries(exam.right.motor.entries.where((e) => _lemsLevels.contains(e.key)))),
      lowerExtremityLeft: calc(Map.fromEntries(exam.left.motor.entries.where((e) => _lemsLevels.contains(e.key)))),
      lightTouchRight: calc(exam.right.lightTouch),
      lightTouchLeft: calc(exam.left.lightTouch),
      pinPrickRight: calc(exam.right.pinPrick),
      pinPrickLeft: calc(exam.left.pinPrick),
    );
  }

  // #######################################################################
  // HELPERS DE LÓGICA E CHECAGEM
  // #######################################################################

  /// Converte um valor de string (ex: "2*", "NT") para um inteiro. Retorna null para 'NT'.
  int? _getNumericValue(String value) {
    if (value.trim().toUpperCase().startsWith('NT')) return null;
    return int.tryParse(value.replaceAll(RegExp(r'\*+'), ''));
  }

  /// Verifica se um valor indica comprometimento por dor/sensibilidade.
  bool _isImpaired(String value) => value.contains('*') && !value.contains('**');

  /// Verifica se um valor é considerado 'normal' (5 para motor, 2 para sensorial).
  bool _isNormal(String value, {required bool isMotor}) {
    if (value.toUpperCase().startsWith('NT') || _isImpaired(value)) return false;
    if (value.contains('**')) return true; // ** indica normalidade apesar da não-lesão.
    final numericValue = _getNumericValue(value);
    return isMotor ? numericValue == 5 : numericValue == 2;
  }

  /// Verifica se todos os níveis acima (rostrais) de um dado nível são normais.
  bool _areAllRostralLevelsNormal(ExamSide side, String level, {required bool isMotor}) {
    final levelsToCheck = isMotor ? _motorLevels : _sensoryLevels;
    final currentLevelIndex = levelsToCheck.indexOf(level);
    for (int i = 0; i < currentLevelIndex; i++) {
      final key = levelsToCheck[i].replaceAll('-', '_');
      if (isMotor) {
        if (!_isNormal(side.motor[key] ?? '', isMotor: true)) return false;
      } else {
        if (!_isNormal(side.lightTouch[key] ?? '', isMotor: false) ||
            !_isNormal(side.pinPrick[key] ?? '', isMotor: false)) return false;
      }
    }
    return true;
  }

  /// Verifica se há algum valor com comprometimento ('*') no nível atual ou acima dele.
  bool _isLevelImpairedAtOrAbove(ExamSide side, String level, {required bool isMotor}) {
    final levelsToCheck = isMotor ? _motorLevels : _sensoryLevels;
    final levelIndex = levelsToCheck.indexOf(level);
    for (int i = 0; i <= levelIndex; i++) {
      final key = levelsToCheck[i].replaceAll('-', '_');
      if (isMotor) {
        if (_isImpaired(side.motor[key] ?? '')) return true;
      } else {
        if (_isImpaired(side.lightTouch[key] ?? '') || _isImpaired(side.pinPrick[key] ?? '')) return true;
      }
    }
    return false;
  }
  
  /// Verifica se há qualquer valor com asterisco ('*') no exame inteiro.
  bool _isAnyValueImpaired() {
    final allValues = [
        ...exam.right.motor.values, ...exam.left.motor.values,
        ...exam.right.lightTouch.values, ...exam.left.lightTouch.values,
        ...exam.right.pinPrick.values, ...exam.left.pinPrick.values,
    ];
    return allValues.any((v) => _isImpaired(v));
  }

  /// Verifica se há função sensorial nos segmentos sacrais S4-5.
  bool _isSensoryIncomplete() {
    return (exam.deepAnalPressure == 'Yes') ||
        (_getNumericValue(exam.right.lightTouch['S4_5'] ?? '') ?? 0) > 0 ||
        (_getNumericValue(exam.right.pinPrick['S4_5'] ?? '') ?? 0) > 0 ||
        (_getNumericValue(exam.left.lightTouch['S4_5'] ?? '') ?? 0) > 0 ||
        (_getNumericValue(exam.left.pinPrick['S4_5'] ?? '') ?? 0) > 0;
  }

  /// Verifica se há função motora nos segmentos sacrais S4-5.
  bool _isMotorIncomplete() {
    return exam.voluntaryAnalContraction.trim().toUpperCase() == 'YES';
  }

  /// Verifica se o exame inteiro tem pontuação normal.
  bool _isNormalExam() {
    bool allNormal(Iterable<String> values, bool isMotor) {
      return values.every((v) => _isNormal(v, isMotor: isMotor));
    }
    return allNormal(exam.right.motor.values, true) &&
           allNormal(exam.left.motor.values, true) &&
           allNormal(exam.right.lightTouch.values, false) &&
           allNormal(exam.right.pinPrick.values, false) &&
           allNormal(exam.left.lightTouch.values, false) &&
           allNormal(exam.left.pinPrick.values, false) &&
           _isMotorIncomplete() && _isSensoryIncomplete();
  }

  /// Retorna uma lista de scores motores de todos os músculos abaixo do NNL.
  List<int> _getMotorScoreBelowNli(String nli) {
    final nliClean = nli.replaceAll('*','');
    int nliSensoryIndex = _sensoryLevels.indexOf(nliClean);
    if (nliSensoryIndex == -1) return [];

    List<int> scores = [];
    for (final level in _motorLevels) {
      final motorSensoryIndex = _sensoryLevels.indexOf(level);
      if (motorSensoryIndex > nliSensoryIndex) {
        final rightValue = _getNumericValue(exam.right.motor[level] ?? '');
        final leftValue = _getNumericValue(exam.left.motor[level] ?? '');
        if (rightValue != null) scores.add(rightValue);
        if (leftValue != null) scores.add(leftValue);
      }
    }
    return scores;
  }
}