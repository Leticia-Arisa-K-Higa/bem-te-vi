import 'package:bem_te_vi/core/models/neurology_cell_data.dart';
import 'package:bem_te_vi/presentation/widgets/value_selection_dialog.dart';
import 'package:flutter/material.dart';

class InteractiveAsiaCell extends StatelessWidget {
  final NeurologyCellData cellData;
  final Function(String id, String? value) onCellValueChanged;

  const InteractiveAsiaCell({
    super.key,
    required this.cellData,
    required this.onCellValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
        onTap: () async {
          final String? selectedValue = await showDialog<String>(
            context: context,
            builder: (BuildContext dialogContext) {
              return ValueSelectionDialog(
                currentValue: cellData.value,
                cellType: cellData.type,
              );
            },
          );
          if (selectedValue != null) {
            onCellValueChanged(cellData.id, selectedValue);
          }
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            cellData.value ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cellData.value?.contains('*') ?? false
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
