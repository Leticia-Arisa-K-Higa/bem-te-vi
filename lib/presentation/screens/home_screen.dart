import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/providers/patient_form_provider.dart';
import 'package:bem_te_vi/presentation/common_widgets/app_drawer.dart';
import 'package:bem_te_vi/presentation/common_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientFormProvider>(context);

    // Controladores para os campos de texto
    final TextEditingController patientNameController = TextEditingController(
      text: patientProvider.patientData.patientName,
    );
    final TextEditingController examinerNameController = TextEditingController(
      text: patientProvider.patientData.examinerName,
    );
    final TextEditingController examDateController = TextEditingController(
      text: DateFormat(
        'dd/MM/yyyy',
      ).format(patientProvider.patientData.examDate),
    );

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.homeTitle)),
      drawer: const AppDrawer(), // Sidebar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              labelText: AppStrings.patientNameLabel,
              controller: patientNameController,
              onChanged: patientProvider.updatePatientName,
            ),
            CustomTextField(
              labelText: AppStrings.examinerNameLabel,
              controller: examinerNameController,
              onChanged: patientProvider.updateExaminerName,
            ),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (patientNameController.text.isEmpty ||
                    examinerNameController.text.isEmpty ||
                    examDateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(AppStrings.pleaseFillFields)),
                  );
                } else {
                  patientProvider
                      .savePatientData(); // Chama o método para "salvar"
                  Navigator.pushNamed(
                    context,
                    '/asia_form',
                  ); // Navega para o formulário ASIA
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                AppStrings.saveAndContinueButton,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
