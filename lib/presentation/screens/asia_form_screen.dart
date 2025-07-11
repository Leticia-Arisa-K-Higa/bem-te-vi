import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/providers/asia_form_provider.dart';
import 'package:bem_te_vi/presentation/common_widgets/app_drawer.dart';
import 'package:bem_te_vi/presentation/common_widgets/custom_text_field.dart';
import 'package:bem_te_vi/presentation/widgets/asia_lateral_totals_section.dart';
import 'package:bem_te_vi/presentation/widgets/asia_subscores_section.dart';
import 'package:bem_te_vi/presentation/widgets/asia_totals_section.dart';
import 'package:bem_te_vi/presentation/widgets/level_input_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bem_te_vi/core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class AsiaFormScreen extends StatelessWidget {
  const AsiaFormScreen({super.key});

  void _showDiagramsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Diagramas de Referência ASIA'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageWithLabel(
                  context: context,
                  imagePath: 'assets/images/asia-man.png',
                  label: 'Corpo Completo',
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                const SizedBox(height: 15),
                _buildImageWithLabel(
                  context: context,
                  imagePath: 'assets/images/asia-legend.png',
                  label: 'Legenda dos Valores',
                  maxHeight: MediaQuery.of(context).size.height * 0.15,
                ),
                const SizedBox(height: 15),
                _buildImageWithLabel(
                  context: context,
                  imagePath: 'assets/images/asia-hands.png',
                  label: 'Detalhe das Mãos',
                  maxHeight: MediaQuery.of(context).size.height * 0.25,
                ),
                const SizedBox(height: 15),
                _buildImageWithLabel(
                  context: context,
                  imagePath: 'assets/images/asia-sacral.png',
                  label: 'Detalhe da Região Sacral',
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                const SizedBox(height: 15),
                _buildImageWithLabel(
                  context: context,
                  imagePath: 'assets/images/asia-head.png',
                  label: 'Detalhe da Cabeça e Pescoço',
                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final patientId = ModalRoute.of(context)!.settings.arguments as int;
    final asiaProvider = Provider.of<AsiaFormProvider>(context);
    final database = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.asiaFormTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Limpar Formulário',
            onPressed: () => asiaProvider.clearForm(),
          ),
          IconButton(
            icon: const Icon(Icons.image_outlined),
            tooltip: 'Ver Diagramas de Referência',
            onPressed: () => _showDiagramsDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar Formulário',
            onPressed: () async {
              final cellsJson = jsonEncode(
                asiaProvider.cells.map((cell) => cell.toJson()).toList(),
              );

              final formCompanion = AsiaFormsCompanion(
                patientId: drift.Value(patientId),
                cellsData: drift.Value(cellsJson),
                voluntaryAnalContraction: drift.Value(
                  asiaProvider.voluntaryAnalContraction,
                ),
                deepAnalPressure: drift.Value(asiaProvider.deepAnalPressure),
                rightLowestNonKeyMuscle: drift.Value(
                  asiaProvider.rightLowestNonKeyMuscle,
                ),
                leftLowestNonKeyMuscle: drift.Value(
                  asiaProvider.leftLowestNonKeyMuscle,
                ),
                comments: drift.Value(asiaProvider.comments),
              );

              try {
                await database.into(database.asiaForms).insert(formCompanion);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Formulário ASIA salvo com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao salvar o formulário: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppStrings.emeraldGreen, Color(0xFF4DB6AC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLevelInputCards(context, asiaProvider),
              const SizedBox(height: 20),
              _buildLowestNonKeyMuscles(context, asiaProvider),
              const SizedBox(height: 20),
              _buildComments(context, asiaProvider),
              const SizedBox(height: 20),
              _buildAnalSensationSelectors(context, asiaProvider),
              const SizedBox(height: 20),
              AsiaLateralTotalsSection(result: asiaProvider.result),
              const SizedBox(height: 20),
              AsiaSubscoresSection(result: asiaProvider.result),
              const SizedBox(height: 20),
              AsiaTotalsSection(result: asiaProvider.result),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithLabel({
    required BuildContext context,
    required String imagePath,
    required String label,
    double maxHeight = 200,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            minHeight: 50,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 2.5,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelInputCards(
    BuildContext context,
    AsiaFormProvider provider,
  ) {
    final List<String> allLevels = AppStrings.sensoryLevels.toSet().toList()
      ..sort((a, b) {
        final int aNum = int.tryParse(a.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        final int bNum = int.tryParse(b.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        if (a.startsWith('C') && b.startsWith('T')) return -1;
        if (a.startsWith('T') && b.startsWith('L')) return -1;
        if (a.startsWith('L') && b.startsWith('S')) return -1;
        if (a.startsWith('S') && b.startsWith('C')) return 1;
        return aNum.compareTo(bNum);
      });

    return Column(
      children: allLevels.map((level) {
        final levelCells = provider.cells
            .where((cell) => cell.level == level)
            .toList();
        return LevelInputCard(
          level: level,
          levelCells: levelCells,
          onCellValueChanged: provider.updateCellValue,
        );
      }).toList(),
    );
  }

  Widget _buildAnalSensationSelectors(
    BuildContext context,
    AsiaFormProvider provider,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sensibilidade Anal',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: provider.voluntaryAnalContraction,
              decoration: const InputDecoration(
                labelText: AppStrings.vacLabel,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: provider.setVoluntaryAnalContraction,
              items: AppStrings.analSensationOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: provider.deepAnalPressure,
              decoration: const InputDecoration(
                labelText: AppStrings.dapLabel,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: provider.setDeepAnalPressure,
              items: AppStrings.analSensationOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowestNonKeyMuscles(
    BuildContext context,
    AsiaFormProvider provider,
  ) {
    final List<DropdownMenuItem<String>> muscleOptions = AppStrings
        .lowestNonKeyMuscleOptions
        .entries
        .map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(
              entry.value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        )
        .toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Músculo não-chave mais baixo com função motora:',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Right:', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  flex: 5,
                  child: DropdownButtonFormField<String>(
                    value: provider.rightLowestNonKeyMuscle,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: provider.setRightLowestNonKeyMuscle,
                    items: muscleOptions,
                    isExpanded: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Left:', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  flex: 5,
                  child: DropdownButtonFormField<String>(
                    value: provider.leftLowestNonKeyMuscle,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: provider.setLeftLowestNonKeyMuscle,
                    items: muscleOptions,
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComments(BuildContext context, AsiaFormProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comentários:',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              labelText: 'Digite seus comentários aqui...',
              initialValue: provider.comments,
              onChanged: provider.setComments,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
