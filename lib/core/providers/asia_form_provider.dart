// lib/core/providers/asia_form_provider.dart

import 'package:bem_te_vi/core/models/neurology_cell_data.dart';
import 'package:bem_te_vi/core/models/exam_models.dart';
import 'package:bem_te_vi/core/models/results__models.dart';
import 'package:bem_te_vi/core/utils/asia_calculator.dart';
import 'package:flutter/material.dart';
import 'package:bem_te_vi/core/constants/app_strings.dart';

class AsiaFormProvider extends ChangeNotifier {
  List<NeurologyCellData> _cells = [];
  IscnsciResult? _result;

  String? _voluntaryAnalContraction;
  String? _deepAnalPressure;
  String? _rightLowestNonKeyMuscle;
  String? _leftLowestNonKeyMuscle;
  String _comments = '';
  
  static const List<String> _spinalOrder = ['C2','C3','C4','C5','C6','C7','C8','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12','L1','L2','L3','L4','L5','S1','S2','S3','S4-5'];

  AsiaFormProvider() {
    _initializeCells();
    _calculateAndNotify();
  }

  List<NeurologyCellData> get cells => _cells;
  IscnsciResult? get result => _result;
  String? get voluntaryAnalContraction => _voluntaryAnalContraction;
  String? get deepAnalPressure => _deepAnalPressure;
  String? get rightLowestNonKeyMuscle => _rightLowestNonKeyMuscle;
  String? get leftLowestNonKeyMuscle => _leftLowestNonKeyMuscle;
  String get comments => _comments;

  void _initializeCells() {
    final List<NeurologyCellData> initialCells = [];
    for (String level in AppStrings.sensoryLevels) {
      initialCells.addAll([
        NeurologyCellData(id: '${level}RightLT', type: CellType.sensoryLightTouch, side: Side.right, level: level, title: '$level Light Touch Right', value: ''),
        NeurologyCellData(id: '${level}RightPP', type: CellType.sensoryPinPrick, side: Side.right, level: level, title: '$level Pin Prick Right', value: ''),
        NeurologyCellData(id: '${level}LeftLT', type: CellType.sensoryLightTouch, side: Side.left, level: level, title: '$level Light Touch Left', value: ''),
        NeurologyCellData(id: '${level}LeftPP', type: CellType.sensoryPinPrick, side: Side.left, level: level, title: '$level Pin Prick Left', value: ''),
      ]);
    }
    for (String level in AppStrings.motorLevels) {
      initialCells.addAll([
        NeurologyCellData(id: '${level}RightMotor', type: CellType.motor, side: Side.right, level: level, title: '$level Motor Right', helperText: AppStrings.motorHelpers[level], value: ''),
        NeurologyCellData(id: '${level}LeftMotor', type: CellType.motor, side: Side.left, level: level, title: '$level Motor Left', helperText: AppStrings.motorHelpers[level], value: ''),
      ]);
    }
    _cells = initialCells;
  }

  void updateCellValue(String cellId, String? newValue) {
    if (newValue == null) return;
    final originalCellIndex = _cells.indexWhere((cell) => cell.id == cellId);
    if (originalCellIndex == -1) return;
    final originalCell = _cells[originalCellIndex];
    _cells[originalCellIndex] = originalCell.copyWith(value: newValue);
    if (newValue.isEmpty) {
      _calculateAndNotify();
      return;
    }
    final originalLevelIndex = _spinalOrder.indexOf(originalCell.level);
    if (originalLevelIndex == -1) {
      _calculateAndNotify();
      return;
    }
    for (int i = originalLevelIndex + 1; i < _spinalOrder.length; i++) {
      final lowerLevel = _spinalOrder[i];
      final lowerCellIndex = _cells.indexWhere((cell) => cell.level == lowerLevel && cell.side == originalCell.side && cell.type == originalCell.type);
      if (lowerCellIndex != -1) {
        _cells[lowerCellIndex] = _cells[lowerCellIndex].copyWith(value: newValue);
      }
    }
    _calculateAndNotify();
  }

  void _calculateAndNotify() {
    final exam = _createExamFromCells();
    final calculator = PraxisIscnsciCalculator(exam);
    _result = calculator.calculate();
    notifyListeners();
  }

  Exam _createExamFromCells() {
    MotorValues rightMotor = {};
    SensoryValues rightLt = {};
    SensoryValues rightPp = {};
    MotorValues leftMotor = {};
    SensoryValues leftLt = {};
    SensoryValues leftPp = {};

    for (final cell in _cells) {
      final levelKey = cell.level.replaceAll('-', '_');
      final value = cell.value ?? '';
      
      if (cell.side == Side.right) {
        if (cell.type == CellType.motor) rightMotor[levelKey] = value;
        if (cell.type == CellType.sensoryLightTouch) rightLt[levelKey] = value;
        if (cell.type == CellType.sensoryPinPrick) rightPp[levelKey] = value;
      } else {
        if (cell.type == CellType.motor) leftMotor[levelKey] = value;
        if (cell.type == CellType.sensoryLightTouch) leftLt[levelKey] = value;
        if (cell.type == CellType.sensoryPinPrick) leftPp[levelKey] = value;
      }
    }
    
    return Exam(
      right: ExamSide(motor: rightMotor, lightTouch: rightLt, pinPrick: rightPp, lowestNonKeyMuscleWithMotorFunction: _rightLowestNonKeyMuscle),
      left: ExamSide(motor: leftMotor, lightTouch: leftLt, pinPrick: leftPp, lowestNonKeyMuscleWithMotorFunction: _leftLowestNonKeyMuscle),
      voluntaryAnalContraction: _voluntaryAnalContraction ?? 'No',
      deepAnalPressure: _deepAnalPressure ?? 'No',
    );
  }

  void setVoluntaryAnalContraction(String? value) { _voluntaryAnalContraction = value; _calculateAndNotify(); }
  void setDeepAnalPressure(String? value) { _deepAnalPressure = value; _calculateAndNotify(); }
  void setRightLowestNonKeyMuscle(String? value) { _rightLowestNonKeyMuscle = value; _calculateAndNotify(); }
  void setLeftLowestNonKeyMuscle(String? value) { _leftLowestNonKeyMuscle = value; _calculateAndNotify(); }
  void setComments(String value) { _comments = value; notifyListeners(); }

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