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

  // --- NOVAS PROPRIEDADES E SEUS GETTERS/SETTERS ---
  String? _rightLowestNonKeyMuscle;
  String? _leftLowestNonKeyMuscle;
  String _comments = '';
  // -------------------------------------------------

  AsiaFormProvider() {
    _initializeCells();
    _calculateAndNotify();
  }

  List<NeurologyCellData> get cells => _cells;
  TotalsData get totals => _totals;
  String? get voluntaryAnalContraction => _voluntaryAnalContraction;
  String? get deepAnalPressure => _deepAnalPressure;

  // --- GETTERS PARA AS NOVAS PROPRIEDADES ---
  String? get rightLowestNonKeyMuscle => _rightLowestNonKeyMuscle;
  String? get leftLowestNonKeyMuscle => _leftLowestNonKeyMuscle;
  String get comments => _comments;
  // ------------------------------------------

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

  void updateCellValue(String cellId, String? newValue) {
    final int index = _cells.indexWhere((cell) => cell.id == cellId);
    if (index != -1) {
      _cells[index] = _cells[index].copyWith(value: newValue);
      _calculateAndNotify();
    }
  }

  void setVoluntaryAnalContraction(String? value) {
    _voluntaryAnalContraction = value;
    _calculateAndNotify();
  }

  void setDeepAnalPressure(String? value) {
    _deepAnalPressure = value;
    _calculateAndNotify();
  }

  // --- SETTERS PARA AS NOVAS PROPRIEDADES ---
  void setRightLowestNonKeyMuscle(String? value) {
    _rightLowestNonKeyMuscle = value;
    // Se o cálculo do ASIA depender disso, chame _calculateAndNotify();
    notifyListeners();
  }

  void setLeftLowestNonKeyMuscle(String? value) {
    _leftLowestNonKeyMuscle = value;
    // Se o cálculo do ASIA depender disso, chame _calculateAndNotify();
    notifyListeners();
  }

  void setComments(String value) {
    _comments = value;
    notifyListeners();
  }
  // ------------------------------------------

  void _calculateAndNotify() {
    _totals = AsiaCalculator.calculateTotals(
      _cells,
      voluntaryAnalContraction: _voluntaryAnalContraction == AppStrings.vacYes,
      deepAnalPressure: _deepAnalPressure == AppStrings.vacYes,
      // Passar esses valores para o calculador se ele usar
      // rightLowestNonKeyMuscle: _rightLowestNonKeyMuscle,
      // leftLowestNonKeyMuscle: _leftLowestNonKeyMuscle,
    );
    notifyListeners();
  }

  void clearForm() {
    _initializeCells();
    _voluntaryAnalContraction = null;
    _deepAnalPressure = null;
    // --- RESETAR NOVAS PROPRIEDADES NO CLEAR FORM ---
    _rightLowestNonKeyMuscle = null;
    _leftLowestNonKeyMuscle = null;
    _comments = '';
    // ------------------------------------------------
    _calculateAndNotify();
  }
}
