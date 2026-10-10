// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HeartRateRecordsTable extends HeartRateRecords
    with TableInfo<$HeartRateRecordsTable, HeartRateRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeartRateRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _bpmMeta = const VerificationMeta('bpm');
  @override
  late final GeneratedColumn<int> bpm = GeneratedColumn<int>(
      'bpm', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _measuredAtMeta =
      const VerificationMeta('measuredAt');
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
      'measured_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, deviceId, bpm, measuredAt, createdAt, isSynced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'heart_rate_records';
  @override
  VerificationContext validateIntegrity(Insertable<HeartRateRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('bpm')) {
      context.handle(
          _bpmMeta, bpm.isAcceptableOrUnknown(data['bpm']!, _bpmMeta));
    } else if (isInserting) {
      context.missing(_bpmMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
          _measuredAtMeta,
          measuredAt.isAcceptableOrUnknown(
              data['measured_at']!, _measuredAtMeta));
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeartRateRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeartRateRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      bpm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bpm'])!,
      measuredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}measured_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $HeartRateRecordsTable createAlias(String alias) {
    return $HeartRateRecordsTable(attachedDatabase, alias);
  }
}

class HeartRateRecord extends DataClass implements Insertable<HeartRateRecord> {
  final int id;
  final String deviceId;
  final int bpm;
  final DateTime measuredAt;
  final DateTime createdAt;

  /// V2 新增：旧记录和新记录默认均为未同步。
  final bool isSynced;
  const HeartRateRecord(
      {required this.id,
      required this.deviceId,
      required this.bpm,
      required this.measuredAt,
      required this.createdAt,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['bpm'] = Variable<int>(bpm);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  HeartRateRecordsCompanion toCompanion(bool nullToAbsent) {
    return HeartRateRecordsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      bpm: Value(bpm),
      measuredAt: Value(measuredAt),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory HeartRateRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeartRateRecord(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      bpm: serializer.fromJson<int>(json['bpm']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'bpm': serializer.toJson<int>(bpm),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  HeartRateRecord copyWith(
          {int? id,
          String? deviceId,
          int? bpm,
          DateTime? measuredAt,
          DateTime? createdAt,
          bool? isSynced}) =>
      HeartRateRecord(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        bpm: bpm ?? this.bpm,
        measuredAt: measuredAt ?? this.measuredAt,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
      );
  HeartRateRecord copyWithCompanion(HeartRateRecordsCompanion data) {
    return HeartRateRecord(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      bpm: data.bpm.present ? data.bpm.value : this.bpm,
      measuredAt:
          data.measuredAt.present ? data.measuredAt.value : this.measuredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateRecord(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('bpm: $bpm, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deviceId, bpm, measuredAt, createdAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeartRateRecord &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.bpm == this.bpm &&
          other.measuredAt == this.measuredAt &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class HeartRateRecordsCompanion extends UpdateCompanion<HeartRateRecord> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<int> bpm;
  final Value<DateTime> measuredAt;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const HeartRateRecordsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.bpm = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  HeartRateRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required int bpm,
    required DateTime measuredAt,
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  })  : deviceId = Value(deviceId),
        bpm = Value(bpm),
        measuredAt = Value(measuredAt);
  static Insertable<HeartRateRecord> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<int>? bpm,
    Expression<DateTime>? measuredAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (bpm != null) 'bpm': bpm,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  HeartRateRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? deviceId,
      Value<int>? bpm,
      Value<DateTime>? measuredAt,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced}) {
    return HeartRateRecordsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      bpm: bpm ?? this.bpm,
      measuredAt: measuredAt ?? this.measuredAt,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (bpm.present) {
      map['bpm'] = Variable<int>(bpm.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateRecordsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('bpm: $bpm, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $HeartRateRecordsTable heartRateRecords =
      $HeartRateRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [heartRateRecords];
}
