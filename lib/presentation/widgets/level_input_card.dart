// lib/presentation/widgets/level_input_card.dart
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/models/neurology_cell_data.dart';
import 'package:bem_te_vi/presentation/widgets/interactive_asia_cell.dart';
import 'package:flutter/material.dart';

// Ensure the IterableExtension is defined or imported,
// for firstWhereOrNull to be available.
// If you put it at the very bottom of this file, that's fine.
// Or if you have a central 'extensions.dart' file, import it.

class LevelInputCard extends StatefulWidget {
  final String level;
  final List<NeurologyCellData> levelCells;
  final Function(String id, String? value) onCellValueChanged;

  const LevelInputCard({
    super.key,
    required this.level,
    required this.levelCells,
    required this.onCellValueChanged,
  });

  @override
  State<LevelInputCard> createState() => _LevelInputCardState();
}

class _LevelInputCardState extends State<LevelInputCard> {
  bool _isExpanded = false;

  // Helper para encontrar uma célula específica neste nível
  // *** CORREÇÃO AQUI: Use firstWhereOrNull ***
  NeurologyCellData? _getCell(CellType type, Side side) {
    return widget.levelCells.firstWhereOrNull(
      // <--- THIS IS THE CHANGE
      (c) => c.type == type && c.side == side,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMotor = AppStrings.motorLevels.contains(widget.level);

    // Obtenha as células para este nível e lado, lidando com nulos
    final NeurologyCellData? rightMotorCell = _getCell(
      CellType.motor,
      Side.right,
    );
    final NeurologyCellData? rightLightTouchCell = _getCell(
      CellType.sensoryLightTouch,
      Side.right,
    );
    final NeurologyCellData? rightPinPrickCell = _getCell(
      CellType.sensoryPinPrick,
      Side.right,
    );

    final NeurologyCellData? leftMotorCell = _getCell(
      CellType.motor,
      Side.left,
    );
    final NeurologyCellData? leftLightTouchCell = _getCell(
      CellType.sensoryLightTouch,
      Side.left,
    );
    final NeurologyCellData? leftPinPrickCell = _getCell(
      CellType.sensoryPinPrick,
      Side.left,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      child: ExpansionTile(
        title: Text(
          'Nível ${widget.level}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: hasMotor
            ? Text(AppStrings.motorHelpers[widget.level] ?? '')
            : null,
        trailing: Icon(
          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        initiallyExpanded: _isExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                // Headers para as colunas de dados
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Lado',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (hasMotor)
                        const Expanded(
                          flex: 3,
                          child: Text(
                            AppStrings.motorLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      const Expanded(
                        flex: 3,
                        child: Text(
                          AppStrings.lightTouchLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Expanded(
                        flex: 3,
                        child: Text(
                          AppStrings.pinPrickLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Linha para o Lado Direito
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        AppStrings.rightSideLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (hasMotor) // Only show motor if the level has a motor component
                      Expanded(
                        flex: 3,
                        child: rightMotorCell != null
                            ? InteractiveAsiaCell(
                                cellData: rightMotorCell,
                                onCellValueChanged: widget.onCellValueChanged,
                              )
                            : Container(), // Placeholder if no motor cell for this level/side
                      ),
                    Expanded(
                      flex: 3,
                      child: rightLightTouchCell != null
                          ? InteractiveAsiaCell(
                              cellData: rightLightTouchCell,
                              onCellValueChanged: widget.onCellValueChanged,
                            )
                          : Container(),
                    ),
                    Expanded(
                      flex: 3,
                      child: rightPinPrickCell != null
                          ? InteractiveAsiaCell(
                              cellData: rightPinPrickCell,
                              onCellValueChanged: widget.onCellValueChanged,
                            )
                          : Container(),
                    ),
                  ],
                ),
                const Divider(),

                // Linha para o Lado Esquerdo
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        AppStrings.leftSideLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (hasMotor) // Only show motor if the level has a motor component
                      Expanded(
                        flex: 3,
                        child: leftMotorCell != null
                            ? InteractiveAsiaCell(
                                cellData: leftMotorCell,
                                onCellValueChanged: widget.onCellValueChanged,
                              )
                            : Container(),
                      ),
                    Expanded(
                      flex: 3,
                      child: leftLightTouchCell != null
                          ? InteractiveAsiaCell(
                              cellData: leftLightTouchCell,
                              onCellValueChanged: widget.onCellValueChanged,
                            )
                          : Container(),
                    ),
                    Expanded(
                      flex: 3,
                      child: leftPinPrickCell != null
                          ? InteractiveAsiaCell(
                              cellData: leftPinPrickCell,
                              onCellValueChanged: widget.onCellValueChanged,
                            )
                          : Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Ensure this extension is available. If it's in a central file, remove it from here.
// Otherwise, keep it here.
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
