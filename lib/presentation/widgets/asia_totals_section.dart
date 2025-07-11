// lib/presentation/widgets/asia_totals_section.dart
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/models/totals_data.dart';
import 'package:flutter/material.dart';

class AsiaTotalsSection extends StatelessWidget {
  final TotalsData totals;

  const AsiaTotalsSection({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBlockHeader(
              context,
              AppStrings.neurologicalLevelsTitle,
              helper: AppStrings.neurologicalLevelsHelper,
            ),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('', textAlign: TextAlign.right),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('D', textAlign: TextAlign.center),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('E', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: const Text(
                          AppStrings.sensoryTotalStep,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.rightLightTouchTotal.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.leftLightTouchTotal.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: const Text(
                          AppStrings.motorTotalStep,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.rightMotorTotal.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.leftMotorTotal.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTotalInfoRow(
              context,
              label: AppStrings.nliTitle,
              value: totals.neurologicalLevelOfInjury,
              // Adicionando uma flag para ajustar o tamanho da caixa se necessário
              isLargerBox: true, // <--- NOVO: flag para caixa maior
            ),
            const SizedBox(height: 16),
            _buildTotalInfoRow(
              context,
              label: AppStrings.completenessTitle,
              helper: AppStrings.completenessHelper,
              value: totals.completeness,
              isLargerBox: true, // <--- NOVO: flag para caixa maior
            ),
            const SizedBox(height: 8),
            _buildTotalInfoRow(
              context,
              label: AppStrings.aisTitle,
              value: totals.asiaImpairmentScale,
              isLargerBox: true, // <--- NOVO: flag para caixa maior
            ),
            const SizedBox(height: 16),
            _buildBlockHeader(
              context,
              AppStrings.zppTitle,
              helper: AppStrings.zppHelper,
            ),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('', textAlign: TextAlign.right),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('D', textAlign: TextAlign.center),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('E', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: const Text(
                          'Sensorial',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.rightSensoryZpp,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.leftSensoryZpp,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: const Text('Motor', textAlign: TextAlign.right),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.rightMotorZpp,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          totals.leftMotorZpp,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir cabeçalhos de bloco (sem alterações)
  Widget _buildBlockHeader(
    BuildContext context,
    String title, {
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (helper != null)
          Text(
            helper,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  // MÉTODO AUXILIAR para as linhas de informação de totais
  // Tamanho da caixa será maior se isLargerBox for true
  Widget _buildTotalInfoRow(
    BuildContext context, {
    required String label,
    String? helper,
    required String value,
    bool isLargerBox = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 320;

        // Ajusta a largura e altura da caixa com base em isLargerBox
        final double boxWidth = isLargerBox ? 90 : 80; // Aumentado para 100
        final double boxHeight = isLargerBox ? 60 : 50; // Aumentado para 45
        final double valueFontSize = isLargerBox
            ? 14
            : 12; // Aumentado a fonte para caber melhor

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: isCompact ? 3 : 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (helper != null)
                    Padding(
                      padding: EdgeInsets.only(top: isCompact ? 2.0 : 0.0),
                      child: Text(
                        helper,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: boxWidth, // Largura ajustável
              height: boxHeight, // Altura ajustável
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: valueFontSize,
                  color: Colors.blue.shade800,
                ),
              ), // Fonte ajustável
            ),
          ],
        );
      },
    );
  }
}
