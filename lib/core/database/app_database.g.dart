// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientNameMeta =
      const VerificationMeta('patientName');
  @override
  late final GeneratedColumn<String> patientName =
      GeneratedColumn<String>('patient_name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _examinerNameMeta =
      const VerificationMeta('examinerName');
  @override
  late final GeneratedColumn<String> examinerName =
      GeneratedColumn<String>('examiner_name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _examDateMeta =
      const VerificationMeta('examDate');
  @override
  late final GeneratedColumn<DateTime> examDate = GeneratedColumn<DateTime>(
      'exam_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientName, examinerName, examDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<Patient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_name')) {
      context.handle(
          _patientNameMeta,
          patientName.isAcceptableOrUnknown(
              data['patient_name']!, _patientNameMeta));
    } else if (isInserting) {
      context.missing(_patientNameMeta);
    }
    if (data.containsKey('examiner_name')) {
      context.handle(
          _examinerNameMeta,
          examinerName.isAcceptableOrUnknown(
              data['examiner_name']!, _examinerNameMeta));
    } else if (isInserting) {
      context.missing(_examinerNameMeta);
    }
    if (data.containsKey('exam_date')) {
      context.handle(_examDateMeta,
          examDate.isAcceptableOrUnknown(data['exam_date']!, _examDateMeta));
    } else if (isInserting) {
      context.missing(_examDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_name'])!,
      examinerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}examiner_name'])!,
      examDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}exam_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final int id;
  final String patientName;
  final String examinerName;
  final DateTime examDate;
  final DateTime createdAt;
  const Patient(
      {required this.id,
      required this.patientName,
      required this.examinerName,
      required this.examDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_name'] = Variable<String>(patientName);
    map['examiner_name'] = Variable<String>(examinerName);
    map['exam_date'] = Variable<DateTime>(examDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      patientName: Value(patientName),
      examinerName: Value(examinerName),
      examDate: Value(examDate),
      createdAt: Value(createdAt),
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      id: serializer.fromJson<int>(json['id']),
      patientName: serializer.fromJson<String>(json['patientName']),
      examinerName: serializer.fromJson<String>(json['examinerName']),
      examDate: serializer.fromJson<DateTime>(json['examDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientName': serializer.toJson<String>(patientName),
      'examinerName': serializer.toJson<String>(examinerName),
      'examDate': serializer.toJson<DateTime>(examDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Patient copyWith(
          {int? id,
          String? patientName,
          String? examinerName,
          DateTime? examDate,
          DateTime? createdAt}) =>
      Patient(
        id: id ?? this.id,
        patientName: patientName ?? this.patientName,
        examinerName: examinerName ?? this.examinerName,
        examDate: examDate ?? this.examDate,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('id: $id, ')
          ..write('patientName: $patientName, ')
          ..write('examinerName: $examinerName, ')
          ..write('examDate: $examDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patientName, examinerName, examDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.id == this.id &&
          other.patientName == this.patientName &&
          other.examinerName == this.examinerName &&
          other.examDate == this.examDate &&
          other.createdAt == this.createdAt);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<int> id;
  final Value<String> patientName;
  final Value<String> examinerName;
  final Value<DateTime> examDate;
  final Value<DateTime> createdAt;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.patientName = const Value.absent(),
    this.examinerName = const Value.absent(),
    this.examDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PatientsCompanion.insert({
    this.id = const Value.absent(),
    required String patientName,
    required String examinerName,
    required DateTime examDate,
    this.createdAt = const Value.absent(),
  })  : patientName = Value(patientName),
        examinerName = Value(examinerName),
        examDate = Value(examDate);
  static Insertable<Patient> custom({
    Expression<int>? id,
    Expression<String>? patientName,
    Expression<String>? examinerName,
    Expression<DateTime>? examDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientName != null) 'patient_name': patientName,
      if (examinerName != null) 'examiner_name': examinerName,
      if (examDate != null) 'exam_date': examDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PatientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? patientName,
      Value<String>? examinerName,
      Value<DateTime>? examDate,
      Value<DateTime>? createdAt}) {
    return PatientsCompanion(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      examinerName: examinerName ?? this.examinerName,
      examDate: examDate ?? this.examDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientName.present) {
      map['patient_name'] = Variable<String>(patientName.value);
    }
    if (examinerName.present) {
      map['examiner_name'] = Variable<String>(examinerName.value);
    }
    if (examDate.present) {
      map['exam_date'] = Variable<DateTime>(examDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('patientName: $patientName, ')
          ..write('examinerName: $examinerName, ')
          ..write('examDate: $examDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AsiaFormsTable extends AsiaForms
    with TableInfo<$AsiaFormsTable, AsiaFormData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AsiaFormsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _cellsDataMeta =
      const VerificationMeta('cellsData');
  @override
  late final GeneratedColumn<String> cellsData = GeneratedColumn<String>(
      'cells_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voluntaryAnalContractionMeta =
      const VerificationMeta('voluntaryAnalContraction');
  @override
  late final GeneratedColumn<String> voluntaryAnalContraction =
      GeneratedColumn<String>('voluntary_anal_contraction', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deepAnalPressureMeta =
      const VerificationMeta('deepAnalPressure');
  @override
  late final GeneratedColumn<String> deepAnalPressure = GeneratedColumn<String>(
      'deep_anal_pressure', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rightLowestNonKeyMuscleMeta =
      const VerificationMeta('rightLowestNonKeyMuscle');
  @override
  late final GeneratedColumn<String> rightLowestNonKeyMuscle =
      GeneratedColumn<String>('right_lowest_non_key_muscle', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _leftLowestNonKeyMuscleMeta =
      const VerificationMeta('leftLowestNonKeyMuscle');
  @override
  late final GeneratedColumn<String> leftLowestNonKeyMuscle =
      GeneratedColumn<String>('left_lowest_non_key_muscle', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentsMeta =
      const VerificationMeta('comments');
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
      'comments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        cellsData,
        voluntaryAnalContraction,
        deepAnalPressure,
        rightLowestNonKeyMuscle,
        leftLowestNonKeyMuscle,
        comments
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asia_forms';
  @override
  VerificationContext validateIntegrity(Insertable<AsiaFormData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('cells_data')) {
      context.handle(_cellsDataMeta,
          cellsData.isAcceptableOrUnknown(data['cells_data']!, _cellsDataMeta));
    } else if (isInserting) {
      context.missing(_cellsDataMeta);
    }
    if (data.containsKey('voluntary_anal_contraction')) {
      context.handle(
          _voluntaryAnalContractionMeta,
          voluntaryAnalContraction.isAcceptableOrUnknown(
              data['voluntary_anal_contraction']!,
              _voluntaryAnalContractionMeta));
    }
    if (data.containsKey('deep_anal_pressure')) {
      context.handle(
          _deepAnalPressureMeta,
          deepAnalPressure.isAcceptableOrUnknown(
              data['deep_anal_pressure']!, _deepAnalPressureMeta));
    }
    if (data.containsKey('right_lowest_non_key_muscle')) {
      context.handle(
          _rightLowestNonKeyMuscleMeta,
          rightLowestNonKeyMuscle.isAcceptableOrUnknown(
              data['right_lowest_non_key_muscle']!,
              _rightLowestNonKeyMuscleMeta));
    }
    if (data.containsKey('left_lowest_non_key_muscle')) {
      context.handle(
          _leftLowestNonKeyMuscleMeta,
          leftLowestNonKeyMuscle.isAcceptableOrUnknown(
              data['left_lowest_non_key_muscle']!,
              _leftLowestNonKeyMuscleMeta));
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AsiaFormData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AsiaFormData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      cellsData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cells_data'])!,
      voluntaryAnalContraction: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}voluntary_anal_contraction']),
      deepAnalPressure: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}deep_anal_pressure']),
      rightLowestNonKeyMuscle: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}right_lowest_non_key_muscle']),
      leftLowestNonKeyMuscle: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}left_lowest_non_key_muscle']),
      comments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comments']),
    );
  }

  @override
  $AsiaFormsTable createAlias(String alias) {
    return $AsiaFormsTable(attachedDatabase, alias);
  }
}

class AsiaFormData extends DataClass implements Insertable<AsiaFormData> {
  final int id;
  final int patientId;
  final String cellsData;
  final String? voluntaryAnalContraction;
  final String? deepAnalPressure;
  final String? rightLowestNonKeyMuscle;
  final String? leftLowestNonKeyMuscle;
  final String? comments;
  const AsiaFormData(
      {required this.id,
      required this.patientId,
      required this.cellsData,
      this.voluntaryAnalContraction,
      this.deepAnalPressure,
      this.rightLowestNonKeyMuscle,
      this.leftLowestNonKeyMuscle,
      this.comments});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['cells_data'] = Variable<String>(cellsData);
    if (!nullToAbsent || voluntaryAnalContraction != null) {
      map['voluntary_anal_contraction'] =
          Variable<String>(voluntaryAnalContraction);
    }
    if (!nullToAbsent || deepAnalPressure != null) {
      map['deep_anal_pressure'] = Variable<String>(deepAnalPressure);
    }
    if (!nullToAbsent || rightLowestNonKeyMuscle != null) {
      map['right_lowest_non_key_muscle'] =
          Variable<String>(rightLowestNonKeyMuscle);
    }
    if (!nullToAbsent || leftLowestNonKeyMuscle != null) {
      map['left_lowest_non_key_muscle'] =
          Variable<String>(leftLowestNonKeyMuscle);
    }
    if (!nullToAbsent || comments != null) {
      map['comments'] = Variable<String>(comments);
    }
    return map;
  }

  AsiaFormsCompanion toCompanion(bool nullToAbsent) {
    return AsiaFormsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      cellsData: Value(cellsData),
      voluntaryAnalContraction: voluntaryAnalContraction == null && nullToAbsent
          ? const Value.absent()
          : Value(voluntaryAnalContraction),
      deepAnalPressure: deepAnalPressure == null && nullToAbsent
          ? const Value.absent()
          : Value(deepAnalPressure),
      rightLowestNonKeyMuscle: rightLowestNonKeyMuscle == null && nullToAbsent
          ? const Value.absent()
          : Value(rightLowestNonKeyMuscle),
      leftLowestNonKeyMuscle: leftLowestNonKeyMuscle == null && nullToAbsent
          ? const Value.absent()
          : Value(leftLowestNonKeyMuscle),
      comments: comments == null && nullToAbsent
          ? const Value.absent()
          : Value(comments),
    );
  }

  factory AsiaFormData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AsiaFormData(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      cellsData: serializer.fromJson<String>(json['cellsData']),
      voluntaryAnalContraction:
          serializer.fromJson<String?>(json['voluntaryAnalContraction']),
      deepAnalPressure: serializer.fromJson<String?>(json['deepAnalPressure']),
      rightLowestNonKeyMuscle:
          serializer.fromJson<String?>(json['rightLowestNonKeyMuscle']),
      leftLowestNonKeyMuscle:
          serializer.fromJson<String?>(json['leftLowestNonKeyMuscle']),
      comments: serializer.fromJson<String?>(json['comments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'cellsData': serializer.toJson<String>(cellsData),
      'voluntaryAnalContraction':
          serializer.toJson<String?>(voluntaryAnalContraction),
      'deepAnalPressure': serializer.toJson<String?>(deepAnalPressure),
      'rightLowestNonKeyMuscle':
          serializer.toJson<String?>(rightLowestNonKeyMuscle),
      'leftLowestNonKeyMuscle':
          serializer.toJson<String?>(leftLowestNonKeyMuscle),
      'comments': serializer.toJson<String?>(comments),
    };
  }

  AsiaFormData copyWith(
          {int? id,
          int? patientId,
          String? cellsData,
          Value<String?> voluntaryAnalContraction = const Value.absent(),
          Value<String?> deepAnalPressure = const Value.absent(),
          Value<String?> rightLowestNonKeyMuscle = const Value.absent(),
          Value<String?> leftLowestNonKeyMuscle = const Value.absent(),
          Value<String?> comments = const Value.absent()}) =>
      AsiaFormData(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        cellsData: cellsData ?? this.cellsData,
        voluntaryAnalContraction: voluntaryAnalContraction.present
            ? voluntaryAnalContraction.value
            : this.voluntaryAnalContraction,
        deepAnalPressure: deepAnalPressure.present
            ? deepAnalPressure.value
            : this.deepAnalPressure,
        rightLowestNonKeyMuscle: rightLowestNonKeyMuscle.present
            ? rightLowestNonKeyMuscle.value
            : this.rightLowestNonKeyMuscle,
        leftLowestNonKeyMuscle: leftLowestNonKeyMuscle.present
            ? leftLowestNonKeyMuscle.value
            : this.leftLowestNonKeyMuscle,
        comments: comments.present ? comments.value : this.comments,
      );
  @override
  String toString() {
    return (StringBuffer('AsiaFormData(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('cellsData: $cellsData, ')
          ..write('voluntaryAnalContraction: $voluntaryAnalContraction, ')
          ..write('deepAnalPressure: $deepAnalPressure, ')
          ..write('rightLowestNonKeyMuscle: $rightLowestNonKeyMuscle, ')
          ..write('leftLowestNonKeyMuscle: $leftLowestNonKeyMuscle, ')
          ..write('comments: $comments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      cellsData,
      voluntaryAnalContraction,
      deepAnalPressure,
      rightLowestNonKeyMuscle,
      leftLowestNonKeyMuscle,
      comments);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AsiaFormData &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.cellsData == this.cellsData &&
          other.voluntaryAnalContraction == this.voluntaryAnalContraction &&
          other.deepAnalPressure == this.deepAnalPressure &&
          other.rightLowestNonKeyMuscle == this.rightLowestNonKeyMuscle &&
          other.leftLowestNonKeyMuscle == this.leftLowestNonKeyMuscle &&
          other.comments == this.comments);
}

class AsiaFormsCompanion extends UpdateCompanion<AsiaFormData> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<String> cellsData;
  final Value<String?> voluntaryAnalContraction;
  final Value<String?> deepAnalPressure;
  final Value<String?> rightLowestNonKeyMuscle;
  final Value<String?> leftLowestNonKeyMuscle;
  final Value<String?> comments;
  const AsiaFormsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.cellsData = const Value.absent(),
    this.voluntaryAnalContraction = const Value.absent(),
    this.deepAnalPressure = const Value.absent(),
    this.rightLowestNonKeyMuscle = const Value.absent(),
    this.leftLowestNonKeyMuscle = const Value.absent(),
    this.comments = const Value.absent(),
  });
  AsiaFormsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required String cellsData,
    this.voluntaryAnalContraction = const Value.absent(),
    this.deepAnalPressure = const Value.absent(),
    this.rightLowestNonKeyMuscle = const Value.absent(),
    this.leftLowestNonKeyMuscle = const Value.absent(),
    this.comments = const Value.absent(),
  })  : patientId = Value(patientId),
        cellsData = Value(cellsData);
  static Insertable<AsiaFormData> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<String>? cellsData,
    Expression<String>? voluntaryAnalContraction,
    Expression<String>? deepAnalPressure,
    Expression<String>? rightLowestNonKeyMuscle,
    Expression<String>? leftLowestNonKeyMuscle,
    Expression<String>? comments,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (cellsData != null) 'cells_data': cellsData,
      if (voluntaryAnalContraction != null)
        'voluntary_anal_contraction': voluntaryAnalContraction,
      if (deepAnalPressure != null) 'deep_anal_pressure': deepAnalPressure,
      if (rightLowestNonKeyMuscle != null)
        'right_lowest_non_key_muscle': rightLowestNonKeyMuscle,
      if (leftLowestNonKeyMuscle != null)
        'left_lowest_non_key_muscle': leftLowestNonKeyMuscle,
      if (comments != null) 'comments': comments,
    });
  }

  AsiaFormsCompanion copyWith(
      {Value<int>? id,
      Value<int>? patientId,
      Value<String>? cellsData,
      Value<String?>? voluntaryAnalContraction,
      Value<String?>? deepAnalPressure,
      Value<String?>? rightLowestNonKeyMuscle,
      Value<String?>? leftLowestNonKeyMuscle,
      Value<String?>? comments}) {
    return AsiaFormsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      cellsData: cellsData ?? this.cellsData,
      voluntaryAnalContraction:
          voluntaryAnalContraction ?? this.voluntaryAnalContraction,
      deepAnalPressure: deepAnalPressure ?? this.deepAnalPressure,
      rightLowestNonKeyMuscle:
          rightLowestNonKeyMuscle ?? this.rightLowestNonKeyMuscle,
      leftLowestNonKeyMuscle:
          leftLowestNonKeyMuscle ?? this.leftLowestNonKeyMuscle,
      comments: comments ?? this.comments,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (cellsData.present) {
      map['cells_data'] = Variable<String>(cellsData.value);
    }
    if (voluntaryAnalContraction.present) {
      map['voluntary_anal_contraction'] =
          Variable<String>(voluntaryAnalContraction.value);
    }
    if (deepAnalPressure.present) {
      map['deep_anal_pressure'] = Variable<String>(deepAnalPressure.value);
    }
    if (rightLowestNonKeyMuscle.present) {
      map['right_lowest_non_key_muscle'] =
          Variable<String>(rightLowestNonKeyMuscle.value);
    }
    if (leftLowestNonKeyMuscle.present) {
      map['left_lowest_non_key_muscle'] =
          Variable<String>(leftLowestNonKeyMuscle.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AsiaFormsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('cellsData: $cellsData, ')
          ..write('voluntaryAnalContraction: $voluntaryAnalContraction, ')
          ..write('deepAnalPressure: $deepAnalPressure, ')
          ..write('rightLowestNonKeyMuscle: $rightLowestNonKeyMuscle, ')
          ..write('leftLowestNonKeyMuscle: $leftLowestNonKeyMuscle, ')
          ..write('comments: $comments')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $AsiaFormsTable asiaForms = $AsiaFormsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [patients, asiaForms];
}

typedef $$PatientsTableInsertCompanionBuilder = PatientsCompanion Function({
  Value<int> id,
  required String patientName,
  required String examinerName,
  required DateTime examDate,
  Value<DateTime> createdAt,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<int> id,
  Value<String> patientName,
  Value<String> examinerName,
  Value<DateTime> examDate,
  Value<DateTime> createdAt,
});

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableProcessedTableManager,
    $$PatientsTableInsertCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder> {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PatientsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PatientsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PatientsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> patientName = const Value.absent(),
            Value<String> examinerName = const Value.absent(),
            Value<DateTime> examDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PatientsCompanion(
            id: id,
            patientName: patientName,
            examinerName: examinerName,
            examDate: examDate,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String patientName,
            required String examinerName,
            required DateTime examDate,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            id: id,
            patientName: patientName,
            examinerName: examinerName,
            examDate: examDate,
            createdAt: createdAt,
          ),
        ));
}

class $$PatientsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableProcessedTableManager,
    $$PatientsTableInsertCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder> {
  $$PatientsTableProcessedTableManager(super.$state);
}

class $$PatientsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get patientName => $state.composableBuilder(
      column: $state.table.patientName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get examinerName => $state.composableBuilder(
      column: $state.table.examinerName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get examDate => $state.composableBuilder(
      column: $state.table.examDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter asiaFormsRefs(
      ComposableFilter Function($$AsiaFormsTableFilterComposer f) f) {
    final $$AsiaFormsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.asiaForms,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder, parentComposers) =>
            $$AsiaFormsTableFilterComposer(ComposerState(
                $state.db, $state.db.asiaForms, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get patientName => $state.composableBuilder(
      column: $state.table.patientName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get examinerName => $state.composableBuilder(
      column: $state.table.examinerName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get examDate => $state.composableBuilder(
      column: $state.table.examDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AsiaFormsTableInsertCompanionBuilder = AsiaFormsCompanion Function({
  Value<int> id,
  required int patientId,
  required String cellsData,
  Value<String?> voluntaryAnalContraction,
  Value<String?> deepAnalPressure,
  Value<String?> rightLowestNonKeyMuscle,
  Value<String?> leftLowestNonKeyMuscle,
  Value<String?> comments,
});
typedef $$AsiaFormsTableUpdateCompanionBuilder = AsiaFormsCompanion Function({
  Value<int> id,
  Value<int> patientId,
  Value<String> cellsData,
  Value<String?> voluntaryAnalContraction,
  Value<String?> deepAnalPressure,
  Value<String?> rightLowestNonKeyMuscle,
  Value<String?> leftLowestNonKeyMuscle,
  Value<String?> comments,
});

class $$AsiaFormsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AsiaFormsTable,
    AsiaFormData,
    $$AsiaFormsTableFilterComposer,
    $$AsiaFormsTableOrderingComposer,
    $$AsiaFormsTableProcessedTableManager,
    $$AsiaFormsTableInsertCompanionBuilder,
    $$AsiaFormsTableUpdateCompanionBuilder> {
  $$AsiaFormsTableTableManager(_$AppDatabase db, $AsiaFormsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AsiaFormsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AsiaFormsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$AsiaFormsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<String> cellsData = const Value.absent(),
            Value<String?> voluntaryAnalContraction = const Value.absent(),
            Value<String?> deepAnalPressure = const Value.absent(),
            Value<String?> rightLowestNonKeyMuscle = const Value.absent(),
            Value<String?> leftLowestNonKeyMuscle = const Value.absent(),
            Value<String?> comments = const Value.absent(),
          }) =>
              AsiaFormsCompanion(
            id: id,
            patientId: patientId,
            cellsData: cellsData,
            voluntaryAnalContraction: voluntaryAnalContraction,
            deepAnalPressure: deepAnalPressure,
            rightLowestNonKeyMuscle: rightLowestNonKeyMuscle,
            leftLowestNonKeyMuscle: leftLowestNonKeyMuscle,
            comments: comments,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int patientId,
            required String cellsData,
            Value<String?> voluntaryAnalContraction = const Value.absent(),
            Value<String?> deepAnalPressure = const Value.absent(),
            Value<String?> rightLowestNonKeyMuscle = const Value.absent(),
            Value<String?> leftLowestNonKeyMuscle = const Value.absent(),
            Value<String?> comments = const Value.absent(),
          }) =>
              AsiaFormsCompanion.insert(
            id: id,
            patientId: patientId,
            cellsData: cellsData,
            voluntaryAnalContraction: voluntaryAnalContraction,
            deepAnalPressure: deepAnalPressure,
            rightLowestNonKeyMuscle: rightLowestNonKeyMuscle,
            leftLowestNonKeyMuscle: leftLowestNonKeyMuscle,
            comments: comments,
          ),
        ));
}

class $$AsiaFormsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $AsiaFormsTable,
    AsiaFormData,
    $$AsiaFormsTableFilterComposer,
    $$AsiaFormsTableOrderingComposer,
    $$AsiaFormsTableProcessedTableManager,
    $$AsiaFormsTableInsertCompanionBuilder,
    $$AsiaFormsTableUpdateCompanionBuilder> {
  $$AsiaFormsTableProcessedTableManager(super.$state);
}

class $$AsiaFormsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AsiaFormsTable> {
  $$AsiaFormsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cellsData => $state.composableBuilder(
      column: $state.table.cellsData,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get voluntaryAnalContraction =>
      $state.composableBuilder(
          column: $state.table.voluntaryAnalContraction,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deepAnalPressure => $state.composableBuilder(
      column: $state.table.deepAnalPressure,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rightLowestNonKeyMuscle => $state.composableBuilder(
      column: $state.table.rightLowestNonKeyMuscle,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get leftLowestNonKeyMuscle => $state.composableBuilder(
      column: $state.table.leftLowestNonKeyMuscle,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get comments => $state.composableBuilder(
      column: $state.table.comments,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableFilterComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$AsiaFormsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AsiaFormsTable> {
  $$AsiaFormsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cellsData => $state.composableBuilder(
      column: $state.table.cellsData,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get voluntaryAnalContraction =>
      $state.composableBuilder(
          column: $state.table.voluntaryAnalContraction,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deepAnalPressure => $state.composableBuilder(
      column: $state.table.deepAnalPressure,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rightLowestNonKeyMuscle =>
      $state.composableBuilder(
          column: $state.table.rightLowestNonKeyMuscle,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get leftLowestNonKeyMuscle =>
      $state.composableBuilder(
          column: $state.table.leftLowestNonKeyMuscle,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get comments => $state.composableBuilder(
      column: $state.table.comments,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableOrderingComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$AsiaFormsTableTableManager get asiaForms =>
      $$AsiaFormsTableTableManager(_db, _db.asiaForms);
}
