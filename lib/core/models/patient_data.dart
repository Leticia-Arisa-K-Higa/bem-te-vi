class PatientData {
  String patientName;
  String examinerName;
  DateTime examDate;

  PatientData({
    required this.patientName,
    required this.examinerName,
    required this.examDate,
  });

  PatientData copyWith({
    String? patientName,
    String? examinerName,
    DateTime? examDate,
  }) {
    return PatientData(
      patientName: patientName ?? this.patientName,
      examinerName: examinerName ?? this.examinerName,
      examDate: examDate ?? this.examDate,
    );
  }
}
