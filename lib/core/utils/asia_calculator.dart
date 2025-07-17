// lib/core/utils/praxis_asia_calculator.dart

import 'package:bem_te_vi/core/models/exam_models.dart';
import 'package:bem_te_vi/core/models/results__models.dart';

// #region ENUMS E CLASSES AUXILIARES DE DADOS

// Resultado de uma verificação de lógica, replicando o { result: boolean, variable: boolean } do TS.
class _CheckResult {
  bool result;
  bool variable;
  _CheckResult({this.result = false, this.variable = false});
}

// Resultado de uma verificação de nível durante a iteração.
class _CheckLevelResult {
  final bool continueProcessing;
  final String? level;
  final bool variable;

  _CheckLevelResult({
    this.continueProcessing = false,
    this.level,
    this.variable = false,
  });
}

// Agrupa os níveis neurológicos para cada lado.
class _NeurologicalLevels {
  final String motorRight;
  final String motorLeft;
  final String sensoryRight;
  final String sensoryLeft;

  _NeurologicalLevels({
    required this.motorRight,
    required this.motorLeft,
    required this.sensoryRight,
    required this.sensoryLeft,
  });
}

// Representa um único nível da medula para os cálculos da ZPP.
class _SideLevel {
  final String name;
  final String lightTouch;
  final String pinPrick;
  final String? motor;
  final int index;
  _SideLevel? next;
  _SideLevel? previous;

  _SideLevel({
    required this.name,
    required this.lightTouch,
    required this.pinPrick,
    this.motor,
    required this.index,
    this.next,
    this.previous,
  });
}

// Estado para a máquina de estados do cálculo da ZPP Motora.
class _MotorZppState {
  final String ais;
  final String motorLevel;
  final String voluntaryAnalContraction;
  List<String> zpp;
  final ExamSide side;
  _SideLevel topLevel;
  _SideLevel bottomLevel;
  _SideLevel? currentLevel;
  _SideLevel? nonKeyMuscle;
  bool nonKeyMuscleHasBeenAdded;
  bool testNonKeyMuscle;
  bool addNonKeyMuscle;
  _SideLevel? firstLevelWithStar;
  _SideLevel lastLevelWithConsecutiveNormalValues;

  _MotorZppState({
    required this.ais,
    required this.motorLevel,
    required this.voluntaryAnalContraction,
    required this.zpp,
    required this.side,
    required this.topLevel,
    required this.bottomLevel,
    this.currentLevel,
    this.nonKeyMuscle,
    this.nonKeyMuscleHasBeenAdded = false,
    this.testNonKeyMuscle = false,
    this.addNonKeyMuscle = false,
    this.firstLevelWithStar,
    required this.lastLevelWithConsecutiveNormalValues,
  });
}

// Classe para encapsular o resultado de _getLevelsRange
class _LevelsRangeResult {
  final _SideLevel topLevel;
  final _SideLevel bottomLevel;
  final _SideLevel? nonKeyMuscle;
  final _SideLevel? firstLevelWithStar;
  final _SideLevel lastLevelWithConsecutiveNormalValues;

  _LevelsRangeResult({
    required this.topLevel,
    required this.bottomLevel,
    this.nonKeyMuscle,
    this.firstLevelWithStar,
    required this.lastLevelWithConsecutiveNormalValues,
  });
}

// Representa uma etapa na máquina de estados da ZPP.
class _ZppStep {
  final _MotorZppState state;
  final _ZppStep Function(_MotorZppState)? next;
  _ZppStep(this.state, this.next);
}

// #endregion

class PraxisIscnsciCalculator {
  final Exam exam;

  PraxisIscnsciCalculator(this.exam);

