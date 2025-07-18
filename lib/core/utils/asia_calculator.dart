// lib/core/utils/praxis_asia_calculator.dart

import 'package:bem_te_vi/core/models/exam_models.dart';
import 'package:bem_te_vi/core/models/results__models.dart';

// #region CLASSES AUXILIARES DE DADOS
class _NeurologicalLevels {
  final String motorRight;
  final String motorLeft;
  final String sensoryRight;
  final String sensoryLeft;

  _NeurologicalLevels({
    this.motorRight = 'N/A',
    this.motorLeft = 'N/A',
    this.sensoryRight = 'N/A',
    this.sensoryLeft = 'N/A',
  });
}
// #endregion

class PraxisIscnsciCalculator {
  final Exam exam;

  PraxisIscnsciCalculator(this.exam);

  static const _sensoryLevels = ['C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'L1', 'L2', 'L3', 'L4', 'L5', 'S1', 'S2', 'S3', 'S4_5'];
  static const _motorLevels = ['C5', 'C6', 'C7', 'C8', 'T1', 'L2', 'L3', 'L4', 'L5', 'S1'];
  static const _uemsLevels = ['C5', 'C6', 'C7', 'C8', 'T1'];
  static const _lemsLevels = ['L2', 'L3', 'L4', 'L5', 'S1'];

  /// Função principal que orquestra todos os cálculos.
  IscnsciResult calculate() {
    final neurologicalLevels = _determineNeurologicalLevels();
    final nli = _determineNeurologicalLevelOfInjury(neurologicalLevels);
    final isComplete = _isInjuryComplete();
    final aisGrade = _determineAisGrade(isComplete, nli, neurologicalLevels);
    final zpp = _determineZoneOfPartialPreservations();
    final totals = _calculateTotals();

    return IscnsciResult(
      classification: ClassificationResult(
        neurologicalLevels: NeurologicalLevels(
          sensoryRight: neurologicalLevels.sensoryRight,
          sensoryLeft: neurologicalLevels.sensoryLeft,
          motorRight: neurologicalLevels.motorRight,
          motorLeft: neurologicalLevels.motorLeft,
        ),
        neurologicalLevelOfInjury: nli,
        injuryComplete: isComplete ? 'C' : 'I',
        asiaImpairmentScale: aisGrade,
        zoneOfPartialPreservations: zpp,
      ),
      totals: totals,
    );
  }

  // #region MÉTODOS DE CÁLCULO PRINCIPAIS

  _NeurologicalLevels _determineNeurologicalLevels() {
    return _NeurologicalLevels(
      sensoryRight: _determineSensoryLevel(exam.right),
      sensoryLeft: _determineSensoryLevel(exam.left),
      motorRight: _determineMotorLevel(exam.right),
      motorLeft: _determineMotorLevel(exam.left),
    );
  }

  String _determineNeurologicalLevelOfInjury(_NeurologicalLevels levels) {
    final allLevels = [levels.sensoryRight, levels.sensoryLeft, levels.motorRight, levels.motorLeft];
    int mostRostralIndex = 999;

    for (final level in allLevels) {
      if (level != 'N/A' && !level.contains('INT')) {
        final cleanLevel = level.replaceAll('*', '');
        final index = _sensoryLevels.indexOf(cleanLevel);
        if (index != -1 && index < mostRostralIndex) {
          mostRostralIndex = index;
        }
      }
    }

    if (mostRostralIndex == 999) {
      return allLevels.any((l) => l.contains('INT')) ? 'INT' : 'N/A';
    }
    return _sensoryLevels[mostRostralIndex];
  }

  bool _isInjuryComplete() {
    final hasSacralSensation = (exam.deepAnalPressure == 'Yes') ||
        (_getNumericValue(exam.right.lightTouch['S4_5'] ?? '0') ?? 0) > 0 ||
        (_getNumericValue(exam.right.pinPrick['S4_5'] ?? '0') ?? 0) > 0 ||
        (_getNumericValue(exam.left.lightTouch['S4_5'] ?? '0') ?? 0) > 0 ||
        (_getNumericValue(exam.left.pinPrick['S4_5'] ?? '0') ?? 0) > 0;

    final hasSacralMotor = exam.voluntaryAnalContraction == 'Yes';

    return !hasSacralSensation && !hasSacralMotor;
  }
  
  String _determineAisGrade(bool isComplete, String nli, _NeurologicalLevels neuroLevels) {
    // AIS E: Exame Normal
    if (_isNormalExam()) return 'E';
    
    // AIS A: Lesão Completa
    if (isComplete) return 'A';

    final hasSacralSensation = (exam.deepAnalPressure == 'Yes') ||
        (_getNumericValue(exam.right.lightTouch['S4_5'] ?? '0') ?? 0) > 0 ||
        (_getNumericValue(exam.right.pinPrick['S4_5'] ?? '0') ?? 0) > 0 ||
        (_getNumericValue(exam.left.lightTouch['S4_5'] ?? '0') ?? 0) > 0 ||
        (_getNumericValue(exam.left.pinPrick['S4_5'] ?? '0') ?? 0) > 0;
    
    final hasSacralMotor = exam.voluntaryAnalContraction == 'Yes';

    // Se é Incompleto, verifica se é B, C ou D
    if (hasSacralSensation && !hasSacralMotor) {
        // Para ser B, não pode haver função motora > 3 níveis abaixo do nível motor
        bool motorPreservedMoreThan3LevelsBelow = 
            _isMotorPreservedMoreThan3LevelsBelow(exam.right, neuroLevels.motorRight) ||
            _isMotorPreservedMoreThan3LevelsBelow(exam.left, neuroLevels.motorLeft);
        if (!motorPreservedMoreThan3LevelsBelow) return 'B';
    }
    
    // Se chegou aqui, é AIS C ou D
    final musclesBelowNli = _getMusclesBelowNli(nli);
    if (musclesBelowNli.isEmpty) return 'C'; // Não há músculos abaixo para avaliar, default para C
    
    final scoresBelowNli = musclesBelowNli.expand((level) => [
        _getNumericValue(exam.right.motor[level] ?? '0'),
        _getNumericValue(exam.left.motor[level] ?? '0'),
    ]).whereType<int>().toList();

    final musclesWithGrade3orMore = scoresBelowNli.where((score) => score >= 3).length;

    if (musclesWithGrade3orMore >= (scoresBelowNli.length / 2.0)) {
        return 'D';
    } else {
        return 'C';
    }
  }

  ZoneOfPartialPreservations _determineZoneOfPartialPreservations() {
    final isMotorSacralAbsent = exam.voluntaryAnalContraction == 'No';
    final isSensorySacralAbsent = (exam.deepAnalPressure == 'No') &&
        (_getNumericValue(exam.right.lightTouch['S4_5'] ?? '0') ?? 0) == 0 &&
        (_getNumericValue(exam.right.pinPrick['S4_5'] ?? '0') ?? 0) == 0 &&
        (_getNumericValue(exam.left.lightTouch['S4_5'] ?? '0') ?? 0) == 0 &&
        (_getNumericValue(exam.left.pinPrick['S4_5'] ?? '0') ?? 0) == 0;
        
    if (!isMotorSacralAbsent && !isSensorySacralAbsent) {
      return ZoneOfPartialPreservations(sensoryRight: 'NA', sensoryLeft: 'NA', motorRight: 'NA', motorLeft: 'NA');
    }
    
    String findLowestLevelWithFunction(ExamSide side, bool isMotor) {
      final levels = isMotor ? _motorLevels : _sensoryLevels;
      for (final level in levels.reversed) {
        if (isMotor) {
          if ((_getNumericValue(side.motor[level] ?? '') ?? 0) > 0) return level;
        } else {
          final lt = _getNumericValue(side.lightTouch[level] ?? '') ?? 0;
          final pp = _getNumericValue(side.pinPrick[level] ?? '') ?? 0;
          if (lt > 0 || pp > 0) return level;
        }
      }
      return 'Nenhum';
    }
    
    return ZoneOfPartialPreservations(
      sensoryRight: isSensorySacralAbsent ? findLowestLevelWithFunction(exam.right, false) : 'NA',
      sensoryLeft: isSensorySacralAbsent ? findLowestLevelWithFunction(exam.left, false) : 'NA',
      motorRight: isMotorSacralAbsent ? findLowestLevelWithFunction(exam.right, true) : 'NA',
      motorLeft: isMotorSacralAbsent ? findLowestLevelWithFunction(exam.left, true) : 'NA',
    );
  }

  // #endregion

  // #region LÓGICA DE DETERMINAÇÃO DE NÍVEIS
  
  String _determineSensoryLevel(ExamSide side) {
    String? lowestNormalLevel;
    // Percorre de baixo para cima (caudal para rostral)
    for (final level in _sensoryLevels.reversed) {
      final ltValue = side.lightTouch[level] ?? '0';
      final ppValue = side.pinPrick[level] ?? '0';

      final isNormal = (_getNumericValue(ltValue) == 2) && (_getNumericValue(ppValue) == 2);
      
      if (isNormal) {
        // Verifica se TODOS os níveis acima são normais (score 2)
        bool allAboveNormal = true;
        for (int i = 0; i < _sensoryLevels.indexOf(level); i++) {
          final upperLevel = _sensoryLevels[i];
          final upperLt = side.lightTouch[upperLevel] ?? '0';
          final upperPp = side.pinPrick[upperLevel] ?? '0';
          if (_getNumericValue(upperLt) != 2 || _getNumericValue(upperPp) != 2) {
            allAboveNormal = false;
            break;
          }
        }
        if (allAboveNormal) {
          lowestNormalLevel = level;
          break; // Encontrou o nível mais baixo que satisfaz a condição
        }
      }
    }
    if (lowestNormalLevel == 'S4_5') return 'INT';
    return lowestNormalLevel ?? 'N/A';
  }

  String _determineMotorLevel(ExamSide side) {
    String? mostCaudalLevel;
    // Percorre de cima para baixo (rostral para caudal)
    for (final level in _motorLevels) {
        final score = _getNumericValue(side.motor[level] ?? '0');
        
        // Verifica se o nível atual é o último com força normal (5)
        // antes de uma queda.
        if (score == 5) {
            mostCaudalLevel = level;
        } else if (score != null && score >= 3) {
            // Se o nível anterior era 5, este nível é o nível motor.
            final currentIndex = _motorLevels.indexOf(level);
            if (currentIndex > 0) {
                final prevLevel = _motorLevels[currentIndex - 1];
                if (_getNumericValue(side.motor[prevLevel] ?? '0') == 5) {
                    mostCaudalLevel = level;
                    break;
                }
            } else { // Caso C5
                mostCaudalLevel = level;
                break;
            }
        } else {
            // A força caiu para menos de 3, então o loop para.
            // O nível motor é o último que foi registrado como 5.
            break;
        }
    }
    return mostCaudalLevel ?? 'N/A';
  }

  // #endregion

  // #region HELPERS E FUNÇÕES AUXILIARES

  int? _getNumericValue(String value) {
    if (value.toUpperCase().startsWith('NT')) return null;
    return int.tryParse(value.replaceAll(RegExp(r'\*+'), ''));
  }

  bool _isNormalExam() {
    bool allNormal(Iterable<String> values, bool isMotor) {
      return values.every((v) {
        final numVal = _getNumericValue(v);
        return isMotor ? numVal == 5 : numVal == 2;
      });
    }
    return allNormal(exam.right.motor.values, true) &&
           allNormal(exam.left.motor.values, true) &&
           allNormal(exam.right.lightTouch.values, false) &&
           allNormal(exam.right.pinPrick.values, false) &&
           allNormal(exam.left.lightTouch.values, false) &&
           allNormal(exam.left.pinPrick.values, false) &&
           exam.voluntaryAnalContraction == 'Yes' &&
           exam.deepAnalPressure == 'Yes';
  }

  bool _isMotorPreservedMoreThan3LevelsBelow(ExamSide side, String motorLevel) {
    if (motorLevel == 'N/A' || motorLevel.contains('INT')) return false;

    final motorLevelIndex = _motorLevels.indexOf(motorLevel.replaceAll('*',''));
    if (motorLevelIndex == -1) return false;
    
    // Níveis > 3 abaixo
    for (int i = motorLevelIndex + 4; i < _motorLevels.length; i++) {
        final level = _motorLevels[i];
        if ((_getNumericValue(side.motor[level] ?? '0') ?? 0) > 0) {
            return true;
        }
    }
    return false;
  }
  
  List<String> _getMusclesBelowNli(String nli) {
    if (nli.isEmpty || nli == 'N/A' || nli.contains('INT')) return [];
    final nliIndexInSensory = _sensoryLevels.indexOf(nli.replaceAll('*', ''));
    if (nliIndexInSensory == -1) return [];

    return _motorLevels.where((motorLevel) {
      final motorIndexInSensory = _sensoryLevels.indexOf(motorLevel);
      return motorIndexInSensory > nliIndexInSensory;
    }).toList();
  }

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

  // #endregion
}