// lib/core/utils/asia_calculator.dart

import 'package:bem_te_vi/core/models/neurology_cell_data.dart';
import 'package:bem_te_vi/core/models/totals_data.dart';

class AsiaCalculator {
  final List<NeurologyCellData> cells;
  final bool voluntaryAnalContraction;
  final bool deepAnalPressure;

  static const List<String> _sensoryOrder = [
    'C2',
    'C3',
    'C4',
    'C5',
    'C6',
    'C7',
    'C8',
    'T1',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'T8',
    'T9',
    'T10',
    'T11',
    'T12',
    'L1',
    'L2',
    'L3',
    'L4',
    'L5',
    'S1',
    'S2',
    'S3',
    'S4-5',
  ];
  static const List<String> _motorOrder = [
    'C5',
    'C6',
    'C7',
    'C8',
    'T1',
    'L2',
    'L3',
    'L4',
    'L5',
    'S1',
  ];
  static const List<String> _uemsLevels = ['C5', 'C6', 'C7', 'C8', 'T1'];
  static const List<String> _lemsLevels = ['L2', 'L3', 'L4', 'L5', 'S1'];

  AsiaCalculator({
    required this.cells,
    required this.voluntaryAnalContraction,
    required this.deepAnalPressure,
  });

  TotalsData calculate() {
    final totals = _calculateBasicTotals();

    final rightSensoryLevel = _determineSensoryLevel(Side.right);
    final leftSensoryLevel = _determineSensoryLevel(Side.left);

    final rightMotorLevel = _determineMotorLevel(Side.right);
    final leftMotorLevel = _determineMotorLevel(Side.left);

    final nli = _determineNli(
      rightSensoryLevel,
      leftSensoryLevel,
      rightMotorLevel,
      leftMotorLevel,
    );

    final isMotorIncomplete = _isMotorIncomplete(nli);
    final isSensoryIncomplete = _isSensoryIncomplete();
    final isComplete = !(isMotorIncomplete || isSensoryIncomplete);

    final aisGrade = _determineAisGrade(
      isComplete,
      isMotorIncomplete,
      isSensoryIncomplete,
      nli,
    );

    final rightSensoryZpp = (aisGrade == 'A')
        ? _determineZppSensory(Side.right)
        : 'N/A';
    final leftSensoryZpp = (aisGrade == 'A')
        ? _determineZppSensory(Side.left)
        : 'N/A';
    final rightMotorZpp = (aisGrade == 'A')
        ? _determineZppMotor(Side.right)
        : 'N/A';
    final leftMotorZpp = (aisGrade == 'A')
        ? _determineZppMotor(Side.left)
        : 'N/A';

    return totals.copyWith(
      neurologicalLevelOfInjury: nli,
      completeness: isComplete ? 'Completo' : 'Incompleto',
      asiaImpairmentScale: aisGrade,
      rightSensoryZpp: rightSensoryZpp,
      leftSensoryZpp: leftSensoryZpp,
      rightMotorZpp: rightMotorZpp,
      leftMotorZpp: leftMotorZpp,
    );
  }

  // PASSO 1: NÍVEL SENSORIAL
  String _determineSensoryLevel(Side side) {
    for (final level in _sensoryOrder.reversed) {
      final lightTouch = _getCell(
        level,
        CellType.sensoryLightTouch,
        side,
      )?.value;
      final pinPrick = _getCell(level, CellType.sensoryPinPrick, side)?.value;
      if (lightTouch == '2' && pinPrick == '2') {
        return level;
      }
    }
    return 'N/A';
  }

