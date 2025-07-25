// lib/presentation/widgets/asia_totals_section.dart
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/models/results__models.dart';
import 'package:flutter/material.dart';

class AsiaTotalsSection extends StatelessWidget {
  final IscnsciResult? result;

  const AsiaTotalsSection({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Card(child: Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text("Preencha o formulário para ver a classificação."))));
    }
    
    final classification = result!.classification;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBlockHeader(context, AppStrings.neurologicalLevelsTitle, helper: AppStrings.neurologicalLevelsHelper),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: const [
                    TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text(''))),
                    TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Direita', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Esquerda', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: const Padding(padding: EdgeInsets.all(8.0), child: Text(AppStrings.sensoryTotalStep, textAlign: TextAlign.right))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.neurologicalLevels.sensoryRight, textAlign: TextAlign.center))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.neurologicalLevels.sensoryLeft, textAlign: TextAlign.center))),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: const Padding(padding: EdgeInsets.all(8.0), child: Text(AppStrings.motorTotalStep, textAlign: TextAlign.right))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.neurologicalLevels.motorRight, textAlign: TextAlign.center))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.neurologicalLevels.motorLeft, textAlign: TextAlign.center))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTotalInfoRow(context, label: AppStrings.nliTitle, value: classification.neurologicalLevelOfInjury, isLargerBox: true),
            const SizedBox(height: 16),
            _buildTotalInfoRow(context, label: AppStrings.completenessTitle, helper: AppStrings.completenessHelper, value: classification.injuryComplete, isLargerBox: true),
            const SizedBox(height: 8),
            _buildTotalInfoRow(context, label: AppStrings.aisTitle, value: classification.asiaImpairmentScale, isLargerBox: true),
            const SizedBox(height: 16),
            _buildBlockHeader(context, AppStrings.zppTitle, helper: AppStrings.zppHelper),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: const [
                    TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text(''))),
                    TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Direita', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Esquerda', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: EdgeInsets.all(8.0), child: Text('Sensorial', textAlign: TextAlign.right))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.zoneOfPartialPreservations.sensoryRight, textAlign: TextAlign.center))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.zoneOfPartialPreservations.sensoryLeft, textAlign: TextAlign.center))),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: EdgeInsets.all(8.0), child: Text('Motor', textAlign: TextAlign.right))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.zoneOfPartialPreservations.motorRight, textAlign: TextAlign.center))),
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(classification.zoneOfPartialPreservations.motorLeft, textAlign: TextAlign.center))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockHeader(BuildContext context, String title, {String? helper}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        if (helper != null) Text(helper, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTotalInfoRow(BuildContext context, {required String label, String? helper, required String value, bool isLargerBox = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 320;
        final double boxWidth = isLargerBox ? 90 : 80;
        final double boxHeight = isLargerBox ? 60 : 50;
        final double valueFontSize = isLargerBox ? 14 : 12;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: isCompact ? 3 : 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (helper != null) Padding(padding: EdgeInsets.only(top: isCompact ? 2.0 : 0.0), child: Text(helper, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                ],
              ),
            ),
            Container(
              width: boxWidth,
              height: boxHeight,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(8), color: Colors.blue.shade50),
              alignment: Alignment.center,
              child: Text(value, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: valueFontSize, color: Colors.blue.shade800)),
            ),
          ],
        );
      },
    );
  }
}