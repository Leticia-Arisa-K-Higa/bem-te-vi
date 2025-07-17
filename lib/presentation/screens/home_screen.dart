import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/providers/patient_form_provider.dart';
import 'package:bem_te_vi/presentation/common_widgets/app_drawer.dart';
import 'package:bem_te_vi/presentation/common_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bem_te_vi/core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController patientNameController;
  late TextEditingController examinerNameController;
  late TextEditingController examDateController;

  @override
  void initState() {
    super.initState();
    final patientProvider = context.read<PatientFormProvider>();
    patientNameController = TextEditingController(
      text: patientProvider.patientData.patientName,
    );
    examinerNameController = TextEditingController(
      text: patientProvider.patientData.examinerName,
    );
    examDateController = TextEditingController(
      text: DateFormat(
        'dd/MM/yyyy',
      ).format(patientProvider.patientData.examDate),
    );
  }

  @override
  void dispose() {
    patientNameController.dispose();
    examinerNameController.dispose();
    examDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientFormProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.homeTitle)),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppStrings.emeraldGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppStrings.emeraldGreen.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      labelText: AppStrings.patientNameLabel,
                      controller: patientNameController,
                      onChanged: patientProvider.updatePatientName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: AppStrings.examinerNameLabel,
                      controller: examinerNameController,
                      onChanged: patientProvider.updateExaminerName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: AppStrings.examDateLabel,
                      controller: examDateController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: patientProvider.patientData.examDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          patientProvider.updateExamDate(pickedDate);
                          examDateController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (patientNameController.text.isEmpty ||
                            examinerNameController.text.isEmpty ||
                            examinerNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.pleaseFillFields),
                            ),
                          );
                        } else {
                          final database = context.read<AppDatabase>();
                          final patientProvider = context
                              .read<PatientFormProvider>();

                          final patientCompanion = PatientsCompanion(
                            patientName: drift.Value(
                              patientProvider.patientData.patientName,
                            ),
                            examinerName: drift.Value(
                              patientProvider.patientData.patientName,
                            ),
                            examDate: drift.Value(
                              patientProvider.patientData.examDate,
                            ),
                          );

                          try {
                            final newPatientId = await database
                                .into(database.patients)
                                .insert(patientCompanion);

                            if (mounted) {
                              Navigator.pushNamed(
                                context,
                                '/asia_form',
                                arguments: newPatientId,
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao salvar paciente: $e'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(AppStrings.saveAndContinueButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