  // PASSO 2: NÍVEL MOTOR
  String _determineMotorLevel(Side side) {
    String? motorLevel;
    for (final level in _motorOrder.reversed) {
      final score = int.tryParse(
        _getCell(level, CellType.motor, side)?.value?.replaceAll('*', '') ?? '',
      );
      if (score != null && score >= 3) {
        bool allAboveAreNormal = true;
        final currentLevelIndex = _motorOrder.indexOf(level);
        for (int i = 0; i < currentLevelIndex; i++) {
          final levelAbove = _motorOrder[i];
          final scoreAbove = int.tryParse(
            _getCell(
                  levelAbove,
                  CellType.motor,
                  side,
                )?.value?.replaceAll('*', '') ??
                '',
          );
          if (scoreAbove != 5) {
            allAboveAreNormal = false;
            break;
          }
        }
        if (allAboveAreNormal) {
          motorLevel = level;
          break;
        }
      }
    }
    return motorLevel ?? 'N/A';
  }

  // PASSO 3: NÍVEL NEUROLÓGICO DA LESÃO (NNL)
  String _determineNli(String rs, String ls, String rm, String lm) {
    final levels = [rs, ls, rm, lm];
    int highestIndex = 999;
    for (final level in levels) {
      if (level != 'N/A') {
        final index = _sensoryOrder.indexOf(level);
        if (index != -1 && index < highestIndex) {
          highestIndex = index;
        }
      }
    }
    return highestIndex != 999 ? _sensoryOrder[highestIndex] : 'N/A';
  }

  // PASSO 4: COMPLETUDE
  bool _isSensoryIncomplete() {
    final s45LtRight = _getCell(
      'S4-5',
      CellType.sensoryLightTouch,
      Side.right,
    )?.value;
    final s45PpRight = _getCell(
      'S4-5',
      CellType.sensoryPinPrick,
      Side.right,
    )?.value;
    final s45LtLeft = _getCell(
      'S4-5',
      CellType.sensoryLightTouch,
      Side.left,
    )?.value;
    final s45PpLeft = _getCell(
      'S4-5',
      CellType.sensoryPinPrick,
      Side.left,
    )?.value;
    return (s45LtRight != '0' && s45LtRight != null && s45LtRight != '') ||
        (s45PpRight != '0' && s45PpRight != null && s45PpRight != '') ||
        (s45LtLeft != '0' && s45LtLeft != null && s45LtLeft != '') ||
        (s45PpLeft != '0' && s45PpLeft != null && s45PpLeft != '') ||
        deepAnalPressure;
  }

  bool _isMotorIncomplete(String nli) {
    if (voluntaryAnalContraction) return true;
    if (nli == 'N/A') return false;

    bool motorFunctionBelowNLI = false;
    final nliIndex = _motorOrder.indexOf(nli);
    final startIndex = (nliIndex == -1) ? 0 : nliIndex + 1;

    for (int i = startIndex; i < _motorOrder.length; i++) {
      final level = _motorOrder[i];
      final rightScore = int.tryParse(
        _getCell(
              level,
              CellType.motor,
              Side.right,
            )?.value?.replaceAll('*', '') ??
            '',
      );
      final leftScore = int.tryParse(
        _getCell(
              level,
              CellType.motor,
              Side.left,
            )?.value?.replaceAll('*', '') ??
            '',
      );
      if ((rightScore != null && rightScore > 0) ||
          (leftScore != null && leftScore > 0)) {
        motorFunctionBelowNLI = true;
        break;
      }
    }
    return motorFunctionBelowNLI;
  }

