// lib/core/models/totals_data.dart

/// Representa os resultados totais e a classificação final do exame ISNCSCI (ASIA).
class TotalsData {
  // Totais de Escores Sensoriais (Toque Leve e Picada)
  final int rightLightTouchTotal;
  final int leftLightTouchTotal;
  final int rightPinPrickTotal;
  final int leftPinPrickTotal;

  // ▼▼▼ CAMPOS ATUALIZADOS E ADICIONADOS ▼▼▼
  // Subscores Motores (MMSS e MMII)
  final int uemsRight; // Upper Extremity Motor Score - Direita (C5-T1)
  final int uemsLeft; // Upper Extremity Motor Score - Esquerda (C5-T1)
  final int lemsRight; // Lower Extremity Motor Score - Direita (L2-S1)
  final int lemsLeft; // Lower Extremity Motor Score - Esquerda (L2-S1)

  // Totais Motores (soma dos subscores)
  int get rightMotorTotal => uemsRight + lemsRight;
  int get leftMotorTotal => uemsLeft + lemsLeft;
  // ▲▲▲ FIM DAS MUDANÇAS ▲▲▲

  // Classificações e Níveis Finais
  final String neurologicalLevelOfInjury; // Nível Neurológico da Lesão (NNL)
  final String completeness; // Completude (Completo/Incompleto)
  final String asiaImpairmentScale; // Escala de Deficiência ASIA (EDA)

  // Zonas de Preservação Parcial (ZPP)
  final String rightSensoryZpp;
  final String leftSensoryZpp;
  final String rightMotorZpp;
  final String leftMotorZpp;

  TotalsData({
    this.rightLightTouchTotal = 0,
    this.leftLightTouchTotal = 0,
    this.rightPinPrickTotal = 0,
    this.leftPinPrickTotal = 0,
    this.uemsRight = 0,
    this.uemsLeft = 0,
    this.lemsRight = 0,
    this.lemsLeft = 0,
    this.neurologicalLevelOfInjury = 'N/A',
    this.completeness = 'N/A',
    this.asiaImpairmentScale = 'N/A',
    this.rightSensoryZpp = 'N/A',
    this.leftSensoryZpp = 'N/A',
    this.rightMotorZpp = 'N/A',
    this.leftMotorZpp = 'N/A',
  });

  TotalsData copyWith({
    int? rightLightTouchTotal,
    int? leftLightTouchTotal,
    int? rightPinPrickTotal,
    int? leftPinPrickTotal,
    int? uemsRight,
    int? uemsLeft,
    int? lemsRight,
    int? lemsLeft,
    String? neurologicalLevelOfInjury,
    String? completeness,
    String? asiaImpairmentScale,
    String? rightSensoryZpp,
    String? leftSensoryZpp,
    String? rightMotorZpp,
    String? leftMotorZpp,
  }) {
    return TotalsData(
      rightLightTouchTotal: rightLightTouchTotal ?? this.rightLightTouchTotal,
      leftLightTouchTotal: leftLightTouchTotal ?? this.leftLightTouchTotal,
      rightPinPrickTotal: rightPinPrickTotal ?? this.rightPinPrickTotal,
      leftPinPrickTotal: leftPinPrickTotal ?? this.leftPinPrickTotal,
      uemsRight: uemsRight ?? this.uemsRight,
      uemsLeft: uemsLeft ?? this.uemsLeft,
      lemsRight: lemsRight ?? this.lemsRight,
      lemsLeft: lemsLeft ?? this.lemsLeft,
      neurologicalLevelOfInjury:
          neurologicalLevelOfInjury ?? this.neurologicalLevelOfInjury,
      completeness: completeness ?? this.completeness,
      asiaImpairmentScale: asiaImpairmentScale ?? this.asiaImpairmentScale,
      rightSensoryZpp: rightSensoryZpp ?? this.rightSensoryZpp,
      leftSensoryZpp: leftSensoryZpp ?? this.leftSensoryZpp,
      rightMotorZpp: rightMotorZpp ?? this.rightMotorZpp,
      leftMotorZpp: leftMotorZpp ?? this.leftMotorZpp,
    );
  }
}
