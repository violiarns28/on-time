// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_sql_local.dart';

// ignore_for_file: type=lint
class $AttendanceTableTable extends AttendanceTable
    with TableInfo<$AttendanceTableTable, AttendanceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<AttendanceType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AttendanceType>($AttendanceTableTable.$convertertype);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<BigInt> timestamp = GeneratedColumn<BigInt>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
      'hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousHashMeta =
      const VerificationMeta('previousHash');
  @override
  late final GeneratedColumn<String> previousHash = GeneratedColumn<String>(
      'previous_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<int> nonce = GeneratedColumn<int>(
      'nonce', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        latitude,
        longitude,
        type,
        date,
        timestamp,
        hash,
        previousHash,
        nonce
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AttendanceTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('previous_hash')) {
      context.handle(
          _previousHashMeta,
          previousHash.isAcceptableOrUnknown(
              data['previous_hash']!, _previousHashMeta));
    } else if (isInserting) {
      context.missing(_previousHashMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      type: $AttendanceTableTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}timestamp'])!,
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
      previousHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}previous_hash'])!,
      nonce: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nonce'])!,
    );
  }

  @override
  $AttendanceTableTable createAlias(String alias) {
    return $AttendanceTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AttendanceType, int, int> $convertertype =
      const EnumIndexConverter<AttendanceType>(AttendanceType.values);
}

class AttendanceTableData extends DataClass
    implements Insertable<AttendanceTableData> {
  final int id;
  final int userId;
  final double latitude;
  final double longitude;
  final AttendanceType type;
  final String date;
  final BigInt timestamp;
  final String hash;
  final String previousHash;
  final int nonce;
  const AttendanceTableData(
      {required this.id,
      required this.userId,
      required this.latitude,
      required this.longitude,
      required this.type,
      required this.date,
      required this.timestamp,
      required this.hash,
      required this.previousHash,
      required this.nonce});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    {
      map['type'] =
          Variable<int>($AttendanceTableTable.$convertertype.toSql(type));
    }
    map['date'] = Variable<String>(date);
    map['timestamp'] = Variable<BigInt>(timestamp);
    map['hash'] = Variable<String>(hash);
    map['previous_hash'] = Variable<String>(previousHash);
    map['nonce'] = Variable<int>(nonce);
    return map;
  }

  AttendanceTableCompanion toCompanion(bool nullToAbsent) {
    return AttendanceTableCompanion(
      id: Value(id),
      userId: Value(userId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      type: Value(type),
      date: Value(date),
      timestamp: Value(timestamp),
      hash: Value(hash),
      previousHash: Value(previousHash),
      nonce: Value(nonce),
    );
  }

  factory AttendanceTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      type: $AttendanceTableTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      date: serializer.fromJson<String>(json['date']),
      timestamp: serializer.fromJson<BigInt>(json['timestamp']),
      hash: serializer.fromJson<String>(json['hash']),
      previousHash: serializer.fromJson<String>(json['previousHash']),
      nonce: serializer.fromJson<int>(json['nonce']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'type': serializer
          .toJson<int>($AttendanceTableTable.$convertertype.toJson(type)),
      'date': serializer.toJson<String>(date),
      'timestamp': serializer.toJson<BigInt>(timestamp),
      'hash': serializer.toJson<String>(hash),
      'previousHash': serializer.toJson<String>(previousHash),
      'nonce': serializer.toJson<int>(nonce),
    };
  }

  AttendanceTableData copyWith(
          {int? id,
          int? userId,
          double? latitude,
          double? longitude,
          AttendanceType? type,
          String? date,
          BigInt? timestamp,
          String? hash,
          String? previousHash,
          int? nonce}) =>
      AttendanceTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        type: type ?? this.type,
        date: date ?? this.date,
        timestamp: timestamp ?? this.timestamp,
        hash: hash ?? this.hash,
        previousHash: previousHash ?? this.previousHash,
        nonce: nonce ?? this.nonce,
      );
  AttendanceTableData copyWithCompanion(AttendanceTableCompanion data) {
    return AttendanceTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      hash: data.hash.present ? data.hash.value : this.hash,
      previousHash: data.previousHash.present
          ? data.previousHash.value
          : this.previousHash,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('timestamp: $timestamp, ')
          ..write('hash: $hash, ')
          ..write('previousHash: $previousHash, ')
          ..write('nonce: $nonce')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, latitude, longitude, type, date,
      timestamp, hash, previousHash, nonce);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.type == this.type &&
          other.date == this.date &&
          other.timestamp == this.timestamp &&
          other.hash == this.hash &&
          other.previousHash == this.previousHash &&
          other.nonce == this.nonce);
}