  // PASSO 5: ESCALA ASIA (AIS)
  String _determineAisGrade(
    bool isComplete,
    bool isMotorIncomplete,
    bool isSensoryIncomplete,
    String nli,
  ) {
    if (isComplete) return 'A';

    if (isSensoryIncomplete && !isMotorIncomplete) return 'B';

    if (isMotorIncomplete) {
      if (nli == 'N/A') return 'C'; // Não pode ser D se não há NLI motor

      int musclesBelowNliCount = 0;
      int musclesBelowNliWithScore3OrMore = 0;

      final nliIndex = _motorOrder.indexOf(nli);
      final startIndex = (nliIndex == -1) ? 0 : nliIndex;

      for (int i = startIndex; i < _motorOrder.length; i++) {
        final level = _motorOrder[i];
        final rightCell = _getCell(level, CellType.motor, Side.right);
        final leftCell = _getCell(level, CellType.motor, Side.left);

        if (rightCell != null) {
          musclesBelowNliCount++;
          final score = int.tryParse(
            rightCell.value?.replaceAll('*', '') ?? '',
          );
          if (score != null && score >= 3) {
            musclesBelowNliWithScore3OrMore++;
          }
        }
        if (leftCell != null) {
          musclesBelowNliCount++;
          final score = int.tryParse(leftCell.value?.replaceAll('*', '') ?? '');
          if (score != null && score >= 3) {
            musclesBelowNliWithScore3OrMore++;
          }
        }
      }

      if (musclesBelowNliCount > 0 &&
          (musclesBelowNliWithScore3OrMore >= (musclesBelowNliCount / 2))) {
        return 'D';
      } else {
        return 'C';
      }
    }

    // Verificação para AIS E (Normal) - deve ser feita no final
    bool isNormal = true;
    for (var cell in cells) {
      if (cell.type == CellType.motor && cell.value != '5') {
        isNormal = false;
        break;
      }
      if ((cell.type == CellType.sensoryLightTouch ||
              cell.type == CellType.sensoryPinPrick) &&
          cell.value != '2') {
        isNormal = false;
        break;
      }
    }
    if (isNormal) return 'E';

    return 'N/A'; // Fallback
  }

  // PASSO 6: ZONA DE PRESERVAÇÃO PARCIAL (ZPP)
  String _determineZppSensory(Side side) {
    for (final level in _sensoryOrder.reversed) {
      final ltValue = _getCell(level, CellType.sensoryLightTouch, side)?.value;
      final ppValue = _getCell(level, CellType.sensoryPinPrick, side)?.value;
      if ((ltValue != null && ltValue.isNotEmpty && ltValue != '0') ||
          (ppValue != null && ppValue.isNotEmpty && ppValue != '0')) {
        return level;
      }
    }
    return 'Nenhum';
  }

  String _determineZppMotor(Side side) {
    for (final level in _motorOrder.reversed) {
      final motorValue = _getCell(level, CellType.motor, side)?.value;
      if (motorValue != null && motorValue.isNotEmpty && motorValue != '0') {
        return level;
      }
    }
    return 'Nenhum';
  }

  // MÉTODOS AUXILIARES
  NeurologyCellData? _getCell(String level, CellType type, Side side) {
    try {
      return cells.firstWhere(
        (c) => c.level == level && c.type == type && c.side == side,
      );
    } catch (e) {
      return null;
    }
  }

  TotalsData _calculateBasicTotals() {
    int rLt = 0, lLt = 0, rPp = 0, lPp = 0;
    int uemsR = 0, uemsL = 0, lemsR = 0, lemsL = 0;

    for (var cell in cells) {
      final score = int.tryParse(cell.value?.replaceAll('*', '') ?? '');
      if (score != null) {
        if (cell.type == CellType.motor) {
          if (_uemsLevels.contains(cell.level)) {
            (cell.side == Side.right) ? uemsR += score : uemsL += score;
          } else if (_lemsLevels.contains(cell.level)) {
            (cell.side == Side.right) ? lemsR += score : lemsL += score;
          }
        } else if (cell.type == CellType.sensoryLightTouch) {
          (cell.side == Side.right) ? rLt += score : lLt += score;
        } else if (cell.type == CellType.sensoryPinPrick) {
          (cell.side == Side.right) ? rPp += score : lPp += score;
        }
      }
    }
    return TotalsData(
      rightLightTouchTotal: rLt,
      leftLightTouchTotal: lLt,
      rightPinPrickTotal: rPp,
      leftPinPrickTotal: lPp,
      uemsRight: uemsR,
      uemsLeft: uemsL,
      lemsRight: lemsR,
      lemsLeft: lemsL,
    );
  }
}
