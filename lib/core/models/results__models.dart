// lib/core/models/results_models.dart

// Estrutura para os Níveis Neurológicos
class NeurologicalLevels {
  final String sensoryRight;
  final String sensoryLeft;
  final String motorRight;
  final String motorLeft;

  NeurologicalLevels({
    this.sensoryRight = 'N/A',
    this.sensoryLeft = 'N/A',
    this.motorRight = 'N/A',
    this.motorLeft = 'N/A',
  });
}

// Estrutura para as Zonas de Preservação Parcial
class ZoneOfPartialPreservations {
  final String sensoryRight;
  final String sensoryLeft;
  final String motorRight;
  final String motorLeft;

  ZoneOfPartialPreservations({
    this.sensoryRight = 'N/A',
    this.sensoryLeft = 'N/A',
    this.motorRight = 'N/A',
    this.motorLeft = 'N/A',
  });
}

// Estrutura para o resultado da Classificação
class ClassificationResult {
  final NeurologicalLevels neurologicalLevels;
  final String neurologicalLevelOfInjury;
  final String injuryComplete; // 'C' (Completo) ou 'I' (Incompleto)
  final String asiaImpairmentScale; // A, B, C, D, E (pode ter *)
  final ZoneOfPartialPreservations zoneOfPartialPreservations;

  ClassificationResult({
    required this.neurologicalLevels,
    required this.neurologicalLevelOfInjury,
    required this.injuryComplete,
    required this.asiaImpairmentScale,
    required this.zoneOfPartialPreservations,
  });
}

// Estrutura para o resultado dos Totais
class TotalsResult {
  final dynamic upperExtremityRight; // Pode ser int ou a string 'ND'
  final dynamic upperExtremityLeft;
  final dynamic lowerExtremityRight;
  final dynamic lowerExtremityLeft;
  final dynamic lightTouchRight;
  final dynamic lightTouchLeft;
  final dynamic pinPrickRight;
  final dynamic pinPrickLeft;

  // Getters para os totais combinados
  dynamic get upperExtremity => _add(upperExtremityRight, upperExtremityLeft);
  dynamic get lowerExtremity => _add(lowerExtremityRight, lowerExtremityLeft);
  dynamic get rightMotor => _add(upperExtremityRight, lowerExtremityRight);
  dynamic get leftMotor => _add(upperExtremityLeft, lowerExtremityLeft);
  dynamic get lightTouch => _add(lightTouchRight, lightTouchLeft);
  dynamic get pinPrick => _add(pinPrickRight, pinPrickLeft);

  TotalsResult({
    required this.upperExtremityRight,
    required this.upperExtremityLeft,
    required this.lowerExtremityRight,
    required this.lowerExtremityLeft,
    required this.lightTouchRight,
    required this.lightTouchLeft,
    required this.pinPrickRight,
    required this.pinPrickLeft,
  });

  // Helper para somar, tratando o caso 'ND'
  dynamic _add(dynamic a, dynamic b) {
    if (a == 'ND' || b == 'ND') return 'ND';
    if (a is int && b is int) return a + b;
    return 'ND'; // Fallback
  }
}

// Estrutura final que une Classificação e Totais
class IscnsciResult {
  final ClassificationResult classification;
  final TotalsResult totals;

  IscnsciResult({required this.classification, required this.totals});
}