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

  // Método para "salvar" os dados (neste frontend, apenas mantém no estado)
  void savePatientData() {
    // Em um app real, aqui você chamaria um serviço para persistir os dados.
    print(
      'Dados do paciente salvos: ${_patientData.patientName}, ${_patientData.examinerName}, ${_patientData.examDate}',
    );
  }
}
