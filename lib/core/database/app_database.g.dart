// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MonthlyGoalsTable extends MonthlyGoals
    with TableInfo<$MonthlyGoalsTable, MonthlyGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    year,
    month,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MonthlyGoalsTable createAlias(String alias) {
    return $MonthlyGoalsTable(attachedDatabase, alias);
  }
}

class MonthlyGoalRow extends DataClass implements Insertable<MonthlyGoalRow> {
  final String id;
  final String title;
  final String? description;
  final int year;
  final int month;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MonthlyGoalRow({
    required this.id,
    required this.title,
    this.description,
    required this.year,
    required this.month,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MonthlyGoalsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyGoalsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      year: Value(year),
      month: Value(month),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MonthlyGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyGoalRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MonthlyGoalRow copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    int? year,
    int? month,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MonthlyGoalRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    year: year ?? this.year,
    month: month ?? this.month,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MonthlyGoalRow copyWithCompanion(MonthlyGoalsCompanion data) {
    return MonthlyGoalRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyGoalRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    year,
    month,
    isCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyGoalRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.year == this.year &&
          other.month == this.month &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MonthlyGoalsCompanion extends UpdateCompanion<MonthlyGoalRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> year;
  final Value<int> month;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MonthlyGoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthlyGoalsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required int year,
    required int month,
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       year = Value(year),
       month = Value(month),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MonthlyGoalRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? year,
    Expression<int>? month,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthlyGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? year,
    Value<int>? month,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MonthlyGoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      year: year ?? this.year,
      month: month ?? this.month,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyGoalsTable extends WeeklyGoals
    with TableInfo<$WeeklyGoalsTable, WeeklyGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyGoalIdMeta = const VerificationMeta(
    'monthlyGoalId',
  );
  @override
  late final GeneratedColumn<String> monthlyGoalId = GeneratedColumn<String>(
    'monthly_goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES monthly_goals (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<int> weekStart = GeneratedColumn<int>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekEndMeta = const VerificationMeta(
    'weekEnd',
  );
  @override
  late final GeneratedColumn<int> weekEnd = GeneratedColumn<int>(
    'week_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    monthlyGoalId,
    title,
    description,
    weekStart,
    weekEnd,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('monthly_goal_id')) {
      context.handle(
        _monthlyGoalIdMeta,
        monthlyGoalId.isAcceptableOrUnknown(
          data['monthly_goal_id']!,
          _monthlyGoalIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('week_end')) {
      context.handle(
        _weekEndMeta,
        weekEnd.isAcceptableOrUnknown(data['week_end']!, _weekEndMeta),
      );
    } else if (isInserting) {
      context.missing(_weekEndMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      monthlyGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}monthly_goal_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_start'],
      )!,
      weekEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_end'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WeeklyGoalsTable createAlias(String alias) {
    return $WeeklyGoalsTable(attachedDatabase, alias);
  }
}

class WeeklyGoalRow extends DataClass implements Insertable<WeeklyGoalRow> {
  final String id;
  final String? monthlyGoalId;
  final String title;
  final String? description;
  final int weekStart;
  final int weekEnd;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WeeklyGoalRow({
    required this.id,
    this.monthlyGoalId,
    required this.title,
    this.description,
    required this.weekStart,
    required this.weekEnd,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || monthlyGoalId != null) {
      map['monthly_goal_id'] = Variable<String>(monthlyGoalId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['week_start'] = Variable<int>(weekStart);
    map['week_end'] = Variable<int>(weekEnd);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WeeklyGoalsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyGoalsCompanion(
      id: Value(id),
      monthlyGoalId: monthlyGoalId == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyGoalId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      weekStart: Value(weekStart),
      weekEnd: Value(weekEnd),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WeeklyGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyGoalRow(
      id: serializer.fromJson<String>(json['id']),
      monthlyGoalId: serializer.fromJson<String?>(json['monthlyGoalId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      weekStart: serializer.fromJson<int>(json['weekStart']),
      weekEnd: serializer.fromJson<int>(json['weekEnd']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'monthlyGoalId': serializer.toJson<String?>(monthlyGoalId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'weekStart': serializer.toJson<int>(weekStart),
      'weekEnd': serializer.toJson<int>(weekEnd),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WeeklyGoalRow copyWith({
    String? id,
    Value<String?> monthlyGoalId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    int? weekStart,
    int? weekEnd,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WeeklyGoalRow(
    id: id ?? this.id,
    monthlyGoalId: monthlyGoalId.present
        ? monthlyGoalId.value
        : this.monthlyGoalId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    weekStart: weekStart ?? this.weekStart,
    weekEnd: weekEnd ?? this.weekEnd,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WeeklyGoalRow copyWithCompanion(WeeklyGoalsCompanion data) {
    return WeeklyGoalRow(
      id: data.id.present ? data.id.value : this.id,
      monthlyGoalId: data.monthlyGoalId.present
          ? data.monthlyGoalId.value
          : this.monthlyGoalId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      weekEnd: data.weekEnd.present ? data.weekEnd.value : this.weekEnd,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyGoalRow(')
          ..write('id: $id, ')
          ..write('monthlyGoalId: $monthlyGoalId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('weekStart: $weekStart, ')
          ..write('weekEnd: $weekEnd, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    monthlyGoalId,
    title,
    description,
    weekStart,
    weekEnd,
    isCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyGoalRow &&
          other.id == this.id &&
          other.monthlyGoalId == this.monthlyGoalId &&
          other.title == this.title &&
          other.description == this.description &&
          other.weekStart == this.weekStart &&
          other.weekEnd == this.weekEnd &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WeeklyGoalsCompanion extends UpdateCompanion<WeeklyGoalRow> {
  final Value<String> id;
  final Value<String?> monthlyGoalId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> weekStart;
  final Value<int> weekEnd;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeeklyGoalsCompanion({
    this.id = const Value.absent(),
    this.monthlyGoalId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.weekEnd = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyGoalsCompanion.insert({
    required String id,
    this.monthlyGoalId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required int weekStart,
    required int weekEnd,
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       weekStart = Value(weekStart),
       weekEnd = Value(weekEnd),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WeeklyGoalRow> custom({
    Expression<String>? id,
    Expression<String>? monthlyGoalId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? weekStart,
    Expression<int>? weekEnd,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthlyGoalId != null) 'monthly_goal_id': monthlyGoalId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (weekStart != null) 'week_start': weekStart,
      if (weekEnd != null) 'week_end': weekEnd,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyGoalsCompanion copyWith({
    Value<String>? id,
    Value<String?>? monthlyGoalId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? weekStart,
    Value<int>? weekEnd,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WeeklyGoalsCompanion(
      id: id ?? this.id,
      monthlyGoalId: monthlyGoalId ?? this.monthlyGoalId,
      title: title ?? this.title,
      description: description ?? this.description,
      weekStart: weekStart ?? this.weekStart,
      weekEnd: weekEnd ?? this.weekEnd,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (monthlyGoalId.present) {
      map['monthly_goal_id'] = Variable<String>(monthlyGoalId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<int>(weekStart.value);
    }
    if (weekEnd.present) {
      map['week_end'] = Variable<int>(weekEnd.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('monthlyGoalId: $monthlyGoalId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('weekStart: $weekStart, ')
          ..write('weekEnd: $weekEnd, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weeklyGoalIdMeta = const VerificationMeta(
    'weeklyGoalId',
  );
  @override
  late final GeneratedColumn<String> weeklyGoalId = GeneratedColumn<String>(
    'weekly_goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES weekly_goals (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<int> scheduledDate = GeneratedColumn<int>(
    'scheduled_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weeklyGoalId,
    title,
    description,
    scheduledDate,
    dueAt,
    priority,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weekly_goal_id')) {
      context.handle(
        _weeklyGoalIdMeta,
        weeklyGoalId.isAcceptableOrUnknown(
          data['weekly_goal_id']!,
          _weeklyGoalIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      weeklyGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekly_goal_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_date'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String? weeklyGoalId;
  final String title;
  final String? description;
  final int scheduledDate;
  final DateTime? dueAt;
  final String priority;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskRow({
    required this.id,
    this.weeklyGoalId,
    required this.title,
    this.description,
    required this.scheduledDate,
    this.dueAt,
    required this.priority,
    required this.isCompleted,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || weeklyGoalId != null) {
      map['weekly_goal_id'] = Variable<String>(weeklyGoalId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['scheduled_date'] = Variable<int>(scheduledDate);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    map['priority'] = Variable<String>(priority);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      weeklyGoalId: weeklyGoalId == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyGoalId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      scheduledDate: Value(scheduledDate),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      weeklyGoalId: serializer.fromJson<String?>(json['weeklyGoalId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      scheduledDate: serializer.fromJson<int>(json['scheduledDate']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      priority: serializer.fromJson<String>(json['priority']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weeklyGoalId': serializer.toJson<String?>(weeklyGoalId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'scheduledDate': serializer.toJson<int>(scheduledDate),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'priority': serializer.toJson<String>(priority),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    Value<String?> weeklyGoalId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    int? scheduledDate,
    Value<DateTime?> dueAt = const Value.absent(),
    String? priority,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskRow(
    id: id ?? this.id,
    weeklyGoalId: weeklyGoalId.present ? weeklyGoalId.value : this.weeklyGoalId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    priority: priority ?? this.priority,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      weeklyGoalId: data.weeklyGoalId.present
          ? data.weeklyGoalId.value
          : this.weeklyGoalId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      priority: data.priority.present ? data.priority.value : this.priority,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('weeklyGoalId: $weeklyGoalId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('dueAt: $dueAt, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weeklyGoalId,
    title,
    description,
    scheduledDate,
    dueAt,
    priority,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.weeklyGoalId == this.weeklyGoalId &&
          other.title == this.title &&
          other.description == this.description &&
          other.scheduledDate == this.scheduledDate &&
          other.dueAt == this.dueAt &&
          other.priority == this.priority &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String?> weeklyGoalId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> scheduledDate;
  final Value<DateTime?> dueAt;
  final Value<String> priority;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.weeklyGoalId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.weeklyGoalId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required int scheduledDate,
    this.dueAt = const Value.absent(),
    required String priority,
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       scheduledDate = Value(scheduledDate),
       priority = Value(priority),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? weeklyGoalId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? scheduledDate,
    Expression<DateTime>? dueAt,
    Expression<String>? priority,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weeklyGoalId != null) 'weekly_goal_id': weeklyGoalId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (dueAt != null) 'due_at': dueAt,
      if (priority != null) 'priority': priority,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String?>? weeklyGoalId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? scheduledDate,
    Value<DateTime?>? dueAt,
    Value<String>? priority,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      weeklyGoalId: weeklyGoalId ?? this.weeklyGoalId,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      dueAt: dueAt ?? this.dueAt,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (weeklyGoalId.present) {
      map['weekly_goal_id'] = Variable<String>(weeklyGoalId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<int>(scheduledDate.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('weeklyGoalId: $weeklyGoalId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('dueAt: $dueAt, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceRulesTable extends RecurrenceRules
    with TableInfo<$RecurrenceRulesTable, RecurrenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthDayMeta = const VerificationMeta(
    'monthDay',
  );
  @override
  late final GeneratedColumn<int> monthDay = GeneratedColumn<int>(
    'month_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDayMeta = const VerificationMeta(
    'startDay',
  );
  @override
  late final GeneratedColumn<int> startDay = GeneratedColumn<int>(
    'start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDayMeta = const VerificationMeta('endDay');
  @override
  late final GeneratedColumn<int> endDay = GeneratedColumn<int>(
    'end_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurrenceCountMeta = const VerificationMeta(
    'occurrenceCount',
  );
  @override
  late final GeneratedColumn<int> occurrenceCount = GeneratedColumn<int>(
    'occurrence_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    frequency,
    interval,
    weekdays,
    monthDay,
    startDay,
    endDay,
    occurrenceCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurrenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    } else if (isInserting) {
      context.missing(_intervalMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('month_day')) {
      context.handle(
        _monthDayMeta,
        monthDay.isAcceptableOrUnknown(data['month_day']!, _monthDayMeta),
      );
    } else if (isInserting) {
      context.missing(_monthDayMeta);
    }
    if (data.containsKey('start_day')) {
      context.handle(
        _startDayMeta,
        startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta),
      );
    } else if (isInserting) {
      context.missing(_startDayMeta);
    }
    if (data.containsKey('end_day')) {
      context.handle(
        _endDayMeta,
        endDay.isAcceptableOrUnknown(data['end_day']!, _endDayMeta),
      );
    }
    if (data.containsKey('occurrence_count')) {
      context.handle(
        _occurrenceCountMeta,
        occurrenceCount.isAcceptableOrUnknown(
          data['occurrence_count']!,
          _occurrenceCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  RecurrenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceRow(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      )!,
      monthDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month_day'],
      )!,
      startDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_day'],
      )!,
      endDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_day'],
      ),
      occurrenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_count'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurrenceRulesTable createAlias(String alias) {
    return $RecurrenceRulesTable(attachedDatabase, alias);
  }
}

class RecurrenceRow extends DataClass implements Insertable<RecurrenceRow> {
  final String taskId;
  final String frequency;
  final int interval;
  final int weekdays;
  final int monthDay;
  final int startDay;
  final int? endDay;
  final int? occurrenceCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurrenceRow({
    required this.taskId,
    required this.frequency,
    required this.interval,
    required this.weekdays,
    required this.monthDay,
    required this.startDay,
    this.endDay,
    this.occurrenceCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['frequency'] = Variable<String>(frequency);
    map['interval'] = Variable<int>(interval);
    map['weekdays'] = Variable<int>(weekdays);
    map['month_day'] = Variable<int>(monthDay);
    map['start_day'] = Variable<int>(startDay);
    if (!nullToAbsent || endDay != null) {
      map['end_day'] = Variable<int>(endDay);
    }
    if (!nullToAbsent || occurrenceCount != null) {
      map['occurrence_count'] = Variable<int>(occurrenceCount);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurrenceRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceRulesCompanion(
      taskId: Value(taskId),
      frequency: Value(frequency),
      interval: Value(interval),
      weekdays: Value(weekdays),
      monthDay: Value(monthDay),
      startDay: Value(startDay),
      endDay: endDay == null && nullToAbsent
          ? const Value.absent()
          : Value(endDay),
      occurrenceCount: occurrenceCount == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurrenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceRow(
      taskId: serializer.fromJson<String>(json['taskId']),
      frequency: serializer.fromJson<String>(json['frequency']),
      interval: serializer.fromJson<int>(json['interval']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      monthDay: serializer.fromJson<int>(json['monthDay']),
      startDay: serializer.fromJson<int>(json['startDay']),
      endDay: serializer.fromJson<int?>(json['endDay']),
      occurrenceCount: serializer.fromJson<int?>(json['occurrenceCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'frequency': serializer.toJson<String>(frequency),
      'interval': serializer.toJson<int>(interval),
      'weekdays': serializer.toJson<int>(weekdays),
      'monthDay': serializer.toJson<int>(monthDay),
      'startDay': serializer.toJson<int>(startDay),
      'endDay': serializer.toJson<int?>(endDay),
      'occurrenceCount': serializer.toJson<int?>(occurrenceCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurrenceRow copyWith({
    String? taskId,
    String? frequency,
    int? interval,
    int? weekdays,
    int? monthDay,
    int? startDay,
    Value<int?> endDay = const Value.absent(),
    Value<int?> occurrenceCount = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurrenceRow(
    taskId: taskId ?? this.taskId,
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    weekdays: weekdays ?? this.weekdays,
    monthDay: monthDay ?? this.monthDay,
    startDay: startDay ?? this.startDay,
    endDay: endDay.present ? endDay.value : this.endDay,
    occurrenceCount: occurrenceCount.present
        ? occurrenceCount.value
        : this.occurrenceCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurrenceRow copyWithCompanion(RecurrenceRulesCompanion data) {
    return RecurrenceRow(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      interval: data.interval.present ? data.interval.value : this.interval,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      monthDay: data.monthDay.present ? data.monthDay.value : this.monthDay,
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      endDay: data.endDay.present ? data.endDay.value : this.endDay,
      occurrenceCount: data.occurrenceCount.present
          ? data.occurrenceCount.value
          : this.occurrenceCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRow(')
          ..write('taskId: $taskId, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('weekdays: $weekdays, ')
          ..write('monthDay: $monthDay, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    frequency,
    interval,
    weekdays,
    monthDay,
    startDay,
    endDay,
    occurrenceCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceRow &&
          other.taskId == this.taskId &&
          other.frequency == this.frequency &&
          other.interval == this.interval &&
          other.weekdays == this.weekdays &&
          other.monthDay == this.monthDay &&
          other.startDay == this.startDay &&
          other.endDay == this.endDay &&
          other.occurrenceCount == this.occurrenceCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurrenceRulesCompanion extends UpdateCompanion<RecurrenceRow> {
  final Value<String> taskId;
  final Value<String> frequency;
  final Value<int> interval;
  final Value<int> weekdays;
  final Value<int> monthDay;
  final Value<int> startDay;
  final Value<int?> endDay;
  final Value<int?> occurrenceCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecurrenceRulesCompanion({
    this.taskId = const Value.absent(),
    this.frequency = const Value.absent(),
    this.interval = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.monthDay = const Value.absent(),
    this.startDay = const Value.absent(),
    this.endDay = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrenceRulesCompanion.insert({
    required String taskId,
    required String frequency,
    required int interval,
    required int weekdays,
    required int monthDay,
    required int startDay,
    this.endDay = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       frequency = Value(frequency),
       interval = Value(interval),
       weekdays = Value(weekdays),
       monthDay = Value(monthDay),
       startDay = Value(startDay),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecurrenceRow> custom({
    Expression<String>? taskId,
    Expression<String>? frequency,
    Expression<int>? interval,
    Expression<int>? weekdays,
    Expression<int>? monthDay,
    Expression<int>? startDay,
    Expression<int>? endDay,
    Expression<int>? occurrenceCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (frequency != null) 'frequency': frequency,
      if (interval != null) 'interval': interval,
      if (weekdays != null) 'weekdays': weekdays,
      if (monthDay != null) 'month_day': monthDay,
      if (startDay != null) 'start_day': startDay,
      if (endDay != null) 'end_day': endDay,
      if (occurrenceCount != null) 'occurrence_count': occurrenceCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrenceRulesCompanion copyWith({
    Value<String>? taskId,
    Value<String>? frequency,
    Value<int>? interval,
    Value<int>? weekdays,
    Value<int>? monthDay,
    Value<int>? startDay,
    Value<int?>? endDay,
    Value<int?>? occurrenceCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurrenceRulesCompanion(
      taskId: taskId ?? this.taskId,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      weekdays: weekdays ?? this.weekdays,
      monthDay: monthDay ?? this.monthDay,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (monthDay.present) {
      map['month_day'] = Variable<int>(monthDay.value);
    }
    if (startDay.present) {
      map['start_day'] = Variable<int>(startDay.value);
    }
    if (endDay.present) {
      map['end_day'] = Variable<int>(endDay.value);
    }
    if (occurrenceCount.present) {
      map['occurrence_count'] = Variable<int>(occurrenceCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRulesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('weekdays: $weekdays, ')
          ..write('monthDay: $monthDay, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OccurrenceStatesTable extends OccurrenceStates
    with TableInfo<$OccurrenceStatesTable, OccurrenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OccurrenceStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurrence_rules (task_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _occurrenceDayMeta = const VerificationMeta(
    'occurrenceDay',
  );
  @override
  late final GeneratedColumn<int> occurrenceDay = GeneratedColumn<int>(
    'occurrence_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDayMeta = const VerificationMeta(
    'scheduledDay',
  );
  @override
  late final GeneratedColumn<int> scheduledDay = GeneratedColumn<int>(
    'scheduled_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overrideDataMeta = const VerificationMeta(
    'overrideData',
  );
  @override
  late final GeneratedColumn<String> overrideData = GeneratedColumn<String>(
    'override_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    occurrenceDay,
    scheduledDay,
    overrideData,
    skipped,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'occurrence_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<OccurrenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('occurrence_day')) {
      context.handle(
        _occurrenceDayMeta,
        occurrenceDay.isAcceptableOrUnknown(
          data['occurrence_day']!,
          _occurrenceDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceDayMeta);
    }
    if (data.containsKey('scheduled_day')) {
      context.handle(
        _scheduledDayMeta,
        scheduledDay.isAcceptableOrUnknown(
          data['scheduled_day']!,
          _scheduledDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDayMeta);
    }
    if (data.containsKey('override_data')) {
      context.handle(
        _overrideDataMeta,
        overrideData.isAcceptableOrUnknown(
          data['override_data']!,
          _overrideDataMeta,
        ),
      );
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, occurrenceDay};
  @override
  OccurrenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OccurrenceRow(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      occurrenceDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_day'],
      )!,
      scheduledDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_day'],
      )!,
      overrideData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}override_data'],
      ),
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OccurrenceStatesTable createAlias(String alias) {
    return $OccurrenceStatesTable(attachedDatabase, alias);
  }
}

class OccurrenceRow extends DataClass implements Insertable<OccurrenceRow> {
  final String taskId;
  final int occurrenceDay;
  final int scheduledDay;
  final String? overrideData;
  final bool skipped;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const OccurrenceRow({
    required this.taskId,
    required this.occurrenceDay,
    required this.scheduledDay,
    this.overrideData,
    required this.skipped,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['occurrence_day'] = Variable<int>(occurrenceDay);
    map['scheduled_day'] = Variable<int>(scheduledDay);
    if (!nullToAbsent || overrideData != null) {
      map['override_data'] = Variable<String>(overrideData);
    }
    map['skipped'] = Variable<bool>(skipped);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OccurrenceStatesCompanion toCompanion(bool nullToAbsent) {
    return OccurrenceStatesCompanion(
      taskId: Value(taskId),
      occurrenceDay: Value(occurrenceDay),
      scheduledDay: Value(scheduledDay),
      overrideData: overrideData == null && nullToAbsent
          ? const Value.absent()
          : Value(overrideData),
      skipped: Value(skipped),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OccurrenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OccurrenceRow(
      taskId: serializer.fromJson<String>(json['taskId']),
      occurrenceDay: serializer.fromJson<int>(json['occurrenceDay']),
      scheduledDay: serializer.fromJson<int>(json['scheduledDay']),
      overrideData: serializer.fromJson<String?>(json['overrideData']),
      skipped: serializer.fromJson<bool>(json['skipped']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'occurrenceDay': serializer.toJson<int>(occurrenceDay),
      'scheduledDay': serializer.toJson<int>(scheduledDay),
      'overrideData': serializer.toJson<String?>(overrideData),
      'skipped': serializer.toJson<bool>(skipped),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OccurrenceRow copyWith({
    String? taskId,
    int? occurrenceDay,
    int? scheduledDay,
    Value<String?> overrideData = const Value.absent(),
    bool? skipped,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => OccurrenceRow(
    taskId: taskId ?? this.taskId,
    occurrenceDay: occurrenceDay ?? this.occurrenceDay,
    scheduledDay: scheduledDay ?? this.scheduledDay,
    overrideData: overrideData.present ? overrideData.value : this.overrideData,
    skipped: skipped ?? this.skipped,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OccurrenceRow copyWithCompanion(OccurrenceStatesCompanion data) {
    return OccurrenceRow(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      occurrenceDay: data.occurrenceDay.present
          ? data.occurrenceDay.value
          : this.occurrenceDay,
      scheduledDay: data.scheduledDay.present
          ? data.scheduledDay.value
          : this.scheduledDay,
      overrideData: data.overrideData.present
          ? data.overrideData.value
          : this.overrideData,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OccurrenceRow(')
          ..write('taskId: $taskId, ')
          ..write('occurrenceDay: $occurrenceDay, ')
          ..write('scheduledDay: $scheduledDay, ')
          ..write('overrideData: $overrideData, ')
          ..write('skipped: $skipped, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    occurrenceDay,
    scheduledDay,
    overrideData,
    skipped,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OccurrenceRow &&
          other.taskId == this.taskId &&
          other.occurrenceDay == this.occurrenceDay &&
          other.scheduledDay == this.scheduledDay &&
          other.overrideData == this.overrideData &&
          other.skipped == this.skipped &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class OccurrenceStatesCompanion extends UpdateCompanion<OccurrenceRow> {
  final Value<String> taskId;
  final Value<int> occurrenceDay;
  final Value<int> scheduledDay;
  final Value<String?> overrideData;
  final Value<bool> skipped;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OccurrenceStatesCompanion({
    this.taskId = const Value.absent(),
    this.occurrenceDay = const Value.absent(),
    this.scheduledDay = const Value.absent(),
    this.overrideData = const Value.absent(),
    this.skipped = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OccurrenceStatesCompanion.insert({
    required String taskId,
    required int occurrenceDay,
    required int scheduledDay,
    this.overrideData = const Value.absent(),
    this.skipped = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       occurrenceDay = Value(occurrenceDay),
       scheduledDay = Value(scheduledDay),
       updatedAt = Value(updatedAt);
  static Insertable<OccurrenceRow> custom({
    Expression<String>? taskId,
    Expression<int>? occurrenceDay,
    Expression<int>? scheduledDay,
    Expression<String>? overrideData,
    Expression<bool>? skipped,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (occurrenceDay != null) 'occurrence_day': occurrenceDay,
      if (scheduledDay != null) 'scheduled_day': scheduledDay,
      if (overrideData != null) 'override_data': overrideData,
      if (skipped != null) 'skipped': skipped,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OccurrenceStatesCompanion copyWith({
    Value<String>? taskId,
    Value<int>? occurrenceDay,
    Value<int>? scheduledDay,
    Value<String?>? overrideData,
    Value<bool>? skipped,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OccurrenceStatesCompanion(
      taskId: taskId ?? this.taskId,
      occurrenceDay: occurrenceDay ?? this.occurrenceDay,
      scheduledDay: scheduledDay ?? this.scheduledDay,
      overrideData: overrideData ?? this.overrideData,
      skipped: skipped ?? this.skipped,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (occurrenceDay.present) {
      map['occurrence_day'] = Variable<int>(occurrenceDay.value);
    }
    if (scheduledDay.present) {
      map['scheduled_day'] = Variable<int>(scheduledDay.value);
    }
    if (overrideData.present) {
      map['override_data'] = Variable<String>(overrideData.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OccurrenceStatesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('occurrenceDay: $occurrenceDay, ')
          ..write('scheduledDay: $scheduledDay, ')
          ..write('overrideData: $overrideData, ')
          ..write('skipped: $skipped, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderRulesTable extends ReminderRules
    with TableInfo<$ReminderRulesTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _occurrenceDayMeta = const VerificationMeta(
    'occurrenceDay',
  );
  @override
  late final GeneratedColumn<int> occurrenceDay = GeneratedColumn<int>(
    'occurrence_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minutesBeforeMeta = const VerificationMeta(
    'minutesBefore',
  );
  @override
  late final GeneratedColumn<int> minutesBefore = GeneratedColumn<int>(
    'minutes_before',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _absoluteTimeMeta = const VerificationMeta(
    'absoluteTime',
  );
  @override
  late final GeneratedColumn<DateTime> absoluteTime = GeneratedColumn<DateTime>(
    'absolute_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    occurrenceDay,
    minutesBefore,
    absoluteTime,
    enabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('occurrence_day')) {
      context.handle(
        _occurrenceDayMeta,
        occurrenceDay.isAcceptableOrUnknown(
          data['occurrence_day']!,
          _occurrenceDayMeta,
        ),
      );
    }
    if (data.containsKey('minutes_before')) {
      context.handle(
        _minutesBeforeMeta,
        minutesBefore.isAcceptableOrUnknown(
          data['minutes_before']!,
          _minutesBeforeMeta,
        ),
      );
    }
    if (data.containsKey('absolute_time')) {
      context.handle(
        _absoluteTimeMeta,
        absoluteTime.isAcceptableOrUnknown(
          data['absolute_time']!,
          _absoluteTimeMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      occurrenceDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_day'],
      ),
      minutesBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_before'],
      ),
      absoluteTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}absolute_time'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReminderRulesTable createAlias(String alias) {
    return $ReminderRulesTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final String id;
  final String taskId;
  final int? occurrenceDay;
  final int? minutesBefore;
  final DateTime? absoluteTime;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReminderRow({
    required this.id,
    required this.taskId,
    this.occurrenceDay,
    this.minutesBefore,
    this.absoluteTime,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    if (!nullToAbsent || occurrenceDay != null) {
      map['occurrence_day'] = Variable<int>(occurrenceDay);
    }
    if (!nullToAbsent || minutesBefore != null) {
      map['minutes_before'] = Variable<int>(minutesBefore);
    }
    if (!nullToAbsent || absoluteTime != null) {
      map['absolute_time'] = Variable<DateTime>(absoluteTime);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReminderRulesCompanion toCompanion(bool nullToAbsent) {
    return ReminderRulesCompanion(
      id: Value(id),
      taskId: Value(taskId),
      occurrenceDay: occurrenceDay == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceDay),
      minutesBefore: minutesBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(minutesBefore),
      absoluteTime: absoluteTime == null && nullToAbsent
          ? const Value.absent()
          : Value(absoluteTime),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      occurrenceDay: serializer.fromJson<int?>(json['occurrenceDay']),
      minutesBefore: serializer.fromJson<int?>(json['minutesBefore']),
      absoluteTime: serializer.fromJson<DateTime?>(json['absoluteTime']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'occurrenceDay': serializer.toJson<int?>(occurrenceDay),
      'minutesBefore': serializer.toJson<int?>(minutesBefore),
      'absoluteTime': serializer.toJson<DateTime?>(absoluteTime),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderRow copyWith({
    String? id,
    String? taskId,
    Value<int?> occurrenceDay = const Value.absent(),
    Value<int?> minutesBefore = const Value.absent(),
    Value<DateTime?> absoluteTime = const Value.absent(),
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ReminderRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    occurrenceDay: occurrenceDay.present
        ? occurrenceDay.value
        : this.occurrenceDay,
    minutesBefore: minutesBefore.present
        ? minutesBefore.value
        : this.minutesBefore,
    absoluteTime: absoluteTime.present ? absoluteTime.value : this.absoluteTime,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderRow copyWithCompanion(ReminderRulesCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      occurrenceDay: data.occurrenceDay.present
          ? data.occurrenceDay.value
          : this.occurrenceDay,
      minutesBefore: data.minutesBefore.present
          ? data.minutesBefore.value
          : this.minutesBefore,
      absoluteTime: data.absoluteTime.present
          ? data.absoluteTime.value
          : this.absoluteTime,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('occurrenceDay: $occurrenceDay, ')
          ..write('minutesBefore: $minutesBefore, ')
          ..write('absoluteTime: $absoluteTime, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    occurrenceDay,
    minutesBefore,
    absoluteTime,
    enabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.occurrenceDay == this.occurrenceDay &&
          other.minutesBefore == this.minutesBefore &&
          other.absoluteTime == this.absoluteTime &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReminderRulesCompanion extends UpdateCompanion<ReminderRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int?> occurrenceDay;
  final Value<int?> minutesBefore;
  final Value<DateTime?> absoluteTime;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReminderRulesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.occurrenceDay = const Value.absent(),
    this.minutesBefore = const Value.absent(),
    this.absoluteTime = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderRulesCompanion.insert({
    required String id,
    required String taskId,
    this.occurrenceDay = const Value.absent(),
    this.minutesBefore = const Value.absent(),
    this.absoluteTime = const Value.absent(),
    required bool enabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       enabled = Value(enabled),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? occurrenceDay,
    Expression<int>? minutesBefore,
    Expression<DateTime>? absoluteTime,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (occurrenceDay != null) 'occurrence_day': occurrenceDay,
      if (minutesBefore != null) 'minutes_before': minutesBefore,
      if (absoluteTime != null) 'absolute_time': absoluteTime,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<int?>? occurrenceDay,
    Value<int?>? minutesBefore,
    Value<DateTime?>? absoluteTime,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReminderRulesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      occurrenceDay: occurrenceDay ?? this.occurrenceDay,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      absoluteTime: absoluteTime ?? this.absoluteTime,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (occurrenceDay.present) {
      map['occurrence_day'] = Variable<int>(occurrenceDay.value);
    }
    if (minutesBefore.present) {
      map['minutes_before'] = Variable<int>(minutesBefore.value);
    }
    if (absoluteTime.present) {
      map['absolute_time'] = Variable<DateTime>(absoluteTime.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRulesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('occurrenceDay: $occurrenceDay, ')
          ..write('minutesBefore: $minutesBefore, ')
          ..write('absoluteTime: $absoluteTime, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderDeliveriesTable extends ReminderDeliveries
    with TableInfo<$ReminderDeliveriesTable, DeliveryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderDeliveriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _occurrenceKeyMeta = const VerificationMeta(
    'occurrenceKey',
  );
  @override
  late final GeneratedColumn<String> occurrenceKey = GeneratedColumn<String>(
    'occurrence_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fireAtMeta = const VerificationMeta('fireAt');
  @override
  late final GeneratedColumn<DateTime> fireAt = GeneratedColumn<DateTime>(
    'fire_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurrenceKey,
    fingerprint,
    state,
    fireAt,
    taskId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_deliveries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeliveryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('occurrence_key')) {
      context.handle(
        _occurrenceKeyMeta,
        occurrenceKey.isAcceptableOrUnknown(
          data['occurrence_key']!,
          _occurrenceKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceKeyMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('fire_at')) {
      context.handle(
        _fireAtMeta,
        fireAt.isAcceptableOrUnknown(data['fire_at']!, _fireAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fireAtMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeliveryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeliveryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      occurrenceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurrence_key'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      fireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fire_at'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
    );
  }

  @override
  $ReminderDeliveriesTable createAlias(String alias) {
    return $ReminderDeliveriesTable(attachedDatabase, alias);
  }
}

class DeliveryRow extends DataClass implements Insertable<DeliveryRow> {
  final int id;
  final String occurrenceKey;
  final String fingerprint;
  final String state;
  final DateTime fireAt;
  final String taskId;
  const DeliveryRow({
    required this.id,
    required this.occurrenceKey,
    required this.fingerprint,
    required this.state,
    required this.fireAt,
    required this.taskId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['occurrence_key'] = Variable<String>(occurrenceKey);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['state'] = Variable<String>(state);
    map['fire_at'] = Variable<DateTime>(fireAt);
    map['task_id'] = Variable<String>(taskId);
    return map;
  }

  ReminderDeliveriesCompanion toCompanion(bool nullToAbsent) {
    return ReminderDeliveriesCompanion(
      id: Value(id),
      occurrenceKey: Value(occurrenceKey),
      fingerprint: Value(fingerprint),
      state: Value(state),
      fireAt: Value(fireAt),
      taskId: Value(taskId),
    );
  }

  factory DeliveryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeliveryRow(
      id: serializer.fromJson<int>(json['id']),
      occurrenceKey: serializer.fromJson<String>(json['occurrenceKey']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      state: serializer.fromJson<String>(json['state']),
      fireAt: serializer.fromJson<DateTime>(json['fireAt']),
      taskId: serializer.fromJson<String>(json['taskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'occurrenceKey': serializer.toJson<String>(occurrenceKey),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'state': serializer.toJson<String>(state),
      'fireAt': serializer.toJson<DateTime>(fireAt),
      'taskId': serializer.toJson<String>(taskId),
    };
  }

  DeliveryRow copyWith({
    int? id,
    String? occurrenceKey,
    String? fingerprint,
    String? state,
    DateTime? fireAt,
    String? taskId,
  }) => DeliveryRow(
    id: id ?? this.id,
    occurrenceKey: occurrenceKey ?? this.occurrenceKey,
    fingerprint: fingerprint ?? this.fingerprint,
    state: state ?? this.state,
    fireAt: fireAt ?? this.fireAt,
    taskId: taskId ?? this.taskId,
  );
  DeliveryRow copyWithCompanion(ReminderDeliveriesCompanion data) {
    return DeliveryRow(
      id: data.id.present ? data.id.value : this.id,
      occurrenceKey: data.occurrenceKey.present
          ? data.occurrenceKey.value
          : this.occurrenceKey,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      state: data.state.present ? data.state.value : this.state,
      fireAt: data.fireAt.present ? data.fireAt.value : this.fireAt,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryRow(')
          ..write('id: $id, ')
          ..write('occurrenceKey: $occurrenceKey, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('state: $state, ')
          ..write('fireAt: $fireAt, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, occurrenceKey, fingerprint, state, fireAt, taskId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeliveryRow &&
          other.id == this.id &&
          other.occurrenceKey == this.occurrenceKey &&
          other.fingerprint == this.fingerprint &&
          other.state == this.state &&
          other.fireAt == this.fireAt &&
          other.taskId == this.taskId);
}

class ReminderDeliveriesCompanion extends UpdateCompanion<DeliveryRow> {
  final Value<int> id;
  final Value<String> occurrenceKey;
  final Value<String> fingerprint;
  final Value<String> state;
  final Value<DateTime> fireAt;
  final Value<String> taskId;
  const ReminderDeliveriesCompanion({
    this.id = const Value.absent(),
    this.occurrenceKey = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.state = const Value.absent(),
    this.fireAt = const Value.absent(),
    this.taskId = const Value.absent(),
  });
  ReminderDeliveriesCompanion.insert({
    this.id = const Value.absent(),
    required String occurrenceKey,
    required String fingerprint,
    required String state,
    required DateTime fireAt,
    required String taskId,
  }) : occurrenceKey = Value(occurrenceKey),
       fingerprint = Value(fingerprint),
       state = Value(state),
       fireAt = Value(fireAt),
       taskId = Value(taskId);
  static Insertable<DeliveryRow> custom({
    Expression<int>? id,
    Expression<String>? occurrenceKey,
    Expression<String>? fingerprint,
    Expression<String>? state,
    Expression<DateTime>? fireAt,
    Expression<String>? taskId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurrenceKey != null) 'occurrence_key': occurrenceKey,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (state != null) 'state': state,
      if (fireAt != null) 'fire_at': fireAt,
      if (taskId != null) 'task_id': taskId,
    });
  }

  ReminderDeliveriesCompanion copyWith({
    Value<int>? id,
    Value<String>? occurrenceKey,
    Value<String>? fingerprint,
    Value<String>? state,
    Value<DateTime>? fireAt,
    Value<String>? taskId,
  }) {
    return ReminderDeliveriesCompanion(
      id: id ?? this.id,
      occurrenceKey: occurrenceKey ?? this.occurrenceKey,
      fingerprint: fingerprint ?? this.fingerprint,
      state: state ?? this.state,
      fireAt: fireAt ?? this.fireAt,
      taskId: taskId ?? this.taskId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (occurrenceKey.present) {
      map['occurrence_key'] = Variable<String>(occurrenceKey.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (fireAt.present) {
      map['fire_at'] = Variable<DateTime>(fireAt.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderDeliveriesCompanion(')
          ..write('id: $id, ')
          ..write('occurrenceKey: $occurrenceKey, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('state: $state, ')
          ..write('fireAt: $fireAt, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }
}

class $ApplicationSettingsTable extends ApplicationSettings
    with TableInfo<$ApplicationSettingsTable, PreferencesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApplicationSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderOffsetMeta = const VerificationMeta(
    'reminderOffset',
  );
  @override
  late final GeneratedColumn<int> reminderOffset = GeneratedColumn<int>(
    'reminder_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _sundayFirstMeta = const VerificationMeta(
    'sundayFirst',
  );
  @override
  late final GeneratedColumn<bool> sundayFirst = GeneratedColumn<bool>(
    'sunday_first',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sunday_first" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _calendarWeekMeta = const VerificationMeta(
    'calendarWeek',
  );
  @override
  late final GeneratedColumn<bool> calendarWeek = GeneratedColumn<bool>(
    'calendar_week',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("calendar_week" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dateFormatMeta = const VerificationMeta(
    'dateFormat',
  );
  @override
  late final GeneratedColumn<String> dateFormat = GeneratedColumn<String>(
    'date_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    theme,
    remindersEnabled,
    reminderOffset,
    sundayFirst,
    calendarWeek,
    dateFormat,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'application_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferencesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_offset')) {
      context.handle(
        _reminderOffsetMeta,
        reminderOffset.isAcceptableOrUnknown(
          data['reminder_offset']!,
          _reminderOffsetMeta,
        ),
      );
    }
    if (data.containsKey('sunday_first')) {
      context.handle(
        _sundayFirstMeta,
        sundayFirst.isAcceptableOrUnknown(
          data['sunday_first']!,
          _sundayFirstMeta,
        ),
      );
    }
    if (data.containsKey('calendar_week')) {
      context.handle(
        _calendarWeekMeta,
        calendarWeek.isAcceptableOrUnknown(
          data['calendar_week']!,
          _calendarWeekMeta,
        ),
      );
    }
    if (data.containsKey('date_format')) {
      context.handle(
        _dateFormatMeta,
        dateFormat.isAcceptableOrUnknown(data['date_format']!, _dateFormatMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      remindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_enabled'],
      )!,
      reminderOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_offset'],
      )!,
      sundayFirst: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sunday_first'],
      )!,
      calendarWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calendar_week'],
      )!,
      dateFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_format'],
      )!,
    );
  }

  @override
  $ApplicationSettingsTable createAlias(String alias) {
    return $ApplicationSettingsTable(attachedDatabase, alias);
  }
}

class PreferencesRow extends DataClass implements Insertable<PreferencesRow> {
  final int id;
  final String theme;
  final bool remindersEnabled;
  final int reminderOffset;
  final bool sundayFirst;
  final bool calendarWeek;
  final String dateFormat;
  const PreferencesRow({
    required this.id,
    required this.theme,
    required this.remindersEnabled,
    required this.reminderOffset,
    required this.sundayFirst,
    required this.calendarWeek,
    required this.dateFormat,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme'] = Variable<String>(theme);
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    map['reminder_offset'] = Variable<int>(reminderOffset);
    map['sunday_first'] = Variable<bool>(sundayFirst);
    map['calendar_week'] = Variable<bool>(calendarWeek);
    map['date_format'] = Variable<String>(dateFormat);
    return map;
  }

  ApplicationSettingsCompanion toCompanion(bool nullToAbsent) {
    return ApplicationSettingsCompanion(
      id: Value(id),
      theme: Value(theme),
      remindersEnabled: Value(remindersEnabled),
      reminderOffset: Value(reminderOffset),
      sundayFirst: Value(sundayFirst),
      calendarWeek: Value(calendarWeek),
      dateFormat: Value(dateFormat),
    );
  }

  factory PreferencesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesRow(
      id: serializer.fromJson<int>(json['id']),
      theme: serializer.fromJson<String>(json['theme']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      reminderOffset: serializer.fromJson<int>(json['reminderOffset']),
      sundayFirst: serializer.fromJson<bool>(json['sundayFirst']),
      calendarWeek: serializer.fromJson<bool>(json['calendarWeek']),
      dateFormat: serializer.fromJson<String>(json['dateFormat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'theme': serializer.toJson<String>(theme),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'reminderOffset': serializer.toJson<int>(reminderOffset),
      'sundayFirst': serializer.toJson<bool>(sundayFirst),
      'calendarWeek': serializer.toJson<bool>(calendarWeek),
      'dateFormat': serializer.toJson<String>(dateFormat),
    };
  }

  PreferencesRow copyWith({
    int? id,
    String? theme,
    bool? remindersEnabled,
    int? reminderOffset,
    bool? sundayFirst,
    bool? calendarWeek,
    String? dateFormat,
  }) => PreferencesRow(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    reminderOffset: reminderOffset ?? this.reminderOffset,
    sundayFirst: sundayFirst ?? this.sundayFirst,
    calendarWeek: calendarWeek ?? this.calendarWeek,
    dateFormat: dateFormat ?? this.dateFormat,
  );
  PreferencesRow copyWithCompanion(ApplicationSettingsCompanion data) {
    return PreferencesRow(
      id: data.id.present ? data.id.value : this.id,
      theme: data.theme.present ? data.theme.value : this.theme,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      reminderOffset: data.reminderOffset.present
          ? data.reminderOffset.value
          : this.reminderOffset,
      sundayFirst: data.sundayFirst.present
          ? data.sundayFirst.value
          : this.sundayFirst,
      calendarWeek: data.calendarWeek.present
          ? data.calendarWeek.value
          : this.calendarWeek,
      dateFormat: data.dateFormat.present
          ? data.dateFormat.value
          : this.dateFormat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesRow(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('reminderOffset: $reminderOffset, ')
          ..write('sundayFirst: $sundayFirst, ')
          ..write('calendarWeek: $calendarWeek, ')
          ..write('dateFormat: $dateFormat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    theme,
    remindersEnabled,
    reminderOffset,
    sundayFirst,
    calendarWeek,
    dateFormat,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferencesRow &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.remindersEnabled == this.remindersEnabled &&
          other.reminderOffset == this.reminderOffset &&
          other.sundayFirst == this.sundayFirst &&
          other.calendarWeek == this.calendarWeek &&
          other.dateFormat == this.dateFormat);
}

class ApplicationSettingsCompanion extends UpdateCompanion<PreferencesRow> {
  final Value<int> id;
  final Value<String> theme;
  final Value<bool> remindersEnabled;
  final Value<int> reminderOffset;
  final Value<bool> sundayFirst;
  final Value<bool> calendarWeek;
  final Value<String> dateFormat;
  const ApplicationSettingsCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.reminderOffset = const Value.absent(),
    this.sundayFirst = const Value.absent(),
    this.calendarWeek = const Value.absent(),
    this.dateFormat = const Value.absent(),
  });
  ApplicationSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.reminderOffset = const Value.absent(),
    this.sundayFirst = const Value.absent(),
    this.calendarWeek = const Value.absent(),
    this.dateFormat = const Value.absent(),
  });
  static Insertable<PreferencesRow> custom({
    Expression<int>? id,
    Expression<String>? theme,
    Expression<bool>? remindersEnabled,
    Expression<int>? reminderOffset,
    Expression<bool>? sundayFirst,
    Expression<bool>? calendarWeek,
    Expression<String>? dateFormat,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'theme': theme,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (reminderOffset != null) 'reminder_offset': reminderOffset,
      if (sundayFirst != null) 'sunday_first': sundayFirst,
      if (calendarWeek != null) 'calendar_week': calendarWeek,
      if (dateFormat != null) 'date_format': dateFormat,
    });
  }

  ApplicationSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? theme,
    Value<bool>? remindersEnabled,
    Value<int>? reminderOffset,
    Value<bool>? sundayFirst,
    Value<bool>? calendarWeek,
    Value<String>? dateFormat,
  }) {
    return ApplicationSettingsCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderOffset: reminderOffset ?? this.reminderOffset,
      sundayFirst: sundayFirst ?? this.sundayFirst,
      calendarWeek: calendarWeek ?? this.calendarWeek,
      dateFormat: dateFormat ?? this.dateFormat,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (reminderOffset.present) {
      map['reminder_offset'] = Variable<int>(reminderOffset.value);
    }
    if (sundayFirst.present) {
      map['sunday_first'] = Variable<bool>(sundayFirst.value);
    }
    if (calendarWeek.present) {
      map['calendar_week'] = Variable<bool>(calendarWeek.value);
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<String>(dateFormat.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApplicationSettingsCompanion(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('reminderOffset: $reminderOffset, ')
          ..write('sundayFirst: $sundayFirst, ')
          ..write('calendarWeek: $calendarWeek, ')
          ..write('dateFormat: $dateFormat')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MonthlyGoalsTable monthlyGoals = $MonthlyGoalsTable(this);
  late final $WeeklyGoalsTable weeklyGoals = $WeeklyGoalsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $RecurrenceRulesTable recurrenceRules = $RecurrenceRulesTable(
    this,
  );
  late final $OccurrenceStatesTable occurrenceStates = $OccurrenceStatesTable(
    this,
  );
  late final $ReminderRulesTable reminderRules = $ReminderRulesTable(this);
  late final $ReminderDeliveriesTable reminderDeliveries =
      $ReminderDeliveriesTable(this);
  late final $ApplicationSettingsTable applicationSettings =
      $ApplicationSettingsTable(this);
  late final Index monthlyGoalsPeriod = Index(
    'monthly_goals_period',
    'CREATE INDEX monthly_goals_period ON monthly_goals (year, month)',
  );
  late final Index weeklyGoalsParent = Index(
    'weekly_goals_parent',
    'CREATE INDEX weekly_goals_parent ON weekly_goals (monthly_goal_id)',
  );
  late final Index weeklyGoalsPeriod = Index(
    'weekly_goals_period',
    'CREATE INDEX weekly_goals_period ON weekly_goals (week_start)',
  );
  late final Index tasksParent = Index(
    'tasks_parent',
    'CREATE INDEX tasks_parent ON tasks (weekly_goal_id)',
  );
  late final Index tasksScheduled = Index(
    'tasks_scheduled',
    'CREATE INDEX tasks_scheduled ON tasks (scheduled_date)',
  );
  late final Index tasksDeadline = Index(
    'tasks_deadline',
    'CREATE INDEX tasks_deadline ON tasks (due_at)',
  );
  late final Index recurrencePeriod = Index(
    'recurrence_period',
    'CREATE INDEX recurrence_period ON recurrence_rules (start_day, end_day)',
  );
  late final Index occurrenceSchedule = Index(
    'occurrence_schedule',
    'CREATE INDEX occurrence_schedule ON occurrence_states (scheduled_day)',
  );
  late final Index remindersTask = Index(
    'reminders_task',
    'CREATE INDEX reminders_task ON reminder_rules (task_id)',
  );
  late final MonthlyGoalDao monthlyGoalDao = MonthlyGoalDao(
    this as AppDatabase,
  );
  late final WeeklyGoalDao weeklyGoalDao = WeeklyGoalDao(this as AppDatabase);
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    monthlyGoals,
    weeklyGoals,
    tasks,
    recurrenceRules,
    occurrenceStates,
    reminderRules,
    reminderDeliveries,
    applicationSettings,
    monthlyGoalsPeriod,
    weeklyGoalsParent,
    weeklyGoalsPeriod,
    tasksParent,
    tasksScheduled,
    tasksDeadline,
    recurrencePeriod,
    occurrenceSchedule,
    remindersTask,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrence_rules', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recurrence_rules',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('occurrence_states', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminder_rules', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$MonthlyGoalsTableCreateCompanionBuilder =
    MonthlyGoalsCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required int year,
      required int month,
      Value<bool> isCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MonthlyGoalsTableUpdateCompanionBuilder =
    MonthlyGoalsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<int> year,
      Value<int> month,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MonthlyGoalsTableReferences
    extends BaseReferences<_$AppDatabase, $MonthlyGoalsTable, MonthlyGoalRow> {
  $$MonthlyGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WeeklyGoalsTable, List<WeeklyGoalRow>>
  _weeklyGoalsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weeklyGoals,
    aliasName: 'monthly_goals__id__weekly_goals__monthly_goal_id',
  );

  $$WeeklyGoalsTableProcessedTableManager get weeklyGoalsRefs {
    final manager = $$WeeklyGoalsTableTableManager(
      $_db,
      $_db.weeklyGoals,
    ).filter((f) => f.monthlyGoalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_weeklyGoalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MonthlyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weeklyGoalsRefs(
    Expression<bool> Function($$WeeklyGoalsTableFilterComposer f) f,
  ) {
    final $$WeeklyGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weeklyGoals,
      getReferencedColumn: (t) => t.monthlyGoalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeeklyGoalsTableFilterComposer(
            $db: $db,
            $table: $db.weeklyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> weeklyGoalsRefs<T extends Object>(
    Expression<T> Function($$WeeklyGoalsTableAnnotationComposer a) f,
  ) {
    final $$WeeklyGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weeklyGoals,
      getReferencedColumn: (t) => t.monthlyGoalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeeklyGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.weeklyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyGoalsTable,
          MonthlyGoalRow,
          $$MonthlyGoalsTableFilterComposer,
          $$MonthlyGoalsTableOrderingComposer,
          $$MonthlyGoalsTableAnnotationComposer,
          $$MonthlyGoalsTableCreateCompanionBuilder,
          $$MonthlyGoalsTableUpdateCompanionBuilder,
          (MonthlyGoalRow, $$MonthlyGoalsTableReferences),
          MonthlyGoalRow,
          PrefetchHooks Function({bool weeklyGoalsRefs})
        > {
  $$MonthlyGoalsTableTableManager(_$AppDatabase db, $MonthlyGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthlyGoalsCompanion(
                id: id,
                title: title,
                description: description,
                year: year,
                month: month,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required int year,
                required int month,
                Value<bool> isCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MonthlyGoalsCompanion.insert(
                id: id,
                title: title,
                description: description,
                year: year,
                month: month,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MonthlyGoalsTable, MonthlyGoalRow>(table),
                  $$MonthlyGoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weeklyGoalsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (weeklyGoalsRefs) db.weeklyGoals],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (weeklyGoalsRefs)
                    await $_getPrefetchedDataByColumns<
                      MonthlyGoalRow,
                      $MonthlyGoalsTable,
                      WeeklyGoalRow,
                      $WeeklyGoalsTable
                    >(
                      currentTable: table,
                      referencedTable: $$MonthlyGoalsTableReferences
                          ._weeklyGoalsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MonthlyGoalsTableReferences(
                            db,
                            table,
                            p0,
                          ).weeklyGoalsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'monthly_goal_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MonthlyGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyGoalsTable,
      MonthlyGoalRow,
      $$MonthlyGoalsTableFilterComposer,
      $$MonthlyGoalsTableOrderingComposer,
      $$MonthlyGoalsTableAnnotationComposer,
      $$MonthlyGoalsTableCreateCompanionBuilder,
      $$MonthlyGoalsTableUpdateCompanionBuilder,
      (MonthlyGoalRow, $$MonthlyGoalsTableReferences),
      MonthlyGoalRow,
      PrefetchHooks Function({bool weeklyGoalsRefs})
    >;
typedef $$WeeklyGoalsTableCreateCompanionBuilder =
    WeeklyGoalsCompanion Function({
      required String id,
      Value<String?> monthlyGoalId,
      required String title,
      Value<String?> description,
      required int weekStart,
      required int weekEnd,
      Value<bool> isCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WeeklyGoalsTableUpdateCompanionBuilder =
    WeeklyGoalsCompanion Function({
      Value<String> id,
      Value<String?> monthlyGoalId,
      Value<String> title,
      Value<String?> description,
      Value<int> weekStart,
      Value<int> weekEnd,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WeeklyGoalsTableReferences
    extends BaseReferences<_$AppDatabase, $WeeklyGoalsTable, WeeklyGoalRow> {
  $$WeeklyGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MonthlyGoalsTable _monthlyGoalIdTable(_$AppDatabase db) => db
      .monthlyGoals
      .createAlias('weekly_goals__monthly_goal_id__monthly_goals__id');

  $$MonthlyGoalsTableProcessedTableManager? get monthlyGoalId {
    final $_column = $_itemColumn<String>('monthly_goal_id');
    if ($_column == null) return null;
    final manager = $$MonthlyGoalsTableTableManager(
      $_db,
      $_db.monthlyGoals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_monthlyGoalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<TaskRow>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'weekly_goals__id__tasks__weekly_goal_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.weeklyGoalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeeklyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyGoalsTable> {
  $$WeeklyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekEnd => $composableBuilder(
    column: $table.weekEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MonthlyGoalsTableFilterComposer get monthlyGoalId {
    final $$MonthlyGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthlyGoalId,
      referencedTable: $db.monthlyGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyGoalsTableFilterComposer(
            $db: $db,
            $table: $db.monthlyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.weeklyGoalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeeklyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyGoalsTable> {
  $$WeeklyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekEnd => $composableBuilder(
    column: $table.weekEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MonthlyGoalsTableOrderingComposer get monthlyGoalId {
    final $$MonthlyGoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthlyGoalId,
      referencedTable: $db.monthlyGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyGoalsTableOrderingComposer(
            $db: $db,
            $table: $db.monthlyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeeklyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyGoalsTable> {
  $$WeeklyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<int> get weekEnd =>
      $composableBuilder(column: $table.weekEnd, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MonthlyGoalsTableAnnotationComposer get monthlyGoalId {
    final $$MonthlyGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthlyGoalId,
      referencedTable: $db.monthlyGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.monthlyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.weeklyGoalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeeklyGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyGoalsTable,
          WeeklyGoalRow,
          $$WeeklyGoalsTableFilterComposer,
          $$WeeklyGoalsTableOrderingComposer,
          $$WeeklyGoalsTableAnnotationComposer,
          $$WeeklyGoalsTableCreateCompanionBuilder,
          $$WeeklyGoalsTableUpdateCompanionBuilder,
          (WeeklyGoalRow, $$WeeklyGoalsTableReferences),
          WeeklyGoalRow,
          PrefetchHooks Function({bool monthlyGoalId, bool tasksRefs})
        > {
  $$WeeklyGoalsTableTableManager(_$AppDatabase db, $WeeklyGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> monthlyGoalId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> weekStart = const Value.absent(),
                Value<int> weekEnd = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyGoalsCompanion(
                id: id,
                monthlyGoalId: monthlyGoalId,
                title: title,
                description: description,
                weekStart: weekStart,
                weekEnd: weekEnd,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> monthlyGoalId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required int weekStart,
                required int weekEnd,
                Value<bool> isCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WeeklyGoalsCompanion.insert(
                id: id,
                monthlyGoalId: monthlyGoalId,
                title: title,
                description: description,
                weekStart: weekStart,
                weekEnd: weekEnd,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeeklyGoalsTable, WeeklyGoalRow>(table),
                  $$WeeklyGoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({monthlyGoalId = false, tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksRefs) db.tasks],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (monthlyGoalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.monthlyGoalId,
                        referencedTable: $$WeeklyGoalsTableReferences
                            ._monthlyGoalIdTable(db),
                        referencedColumn: $$WeeklyGoalsTableReferences
                            ._monthlyGoalIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedDataByColumns<
                      WeeklyGoalRow,
                      $WeeklyGoalsTable,
                      TaskRow,
                      $TasksTable
                    >(
                      currentTable: table,
                      referencedTable: $$WeeklyGoalsTableReferences
                          ._tasksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WeeklyGoalsTableReferences(db, table, p0).tasksRefs,
                      currentColumn: 'id',
                      referencedColumn: 'weekly_goal_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WeeklyGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyGoalsTable,
      WeeklyGoalRow,
      $$WeeklyGoalsTableFilterComposer,
      $$WeeklyGoalsTableOrderingComposer,
      $$WeeklyGoalsTableAnnotationComposer,
      $$WeeklyGoalsTableCreateCompanionBuilder,
      $$WeeklyGoalsTableUpdateCompanionBuilder,
      (WeeklyGoalRow, $$WeeklyGoalsTableReferences),
      WeeklyGoalRow,
      PrefetchHooks Function({bool monthlyGoalId, bool tasksRefs})
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  Value<String?> weeklyGoalId,
  required String title,
  Value<String?> description,
  required int scheduledDate,
  Value<DateTime?> dueAt,
  required String priority,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String?> weeklyGoalId,
  Value<String> title,
  Value<String?> description,
  Value<int> scheduledDate,
  Value<DateTime?> dueAt,
  Value<String> priority,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TaskRow> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WeeklyGoalsTable _weeklyGoalIdTable(_$AppDatabase db) =>
      db.weeklyGoals.createAlias('tasks__weekly_goal_id__weekly_goals__id');

  $$WeeklyGoalsTableProcessedTableManager? get weeklyGoalId {
    final $_column = $_itemColumn<String>('weekly_goal_id');
    if ($_column == null) return null;
    final manager = $$WeeklyGoalsTableTableManager(
      $_db,
      $_db.weeklyGoals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weeklyGoalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecurrenceRulesTable, List<RecurrenceRow>>
  _recurrenceRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurrenceRules,
    aliasName: 'tasks__id__recurrence_rules__task_id',
  );

  $$RecurrenceRulesTableProcessedTableManager get recurrenceRulesRefs {
    final manager = $$RecurrenceRulesTableTableManager(
      $_db,
      $_db.recurrenceRules,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurrenceRulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReminderRulesTable, List<ReminderRow>>
  _reminderRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminderRules,
    aliasName: 'tasks__id__reminder_rules__task_id',
  );

  $$ReminderRulesTableProcessedTableManager get reminderRulesRefs {
    final manager = $$ReminderRulesTableTableManager(
      $_db,
      $_db.reminderRules,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reminderRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WeeklyGoalsTableFilterComposer get weeklyGoalId {
    final $$WeeklyGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weeklyGoalId,
      referencedTable: $db.weeklyGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeeklyGoalsTableFilterComposer(
            $db: $db,
            $table: $db.weeklyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recurrenceRulesRefs(
    Expression<bool> Function($$RecurrenceRulesTableFilterComposer f) f,
  ) {
    final $$RecurrenceRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrenceRules,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceRulesTableFilterComposer(
            $db: $db,
            $table: $db.recurrenceRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reminderRulesRefs(
    Expression<bool> Function($$ReminderRulesTableFilterComposer f) f,
  ) {
    final $$ReminderRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderRules,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRulesTableFilterComposer(
            $db: $db,
            $table: $db.reminderRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeeklyGoalsTableOrderingComposer get weeklyGoalId {
    final $$WeeklyGoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weeklyGoalId,
      referencedTable: $db.weeklyGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeeklyGoalsTableOrderingComposer(
            $db: $db,
            $table: $db.weeklyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WeeklyGoalsTableAnnotationComposer get weeklyGoalId {
    final $$WeeklyGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weeklyGoalId,
      referencedTable: $db.weeklyGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeeklyGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.weeklyGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recurrenceRulesRefs<T extends Object>(
    Expression<T> Function($$RecurrenceRulesTableAnnotationComposer a) f,
  ) {
    final $$RecurrenceRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrenceRules,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrenceRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reminderRulesRefs<T extends Object>(
    Expression<T> Function($$ReminderRulesTableAnnotationComposer a) f,
  ) {
    final $$ReminderRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderRules,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, $$TasksTableReferences),
          TaskRow,
          PrefetchHooks Function({
            bool weeklyGoalId,
            bool recurrenceRulesRefs,
            bool reminderRulesRefs,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> weeklyGoalId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> scheduledDate = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                weeklyGoalId: weeklyGoalId,
                title: title,
                description: description,
                scheduledDate: scheduledDate,
                dueAt: dueAt,
                priority: priority,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> weeklyGoalId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required int scheduledDate,
                Value<DateTime?> dueAt = const Value.absent(),
                required String priority,
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                weeklyGoalId: weeklyGoalId,
                title: title,
                description: description,
                scheduledDate: scheduledDate,
                dueAt: dueAt,
                priority: priority,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, TaskRow>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                weeklyGoalId = false,
                recurrenceRulesRefs = false,
                reminderRulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurrenceRulesRefs) db.recurrenceRules,
                    if (reminderRulesRefs) db.reminderRules,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (weeklyGoalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.weeklyGoalId,
                            referencedTable: $$TasksTableReferences
                                ._weeklyGoalIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._weeklyGoalIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurrenceRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          TaskRow,
                          $TasksTable,
                          RecurrenceRow,
                          $RecurrenceRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._recurrenceRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrenceRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'task_id',
                          typedResults: items,
                        ),
                      if (reminderRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          TaskRow,
                          $TasksTable,
                          ReminderRow,
                          $ReminderRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._reminderRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).reminderRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'task_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, $$TasksTableReferences),
      TaskRow,
      PrefetchHooks Function({
        bool weeklyGoalId,
        bool recurrenceRulesRefs,
        bool reminderRulesRefs,
      })
    >;
typedef $$RecurrenceRulesTableCreateCompanionBuilder =
    RecurrenceRulesCompanion Function({
      required String taskId,
      required String frequency,
      required int interval,
      required int weekdays,
      required int monthDay,
      required int startDay,
      Value<int?> endDay,
      Value<int?> occurrenceCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecurrenceRulesTableUpdateCompanionBuilder =
    RecurrenceRulesCompanion Function({
      Value<String> taskId,
      Value<String> frequency,
      Value<int> interval,
      Value<int> weekdays,
      Value<int> monthDay,
      Value<int> startDay,
      Value<int?> endDay,
      Value<int?> occurrenceCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RecurrenceRulesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RecurrenceRulesTable, RecurrenceRow> {
  $$RecurrenceRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('recurrence_rules__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurrenceRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthDay => $composableBuilder(
    column: $table.monthDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDay => $composableBuilder(
    column: $table.endDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthDay => $composableBuilder(
    column: $table.monthDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDay => $composableBuilder(
    column: $table.endDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get monthDay =>
      $composableBuilder(column: $table.monthDay, builder: (column) => column);

  GeneratedColumn<int> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumn<int> get endDay =>
      $composableBuilder(column: $table.endDay, builder: (column) => column);

  GeneratedColumn<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurrenceRulesTable,
          RecurrenceRow,
          $$RecurrenceRulesTableFilterComposer,
          $$RecurrenceRulesTableOrderingComposer,
          $$RecurrenceRulesTableAnnotationComposer,
          $$RecurrenceRulesTableCreateCompanionBuilder,
          $$RecurrenceRulesTableUpdateCompanionBuilder,
          (RecurrenceRow, $$RecurrenceRulesTableReferences),
          RecurrenceRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$RecurrenceRulesTableTableManager(
    _$AppDatabase db,
    $RecurrenceRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrenceRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrenceRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<int> monthDay = const Value.absent(),
                Value<int> startDay = const Value.absent(),
                Value<int?> endDay = const Value.absent(),
                Value<int?> occurrenceCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceRulesCompanion(
                taskId: taskId,
                frequency: frequency,
                interval: interval,
                weekdays: weekdays,
                monthDay: monthDay,
                startDay: startDay,
                endDay: endDay,
                occurrenceCount: occurrenceCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required String frequency,
                required int interval,
                required int weekdays,
                required int monthDay,
                required int startDay,
                Value<int?> endDay = const Value.absent(),
                Value<int?> occurrenceCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceRulesCompanion.insert(
                taskId: taskId,
                frequency: frequency,
                interval: interval,
                weekdays: weekdays,
                monthDay: monthDay,
                startDay: startDay,
                endDay: endDay,
                occurrenceCount: occurrenceCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurrenceRulesTable, RecurrenceRow>(table),
                  $$RecurrenceRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$RecurrenceRulesTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$RecurrenceRulesTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecurrenceRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurrenceRulesTable,
      RecurrenceRow,
      $$RecurrenceRulesTableFilterComposer,
      $$RecurrenceRulesTableOrderingComposer,
      $$RecurrenceRulesTableAnnotationComposer,
      $$RecurrenceRulesTableCreateCompanionBuilder,
      $$RecurrenceRulesTableUpdateCompanionBuilder,
      (RecurrenceRow, $$RecurrenceRulesTableReferences),
      RecurrenceRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$OccurrenceStatesTableCreateCompanionBuilder =
    OccurrenceStatesCompanion Function({
      required String taskId,
      required int occurrenceDay,
      required int scheduledDay,
      Value<String?> overrideData,
      Value<bool> skipped,
      Value<DateTime?> completedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$OccurrenceStatesTableUpdateCompanionBuilder =
    OccurrenceStatesCompanion Function({
      Value<String> taskId,
      Value<int> occurrenceDay,
      Value<int> scheduledDay,
      Value<String?> overrideData,
      Value<bool> skipped,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OccurrenceStatesTableFilterComposer
    extends Composer<_$AppDatabase, $OccurrenceStatesTable> {
  $$OccurrenceStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledDay => $composableBuilder(
    column: $table.scheduledDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overrideData => $composableBuilder(
    column: $table.overrideData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OccurrenceStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $OccurrenceStatesTable> {
  $$OccurrenceStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDay => $composableBuilder(
    column: $table.scheduledDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overrideData => $composableBuilder(
    column: $table.overrideData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OccurrenceStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OccurrenceStatesTable> {
  $$OccurrenceStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledDay => $composableBuilder(
    column: $table.scheduledDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overrideData => $composableBuilder(
    column: $table.overrideData,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OccurrenceStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OccurrenceStatesTable,
          OccurrenceRow,
          $$OccurrenceStatesTableFilterComposer,
          $$OccurrenceStatesTableOrderingComposer,
          $$OccurrenceStatesTableAnnotationComposer,
          $$OccurrenceStatesTableCreateCompanionBuilder,
          $$OccurrenceStatesTableUpdateCompanionBuilder,
          (
            OccurrenceRow,
            BaseReferences<
              _$AppDatabase,
              $OccurrenceStatesTable,
              OccurrenceRow
            >,
          ),
          OccurrenceRow,
          PrefetchHooks Function()
        > {
  $$OccurrenceStatesTableTableManager(
    _$AppDatabase db,
    $OccurrenceStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OccurrenceStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OccurrenceStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OccurrenceStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<int> occurrenceDay = const Value.absent(),
                Value<int> scheduledDay = const Value.absent(),
                Value<String?> overrideData = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OccurrenceStatesCompanion(
                taskId: taskId,
                occurrenceDay: occurrenceDay,
                scheduledDay: scheduledDay,
                overrideData: overrideData,
                skipped: skipped,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required int occurrenceDay,
                required int scheduledDay,
                Value<String?> overrideData = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => OccurrenceStatesCompanion.insert(
                taskId: taskId,
                occurrenceDay: occurrenceDay,
                scheduledDay: scheduledDay,
                overrideData: overrideData,
                skipped: skipped,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OccurrenceStatesTable, OccurrenceRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OccurrenceStatesTable,
                    OccurrenceRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OccurrenceStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OccurrenceStatesTable,
      OccurrenceRow,
      $$OccurrenceStatesTableFilterComposer,
      $$OccurrenceStatesTableOrderingComposer,
      $$OccurrenceStatesTableAnnotationComposer,
      $$OccurrenceStatesTableCreateCompanionBuilder,
      $$OccurrenceStatesTableUpdateCompanionBuilder,
      (
        OccurrenceRow,
        BaseReferences<_$AppDatabase, $OccurrenceStatesTable, OccurrenceRow>,
      ),
      OccurrenceRow,
      PrefetchHooks Function()
    >;
typedef $$ReminderRulesTableCreateCompanionBuilder =
    ReminderRulesCompanion Function({
      required String id,
      required String taskId,
      Value<int?> occurrenceDay,
      Value<int?> minutesBefore,
      Value<DateTime?> absoluteTime,
      required bool enabled,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReminderRulesTableUpdateCompanionBuilder =
    ReminderRulesCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<int?> occurrenceDay,
      Value<int?> minutesBefore,
      Value<DateTime?> absoluteTime,
      Value<bool> enabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ReminderRulesTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderRulesTable, ReminderRow> {
  $$ReminderRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('reminder_rules__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReminderRulesTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderRulesTable> {
  $$ReminderRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutesBefore => $composableBuilder(
    column: $table.minutesBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get absoluteTime => $composableBuilder(
    column: $table.absoluteTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderRulesTable> {
  $$ReminderRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesBefore => $composableBuilder(
    column: $table.minutesBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get absoluteTime => $composableBuilder(
    column: $table.absoluteTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderRulesTable> {
  $$ReminderRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutesBefore => $composableBuilder(
    column: $table.minutesBefore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get absoluteTime => $composableBuilder(
    column: $table.absoluteTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderRulesTable,
          ReminderRow,
          $$ReminderRulesTableFilterComposer,
          $$ReminderRulesTableOrderingComposer,
          $$ReminderRulesTableAnnotationComposer,
          $$ReminderRulesTableCreateCompanionBuilder,
          $$ReminderRulesTableUpdateCompanionBuilder,
          (ReminderRow, $$ReminderRulesTableReferences),
          ReminderRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$ReminderRulesTableTableManager(_$AppDatabase db, $ReminderRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int?> occurrenceDay = const Value.absent(),
                Value<int?> minutesBefore = const Value.absent(),
                Value<DateTime?> absoluteTime = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderRulesCompanion(
                id: id,
                taskId: taskId,
                occurrenceDay: occurrenceDay,
                minutesBefore: minutesBefore,
                absoluteTime: absoluteTime,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                Value<int?> occurrenceDay = const Value.absent(),
                Value<int?> minutesBefore = const Value.absent(),
                Value<DateTime?> absoluteTime = const Value.absent(),
                required bool enabled,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReminderRulesCompanion.insert(
                id: id,
                taskId: taskId,
                occurrenceDay: occurrenceDay,
                minutesBefore: minutesBefore,
                absoluteTime: absoluteTime,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderRulesTable, ReminderRow>(table),
                  $$ReminderRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$ReminderRulesTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$ReminderRulesTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReminderRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderRulesTable,
      ReminderRow,
      $$ReminderRulesTableFilterComposer,
      $$ReminderRulesTableOrderingComposer,
      $$ReminderRulesTableAnnotationComposer,
      $$ReminderRulesTableCreateCompanionBuilder,
      $$ReminderRulesTableUpdateCompanionBuilder,
      (ReminderRow, $$ReminderRulesTableReferences),
      ReminderRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$ReminderDeliveriesTableCreateCompanionBuilder =
    ReminderDeliveriesCompanion Function({
      Value<int> id,
      required String occurrenceKey,
      required String fingerprint,
      required String state,
      required DateTime fireAt,
      required String taskId,
    });
typedef $$ReminderDeliveriesTableUpdateCompanionBuilder =
    ReminderDeliveriesCompanion Function({
      Value<int> id,
      Value<String> occurrenceKey,
      Value<String> fingerprint,
      Value<String> state,
      Value<DateTime> fireAt,
      Value<String> taskId,
    });

class $$ReminderDeliveriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderDeliveriesTable> {
  $$ReminderDeliveriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurrenceKey => $composableBuilder(
    column: $table.occurrenceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderDeliveriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderDeliveriesTable> {
  $$ReminderDeliveriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurrenceKey => $composableBuilder(
    column: $table.occurrenceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderDeliveriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderDeliveriesTable> {
  $$ReminderDeliveriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get occurrenceKey => $composableBuilder(
    column: $table.occurrenceKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get fireAt =>
      $composableBuilder(column: $table.fireAt, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);
}

class $$ReminderDeliveriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderDeliveriesTable,
          DeliveryRow,
          $$ReminderDeliveriesTableFilterComposer,
          $$ReminderDeliveriesTableOrderingComposer,
          $$ReminderDeliveriesTableAnnotationComposer,
          $$ReminderDeliveriesTableCreateCompanionBuilder,
          $$ReminderDeliveriesTableUpdateCompanionBuilder,
          (
            DeliveryRow,
            BaseReferences<
              _$AppDatabase,
              $ReminderDeliveriesTable,
              DeliveryRow
            >,
          ),
          DeliveryRow,
          PrefetchHooks Function()
        > {
  $$ReminderDeliveriesTableTableManager(
    _$AppDatabase db,
    $ReminderDeliveriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderDeliveriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderDeliveriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderDeliveriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> occurrenceKey = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime> fireAt = const Value.absent(),
                Value<String> taskId = const Value.absent(),
              }) => ReminderDeliveriesCompanion(
                id: id,
                occurrenceKey: occurrenceKey,
                fingerprint: fingerprint,
                state: state,
                fireAt: fireAt,
                taskId: taskId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String occurrenceKey,
                required String fingerprint,
                required String state,
                required DateTime fireAt,
                required String taskId,
              }) => ReminderDeliveriesCompanion.insert(
                id: id,
                occurrenceKey: occurrenceKey,
                fingerprint: fingerprint,
                state: state,
                fireAt: fireAt,
                taskId: taskId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderDeliveriesTable, DeliveryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReminderDeliveriesTable,
                    DeliveryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderDeliveriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderDeliveriesTable,
      DeliveryRow,
      $$ReminderDeliveriesTableFilterComposer,
      $$ReminderDeliveriesTableOrderingComposer,
      $$ReminderDeliveriesTableAnnotationComposer,
      $$ReminderDeliveriesTableCreateCompanionBuilder,
      $$ReminderDeliveriesTableUpdateCompanionBuilder,
      (
        DeliveryRow,
        BaseReferences<_$AppDatabase, $ReminderDeliveriesTable, DeliveryRow>,
      ),
      DeliveryRow,
      PrefetchHooks Function()
    >;
typedef $$ApplicationSettingsTableCreateCompanionBuilder =
    ApplicationSettingsCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<bool> remindersEnabled,
      Value<int> reminderOffset,
      Value<bool> sundayFirst,
      Value<bool> calendarWeek,
      Value<String> dateFormat,
    });
typedef $$ApplicationSettingsTableUpdateCompanionBuilder =
    ApplicationSettingsCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<bool> remindersEnabled,
      Value<int> reminderOffset,
      Value<bool> sundayFirst,
      Value<bool> calendarWeek,
      Value<String> dateFormat,
    });

class $$ApplicationSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ApplicationSettingsTable> {
  $$ApplicationSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sundayFirst => $composableBuilder(
    column: $table.sundayFirst,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get calendarWeek => $composableBuilder(
    column: $table.calendarWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ApplicationSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApplicationSettingsTable> {
  $$ApplicationSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sundayFirst => $composableBuilder(
    column: $table.sundayFirst,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calendarWeek => $composableBuilder(
    column: $table.calendarWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApplicationSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApplicationSettingsTable> {
  $$ApplicationSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sundayFirst => $composableBuilder(
    column: $table.sundayFirst,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get calendarWeek => $composableBuilder(
    column: $table.calendarWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => column,
  );
}

class $$ApplicationSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApplicationSettingsTable,
          PreferencesRow,
          $$ApplicationSettingsTableFilterComposer,
          $$ApplicationSettingsTableOrderingComposer,
          $$ApplicationSettingsTableAnnotationComposer,
          $$ApplicationSettingsTableCreateCompanionBuilder,
          $$ApplicationSettingsTableUpdateCompanionBuilder,
          (
            PreferencesRow,
            BaseReferences<
              _$AppDatabase,
              $ApplicationSettingsTable,
              PreferencesRow
            >,
          ),
          PreferencesRow,
          PrefetchHooks Function()
        > {
  $$ApplicationSettingsTableTableManager(
    _$AppDatabase db,
    $ApplicationSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApplicationSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApplicationSettingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ApplicationSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<int> reminderOffset = const Value.absent(),
                Value<bool> sundayFirst = const Value.absent(),
                Value<bool> calendarWeek = const Value.absent(),
                Value<String> dateFormat = const Value.absent(),
              }) => ApplicationSettingsCompanion(
                id: id,
                theme: theme,
                remindersEnabled: remindersEnabled,
                reminderOffset: reminderOffset,
                sundayFirst: sundayFirst,
                calendarWeek: calendarWeek,
                dateFormat: dateFormat,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<int> reminderOffset = const Value.absent(),
                Value<bool> sundayFirst = const Value.absent(),
                Value<bool> calendarWeek = const Value.absent(),
                Value<String> dateFormat = const Value.absent(),
              }) => ApplicationSettingsCompanion.insert(
                id: id,
                theme: theme,
                remindersEnabled: remindersEnabled,
                reminderOffset: reminderOffset,
                sundayFirst: sundayFirst,
                calendarWeek: calendarWeek,
                dateFormat: dateFormat,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ApplicationSettingsTable, PreferencesRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ApplicationSettingsTable,
                    PreferencesRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ApplicationSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApplicationSettingsTable,
      PreferencesRow,
      $$ApplicationSettingsTableFilterComposer,
      $$ApplicationSettingsTableOrderingComposer,
      $$ApplicationSettingsTableAnnotationComposer,
      $$ApplicationSettingsTableCreateCompanionBuilder,
      $$ApplicationSettingsTableUpdateCompanionBuilder,
      (
        PreferencesRow,
        BaseReferences<
          _$AppDatabase,
          $ApplicationSettingsTable,
          PreferencesRow
        >,
      ),
      PreferencesRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MonthlyGoalsTableTableManager get monthlyGoals =>
      $$MonthlyGoalsTableTableManager(_db, _db.monthlyGoals);
  $$WeeklyGoalsTableTableManager get weeklyGoals =>
      $$WeeklyGoalsTableTableManager(_db, _db.weeklyGoals);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$RecurrenceRulesTableTableManager get recurrenceRules =>
      $$RecurrenceRulesTableTableManager(_db, _db.recurrenceRules);
  $$OccurrenceStatesTableTableManager get occurrenceStates =>
      $$OccurrenceStatesTableTableManager(_db, _db.occurrenceStates);
  $$ReminderRulesTableTableManager get reminderRules =>
      $$ReminderRulesTableTableManager(_db, _db.reminderRules);
  $$ReminderDeliveriesTableTableManager get reminderDeliveries =>
      $$ReminderDeliveriesTableTableManager(_db, _db.reminderDeliveries);
  $$ApplicationSettingsTableTableManager get applicationSettings =>
      $$ApplicationSettingsTableTableManager(_db, _db.applicationSettings);
}
