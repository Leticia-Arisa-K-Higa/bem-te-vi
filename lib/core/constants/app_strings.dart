// lib/core/constants/app_strings.dart

class AppStrings {
  static const String appTitle = 'ISNCSCI App';

  // Home Screen
  static const String homeTitle = 'Formulário Principal';
  static const String patientNameLabel = 'Nome do Paciente';
  static const String examinerNameLabel = 'Nome do Examinador';
  static const String examDateLabel = 'Data do Exame';
  static const String saveAndContinueButton = 'Salvar e Continuar';
  static const String pleaseFillFields = 'Por favor, preencha todos os campos.';

  // Drawer
  static const String drawerHeader = 'Navegação';
  static const String homeDrawerItem = 'Início';
  static const String asiaFormDrawerItem = 'Formulário ASIA';
  static const String otherFormsDrawerItem =
      'Outros Formulários'; // Placeholder

  // ASIA Form Screen
  static const String asiaFormTitle = 'Classificação ISNCSCI (ASIA)';
  static const String motorLabel = 'Motor';
  static const String sensoryLabel = 'Sensorial';
  static const String keyMusclesLabel = 'Músculos-chave';
  static const String keySensoryPointsLabel = 'Pontos Sensoriais-chave';
  static const String lightTouchLabel = 'Toque Leve (TL)';
  static const String pinPrickLabel = 'Picada (P P)';
  static const String rightSideLabel = 'Direita';
  static const String leftSideLabel = 'Esquerda';
  static const String totalsLabelRight =
      'DIREITA TOTAIS'; // Atualizado para o seu request
  static const String totalsLabelLeft =
      'ESQUERDA TOTAIS'; // Atualizado para o seu request
  static const String maximumLabel = '(Máximo)';
  static const String vacLabel = '(VAC) Contração Anal Voluntária';
  static const String dapLabel = '(DAP) Pressão Anal Profunda';
  static const String vacYes = 'Sim';
  static const String vacNo = 'Não';
  static const String vacNt = 'NT';

  // Subscores
  static const String motorSubscoresTitle = 'Subscores Motores';
  static const String sensorySubscoresTitle = 'Subscores Sensoriais';
  static const String uerLabel = 'MMSS Direita'; // Upper Extremity Right
  static const String uelLabel = 'MMSS Esquerda'; // Upper Extremity Left
  static const String lerLabel = 'MMII Direita'; // Lower Extremity Right
  static const String lelLabel = 'MMII Esquerda'; // Lower Extremity Left
  static const String uemsTotal = '= Total MMSS'; // Upper Extremity Motor Score
  static const String lemsTotal = '= Total MMII'; // Lower Extremity Motor Score
  static const String ltTotal = '= Total TL'; // Light Touch Total
  static const String ppTotal = '= Total PP'; // Pin Prick Total

  // Totals Section
  static const String neurologicalLevelsTitle = 'Níveis Neurológicos';
  static const String neurologicalLevelsHelper =
      'Passos 1-6 para classificação';
  static const String sensoryTotalStep = '1. Sensorial';
  static const String motorTotalStep = '2. Motor';
  static const String nliTitle = '3. Nível Neurológico da Lesão (NNL)';
  static const String completenessTitle = '4. Completo ou Incompleto?';
  static const String completenessHelper =
      'Incompleto = Qualquer função sensorial ou motora em S4-5';
  static const String aisTitle = '5. Escala de Deficiência ASIA (EDA)';
  static const String zppTitle = '6. Zona de Preservação Parcial';
  static const String zppHelper = 'Nível mais caudal com qualquer inervação';

  // Lógica ASIA (simplificado para o exemplo)
  static const List<String> motorLevels = [
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
  static const List<String> sensoryLevels = [
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

  static const Map<String, String> motorHelpers = {
    'C5': 'Flexores do cotovelo',
    'C6': 'Extensores do punho',
    'C7': 'Extensores do cotovelo',
    'C8': 'Flexores dos dedos',
    'T1': 'Abdutores dos dedos (mínimo)',
    'L2': 'Flexores do quadril',
    'L3': 'Extensores do joelho',
    'L4': 'Dorsiflexores do tornozelo',
    'L5': 'Extensores longo dos dedos',
    'S1': 'Plantiflexores do tornozelo',
  };

  static const List<String> analSensationOptions = [vacYes, vacNo, vacNt];

  // --- A CONSTANTE 'lowestNonKeyMuscleOptions' QUE ESTAVA FALTANDO ---
  static const Map<String, String> lowestNonKeyMuscleOptions = {
    '0': 'Nenhum', // Adicione 'Nenhum' como primeira opção ou ajuste
    '4':
        'C5 - Ombro: Flexão, extensão, abdução, adução, rotação interna e externa - Cotovelo: Supinação',
    '5': 'C6 - Cotovelo: Pronação - Punho: Flexão',
    '6':
        'C7 - Dedo: Flexão na articulação proximal, extensão. Polegar: Flexão, extensão e abdução no plano do polegar',
    '7':
        'C8 - Dedo: Flexão na articulação MCF Polegar: Oposição, adução e abdução perpendicular à palma',
    '8': 'T1 - Dedo: Abdução do dedo indicador',
    '21': 'L2 - Quadril: Adução',
    '22': 'L3 - Quadril: Rotação externa',
    '23':
        'L4 - Quadril: Extensão, abdução, rotação interna - Joelho: Flexão - Tornozelo: Inversão e eversão - Dedo do pé: Extensão MP e IP',
    '24': 'L5 - Hálux e Dedo do pé: Flexão e abdução DIP e PIP',
    '25': 'S1 - Hálux: Adução',
  };
  // -----------------------------------------------------------------
}
