import 'package:bem_te_vi/core/models/neurology_cell_data.dart';
import 'package:bem_te_vi/core/models/totals_data.dart';

class AsiaCalculator {
  // ATENÇÃO: Esta é uma SIMULAÇÃO de cálculo.
  // A lógica REAL do ASIA é complexa e deve ser implementada com base
  // nas diretrizes oficiais da ISNCSCI/ASIA.

  static TotalsData calculateTotals(
    List<NeurologyCellData> cells, {
    bool voluntaryAnalContraction = false,
    bool deepAnalPressure = false,
  }) {
    int rightMotorTotal = 0;
    int leftMotorTotal = 0;
    int rightLightTouchTotal = 0;
    int leftLightTouchTotal = 0;
    int rightPinPrickTotal = 0;
    int leftPinPrickTotal = 0;

    for (var cell in cells) {
      if (cell.value != null && cell.value!.isNotEmpty && cell.value != 'NT') {
        final int? score = int.tryParse(cell.value!.replaceAll('*', ''));
        if (score != null) {
          switch (cell.type) {
            case CellType.motor:
              if (cell.side == Side.right)
                rightMotorTotal += score;
              else
                leftMotorTotal += score;
              break;
            case CellType.sensoryLightTouch:
              if (cell.side == Side.right)
                rightLightTouchTotal += score;
              else
                leftLightTouchTotal += score;
              break;
            case CellType.sensoryPinPrick:
              if (cell.side == Side.right)
                rightPinPrickTotal += score;
              else
                leftPinPrickTotal += score;
              break;
          }
        }
      }
    }

    // Lógica ASIA Simplificada (PARA EXEMPLO)
    String neurologicalLevelOfInjury = 'C-X (Simulado)';
    String completeness = 'A (Simulado)';
    String asiaImpairmentScale = 'A (Simulado)';
    String rightSensoryZpp = 'C2 (Simulado)';
    String leftSensoryZpp = 'C2 (Simulado)';
    String rightMotorZpp = 'C5 (Simulado)';
    String leftMotorZpp = 'C5 (Simulado)';

    // Exemplo muito básico de completude
    bool s45LtRightNormal =
        (cells.firstWhere((c) => c.id == 'S4-5RightLT').value == '2');
    bool s45LtLeftNormal =
        (cells.firstWhere((c) => c.id == 'S4-5LeftLT').value == '2');
    bool s45PpRightNormal =
        (cells.firstWhere((c) => c.id == 'S4-5RightPP').value == '2');
    bool s45PpLeftNormal =
        (cells.firstWhere((c) => c.id == 'S4-5LeftPP').value == '2');

    if (s45LtRightNormal ||
        s45LtLeftNormal ||
        s45PpRightNormal ||
        s45PpLeftNormal ||
        voluntaryAnalContraction ||
        deepAnalPressure) {
      completeness = 'Incompleto';
    } else {
      completeness = 'Completo';
    }

    return TotalsData(
      rightMotorTotal: rightMotorTotal,
      leftMotorTotal: leftMotorTotal,
      rightLightTouchTotal: rightLightTouchTotal,
      leftLightTouchTotal: leftLightTouchTotal,
      rightPinPrickTotal: rightPinPrickTotal,
      leftPinPrickTotal: leftPinPrickTotal,
      neurologicalLevelOfInjury: neurologicalLevelOfInjury,
      completeness: completeness,
      asiaImpairmentScale: asiaImpairmentScale,
      rightSensoryZpp: rightSensoryZpp,
      leftSensoryZpp: leftSensoryZpp,
      rightMotorZpp: rightMotorZpp,
      leftMotorZpp: leftMotorZpp,
    );
  }
}
