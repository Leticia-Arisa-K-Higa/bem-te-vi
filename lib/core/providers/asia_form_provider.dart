// lib/core/providers/asia_form_provider.dart

import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/models/neurology_cell_data.dart';
import 'package:bem_te_vi/core/models/totals_data.dart';
import 'package:bem_te_vi/core/utils/asia_calculator.dart';
import 'package:flutter/material.dart';

class AsiaFormProvider extends ChangeNotifier {
  List<NeurologyCellData> _cells = [];
  TotalsData _totals = TotalsData();
  String? _voluntaryAnalContraction;
  String? _deepAnalPressure;
  String? _rightLowestNonKeyMuscle;
  String? _leftLowestNonKeyMuscle;
  String _comments = '';

  static const List<String> _spinalOrder = [
    'C2',
    'C3',
    'C4',
    'C5',
    'C6',
    'C7',
    'C8',
    'T1',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'T8',
    'T9',
    'T10',
    'T11',
    'T12',
    'L1',
    'L2',
    'L3',
    'L4',
    'L5',
    'S1',
    'S2',
    'S3',
    'S4-5',
  ];

  AsiaFormProvider() {
    _initializeCells();
    _calculateAndNotify();
  }

  // Getters
  List<NeurologyCellData> get cells => _cells;
  TotalsData get totals => _totals;
  String? get voluntaryAnalContraction => _voluntaryAnalContraction;
  String? get deepAnalPressure => _deepAnalPressure;
  String? get rightLowestNonKeyMuscle => _rightLowestNonKeyMuscle;
  String? get leftLowestNonKeyMuscle => _leftLowestNonKeyMuscle;
  String get comments => _comments;

  // ▼▼▼ CORREÇÃO: Conteúdo deste método foi restaurado ▼▼▼
  void _initializeCells() {
    final List<NeurologyCellData> initialCells = [];

    // Células Sensoriais
    for (String level in AppStrings.sensoryLevels) {
      initialCells.add(
        NeurologyCellData(
          id: '${level}RightLT',
          type: CellType.sensoryLightTouch,
          side: Side.right,
          level: level,
          title: '$level Light Touch Right',
          value: '',
        ),
      );
      initialCells.add(
        NeurologyCellData(
          id: '${level}RightPP',
          type: CellType.sensoryPinPrick,
          side: Side.right,
          level: level,
          title: '$level Pin Prick Right',
          value: '',
        ),
      );
      initialCells.add(
        NeurologyCellData(
          id: '${level}LeftLT',
          type: CellType.sensoryLightTouch,
          side: Side.left,
          level: level,
          title: '$level Light Touch Left',
          value: '',
        ),
      );
      initialCells.add(
        NeurologyCellData(
          id: '${level}LeftPP',
          type: CellType.sensoryPinPrick,
          side: Side.left,
          level: level,
          title: '$level Pin Prick Left',
          value: '',
        ),
      );
    }

    // Células Motoras
    for (String level in AppStrings.motorLevels) {
      initialCells.add(
        NeurologyCellData(
          id: '${level}RightMotor',
          type: CellType.motor,
          side: Side.right,
          level: level,
          title: '$level Motor Right',
          helperText: AppStrings.motorHelpers[level],
          value: '',
        ),
      );
      initialCells.add(
        NeurologyCellData(
          id: '${level}LeftMotor',
          type: CellType.motor,
          side: Side.left,
          level: level,
          title: '$level Motor Left',
          helperText: AppStrings.motorHelpers[level],
          value: '',
        ),
      );
    }
    _cells = initialCells;
  }
  // ▲▲▲ FIM DA CORREÇÃO ▲▲▲

  void updateCellValue(String cellId, String? newValue) {
    if (newValue == null) return; // Permitir limpar o campo com string vazia

    final originalCellIndex = _cells.indexWhere((cell) => cell.id == cellId);
    if (originalCellIndex == -1) return;

    final originalCell = _cells[originalCellIndex];
    _cells[originalCellIndex] = originalCell.copyWith(value: newValue);

    // Se o novo valor for vazio, apenas limpa a célula e recalcula, sem cascata.
    if (newValue.isEmpty) {
      _calculateAndNotify();
      return;
    }

    // Inicia a lógica de cascata para valores não-vazios
    final originalLevelIndex = _spinalOrder.indexOf(originalCell.level);
    if (originalLevelIndex == -1) {
      _calculateAndNotify();
      return;
    }

    for (int i = originalLevelIndex + 1; i < _spinalOrder.length; i++) {
      final lowerLevel = _spinalOrder[i];
      final lowerCellIndex = _cells.indexWhere(
        (cell) =>
            cell.level == lowerLevel &&
            cell.side == originalCell.side &&
            cell.type == originalCell.type,
      );

      if (lowerCellIndex != -1) {
        // ▼▼▼ MUDANÇA PRINCIPAL ▼▼▼
        // A condição 'if' que verificava se a célula estava vazia foi REMOVIDA.
        // Agora, a cascata vai sobrescrever os valores anteriores.
        _cells[lowerCellIndex] = _cells[lowerCellIndex].copyWith(
          value: newValue,
        );
        // ▲▲▲ FIM DA MUDANÇA ▲▲▲
      }
    }

    _calculateAndNotify();
  }

  void setVoluntaryAnalContraction(String? value) {
    _voluntaryAnalContraction = value;
    _calculateAndNotify();
  }

  void setDeepAnalPressure(String? value) {
    _deepAnalPressure = value;
    _calculateAndNotify();
  }

  void setRightLowestNonKeyMuscle(String? value) {
    _rightLowestNonKeyMuscle = value;
    notifyListeners();
    _calculateAndNotify();
  }

  void setLeftLowestNonKeyMuscle(String? value) {
    _leftLowestNonKeyMuscle = value;
    notifyListeners();
    _calculateAndNotify();
  }

  void setComments(String value) {
    _comments = value;
    notifyListeners();
  }

  void _calculateAndNotify() {
    final calculator = AsiaCalculator(
      cells: _cells,
      voluntaryAnalContraction: _voluntaryAnalContraction == AppStrings.vacYes,
      deepAnalPressure: _deepAnalPressure == AppStrings.vacYes,
    );

    _totals = calculator.calculate();

    notifyListeners();
  }

  void clearForm() {
    _initializeCells();
    _voluntaryAnalContraction = null;
    _deepAnalPressure = null;
    _rightLowestNonKeyMuscle = null;
    _leftLowestNonKeyMuscle = null;
    _comments = '';
    _calculateAndNotify();
  }
}
