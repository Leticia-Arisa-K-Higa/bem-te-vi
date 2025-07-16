import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/providers/patient_form_provider.dart';
import 'package:bem_te_vi/presentation/common_widgets/app_drawer.dart';
import 'package:bem_te_vi/presentation/common_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
                      onPressed: () {
                        if (patientNameController.text.isEmpty ||
                            examinerNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.pleaseFillFields),
                            ),
                          );
                        } else {
                          patientProvider.savePatientData();
                          Navigator.pushNamed(context, '/asia_form');
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
