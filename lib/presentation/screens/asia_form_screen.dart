// lib/presentation/screens/asia_form_screen.dart

import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/providers/asia_form_provider.dart';
import 'package:bem_te_vi/presentation/common_widgets/app_drawer.dart';
import 'package:bem_te_vi/presentation/common_widgets/custom_text_field.dart'; // Import necessário para CustomTextField
import 'package:bem_te_vi/presentation/widgets/asia_lateral_totals_section.dart';
import 'package:bem_te_vi/presentation/widgets/asia_subscores_section.dart';
import 'package:bem_te_vi/presentation/widgets/asia_totals_section.dart';
import 'package:bem_te_vi/presentation/widgets/level_input_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsiaFormScreen extends StatelessWidget {
  const AsiaFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final asiaProvider = Provider.of<AsiaFormProvider>(context);

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
            icon: const Icon(Icons.save),
            tooltip: 'Salvar Formulário',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Funcionalidade de salvar não implementada (frontend apenas).',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seção de Diagramas (Imagens Responsivas)
            _buildDiagramSection(context),
            const SizedBox(height: 20),

            // Seção de Níveis Neurológicos (Lista Expansível)
            _buildLevelInputCards(context, asiaProvider),
            const SizedBox(height: 20),

            // Músculos Não-Chave com Função Motora
            _buildLowestNonKeyMuscles(
              context,
              asiaProvider,
            ), // Passando context
            const SizedBox(height: 20),

            // Comentários
            _buildComments(context, asiaProvider), // Passando context
            const SizedBox(height: 20),

            // Seletores de Sensação Anal
            _buildAnalSensationSelectors(asiaProvider),
            const SizedBox(height: 20),

            // Seção de Totais Laterais (Motor e Sensorial p/ Lado)
            AsiaLateralTotalsSection(totals: asiaProvider.totals),
            const SizedBox(height: 20),

            // Subscores Motores e Sensoriais
            AsiaSubscoresSection(totals: asiaProvider.totals),
            const SizedBox(height: 20),

            // Totais Finais ASIA
            AsiaTotalsSection(totals: asiaProvider.totals),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES DA CLASSE AsiaFormScreen ---

  // Método para construir a seção de diagramas (imagens responsivas)
  Widget _buildDiagramSection(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Diagramas de Referência ASIA',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        _buildImageWithLabel(
          context: context,
          imagePath: 'assets/images/asia-man.png',
          label: 'Corpo Completo',
          maxHeight:
              screenHeight * 0.7, // Ajuste a proporção conforme necessário
        ),
        const SizedBox(height: 15),

        _buildImageWithLabel(
          context: context,
          imagePath: 'assets/images/asia-legend.png',
          label: 'Legenda dos Valores',
          maxHeight: screenHeight * 0.15,
        ),
        const SizedBox(height: 15),

        _buildImageWithLabel(
          context: context,
          imagePath: 'assets/images/asia-hands.png',
          label: 'Detalhe das Mãos',
          maxHeight: screenHeight * 0.25,
        ),
        const SizedBox(height: 15),

        _buildImageWithLabel(
          context: context,
          imagePath: 'assets/images/asia-sacral.png',
          label: 'Detalhe da Região Sacral',
          maxHeight: screenHeight * 0.3,
        ),
        const SizedBox(height: 15),

        _buildImageWithLabel(
          context: context,
          imagePath:
              'assets/images/asia-head.png', // Verifique a extensão se for JPG
          label: 'Detalhe da Cabeça e Pescoço',
          maxHeight: screenHeight * 0.2,
        ),
      ],
    );
  }

  // Método auxiliar para criar cada imagem com label, zoom e responsividade
  Widget _buildImageWithLabel({
    required BuildContext context,
    required String imagePath,
    required String label,
    double maxHeight = 200, // Altura máxima padrão
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

  // Método para construir a lista de cartões de entrada de níveis neurológicos
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

  // Método para construir os seletores de sensação anal
  Widget _buildAnalSensationSelectors(AsiaFormProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          value: provider.voluntaryAnalContraction,
          decoration: const InputDecoration(
            labelText: AppStrings.vacLabel,
            border: OutlineInputBorder(),
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
          ),
          onChanged: provider.setDeepAnalPressure,
          items: AppStrings.analSensationOptions
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ],
    );
  }

  // Método para construir a seção de músculos não-chave
  Widget _buildLowestNonKeyMuscles(
    BuildContext context,
    AsiaFormProvider provider,
  ) {
    // Para tornar as opções responsivas, podemos envolver o Text em FittedBox
    // ou simplesmente permitir que o Text use seu softWrap.
    final List<DropdownMenuItem<String>> muscleOptions = AppStrings
        .lowestNonKeyMuscleOptions
        .entries
        .map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(
              entry.value,
              // Adicionando um estilo que permite o texto quebrar linha, se necessário.
              // Em um DropdownMenuItem, o Text geralmente tenta ser uma linha única.
              // Para dropdowns, isExpanded costuma ser a solução principal.
              overflow: TextOverflow
                  .ellipsis, // Corta o texto com '...' se for muito longo
              maxLines: 1, // Exibe no máximo uma linha
            ),
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lowest non-key muscles with motor function:',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Alinha verticalmente os itens da linha
          children: [
            const Expanded(
              flex:
                  2, // Reduz a flexibilidade do label para dar mais espaço ao dropdown
              child: Text('Right:', style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              flex:
                  5, // Aumenta a flexibilidade do dropdown para que ocupe mais espaço
              child: DropdownButtonFormField<String>(
                value: provider.rightLowestNonKeyMuscle,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: provider.setRightLowestNonKeyMuscle,
                items: muscleOptions,
                isExpanded:
                    true, // <--- MUITO IMPORTANTE: Faz o dropdown ocupar a largura disponível
                // Isso resolve muitos problemas de overflow em dropdowns
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Alinha verticalmente os itens da linha
          children: [
            const Expanded(
              flex: 2, // Reduz a flexibilidade do label
              child: Text('Left:', style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              flex: 5, // Aumenta a flexibilidade do dropdown
              child: DropdownButtonFormField<String>(
                value: provider.leftLowestNonKeyMuscle,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: provider.setLeftLowestNonKeyMuscle,
                items: muscleOptions,
                isExpanded: true, // <--- MUITO IMPORTANTE
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Método para construir a seção de comentários
  Widget _buildComments(BuildContext context, AsiaFormProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments:',
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
    );
  }
}
