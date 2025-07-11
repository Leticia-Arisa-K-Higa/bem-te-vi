// lib/presentation/widgets/asia_motor_sensory_table.dart

import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/models/neurology_cell_data.dart';
import 'package:bem_te_vi/core/providers/asia_form_provider.dart';
import 'package:bem_te_vi/presentation/widgets/interactive_asia_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsiaMotorSensoryTable extends StatelessWidget {
  final Side side;
  final List<NeurologyCellData> cells;
  final Function(String id, String? value) onCellValueChanged;

  const AsiaMotorSensoryTable({
    super.key,
    required this.side,
    required this.cells,
    required this.onCellValueChanged,
  });

  // Helper para encontrar uma célula específica. Retorna null se não encontrada.
  // AGORA USANDO firstWhereOrNull para evitar a exceção quando a célula não existe.
  NeurologyCellData? _getCell(String level, CellType type) {
    // Filtra as células fornecidas para este lado e nível específicos
    // e então busca pelo tipo.
    return cells.firstWhereOrNull((c) => c.level == level && c.type == type);
  }

  // Constrói uma linha para os níveis sensoriais (C2-C4, T2-L1, S2-S3)
  TableRow _buildSensoryRow(String level) {
    // Note: getCell agora pode retornar null, então precisamos lidar com isso.
    NeurologyCellData? lightTouchCell = _getCell(
      level,
      CellType.sensoryLightTouch,
    );
    NeurologyCellData? pinPrickCell = _getCell(level, CellType.sensoryPinPrick);

    return TableRow(
      children: side == Side.right
          ? [
              TableCell(
                child: Container(),
              ), // Vazia para alinhar com o helper do motor
              TableCell(
                child: Container(),
              ), // Vazia para alinhar com o helper do motor
              TableCell(child: Center(child: Text(level))),
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()), // Célula vazia se for null
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()), // Célula vazia se for null
            ]
          : [
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              TableCell(child: Center(child: Text(level))),
              TableCell(child: Container()),
              TableCell(child: Container()),
            ],
    );
  }

  // Constrói uma linha para os níveis motores e sensoriais (C5-T1, L2-S1)
  TableRow _buildMotorAndSensoryRow(String level) {
    final NeurologyCellData? motorCell = _getCell(level, CellType.motor);
    final NeurologyCellData? lightTouchCell = _getCell(
      level,
      CellType.sensoryLightTouch,
    );
    final NeurologyCellData? pinPrickCell = _getCell(
      level,
      CellType.sensoryPinPrick,
    );

    return TableRow(
      children: side == Side.right
          ? [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    AppStrings.motorHelpers[level] ?? '',
                  ), // Handle null for helperText
                ),
              ),
              TableCell(child: Center(child: Text(level))),
              motorCell != null
                  ? InteractiveAsiaCell(
                      cellData: motorCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
            ]
          : [
              lightTouchCell != null
                  ? InteractiveAsiaCell(
                      cellData: lightTouchCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              pinPrickCell != null
                  ? InteractiveAsiaCell(
                      cellData: pinPrickCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              motorCell != null
                  ? InteractiveAsiaCell(
                      cellData: motorCell,
                      onCellValueChanged: onCellValueChanged,
                    )
                  : TableCell(child: Container()),
              TableCell(child: Center(child: Text(level))),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    AppStrings.motorHelpers[level] ?? '',
                  ), // Handle null for helperText
                ),
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final neurologyProvider = Provider.of<AsiaFormProvider>(context);
    final result = neurologyProvider.result;

    // Se o resultado ainda não foi calculado, mostramos os totais como '0' ou 'N/A'
    final rightLT = result?.totals.lightTouchRight.toString() ?? '0';
    final rightPP = result?.totals.pinPrickRight.toString() ?? '0';
    final leftLT = result?.totals.lightTouchLeft.toString() ?? '0';
    final leftPP = result?.totals.pinPrickLeft.toString() ?? '0';
    final leftMotor = result?.totals.leftMotor.toString() ?? '0';

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: side == Side.right
          ? const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            }
          : const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(2),
            },
      children: [
        // Headers da Tabela (mantidos como antes)
        TableRow(
          children: side == Side.right
              ? [
                  TableCell(child: Container()),
                  TableCell(child: Container()),
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.motorLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.sensoryLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                ]
              : [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.sensoryLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          AppStrings.motorLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                  TableCell(child: Container()),
                ],
        ),
        TableRow(
          children: side == Side.right
              ? [
                  TableCell(child: Container()),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keyMusclesLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keySensoryPointsLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.lightTouchLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.pinPrickLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]
              : [
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.lightTouchLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.pinPrickLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keyMusclesLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        AppStrings.keySensoryPointsLabel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(child: Container()),
                ],
        ),

        // Corpo da Tabela
        // Níveis Sensoriais Puros (C2-C4, T2-L1, S2-S3)
        // Use `where` para filtrar e então `map` para construir a linha.
        ...AppStrings.sensoryLevels
            .where(
              (level) =>
                  !AppStrings.motorLevels.contains(level) && level != 'S4-5',
            )
            .map((level) => _buildSensoryRow(level))
            .toList(),
        // Níveis Motor e Sensorial
        ...AppStrings.motorLevels
            .map((level) => _buildMotorAndSensoryRow(level))
            .toList(),
        // S4-5 (Sensorial apenas)
        _buildSensoryRow('S4-5'),

        // Rodapé da Tabela (Totais) (mantidos como antes)
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: side == Side.right
              ? [
                  const TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Total Direita', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                  const TableCell(child: Text('')),
                  const TableCell(child: Text('')), // Motor total é calculado separadamente
                  TableCell(child: Center(child: Text(rightLT, style: const TextStyle(fontWeight: FontWeight.bold)))),
                  TableCell(child: Center(child: Text(rightPP, style: const TextStyle(fontWeight: FontWeight.bold)))),
                ]
              : [
                  TableCell(child: Center(child: Text(leftLT, style: const TextStyle(fontWeight: FontWeight.bold)))),
                  TableCell(child: Center(child: Text(leftPP, style: const TextStyle(fontWeight: FontWeight.bold)))),
                  TableCell(child: Center(child: Text(leftMotor, style: const TextStyle(fontWeight: FontWeight.bold)))),
                  const TableCell(child: Text('')),
                  const TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Total Esquerda', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
        ),
         TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: side == Side.right ? [
            const TableCell(child: Text('')),
            const TableCell(child: Text('')),
            const TableCell(child: Center(child: Text('(Máx: 50)'))),
            const TableCell(child: Center(child: Text('(Máx: 56)'))),
            const TableCell(child: Center(child: Text('(Máx: 56)'))),
          ] : [
            const TableCell(child: Center(child: Text('(Máx: 56)'))),
            const TableCell(child: Center(child: Text('(Máx: 56)'))),
            const TableCell(child: Center(child: Text('(Máx: 50)'))),
            const TableCell(child: Text('')),
            const TableCell(child: Text('')),
          ]
        )
      ],
    );
  }
}

// Extensão para firstWhereOrNull, pois não está disponível por padrão em todas as versões/tipos de Iterable
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