  static const _sensoryLevels = [
    'C1',
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
    'S4_5',
  ];
  static const _motorLevels = [
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
  static const _uemsLevels = ['C5', 'C6', 'C7', 'C8', 'T1'];
  static const _lemsLevels = ['L2', 'L3', 'L4', 'L5', 'S1'];

  /// Função principal que orquestra todos os cálculos.
  IscnsciResult calculate() {
    // Passo 1 e 2: Determinar Níveis Sensoriais e Motores para cada lado
    final neurologicalLevels = _determineNeurologicalLevels();

    // Passo 3: Determinar Nível Neurológico da Lesão (NNL)
    final nli = _determineNeurologicalLevelOfInjury();

    // Passo 4: Determinar status de lesão completa/incompleta
    final injuryComplete = _determineInjuryComplete();

    // Passo 5: Determinar a Escala de Deficiência ASIA (AIS)
    final aisGrade = _determineAisGrade(
      injuryComplete: injuryComplete,
      neurologicalLevels: neurologicalLevels,
      neurologicalLevelOfInjury: nli,
    );

    // Passo 6: Determinar Zonas de Preservação Parcial (ZPP)
    final zpp = _determineZoneOfPartialPreservations(
      aisGrade: aisGrade,
      neurologicalLevels: neurologicalLevels,
    );

    // Calcular os totais para os scores
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
        injuryComplete: injuryComplete,
        asiaImpairmentScale: aisGrade,
        zoneOfPartialPreservations: zpp,
      ),
      totals: totals,
    );
  }

  // #region CÁLCULOS PRINCIPAIS (Orquestradores)

  String _determineInjuryComplete() {
    final allS4_5Values = [
      exam.right.lightTouch['S4_5'] ?? '0',
      exam.right.pinPrick['S4_5'] ?? '0',
      exam.left.lightTouch['S4_5'] ?? '0',
      exam.left.pinPrick['S4_5'] ?? '0',
    ];

    bool canBeAbsentSensory(String v) => ['0', '0*', 'NT', 'NT*'].contains(v);

    if (exam.voluntaryAnalContraction == 'No' &&
        exam.deepAnalPressure == 'No') {
      if (allS4_5Values.every((v) => v == '0')) return 'C';
      if (allS4_5Values.every((v) => ['0', '0*'].contains(v))) return 'C*,I*';
      if (allS4_5Values.every((v) => ['0', '0**'].contains(v))) return 'I*';
    }

    if (exam.voluntaryAnalContraction != 'Yes' &&
        exam.deepAnalPressure != 'Yes' &&
        allS4_5Values.every(canBeAbsentSensory)) {
      return 'C,I';
    }

    return 'I';
  }

  _NeurologicalLevels _determineNeurologicalLevels() {
    return _NeurologicalLevels(
      sensoryRight: _determineSensoryLevel(exam.right),
      sensoryLeft: _determineSensoryLevel(exam.left),
      motorRight: _determineMotorLevel(
        exam.right,
        exam.voluntaryAnalContraction,
      ),
      motorLeft: _determineMotorLevel(exam.left, exam.voluntaryAnalContraction),
    );
  }

  String _determineNeurologicalLevelOfInjury() {
    final listOfNLI = <String>{};
    bool variable = false;
    for (int i = 0; i < _sensoryLevels.length; i++) {
      final level = _sensoryLevels[i];
      if (i + 1 >= _sensoryLevels.length) {
        listOfNLI.add('INT' + (variable ? '*' : ''));
        break;
      }
      final nextLevel = _sensoryLevels[i + 1];

      final leftSensoryResult = _checkSensoryLevel(
        exam.left,
        level,
        nextLevel,
        variable,
      );
      final rightSensoryResult = _checkSensoryLevel(
        exam.right,
        level,
        nextLevel,
        variable,
      );

      _CheckLevelResult result;

      if (_levelIsBetween(i, 'C4', 'T1') || _levelIsBetween(i, 'L1', 'S1')) {
        final sensoryResult = _checkLevelWithoutMotor(
          level,
          leftSensoryResult,
          rightSensoryResult,
          variable,
        );
        result = _checkLevelWithMotor(level, sensoryResult, variable);
      } else {
        result = _checkLevelWithoutMotor(
          level,
          leftSensoryResult,
          rightSensoryResult,
          variable,
        );
      }

      variable = variable || result.variable;
      if (result.level != null) {
        listOfNLI.add(result.level!);
      }
      if (!result.continueProcessing) {
        break;
      }
    }
    return listOfNLI.toList().join(',');
  }

  String _determineAisGrade({
    required String injuryComplete,
    required _NeurologicalLevels neurologicalLevels,
    required String neurologicalLevelOfInjury,
  }) {
    // Caso especial para função normal, mas com NLI 'INT'
    if (neurologicalLevelOfInjury == 'INT' &&
        exam.voluntaryAnalContraction == 'Yes')
      return 'E';
    if (neurologicalLevelOfInjury == 'INT*' &&
        exam.voluntaryAnalContraction == 'Yes')
      return 'E*';

    final possibleScales = <String>{}; // Usar um Set para evitar duplicatas

    // Checar AIS A
    final resultA = _checkAsiaImpairmentScaleA(injuryComplete);
    if (resultA != null) possibleScales.add(resultA);

    // Checar AIS B
    final resultB = _checkAsiaImpairmentScaleB(neurologicalLevels);
    if (resultB != null) possibleScales.add(resultB);

    // Checar AIS C e D
    final canBeMotorIncompleteResult = _canBeMotorIncomplete(
      neurologicalLevels,
    );
    if (canBeMotorIncompleteResult.result) {
      final resultC = _checkAsiaImpairmentScaleC(
        neurologicalLevelOfInjury,
        canBeMotorIncompleteResult,
      );
      if (resultC != null) possibleScales.add(resultC);

      final resultD = _checkAsiaImpairmentScaleD(
        neurologicalLevelOfInjury,
        canBeMotorIncompleteResult,
      );
      if (resultD != null) possibleScales.add(resultD);
    }

    // Checar AIS E
    final resultE = _checkAsiaImpairmentScaleE(neurologicalLevelOfInjury);
    if (resultE != null) possibleScales.add(resultE);

    if (possibleScales.isEmpty) {
      // Fallback para o caso de nenhuma classificação ser encontrada, similar ao comportamento do AIS B.
      if (_isSensoryPreserved().result &&
          !_isMotorFunctionPreserved(neurologicalLevels).result) {
        return 'B';
      }
      return 'A'; // Se sensorialmente completo, é A.
    }

    // A ordem de prioridade é importante: A, B, C, D, E.
    final order = ['A', 'A*', 'B', 'B*', 'C', 'C*', 'D', 'D*', 'E', 'E*'];
    final sortedScales = possibleScales.toList()
      ..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
    return sortedScales.join(',');
  }

  ZoneOfPartialPreservations _determineZoneOfPartialPreservations({
    required String aisGrade,
    required _NeurologicalLevels neurologicalLevels,
  }) {
    return ZoneOfPartialPreservations(
      sensoryRight: _determineSensoryZPP(exam.right, exam.deepAnalPressure),
      sensoryLeft: _determineSensoryZPP(exam.left, exam.deepAnalPressure),
      motorRight: _determineMotorZPP(
        exam.right,
        exam.voluntaryAnalContraction,
        aisGrade,
        neurologicalLevels.motorRight,
      ),
      motorLeft: _determineMotorZPP(
        exam.left,
        exam.voluntaryAnalContraction,
        aisGrade,
        neurologicalLevels.motorLeft,
      ),
    );
  }

  // #endregion

  // #region DETERMINAÇÃO DE NÍVEIS (Sensorial e Motor)

  String _determineSensoryLevel(ExamSide side) {
    final levels = <String>{};
    bool variable = false;
    for (int i = 0; i < _sensoryLevels.length; i++) {
      final level = _sensoryLevels[i];
      if (i + 1 >= _sensoryLevels.length) {
        levels.add('INT' + (variable ? '*' : ''));
        break;
      }
      final nextLevel = _sensoryLevels[i + 1];
      final result = _checkSensoryLevel(side, level, nextLevel, variable);
      variable = variable || result.variable;
      if (result.level != null) {
        levels.add(result.level!);
      }
      if (!result.continueProcessing) {
        break;
      }
    }
    return levels.toList().join(',');
  }

  String _determineMotorLevel(ExamSide side, String vac) {
    final levels = <String>{};
    bool variable = false;

    for (int i = 0; i < _sensoryLevels.length; i++) {
      final level = _sensoryLevels[i];
      _CheckLevelResult? result;

      if (i + 1 >= _sensoryLevels.length) {
        // Chegou em S4_5
        if (vac == 'No') {
          if (levels.contains('S3') || levels.contains('S3*')) break;
          result = _CheckLevelResult(
            continueProcessing: false,
            level: 'S3' + (variable ? '*' : ''),
          );
        } else if (vac == 'NT') {
          if (!levels.contains('S3') && !levels.contains('S3*'))
            levels.add('S3' + (variable ? '*' : ''));
          result = _CheckLevelResult(
            continueProcessing: false,
            level: 'INT' + (variable ? '*' : ''),
          );
        } else {
          // Yes
          result = _CheckLevelResult(
            continueProcessing: false,
            level: 'INT' + (variable ? '*' : ''),
          );
        }
      } else {
        final nextLevel = _sensoryLevels[i + 1];
        if (_levelIsBetween(i, 'C1', 'C3') ||
            _levelIsBetween(i, 'T2', 'T12') ||
            _levelIsBetween(i, 'S2', 'S3')) {
          result = _checkSensoryLevel(side, level, nextLevel, variable);
        } else if (level == 'C4' || level == 'L1') {
          final nextMotor = level == 'C4' ? 'C5' : 'L2';
          result = _checkMotorLevelBeforeStartOfKeyMuscles(
            side,
            level,
            nextMotor,
            variable,
          );
        } else if (_levelIsBetween(i, 'C5', 'C8') ||
            _levelIsBetween(i, 'L2', 'L5')) {
          final motorIndex = i - (_levelIsBetween(i, 'C5', 'C8') ? 4 : 16);
          result = _checkMotorLevel(
            side,
            _motorLevels[motorIndex],
            _motorLevels[motorIndex + 1],
            variable,
          );
        } else if (level == 'T1' || level == 'S1') {
          result = _checkMotorLevelAtEndOfKeyMuscles(side, level, variable);
        }
      }

      if (result != null) {
        variable = variable || result.variable;
        if (result.level != null) {
          levels.add(result.level!);
        }
        if (!result.continueProcessing) {
          break;
        }
      }
    }
    return levels.toList().join(',');
  }

  // #endregion

  // #region HELPERS DE NÍVEIS (Sensorial, Motor, NLI)

  bool _levelIsBetween(int index, String start, String end) {
    final startIndex = _sensoryLevels.indexOf(start);
    final endIndex = _sensoryLevels.indexOf(end);
    return index >= startIndex && index <= endIndex;
  }

  _CheckLevelResult _checkSensoryLevel(
    ExamSide side,
    String level,
    String nextLevel,
    bool variable,
  ) {
    final ltNext = side.lightTouch[nextLevel] ?? '0';
    final ppNext = side.pinPrick[nextLevel] ?? '0';

    bool isAbnormal(String v) => ['0', '1', '0*', '1*'].contains(v);
    bool isNtVariable(String v) => ['0**', '1**'].contains(v);
    bool isNtNotVariable(String v) => ['2', 'NT', 'NT**'].contains(v);

    if (ltNext == '2' && ppNext == '2') {
      return _CheckLevelResult(continueProcessing: true, variable: variable);
    }
    if (isAbnormal(ltNext) || isAbnormal(ppNext)) {
      return _CheckLevelResult(
        continueProcessing: false,
        level: level + (variable ? '*' : ''),
        variable: variable,
      );
    }
    if ([ltNext, ppNext].contains('NT*')) {
      return _CheckLevelResult(
        continueProcessing: false,
        level: '$level*',
        variable: true,
      );
    }
    if (ltNext == 'NT' || ppNext == 'NT') {
      if (isNtVariable(ltNext) || isNtVariable(ppNext)) {
        return _CheckLevelResult(
          continueProcessing: true,
          level: level + (variable ? '*' : ''),
          variable: true,
        );
      }
      if (isNtNotVariable(ltNext) || isNtNotVariable(ppNext)) {
        return _CheckLevelResult(
          continueProcessing: true,
          level: level + (variable ? '*' : ''),
          variable: variable,
        );
      }
    }
    return _CheckLevelResult(continueProcessing: true, variable: true);
  }

  _CheckLevelResult _checkLevelWithoutMotor(
    String level,
    _CheckLevelResult left,
    _CheckLevelResult right,
    bool variable,
  ) {
    String? resultLevel;
    if (left.level != null || right.level != null) {
      if (left.level != null &&
          right.level != null &&
          left.level!.contains('*') &&
          right.level!.contains('*')) {
        resultLevel = '$level*';
      } else {
        resultLevel = level + (variable ? '*' : '');
      }
    }
    return _CheckLevelResult(
      continueProcessing: left.continueProcessing && right.continueProcessing,
      level: resultLevel,
      variable: variable || left.variable || right.variable,
    );
  }

  _CheckLevelResult _checkLevelWithMotor(
    String level,
    _CheckLevelResult sensoryResult,
    bool variable,
  ) {
    final i = _sensoryLevels.indexOf(level);
    final index = i - (_levelIsBetween(i, 'C4', 'T1') ? 4 : 16);
    final motorLevel = _motorLevels[index];
    final nextMotorLevel = _motorLevels[index + 1];

    final leftMotorResult = _getMotorResultForNLI(
      exam.left,
      level,
      motorLevel,
      nextMotorLevel,
      variable,
    );
    final rightMotorResult = _getMotorResultForNLI(
      exam.right,
      level,
      motorLevel,
      nextMotorLevel,
      variable,
    );

    String? resultLevel;
    if (leftMotorResult.level != null ||
        rightMotorResult.level != null ||
        sensoryResult.level != null) {
      if (leftMotorResult.level != null &&
          rightMotorResult.level != null &&
          (leftMotorResult.level!.contains('*') ||
              rightMotorResult.level!.contains('*'))) {
        resultLevel = '$level*';
      } else {
        resultLevel = level + (variable ? '*' : '');
      }
    }

    if (!sensoryResult.continueProcessing) {
      return _CheckLevelResult(
        level: resultLevel,
        continueProcessing: false,
        variable: sensoryResult.variable,
      );
    }

    return _CheckLevelResult(
      continueProcessing:
          leftMotorResult.continueProcessing &&
          rightMotorResult.continueProcessing,
      level: resultLevel,
      variable:
          variable ||
          sensoryResult.variable ||
          leftMotorResult.variable ||
          rightMotorResult.variable,
    );
  }

  _CheckLevelResult _getMotorResultForNLI(
    ExamSide side,
    String level,
    String motorLevel,
    String nextMotorLevel,
    bool variable,
  ) {
    if (level == 'C4' || level == 'L1') {
      return _checkMotorLevelBeforeStartOfKeyMuscles(
        side,
        level,
        nextMotorLevel,
        variable,
      );
    }
    if (level == 'T1' || level == 'S1') {
      return _checkMotorLevel(
        side,
        motorLevel,
        motorLevel,
        variable,
      ); // Hotfix from TS
    }
    return _checkMotorLevel(side, motorLevel, nextMotorLevel, variable);
  }

  _CheckLevelResult _checkMotorLevelBeforeStartOfKeyMuscles(
    ExamSide side,
    String level,
    String nextLevel,
    bool variable,
  ) {
    final nextMotorValue = side.motor[nextLevel] ?? '0';
    return _CheckLevelResult(
      continueProcessing: !['0', '1', '2'].contains(nextMotorValue),
      level:
          [
            '0',
            '1',
            '2',
            '0*',
            '1*',
            '2*',
            'NT',
            'NT*',
          ].contains(nextMotorValue)
          ? level + (variable ? '*' : '')
          : null,
      variable: variable || ['0**', '1**', '2**'].contains(nextMotorValue),
    );
  }

  _CheckLevelResult _checkMotorLevel(
    ExamSide side,
    String level,
    String nextLevel,
    bool variable,
  ) {
    final motorVal = side.motor[level] ?? '0';
    final nextMotorVal = side.motor[nextLevel] ?? '0';
    bool shouldContinue = false;
    String? resultLevel;
    bool isVariable = variable;

    if (!['0', '1', '2'].contains(motorVal)) {
      if (!['0*', '1*', '2*', 'NT*', '3', '4', '3*', '4*'].contains(motorVal)) {
        if (!['0', '1', '2'].contains(nextMotorVal)) {
          shouldContinue = true;
        }
      }
    }

    if (!(['5', '0**', '1**', '2**', '3**', '4**', 'NT**'].contains(motorVal) &&
        ![
          '0',
          '1',
          '2',
          '0*',
          '1*',
          '2*',
          'NT',
          'NT*',
        ].contains(nextMotorVal))) {
      if (['0*', '1*', '2*', 'NT*'].contains(motorVal) ||
          (['0**', '1**', '2**'].contains(motorVal) &&
              ['0*', '1*', '2*', 'NT', 'NT*'].contains(nextMotorVal))) {
        resultLevel = '$level*';
      } else {
        resultLevel = level + (variable ? '*' : '');
      }
    }

    if (!['5', '3', '4', '3*', '4*', 'NT'].contains(motorVal)) {
      if (['0**', '1**', '2**', '3**', '4**', 'NT**'].contains(motorVal)) {
        if (!['0', '1', '2'].contains(nextMotorVal)) isVariable = true;
      } else {
        isVariable = true;
      }
    } else if (motorVal == '5' &&
        ['0**', '1**', '2**'].contains(nextMotorVal)) {
      isVariable = true;
    }

    return _CheckLevelResult(
      continueProcessing: shouldContinue,
      level: resultLevel,
      variable: isVariable,
    );
  }

  _CheckLevelResult _checkMotorLevelAtEndOfKeyMuscles(
    ExamSide side,
    String level,
    bool variable,
  ) {
    final motorVal = side.motor[level] ?? '0';
    if (['0', '1', '2'].contains(motorVal)) {
      throw Exception('Invalid motor value at current level');
    }

    final firstMotorLevelOfMotorBlock = level == 'T1' ? 'C5' : 'L2';
    final sensoryCheckLevelResult = _checkMotorLevelUsingSensoryValues(
      side,
      firstMotorLevelOfMotorBlock,
    );
    return _checkWithSensoryCheckLevelResult(
      side,
      level,
      variable,
      sensoryCheckLevelResult,
    );
  }

  _CheckLevelResult _checkMotorLevelUsingSensoryValues(
    ExamSide side,
    String firstMotorLevelOfMotorBlock,
  ) {
    final startIndex = _sensoryLevels.indexOf(firstMotorLevelOfMotorBlock) - 1;
    final result = _CheckLevelResult(continueProcessing: true, variable: false);
    String? finalLevel;
    bool finalVariable = false;
    bool finalContinue = true;

    for (int i = startIndex; i <= startIndex + 5; i++) {
      final level = _sensoryLevels[i];
      final nextLevel = _sensoryLevels[i + 1];
      final currentLevelResult = _checkSensoryLevel(
        side,
        level,
        nextLevel,
        false,
      );
      if (!currentLevelResult.continueProcessing) finalContinue = false;
      if (currentLevelResult.level != null)
        finalLevel = currentLevelResult.level;
      if (currentLevelResult.variable) finalVariable = true;
    }
    return _CheckLevelResult(
      continueProcessing: finalContinue,
      level: finalLevel,
      variable: finalVariable,
    );
  }

  _CheckLevelResult _checkWithSensoryCheckLevelResult(
    ExamSide side,
    String level,
    bool variable,
    _CheckLevelResult sensoryCheckLevelResult,
  ) {
    final motorVal = side.motor[level] ?? '0';
    bool shouldContinue = true;
    String? resultLevel;
    bool isVariable = variable;

    if (['3', '4', '0*', '1*', '2*', '3*', '4*', 'NT*'].contains(motorVal) ||
        !sensoryCheckLevelResult.continueProcessing) {
      shouldContinue = false;
    }

    if (motorVal == 'NT' ||
        !(['5', '0**', '1**', '2**', '3**', '4**', 'NT**'].contains(motorVal) &&
            sensoryCheckLevelResult.continueProcessing &&
            sensoryCheckLevelResult.level == null)) {
      if (['0*', '1*', '2*', 'NT*'].contains(motorVal) ||
          (['0**', '1**', '2**'].contains(motorVal) &&
              (sensoryCheckLevelResult.level != null ||
                  !sensoryCheckLevelResult.continueProcessing))) {
        resultLevel = '$level*';
      } else {
        resultLevel = level + (variable ? '*' : '');
      }
    }

    if (['0*', '1*', '2*', 'NT*', '0**', '1**', '2**'].contains(motorVal) ||
        (['3**', '4**', 'NT**'].contains(motorVal) &&
            sensoryCheckLevelResult.continueProcessing) ||
        (['5', 'NT'].contains(motorVal) &&
            (sensoryCheckLevelResult.continueProcessing &&
                sensoryCheckLevelResult.variable &&
                sensoryCheckLevelResult.level == null))) {
      isVariable = true;
    }

    return _CheckLevelResult(
      continueProcessing: shouldContinue,
      level: resultLevel,
      variable: isVariable,
    );
  }

  // #endregion

  // #region HELPERS DE ESCALA AIS

  String? _checkAsiaImpairmentScaleA(String injuryComplete) {
    if (injuryComplete.startsWith('C')) {
      return injuryComplete.contains('*') ? 'A*' : 'A';
    }
    return null;
  }

  String? _checkAsiaImpairmentScaleB(_NeurologicalLevels neurologicalLevels) {
    final isSensoryPreservedResult = _isSensoryPreserved();
    final motorIsNotPreservedResult = _motorIsNotPreserved(neurologicalLevels);

    final canBeB =
        isSensoryPreservedResult.result && motorIsNotPreservedResult.result;

    if (canBeB) {
      final isVariable =
          isSensoryPreservedResult.variable ||
          motorIsNotPreservedResult.variable;
      return isVariable ? 'B*' : 'B';
    }
    return null;
  }

  String? _checkAsiaImpairmentScaleC(
    String nli,
    _CheckResult canBeMotorIncompleteResult,
  ) {
    final motorFunctionC = _canHaveLessThanHalfKeyMusclesGradeAtLeast3(nli);
    if (motorFunctionC.result) {
      // A lógica para o '*' em C é complexa e depende do resultado sem estrelas.
      // Uma implementação completa exigiria recálculos recursivos, mas por agora
      // consideramos a variabilidade do resultado atual e da condição de ser motor incompleto.
      if (motorFunctionC.variable || canBeMotorIncompleteResult.variable) {
        return 'C*';
      }
      return 'C';
    }
    return null;
  }

  String? _checkAsiaImpairmentScaleD(
    String nli,
    _CheckResult canBeMotorIncompleteResult,
  ) {
    final motorFunctionD = _canHaveAtLeastHalfKeyMusclesGradeAtLeast3(nli);
    if (motorFunctionD.result) {
      if (motorFunctionD.variable || canBeMotorIncompleteResult.variable) {
        return 'D*';
      }
      return 'D';
    }
    return null;
  }

  String? _checkAsiaImpairmentScaleE(String nli) {
    if (exam.voluntaryAnalContraction != 'No') {
      if (nli.contains('INT*')) return 'E*';
      if (nli.contains('INT')) return 'E';
    }

    bool isNormal(String value, {required bool isMotor}) {
      if (value.toUpperCase().startsWith('NT') ||
          (value.contains('*') && !value.contains('**')))
        return false;
      if (value.contains('**')) return true;
      final numericValue = _getNumericValue(value);
      return isMotor ? numericValue == 5 : numericValue == 2;
    }

    bool allNormal(Iterable<String> values, bool isMotor) =>
        values.every((v) => isNormal(v, isMotor: isMotor));
    bool isAnyValueImpaired(ExamSide side) => [
      ...side.motor.values,
      ...side.lightTouch.values,
      ...side.pinPrick.values,
    ].any((v) => (v.contains('*') && !v.contains('**')));

    final normalExam =
        allNormal(exam.right.motor.values, true) &&
        allNormal(exam.left.motor.values, true) &&
        allNormal(exam.right.lightTouch.values, false) &&
        allNormal(exam.right.pinPrick.values, false) &&
        allNormal(exam.left.lightTouch.values, false) &&
        allNormal(exam.left.pinPrick.values, false) &&
        exam.voluntaryAnalContraction == 'Yes' &&
        exam.deepAnalPressure == 'Yes';

    if (normalExam) {
      final hasAnyImpairment =
          isAnyValueImpaired(exam.right) || isAnyValueImpaired(exam.left);
      return hasAnyImpairment ? 'E*' : 'E';
    }
    return null;
  }

  int _startingMotorIndex(int sensoryIndex) {
    if (sensoryIndex >= _sensoryLevels.indexOf('C2') &&
        sensoryIndex <= _sensoryLevels.indexOf('C4'))
      return 0;
    if (sensoryIndex >= _sensoryLevels.indexOf('C5') &&
        sensoryIndex <= _sensoryLevels.indexOf('T1'))
      return sensoryIndex - 4;
    if (sensoryIndex >= _sensoryLevels.indexOf('T2') &&
        sensoryIndex <= _sensoryLevels.indexOf('L1'))
      return 5;
    if (sensoryIndex >= _sensoryLevels.indexOf('L2') &&
        sensoryIndex <= _sensoryLevels.indexOf('S1'))
      return sensoryIndex - 16;
    return _motorLevels.length;
  }

  _CheckResult _isSensoryPreserved() {
    final sensoryAtS45 = [
      exam.right.lightTouch['S4_5'] ?? '0',
      exam.right.pinPrick['S4_5'] ?? '0',
      exam.left.lightTouch['S4_5'] ?? '0',
      exam.left.pinPrick['S4_5'] ?? '0',
    ];

    final result =
        (exam.deepAnalPressure == 'Yes') ||
        sensoryAtS45.any((v) => _getNumericValue(v) != 0);

    final variable =
        (exam.deepAnalPressure != 'Yes') &&
        !sensoryAtS45.every((v) => v == '0') &&
        sensoryAtS45.every((v) => ['0', '0*', '0**'].contains(v));

    return _CheckResult(result: result, variable: variable);
  }

  _CheckResult _canBeMotorIncomplete(_NeurologicalLevels neuroLevels) {
    if (exam.voluntaryAnalContraction == 'Yes') {
      return _CheckResult(result: true);
    }

    final isSensoryPreservedResult = _isSensoryPreserved();
    if (isSensoryPreservedResult.result) {
      final rightMotorResult = _canHaveMotorFunctionMoreThanThreeLevelsBelow(
        exam.right,
        neuroLevels.motorRight,
      );
      final leftMotorResult = _canHaveMotorFunctionMoreThanThreeLevelsBelow(
        exam.left,
        neuroLevels.motorLeft,
      );

      if (rightMotorResult.result || leftMotorResult.result) {
        return _CheckResult(
          result: true,
          variable: rightMotorResult.variable || leftMotorResult.variable,
        );
      }
    }
    return _CheckResult(result: false);
  }

  _CheckResult _canHaveMotorFunctionMoreThanThreeLevelsBelow(
    ExamSide side,
    String motorLevel,
  ) {
    final lowestNonKey = side.lowestNonKeyMuscleWithMotorFunction;
    bool variable = false;

    for (final level in motorLevel.split(',')) {
      final nliClean = level.replaceAll('*', '');
      final index = (nliClean == 'INT')
          ? _sensoryLevels.indexOf('S4_5')
          : _sensoryLevels.indexOf(nliClean) + 4;

      final startingIndex = _startingMotorIndex(index);

      for (int i = startingIndex; i < _motorLevels.length; i++) {
        final mLevel = _motorLevels[i];
        final value = side.motor[mLevel] ?? '0';
        if (value == '0**') variable = true;

        if ((_getNumericValue(value) ?? 0) > 0 || mLevel == lowestNonKey) {
          return _CheckResult(result: true, variable: variable);
        }
      }
    }
    return _CheckResult(result: variable, variable: variable);
  }

  _CheckResult _motorIsNotPreserved(_NeurologicalLevels neuroLevels) {
    final rightMotorResult = _canHaveNoMotorFunctionMoreThanThreeLevelsBelow(
      exam.right,
      neuroLevels.motorRight,
    );
    final leftMotorResult = _canHaveNoMotorFunctionMoreThanThreeLevelsBelow(
      exam.left,
      neuroLevels.motorLeft,
    );

    return _CheckResult(
      result:
          exam.voluntaryAnalContraction != 'Yes' &&
          rightMotorResult.result &&
          leftMotorResult.result,
      variable:
          exam.voluntaryAnalContraction == 'No' &&
          (rightMotorResult.variable || leftMotorResult.variable),
    );
  }

  _CheckResult _canHaveNoMotorFunctionMoreThanThreeLevelsBelow(
    ExamSide side,
    String motorLevel,
  ) {
    final lowestNonKey = side.lowestNonKeyMuscleWithMotorFunction;
    bool variable = false;

    for (final m in motorLevel.split(',')) {
      final level = m.replaceAll('*', '');
      final index = (level == 'INT')
          ? _sensoryLevels.indexOf('S4_5')
          : _sensoryLevels.indexOf(level) + 4;

      final startingIndex = _startingMotorIndex(index);

      bool noMotorFunction = true;
      for (int i = startingIndex; i < _motorLevels.length; i++) {
        final currentMotorLevel = _motorLevels[i];
        final value = side.motor[currentMotorLevel] ?? '0';

        if (value == '0*' || value == '0**') variable = true;

        if (!['0', 'NT', 'NT*', '0*'].contains(value) ||
            currentMotorLevel == lowestNonKey) {
          noMotorFunction = false;
          if (value == '0*') variable = true;
          break;
        }
      }
      if (noMotorFunction) {
        return _CheckResult(result: true, variable: variable);
      }
    }
    return _CheckResult(result: false, variable: false);
  }

  _CheckResult _canHaveLessThanHalfKeyMusclesGradeAtLeast3(String nli) {
    for (final level in nli.replaceAll('*', '').split(',')) {
      final nliIndex = (level == 'INT')
          ? _sensoryLevels.indexOf('S4_5')
          : _sensoryLevels.indexOf(level);
      if (nliIndex == -1) continue;

      final startIndex = _startingMotorIndex(nliIndex + 1);
      final musclesBelowNli = _motorLevels.sublist(startIndex);

      if (musclesBelowNli.isEmpty) continue;

      final totalMuscles = musclesBelowNli.length * 2;
      double count = 0;
      double variableCount = 0;

      for (final mLevel in musclesBelowNli) {
        final leftVal = exam.left.motor[mLevel] ?? '';
        final rightVal = exam.right.motor[mLevel] ?? '';

        if (['0', '1', '2', 'NT', 'NT*'].contains(leftVal)) count++;
        if (['0*', '1*', '2*'].contains(leftVal)) {
          count++;
          variableCount++;
        }

        if (['0', '1', '2', 'NT', 'NT*'].contains(rightVal)) count++;
        if (['0*', '1*', '2*'].contains(rightVal)) {
          count++;
          variableCount++;
        }
      }

      if (count - variableCount > totalMuscles / 2) {
        return _CheckResult(result: true, variable: false);
      }
      if (count > totalMuscles / 2 &&
          count - variableCount <= totalMuscles / 2) {
        return _CheckResult(result: true, variable: true);
      }
    }
    return _CheckResult(result: false, variable: false);
  }

  _CheckResult _canHaveAtLeastHalfKeyMusclesGradeAtLeast3(String nli) {
    _CheckResult overallResult = _CheckResult();

    for (final level in nli.replaceAll('*', '').split(',')) {
      if (level == 'INT') break;

      final nliIndex = _sensoryLevels.indexOf(level);
      if (nliIndex == -1) continue;

      final startIndex = _startingMotorIndex(nliIndex + 1);
      final musclesBelowNli = _motorLevels.sublist(startIndex);

      final half = musclesBelowNli.length.toDouble();
      if (half == 0) return _CheckResult(result: true);

      double count = 0;
      double variableCount = 0;

      for (final mLevel in musclesBelowNli) {
        final leftVal = exam.left.motor[mLevel] ?? '';
        final rightVal = exam.right.motor[mLevel] ?? '';

        if (!['0', '1', '2'].contains(leftVal)) count++;
        if (!['0', '1', '2'].contains(rightVal)) count++;

        if (['0*', '1*', '2*', '0**', '1**', '2**'].contains(leftVal))
          variableCount++;
        if (['0*', '1*', '2*', '0**', '1**', '2**'].contains(rightVal))
          variableCount++;
      }

      if (count - variableCount >= half) {
        return _CheckResult(result: true, variable: false);
      }
      if (count >= half) {
        overallResult.result = true;
        overallResult.variable =
            overallResult.variable || (count - variableCount < half);
      }
    }
    return overallResult;
  }

  _CheckResult _isMotorFunctionPreserved(_NeurologicalLevels neuroLevels) {
    if (exam.voluntaryAnalContraction == 'Yes')
      return _CheckResult(result: true);

    final rightResult = _canHaveMotorFunctionMoreThanThreeLevelsBelow(
      exam.right,
      neuroLevels.motorRight,
    );
    final leftResult = _canHaveMotorFunctionMoreThanThreeLevelsBelow(
      exam.left,
      neuroLevels.motorLeft,
    );

    return _CheckResult(
      result: rightResult.result || leftResult.result,
      variable: rightResult.variable || leftResult.variable,
    );
  }

  // #endregion

  // #region ZPP (Sensorial e Motor)

  String _determineSensoryZPP(ExamSide side, String deepAnalPressure) {
    bool canBeAbsentSensory(String v) => ['0', '0*', 'NT', 'NT*'].contains(v);

    var zpp = <String>[];
    bool variable = false;
    if ((deepAnalPressure == 'No' || deepAnalPressure == 'NT') &&
        canBeAbsentSensory(side.lightTouch['S4_5'] ?? '0') &&
        canBeAbsentSensory(side.pinPrick['S4_5'] ?? '0')) {
      final sacralResult = _checkLevelForSensoryZPP(side, 'S4_5', variable);
      if (deepAnalPressure == 'NT' ||
          (deepAnalPressure == 'No' &&
              (!sacralResult.continueProcessing ||
                  sacralResult.level != null))) {
        zpp.add('NA');
      }

      final levels = <String>[];
      for (int i = _sensoryLevels.indexOf('S3'); i >= 0; i--) {
        final level = _sensoryLevels[i];
        if (i > 0) {
          final result = _checkLevelForSensoryZPP(side, level, variable);
          variable = variable || result.variable;
          if (result.level != null) {
            levels.insert(0, result.level!);
          }
          if (result.continueProcessing) {
            continue;
          } else {
            break;
          }
        } else {
          levels.insert(0, level);
        }
      }
      zpp.addAll(levels);

      final zppSet = zpp.toSet().toList(); // Remove duplicates
      zppSet.sort((a, b) {
        final aIndex = a == 'NA'
            ? -1
            : _sensoryLevels.indexOf(a.replaceAll('*', ''));
        final bIndex = b == 'NA'
            ? -1
            : _sensoryLevels.indexOf(b.replaceAll('*', ''));
        return aIndex.compareTo(bIndex);
      });
      return zppSet.join(',');
    } else {
      return 'NA';
    }
  }

  _CheckLevelResult _checkLevelForSensoryZPP(
    ExamSide side,
    String level,
    bool variable,
  ) {
    bool isAbsent(String v) => v == '0';
    bool canBeAbsent(String v) => ['0', '0*', 'NT', 'NT*'].contains(v);

    final pinPrickVal = side.pinPrick[level] ?? '0';
    final lightTouchVal = side.lightTouch[level] ?? '0';

    if (isAbsent(pinPrickVal) && isAbsent(lightTouchVal)) {
      return _CheckLevelResult(continueProcessing: true, variable: variable);
    }
    if (!canBeAbsent(pinPrickVal) || !canBeAbsent(lightTouchVal)) {
      return _CheckLevelResult(
        continueProcessing: false,
        level: level + (variable ? '*' : ''),
        variable: variable,
      );
    } else {
      final hasNT = [
        pinPrickVal,
        lightTouchVal,
      ].any((v) => ['NT', 'NT*'].contains(v));
      if (hasNT) {
        return _CheckLevelResult(
          continueProcessing: true,
          level: level + (variable ? '*' : ''),
          variable: variable,
        );
      } else {
        return _CheckLevelResult(
          continueProcessing: true,
          level: '$level*',
          variable: variable || !hasNT,
        );
      }
    }
  }

  // #endregion

  // #region ZPP MOTOR (Máquina de Estados)

  String _determineMotorZPP(
    ExamSide side,
    String vac,
    String ais,
    String motorLevel,
  ) {
    // A máquina de estados é iniciada e executada até que não haja próximo passo.
    var step = _ZppStep(
      _getInitialMotorZppState(side, vac, ais, motorLevel),
      _checkIfMotorZPPIsApplicable,
    );

    while (step.next != null) {
      step = step.next!(step.state);
    }

    return step.state.zpp.join(',');
  }

  _MotorZppState _getInitialMotorZppState(
    ExamSide side,
    String vac,
    String ais,
    String motorLevel,
  ) {
    final c1 = _SideLevel(
      name: 'C1',
      lightTouch: '2',
      pinPrick: '2',
      motor: null,
      index: -1,
    );
    return _MotorZppState(
      ais: ais,
      motorLevel: motorLevel.replaceAll('*', ''),
      voluntaryAnalContraction: vac,
      zpp: [],
      side: side,
      topLevel: c1,
      bottomLevel: c1,
      lastLevelWithConsecutiveNormalValues: c1,
    );
  }

  _ZppStep _checkIfMotorZPPIsApplicable(_MotorZppState state) {
    if (state.voluntaryAnalContraction == 'Yes') {
      state.zpp = ['NA'];
      return _ZppStep(state, null); // Fim
    }
    if (state.voluntaryAnalContraction == 'NT') {
      state.zpp = ['NA'];
    }
    return _ZppStep(state, _checkLowerNonKeyMuscle);
  }

  _ZppStep _checkLowerNonKeyMuscle(_MotorZppState state) {
    state.testNonKeyMuscle =
        state.side.lowestNonKeyMuscleWithMotorFunction != null &&
        state.ais.toUpperCase().contains('C');
    return _ZppStep(state, _getTopAndBottomLevelsForCheck);
  }

  _ZppStep _getTopAndBottomLevelsForCheck(_MotorZppState state) {
    if (state.motorLevel.isEmpty) {
      return _ZppStep(state, _sortMotorZPP);
    }
    final motorLevels = state.motorLevel.split(',');
    final top = motorLevels[0];
    final lowestMotorLevel = motorLevels.last;

    final hasMotorBelowS1 = RegExp(
      r'(S2|S3|INT)\*?(,|$)',
    ).hasMatch(state.motorLevel);
    final bottom = hasMotorBelowS1
        ? lowestMotorLevel == 'INT'
              ? 'S3'
              : lowestMotorLevel
        : 'S1';

    try {
      final range = _getLevelsRange(
        state.side,
        top,
        bottom,
        state.side.lowestNonKeyMuscleWithMotorFunction,
      );
      state.topLevel = range.topLevel;
      state.bottomLevel = range.bottomLevel;
      state.currentLevel = range.bottomLevel;
      state.nonKeyMuscle = range.nonKeyMuscle;
      state.firstLevelWithStar = range.firstLevelWithStar;
      state.lastLevelWithConsecutiveNormalValues =
          range.lastLevelWithConsecutiveNormalValues;
    } catch (e) {
      // Se não for possível criar o range, não há ZPP a ser calculada além do que já foi definido.
      return _ZppStep(state, _sortMotorZPP);
    }

    return _ZppStep(state, _checkLevel);
  }

  _ZppStep _checkLevel(_MotorZppState state) {
    if (state.currentLevel == null) {
      return _ZppStep(state, _addLowerNonKeyMuscleToMotorZPPIfNeeded);
    }
    return state.currentLevel!.motor != null
        ? _checkForMotorFunction(state)
        : _checkForSensoryFunction(state);
  }

  _ZppStep _checkForMotorFunction(_MotorZppState state) {
    final currentLevel = state.currentLevel!;
    final motorValue = currentLevel.motor ?? '';

    final isNonKeyMuscle =
        state.nonKeyMuscle != null &&
        currentLevel.name == state.nonKeyMuscle!.name;
    final overrideWithNonKeyMuscle =
        state.testNonKeyMuscle &&
        state.nonKeyMuscle != null &&
        state.nonKeyMuscle!.index - currentLevel.index > 3;
    final isTopRangeLevel = currentLevel.name == state.topLevel.name;

    // Se motor > 0 ou NT**
    if (RegExp(r'^[1-5]').hasMatch(motorValue) ||
        RegExp(r'^(NT|[0-4])\*\*$').hasMatch(motorValue)) {
      final hasStar = _hasStarOnCurrentOrAboveLevel(
        currentLevel,
        state.lastLevelWithConsecutiveNormalValues,
        state.firstLevelWithStar,
      );
      if (overrideWithNonKeyMuscle) {
        state.addNonKeyMuscle = true;
      } else {
        state.zpp.add('${currentLevel.name}${hasStar ? '*' : ''}');
        state.nonKeyMuscleHasBeenAdded =
            state.nonKeyMuscleHasBeenAdded || isNonKeyMuscle;
      }
      return _ZppStep(state, _addLowerNonKeyMuscleToMotorZPPIfNeeded);
    }

    // Se motor é NT, NT* ou 0*
    if (RegExp(r'^(NT\*?$)|(0\*$)').hasMatch(motorValue)) {
      final hasStar = _hasStarOnCurrentOrAboveLevel(
        currentLevel,
        state.lastLevelWithConsecutiveNormalValues,
        state.firstLevelWithStar,
      );
      if (overrideWithNonKeyMuscle) {
        state.addNonKeyMuscle = true;
      } else {
        state.zpp.add('${currentLevel.name}${hasStar ? '*' : ''}');
        state.nonKeyMuscleHasBeenAdded =
            state.nonKeyMuscleHasBeenAdded || isNonKeyMuscle;
      }
      state.currentLevel = currentLevel.previous;
      return _ZppStep(
        state,
        isTopRangeLevel ? _addLowerNonKeyMuscleToMotorZPPIfNeeded : _checkLevel,
      );
    }

    // Se não há função
    state.currentLevel = currentLevel.previous;
    return _ZppStep(
      state,
      isTopRangeLevel ? _addLowerNonKeyMuscleToMotorZPPIfNeeded : _checkLevel,
    );
  }

  _ZppStep _checkForSensoryFunction(_MotorZppState state) {
    final currentLevel = state.currentLevel!;
    final isTopRange = currentLevel.name == state.topLevel.name;

    if (state.motorLevel.split(',').contains(currentLevel.name)) {
      final hasStar = _hasStarOnCurrentOrAboveLevel(
        currentLevel,
        state.lastLevelWithConsecutiveNormalValues,
        state.firstLevelWithStar,
      );
      final motorZPPName = '${currentLevel.name}${hasStar ? '*' : ''}';
      final overrideWithNonKeyMuscle =
          state.testNonKeyMuscle &&
          state.nonKeyMuscle != null &&
          state.nonKeyMuscle!.index - currentLevel.index > 3;

      if (!overrideWithNonKeyMuscle) {
        state.zpp.add(motorZPPName);
      }
      state.addNonKeyMuscle = state.addNonKeyMuscle || overrideWithNonKeyMuscle;
    }

    state.currentLevel = currentLevel.previous;
    return _ZppStep(
      state,
      isTopRange ? _addLowerNonKeyMuscleToMotorZPPIfNeeded : _checkLevel,
    );
  }

  _ZppStep _addLowerNonKeyMuscleToMotorZPPIfNeeded(_MotorZppState state) {
    if (state.addNonKeyMuscle &&
        !state.nonKeyMuscleHasBeenAdded &&
        state.nonKeyMuscle != null) {
      state.zpp.add(state.nonKeyMuscle!.name);
    }
    return _ZppStep(state, _sortMotorZPP);
  }

  _ZppStep _sortMotorZPP(_MotorZppState state) {
    state.zpp = state.zpp.toSet().toList(); // Remover duplicatas
    state.zpp.sort((a, b) {
      final aIndex = a == 'NA'
          ? -1
          : _sensoryLevels.indexOf(a.replaceAll('*', ''));
      final bIndex = b == 'NA'
          ? -1
          : _sensoryLevels.indexOf(b.replaceAll('*', ''));
      return aIndex.compareTo(bIndex);
    });
    return _ZppStep(state, null); // Fim
  }

  _LevelsRangeResult _getLevelsRange(
    ExamSide side,
    String top,
    String bottom,
    String? nonKeyMuscleName,
  ) {
    _SideLevel? currentLevel;
    _SideLevel? topLevel;
    _SideLevel? bottomLevel;
    _SideLevel? nonKeyMuscle;
    _SideLevel? firstLevelWithStar;
    _SideLevel? lastLevelWithConsecutiveNormalValues;

    for (int i = 0; i < _sensoryLevels.length && bottomLevel == null; i++) {
      final sensoryLevelName = _sensoryLevels[i];
      final isMotor = _motorLevels.contains(sensoryLevelName);
      final motorLevelName = isMotor ? sensoryLevelName : null;

      final level = _SideLevel(
        name: sensoryLevelName,
        lightTouch: sensoryLevelName == 'C1'
            ? '2'
            : side.lightTouch[sensoryLevelName] ?? '0',
        pinPrick: sensoryLevelName == 'C1'
            ? '2'
            : side.pinPrick[sensoryLevelName] ?? '0',
        motor: motorLevelName != null ? side.motor[motorLevelName] : null,
        index: i,
      );

      if (firstLevelWithStar == null &&
          (RegExp(r'\*').hasMatch(level.lightTouch) ||
              RegExp(r'\*').hasMatch(level.pinPrick) ||
              RegExp(r'\*').hasMatch(level.motor ?? ''))) {
        firstLevelWithStar = level;
      }
      if (lastLevelWithConsecutiveNormalValues == null &&
          (!RegExp(r'(^2$)|(\*\*$)').hasMatch(level.lightTouch) ||
              !RegExp(r'(^2$)|(\*\*$)').hasMatch(level.pinPrick) ||
              (level.motor != null &&
                  !RegExp(r'(^5$)|(\*\*$)').hasMatch(level.motor!)))) {
        lastLevelWithConsecutiveNormalValues = currentLevel;
      }
      if (motorLevelName != null && motorLevelName == nonKeyMuscleName) {
        nonKeyMuscle = level;
      }

      if (top == sensoryLevelName) {
        currentLevel = level;
        topLevel = level;
      } else if (currentLevel != null) {
        currentLevel.next = level;
        level.previous = currentLevel;
        currentLevel = level;
      }

      if (bottom == sensoryLevelName) {
        bottomLevel = currentLevel;
        if (lastLevelWithConsecutiveNormalValues == null) {
          lastLevelWithConsecutiveNormalValues = currentLevel;
        }
      }
    }

    if (topLevel == null ||
        bottomLevel == null ||
        lastLevelWithConsecutiveNormalValues == null) {
      throw Exception(
        'getLevelsRange :: Unable to determine top, bottom, or last level.',
      );
    }

    return _LevelsRangeResult(
      topLevel: topLevel,
      bottomLevel: bottomLevel,
      nonKeyMuscle: nonKeyMuscle,
      firstLevelWithStar: firstLevelWithStar,
      lastLevelWithConsecutiveNormalValues:
          lastLevelWithConsecutiveNormalValues,
    );
  }

  bool _hasStarOnCurrentOrAboveLevel(
    _SideLevel currentLevel,
    _SideLevel lastLevelWithConsecutiveNormalValues,
    _SideLevel? firstLevelWithStar,
  ) {
    if (firstLevelWithStar == null) return false;
    if (currentLevel.motor != null &&
        RegExp(r'0\*').hasMatch(currentLevel.motor!))
      return true;
    if (RegExp(r'\d\*').hasMatch(currentLevel.lightTouch) ||
        RegExp(r'\d\*').hasMatch(currentLevel.pinPrick))
      return true;
    return currentLevel.index <= lastLevelWithConsecutiveNormalValues.index &&
        currentLevel.index >= firstLevelWithStar.index;
  }

  // #endregion

  // #region HELPERS GERAIS (Numéricos, Totais)

  int? _getNumericValue(String value) {
    if (value.toUpperCase().startsWith('NT')) return null;
    return int.tryParse(value.replaceAll(RegExp(r'\*+'), ''));
  }

  TotalsResult _calculateTotals() {
    dynamic calc(Map<String, String> values) {
      if (values.values.any((v) => v.toUpperCase().startsWith('NT')))
        return 'ND';
      return values.values.fold(
        0,
        (sum, v) => sum + (_getNumericValue(v) ?? 0),
      );
    }

    return TotalsResult(
      upperExtremityRight: calc(
        Map.fromEntries(
          exam.right.motor.entries.where((e) => _uemsLevels.contains(e.key)),
        ),
      ),
      upperExtremityLeft: calc(
        Map.fromEntries(
          exam.left.motor.entries.where((e) => _uemsLevels.contains(e.key)),
        ),
      ),
      lowerExtremityRight: calc(
        Map.fromEntries(
          exam.right.motor.entries.where((e) => _lemsLevels.contains(e.key)),
        ),
      ),
      lowerExtremityLeft: calc(
        Map.fromEntries(
          exam.left.motor.entries.where((e) => _lemsLevels.contains(e.key)),
        ),
      ),
      lightTouchRight: calc(exam.right.lightTouch),
      lightTouchLeft: calc(exam.left.lightTouch),
      pinPrickRight: calc(exam.right.pinPrick),
      pinPrickLeft: calc(exam.left.pinPrick),
    );
  }

  // #endregion
}