class AttendanceTableCompanion extends UpdateCompanion<AttendanceTableData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<AttendanceType> type;
  final Value<String> date;
  final Value<BigInt> timestamp;
  final Value<String> hash;
  final Value<String> previousHash;
  final Value<int> nonce;
  const AttendanceTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.hash = const Value.absent(),
    this.previousHash = const Value.absent(),
    this.nonce = const Value.absent(),
  });
  AttendanceTableCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required double latitude,
    required double longitude,
    required AttendanceType type,
    required String date,
    required BigInt timestamp,
    required String hash,
    required String previousHash,
    required int nonce,
  })  : userId = Value(userId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        type = Value(type),
        date = Value(date),
        timestamp = Value(timestamp),
        hash = Value(hash),
        previousHash = Value(previousHash),
        nonce = Value(nonce);
  static Insertable<AttendanceTableData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? type,
    Expression<String>? date,
    Expression<BigInt>? timestamp,
    Expression<String>? hash,
    Expression<String>? previousHash,
    Expression<int>? nonce,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (timestamp != null) 'timestamp': timestamp,
      if (hash != null) 'hash': hash,
      if (previousHash != null) 'previous_hash': previousHash,
      if (nonce != null) 'nonce': nonce,
    });
  }

  AttendanceTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<AttendanceType>? type,
      Value<String>? date,
      Value<BigInt>? timestamp,
      Value<String>? hash,
      Value<String>? previousHash,
      Value<int>? nonce}) {
    return AttendanceTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      hash: hash ?? this.hash,
      previousHash: previousHash ?? this.previousHash,
      nonce: nonce ?? this.nonce,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($AttendanceTableTable.$convertertype.toSql(type.value));
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<BigInt>(timestamp.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (previousHash.present) {
      map['previous_hash'] = Variable<String>(previousHash.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<int>(nonce.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('timestamp: $timestamp, ')
          ..write('hash: $hash, ')
          ..write('previousHash: $previousHash, ')
          ..write('nonce: $nonce')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseSqlLocal extends GeneratedDatabase {
  _$BaseSqlLocal(QueryExecutor e) : super(e);
  $BaseSqlLocalManager get managers => $BaseSqlLocalManager(this);
  late final $AttendanceTableTable attendanceTable =
      $AttendanceTableTable(this);
  late final AttendanceDao attendanceDao = AttendanceDao(this as BaseSqlLocal);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [attendanceTable];
}

typedef $$AttendanceTableTableCreateCompanionBuilder = AttendanceTableCompanion
    Function({
  Value<int> id,
  required int userId,
  required double latitude,
  required double longitude,
  required AttendanceType type,
  required String date,
  required BigInt timestamp,
  required String hash,
  required String previousHash,
  required int nonce,
});
typedef $$AttendanceTableTableUpdateCompanionBuilder = AttendanceTableCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<double> latitude,
  Value<double> longitude,
  Value<AttendanceType> type,
  Value<String> date,
  Value<BigInt> timestamp,
  Value<String> hash,
  Value<String> previousHash,
  Value<int> nonce,
});

class $$AttendanceTableTableFilterComposer
    extends Composer<_$BaseSqlLocal, $AttendanceTableTable> {
  $$AttendanceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AttendanceType, AttendanceType, int>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousHash => $composableBuilder(
      column: $table.previousHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnFilters(column));
}

class $$AttendanceTableTableOrderingComposer
    extends Composer<_$BaseSqlLocal, $AttendanceTableTable> {
  $$AttendanceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousHash => $composableBuilder(
      column: $table.previousHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnOrderings(column));
}

class $$AttendanceTableTableAnnotationComposer
    extends Composer<_$BaseSqlLocal, $AttendanceTableTable> {
  $$AttendanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AttendanceType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<BigInt> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<String> get previousHash => $composableBuilder(
      column: $table.previousHash, builder: (column) => column);

  GeneratedColumn<int> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);
}

class $$AttendanceTableTableTableManager extends RootTableManager<
    _$BaseSqlLocal,
    $AttendanceTableTable,
    AttendanceTableData,
    $$AttendanceTableTableFilterComposer,
    $$AttendanceTableTableOrderingComposer,
    $$AttendanceTableTableAnnotationComposer,
    $$AttendanceTableTableCreateCompanionBuilder,
    $$AttendanceTableTableUpdateCompanionBuilder,
    (
      AttendanceTableData,
      BaseReferences<_$BaseSqlLocal, $AttendanceTableTable, AttendanceTableData>
    ),
    AttendanceTableData,
    PrefetchHooks Function()> {
  $$AttendanceTableTableTableManager(
      _$BaseSqlLocal db, $AttendanceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<AttendanceType> type = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<BigInt> timestamp = const Value.absent(),
            Value<String> hash = const Value.absent(),
            Value<String> previousHash = const Value.absent(),
            Value<int> nonce = const Value.absent(),
          }) =>
              AttendanceTableCompanion(
            id: id,
            userId: userId,
            latitude: latitude,
            longitude: longitude,
            type: type,
            date: date,
            timestamp: timestamp,
            hash: hash,
            previousHash: previousHash,
            nonce: nonce,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required double latitude,
            required double longitude,
            required AttendanceType type,
            required String date,
            required BigInt timestamp,
            required String hash,
            required String previousHash,
            required int nonce,
          }) =>
              AttendanceTableCompanion.insert(
            id: id,
            userId: userId,
            latitude: latitude,
            longitude: longitude,
            type: type,
            date: date,
            timestamp: timestamp,
            hash: hash,
            previousHash: previousHash,
            nonce: nonce,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttendanceTableTableProcessedTableManager = ProcessedTableManager<
    _$BaseSqlLocal,
    $AttendanceTableTable,
    AttendanceTableData,
    $$AttendanceTableTableFilterComposer,
    $$AttendanceTableTableOrderingComposer,
    $$AttendanceTableTableAnnotationComposer,
    $$AttendanceTableTableCreateCompanionBuilder,
    $$AttendanceTableTableUpdateCompanionBuilder,
    (
      AttendanceTableData,
      BaseReferences<_$BaseSqlLocal, $AttendanceTableTable, AttendanceTableData>
    ),
    AttendanceTableData,
    PrefetchHooks Function()>;

class $BaseSqlLocalManager {
  final _$BaseSqlLocal _db;
  $BaseSqlLocalManager(this._db);
  $$AttendanceTableTableTableManager get attendanceTable =>
      $$AttendanceTableTableTableManager(_db, _db.attendanceTable);
}
