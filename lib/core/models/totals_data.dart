// lib/core/models/totals_data.dart

/// Representa os resultados totais e a classificação final do exame ISNCSCI (ASIA).
class TotalsData {
  // Totais de Escores Motores
  final int rightMotorTotal;
  final int leftMotorTotal;

  // Totais de Escores Sensoriais (Toque Leve e Picada)
  final int rightLightTouchTotal;
  final int leftLightTouchTotal;
  final int rightPinPrickTotal;
  final int leftPinPrickTotal;

  // Classificações e Níveis Finais
  final String neurologicalLevelOfInjury; // Nível Neurológico da Lesão (NNL)
  final String completeness; // Completude (Completo/Incompleto)
  final String asiaImpairmentScale; // Escala de Deficiência ASIA (EDA)

  // Zonas de Preservação Parcial (ZPP)
  final String rightSensoryZpp; // ZPP Sensorial Direita
  final String leftSensoryZpp; // ZPP Sensorial Esquerda
  final String rightMotorZpp; // ZPP Motora Direita
  final String leftMotorZpp; // ZPP Motora Esquerda

  /// Construtor para criar uma instância de [TotalsData].
  /// Todos os campos são inicializados com valores padrão (0 ou 'N/A')
  /// para garantir que sempre haja um estado válido.
  TotalsData({
    this.rightMotorTotal = 0,
    this.leftMotorTotal = 0,
    this.rightLightTouchTotal = 0,
    this.leftLightTouchTotal = 0,
    this.rightPinPrickTotal = 0,
    this.leftPinPrickTotal = 0,
    this.neurologicalLevelOfInjury =
        'N/A', // Não Aplicável ou ainda não calculado
    this.completeness = 'N/A',
    this.asiaImpairmentScale = 'N/A',
    this.rightSensoryZpp = 'N/A',
    this.leftSensoryZpp = 'N/A',
    this.rightMotorZpp = 'N/A',
    this.leftMotorZpp = 'N/A',
  });

  /// Cria uma nova instância de [TotalsData] com valores copiados da
  /// instância atual, permitindo a modificação de campos específicos.
  /// Isso é útil para atualizações de estado imutáveis no `Provider`.
  TotalsData copyWith({
    int? rightMotorTotal,
    int? leftMotorTotal,
    int? rightLightTouchTotal,
    int? leftLightTouchTotal,
    int? rightPinPrickTotal,
    int? leftPinPrickTotal,
    String? neurologicalLevelOfInjury,
    String? completeness,
    String? asiaImpairmentScale,
    String? rightSensoryZpp,
    String? leftSensoryZpp,
    String? rightMotorZpp,
    String? leftMotorZpp,
  }) {
    return TotalsData(
      rightMotorTotal: rightMotorTotal ?? this.rightMotorTotal,
      leftMotorTotal: leftMotorTotal ?? this.leftMotorTotal,
      rightLightTouchTotal: rightLightTouchTotal ?? this.rightLightTouchTotal,
      leftLightTouchTotal: leftLightTouchTotal ?? this.leftLightTouchTotal,
      rightPinPrickTotal: rightPinPrickTotal ?? this.rightPinPrickTotal,
      leftPinPrickTotal: leftPinPrickTotal ?? this.leftPinPrickTotal,
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

  // Opcional: Sobrescrever toString para melhor depuração
  @override
  String toString() {
    return 'TotalsData(rightMotor: $rightMotorTotal, leftMotor: $leftMotorTotal, NLI: $neurologicalLevelOfInjury, AIS: $asiaImpairmentScale)';
  }
}
