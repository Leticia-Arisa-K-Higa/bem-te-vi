import 'package:flutter/material.dart';
import '../../core/models/patient_data.dart';

class PatientFormProvider extends ChangeNotifier {
  PatientData _patientData = PatientData(
    patientName: '',
    examinerName: '',
    examDate: DateTime.now(),
  );

  PatientData get patientData => _patientData;

  void updatePatientName(String name) {
    _patientData = _patientData.copyWith(patientName: name);
    notifyListeners();
  }

  void updateExaminerName(String name) {
    _patientData = _patientData.copyWith(examinerName: name);
    notifyListeners();
  }

  void updateExamDate(DateTime date) {
    _patientData = _patientData.copyWith(examDate: date);
    notifyListeners();
  }
}
