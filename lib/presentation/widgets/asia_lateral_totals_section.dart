// lib/presentation/widgets/asia_lateral_totals_section.dart
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/models/totals_data.dart';
import 'package:flutter/material.dart';

class AsiaLateralTotalsSection extends StatelessWidget {
  final TotalsData totals;

  const AsiaLateralTotalsSection({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Totais Laterais do Exame',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 20, thickness: 1.5),
            const SizedBox(height: 10),

            // --- Totais do Lado Direito ---
            _buildTotalsTable(
              context,
              label: AppStrings.totalsLabelRight,
              motorValue: totals.rightMotorTotal.toString(),
              lightTouchValue: totals.rightLightTouchTotal.toString(),
              pinPrickValue: totals.rightPinPrickTotal.toString(),
              motorMax: '50',
              sensoryMax: '56',
              isLeft: false, // Este é o lado direito
            ),
            const SizedBox(height: 20),

            // --- Totais do Lado Esquerdo ---
            _buildTotalsTable(
              context,
              label: AppStrings.totalsLabelLeft,
              motorValue: totals.leftMotorTotal.toString(),
              lightTouchValue: totals.leftLightTouchTotal.toString(),
              pinPrickValue: totals.leftPinPrickTotal.toString(),
              motorMax: '50',
              sensoryMax: '56',
              isLeft: true, // Este é o lado esquerdo
            ),
          ],
        ),
      ),
    );
  }

  // NOVO: Método para construir a tabela de totais para cada lado
  Widget _buildTotalsTable(
    BuildContext context, {
    required String label,
    required String motorValue,
    required String lightTouchValue,
    required String pinPrickValue,
    required String motorMax,
    required String sensoryMax,
    required bool isLeft,
  }) {
    // Definindo a ordem das colunas para direita/esquerda
    final List<Widget> topRowCells = isLeft
        ? [
            _buildValueBox(lightTouchValue), // LT Esquerda
            _buildValueBox(pinPrickValue), // PP Esquerda
            _buildValueBox(motorValue), // Motor Esquerda
          ]
        : [
            _buildValueBox(motorValue), // Motor Direita
            _buildValueBox(lightTouchValue), // LT Direita
            _buildValueBox(pinPrickValue), // PP Direita
          ];

    final List<Widget> bottomRowCells = isLeft
        ? [
            Text(
              '(${sensoryMax})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              '(${sensoryMax})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              '(${motorMax})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ]
        : [
            Text(
              '(${motorMax})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              '(${sensoryMax})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              '(${sensoryMax})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Estica a coluna
      children: [
        // Rótulo do lado (RIGHT TOTALS / LEFT TOTALS)
        Padding(
          padding: EdgeInsets.only(
            left: isLeft ? 0 : 8.0,
            right: isLeft ? 8.0 : 0,
            bottom: 4.0,
          ),
          child: Align(
            alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ),
        // A Tabela para os valores e máximos
        Table(
          // Definimos a largura das colunas para tentar alinhar
          // de forma proporcional, mantendo o espaçamento igual para os 3 itens
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: topRowCells
                  .map((widget) => TableCell(child: Center(child: widget)))
                  .toList(),
            ),
            TableRow(
              children: bottomRowCells
                  .map((widget) => TableCell(child: Center(child: widget)))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  // Método auxiliar para construir a caixa do valor (usado dentro da Table)
  Widget _buildValueBox(String value) {
    return Container(
      width: 55, // Largura fixa para a caixa do valor
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
