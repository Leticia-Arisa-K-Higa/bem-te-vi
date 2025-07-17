// lib/core/database/app_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Importe isso para que o drift saiba como gerar o arquivo .g.dart
part 'app_database.g.dart';

// Tabela para os dados do paciente (primeiro formulário)
class Patients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get patientName => text().withLength(min: 1)();
  TextColumn get examinerName => text().withLength(min: 1)();
  DateTimeColumn get examDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Tabela para os dados do formulário ASIA (segundo formulário)
@DataClassName('AsiaFormData')
class AsiaForms extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Chave estrangeira para conectar este formulário a um paciente
  IntColumn get patientId => integer().references(Patients, #id)();

  // Armazenaremos a grade complexa de dados como um texto JSON
  TextColumn get cellsData => text()();

  TextColumn get voluntaryAnalContraction => text().nullable()();
  TextColumn get deepAnalPressure => text().nullable()();
  TextColumn get rightLowestNonKeyMuscle => text().nullable()();
  TextColumn get leftLowestNonKeyMuscle => text().nullable()();
  TextColumn get comments => text().nullable()();
}

@DriftDatabase(tables: [Patients, AsiaForms])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bem_te_vi_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
