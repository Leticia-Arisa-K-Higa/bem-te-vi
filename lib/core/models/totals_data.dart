// lib/core/models/totals_data.dart

class TotalsData {
  // Totais de Escores Sensoriais
  final int rightLightTouchTotal;
  final int leftLightTouchTotal;
  final int rightPinPrickTotal;
  final int leftPinPrickTotal;

  // Subscores Motores
  final int uemsRight;
  final int uemsLeft;
  final int lemsRight;
  final int lemsLeft;

  // Totais Motores (getters)
  int get rightMotorTotal => uemsRight + lemsRight;
  int get leftMotorTotal => uemsLeft + lemsLeft;

  // ▼▼▼ CAMPOS ADICIONADOS ▼▼▼
  // Níveis determinados para cada lado
  final String rightSensoryLevel;
  final String leftSensoryLevel;
  final String rightMotorLevel;
  final String leftMotorLevel;
  // ▲▲▲ FIM DOS CAMPOS ADICIONADOS ▲▲▲

  // Classificações e Níveis Finais
  final String neurologicalLevelOfInjury;
  final String completeness;
  final String asiaImpairmentScale;

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
    // Adicionar ao construtor
    this.rightSensoryLevel = 'N/A',
    this.leftSensoryLevel = 'N/A',
    this.rightMotorLevel = 'N/A',
    this.leftMotorLevel = 'N/A',
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
    // Adicionar ao copyWith
    String? rightSensoryLevel,
    String? leftSensoryLevel,
    String? rightMotorLevel,
    String? leftMotorLevel,
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
      // Usar os novos campos
      rightSensoryLevel: rightSensoryLevel ?? this.rightSensoryLevel,
      leftSensoryLevel: leftSensoryLevel ?? this.leftSensoryLevel,
      rightMotorLevel: rightMotorLevel ?? this.rightMotorLevel,
      leftMotorLevel: leftMotorLevel ?? this.leftMotorLevel,
      neurologicalLevelOfInjury: neurologicalLevelOfInjury ?? this.neurologicalLevelOfInjury,
      completeness: completeness ?? this.completeness,
      asiaImpairmentScale: asiaImpairmentScale ?? this.asiaImpairmentScale,
      rightSensoryZpp: rightSensoryZpp ?? this.rightSensoryZpp,
      leftSensoryZpp: leftSensoryZpp ?? this.leftSensoryZpp,
      rightMotorZpp: rightMotorZpp ?? this.rightMotorZpp,
      leftMotorZpp: leftMotorZpp ?? this.leftMotorZpp,
    );
  }
}