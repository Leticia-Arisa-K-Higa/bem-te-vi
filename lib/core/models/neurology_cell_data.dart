// lib/core/models/neurology_cell_data.dart

/// Enumeração para o tipo de teste neurológico da célula.
enum CellType {
  sensoryLightTouch, // Toque leve sensorial
  sensoryPinPrick, // Picada sensorial
  motor, // Motor
}

/// Enumeração para o lado do corpo (Direito ou Esquerdo).
enum Side {
  right, // Direita
  left, // Esquerda
}

/// Representa os dados de uma única célula no formulário de classificação ISNCSCI (ASIA).
class NeurologyCellData {
  /// Um identificador único para a célula (ex: 'C5RightMotor', 'T2LeftLT').
  final String id;

  /// O valor atual da célula (ex: '0', '1', 'NT', '5*'). Pode ser nulo se não preenchido.
  String? value;

  /// O tipo de teste neurológico que esta célula representa.
  final CellType type;

  /// O lado do corpo ao qual esta célula pertence.
  final Side side;

  /// O nível neurológico (dermátomo/miótomo) associado a esta célula (ex: 'C2', 'T1', 'L5', 'S4-5').
  final String level;

  /// Texto auxiliar ou descrição para células motoras (ex: 'Flexores do cotovelo'). Pode ser nulo.
  final String? helperText;

  /// Título ou descrição mais detalhada para a célula (usado para tooltips ou diálogos).
  final String title;

  /// Construtor para criar uma instância de [NeurologyCellData].
  NeurologyCellData({
    required this.id,
    this.value,
    required this.type,
    required this.side,
    required this.level,
    this.helperText,
    required this.title,
  });

  /// Cria uma nova instância de [NeurologyCellData] com valores copiados da
  /// instância atual, permitindo a modificação de campos específicos.
  /// Isso é útil para gerenciamento de estado imutável com `Provider` ou `Bloc`.
  NeurologyCellData copyWith({String? value}) {
    return NeurologyCellData(
      id: id,
      value:
          value ??
          this.value, // Atualiza o valor se fornecido, caso contrário, mantém o atual
      type: type,
      side: side,
      level: level,
      helperText: helperText,
      title: title,
    );
  }

  // ▼▼▼ CÓDIGO A SER ADICIONADO ▼▼▼

  /// Converte a instância da classe em um Map<String, dynamic>.
  /// Este método é essencial para o `jsonEncode` funcionar e converter o objeto
  /// em uma string JSON para ser salva no banco de dados.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      // Convertemos o enum para uma string para que ele possa ser armazenado como texto.
      'type': type.toString(),
      'side': side.toString(),
      'level': level,
      'helperText': helperText,
      'title': title,
    };
  }

  /// Cria uma instância de [NeurologyCellData] a partir de um Map<String, dynamic>.
  /// Este é um "factory constructor" usado para reconstruir o objeto quando
  /// lemos os dados JSON do banco de dados.
  factory NeurologyCellData.fromJson(Map<String, dynamic> json) {
    return NeurologyCellData(
      id: json['id'],
      value: json['value'],
      // Aqui, fazemos o processo inverso: convertemos a string de volta para o enum.
      type: CellType.values.firstWhere((e) => e.toString() == json['type']),
      side: Side.values.firstWhere((e) => e.toString() == json['side']),
      level: json['level'],
      helperText: json['helperText'],
      title: json['title'],
    );
  }

  // ▲▲▲ FIM DO CÓDIGO A SER ADICIONADO ▲▲▲

  // Opcional: Sobrescrever toString para melhor depuração
  @override
  String toString() {
    return 'NeurologyCellData(id: $id, value: $value, type: $type, side: $side, level: $level)';
  }
}
