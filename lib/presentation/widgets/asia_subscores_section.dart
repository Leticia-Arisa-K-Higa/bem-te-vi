// lib/presentation/widgets/asia_subscores_section.dart
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/models/totals_data.dart';
import 'package:flutter/material.dart';

class AsiaSubscoresSection extends StatelessWidget {
  final TotalsData totals;

  const AsiaSubscoresSection({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- Subscores Motores ---
        Card(
          elevation: 4.0,
          margin: const EdgeInsets.only(bottom: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.motorSubscoresTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 20, thickness: 1.5),

                _buildSubscoreRow(
                  // Usando o novo método para linhas
                  label: AppStrings.uerLabel,
                  value: totals.rightMotorTotal.toString(),
                  maxScore: '25',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ ${AppStrings.uelLabel}',
                  value: totals.leftMotorTotal.toString(),
                  maxScore: '25',
                ),
                _buildTotalSubscoreRow(
                  // Usando o novo método para totais
                  label: AppStrings.uemsTotal,
                  value: (totals.rightMotorTotal + totals.leftMotorTotal)
                      .toString(),
                  maxScore: '50',
                ),

                const Divider(height: 20, thickness: 1.0),

                _buildSubscoreRow(
                  label: AppStrings.lerLabel,
                  value: totals.rightMotorTotal
                      .toString(), // Mudar para totals.rightLowerMotorTotal quando implementado
                  maxScore: '25',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ ${AppStrings.lelLabel}',
                  value: totals.leftMotorTotal
                      .toString(), // Mudar para totals.leftLowerMotorTotal quando implementado
                  maxScore: '25',
                ),
                _buildTotalSubscoreRow(
                  label: AppStrings.lemsTotal,
                  value: (totals.rightMotorTotal + totals.leftMotorTotal)
                      .toString(), // Mudar para totais corretos
                  maxScore: '50',
                ),
              ],
            ),
          ),
        ),

        // --- Subscores Sensoriais ---
        Card(
          elevation: 4.0,
          margin: const EdgeInsets.only(bottom: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.sensorySubscoresTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 20, thickness: 1.5),

                _buildSubscoreRow(
                  label: 'TL Direita',
                  value: totals.rightLightTouchTotal.toString(),
                  maxScore: '56',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ TL Esquerda',
                  value: totals.leftLightTouchTotal.toString(),
                  maxScore: '56',
                ),
                _buildTotalSubscoreRow(
                  label: AppStrings.ltTotal,
                  value:
                      (totals.rightLightTouchTotal + totals.leftLightTouchTotal)
                          .toString(),
                  maxScore: '112',
                ),

                const Divider(height: 20, thickness: 1.0),

                _buildSubscoreRow(
                  label: 'PP Direita',
                  value: totals.rightPinPrickTotal.toString(),
                  maxScore: '56',
                ),
                _buildSubscoreGroupSeparator(),
                _buildSubscoreRow(
                  label: '+ PP Esquerda',
                  value: totals.leftPinPrickTotal.toString(),
                  maxScore: '56',
                ),
                _buildTotalSubscoreRow(
                  label: AppStrings.ppTotal,
                  value: (totals.rightPinPrickTotal + totals.leftPinPrickTotal)
                      .toString(),
                  maxScore: '112',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // MÉTODO AUXILIAR para os itens de subscore individuais (e.g., MMSS Direita)
  // O (Máximo) (xx) sempre ficará embaixo
  Widget _buildSubscoreRow({
    required String label,
    required String value,
    required String maxScore,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            // Permite que o label ocupe o máximo de espaço possível
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Column(
            // Agora é sempre uma coluna para o valor e o máximo
            crossAxisAlignment: CrossAxisAlignment.end, // Alinha à direita
            children: [
              _buildValueContainer(value),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${AppStrings.maximumLabel} ($maxScore)',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MÉTODO AUXILIAR para os itens de total (e.g., = Total MMSS)
  Widget _buildTotalSubscoreRow({
    required String label,
    required String value,
    required String maxScore,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Column(
            // Sempre uma coluna para o valor e o máximo
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildValueContainer(value, isTotal: true),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${AppStrings.maximumLabel} ($maxScore)',
                  style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Contêiner de valor reutilizável (sem alterações significativas aqui)
  Widget _buildValueContainer(String value, {bool isTotal = false}) {
    return Container(
      width: 45,
      height: 35,
      decoration: BoxDecoration(
        color: isTotal ? Colors.blue.shade50 : Colors.grey.shade100,
        border: Border.all(color: isTotal ? Colors.blue : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          fontSize: 17,
          color: isTotal ? Colors.blue.shade800 : Colors.black87,
        ),
      ),
    );
  }

  // Separador para agrupar as somas (sem alterações significativas aqui)
  Widget _buildSubscoreGroupSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '+',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
