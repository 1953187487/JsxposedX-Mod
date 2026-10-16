// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_database.dart';

// ignore_for_file: type=lint
class $AiProviderConnectionsTable extends AiProviderConnections
    with TableInfo<$AiProviderConnectionsTable, AiProviderConnection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiProviderConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  List<GeneratedColumn> get $columns => [id, payloadJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_provider_connections';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiProviderConnection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
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
  AiProviderConnection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiProviderConnection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AiProviderConnectionsTable createAlias(String alias) {
    return $AiProviderConnectionsTable(attachedDatabase, alias);
  }
}

class AiProviderConnection extends DataClass
    implements Insertable<AiProviderConnection> {
  final String id;
  final String payloadJson;
  final DateTime updatedAt;
  const AiProviderConnection({
    required this.id,
    required this.payloadJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload_json'] = Variable<String>(payloadJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AiProviderConnectionsCompanion toCompanion(bool nullToAbsent) {
    return AiProviderConnectionsCompanion(
      id: Value(id),
      payloadJson: Value(payloadJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AiProviderConnection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiProviderConnection(
      id: serializer.fromJson<String>(json['id']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AiProviderConnection copyWith({
    String? id,
    String? payloadJson,
    DateTime? updatedAt,
  }) => AiProviderConnection(
    id: id ?? this.id,
    payloadJson: payloadJson ?? this.payloadJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AiProviderConnection copyWithCompanion(AiProviderConnectionsCompanion data) {
    return AiProviderConnection(
      id: data.id.present ? data.id.value : this.id,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiProviderConnection(')
          ..write('id: $id, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payloadJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiProviderConnection &&
          other.id == this.id &&
          other.payloadJson == this.payloadJson &&
          other.updatedAt == this.updatedAt);
}

class AiProviderConnectionsCompanion
    extends UpdateCompanion<AiProviderConnection> {
  final Value<String> id;
  final Value<String> payloadJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AiProviderConnectionsCompanion({
    this.id = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiProviderConnectionsCompanion.insert({
    required String id,
    required String payloadJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payloadJson = Value(payloadJson),
       updatedAt = Value(updatedAt);
  static Insertable<AiProviderConnection> custom({
    Expression<String>? id,
    Expression<String>? payloadJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiProviderConnectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? payloadJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AiProviderConnectionsCompanion(
      id: id ?? this.id,
      payloadJson: payloadJson ?? this.payloadJson,
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
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
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
    return (StringBuffer('AiProviderConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiModelDefinitionsTable extends AiModelDefinitions
    with TableInfo<$AiModelDefinitionsTable, AiModelDefinition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiModelDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _connectionIdMeta = const VerificationMeta(
    'connectionId',
  );
  @override
  late final GeneratedColumn<String> connectionId = GeneratedColumn<String>(
    'connection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    connectionId,
    modelId,
    payloadJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_model_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiModelDefinition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('connection_id')) {
      context.handle(
        _connectionIdMeta,
        connectionId.isAcceptableOrUnknown(
          data['connection_id']!,
          _connectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
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
  Set<GeneratedColumn> get $primaryKey => {connectionId, modelId};
  @override
  AiModelDefinition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiModelDefinition(
      connectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection_id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AiModelDefinitionsTable createAlias(String alias) {
    return $AiModelDefinitionsTable(attachedDatabase, alias);
  }
}

class AiModelDefinition extends DataClass
    implements Insertable<AiModelDefinition> {
  final String connectionId;
  final String modelId;
  final String payloadJson;
  final DateTime updatedAt;
  const AiModelDefinition({
    required this.connectionId,
    required this.modelId,
    required this.payloadJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['connection_id'] = Variable<String>(connectionId);
    map['model_id'] = Variable<String>(modelId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AiModelDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return AiModelDefinitionsCompanion(
      connectionId: Value(connectionId),
      modelId: Value(modelId),
      payloadJson: Value(payloadJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AiModelDefinition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiModelDefinition(
      connectionId: serializer.fromJson<String>(json['connectionId']),
      modelId: serializer.fromJson<String>(json['modelId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'connectionId': serializer.toJson<String>(connectionId),
      'modelId': serializer.toJson<String>(modelId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AiModelDefinition copyWith({
    String? connectionId,
    String? modelId,
    String? payloadJson,
    DateTime? updatedAt,
  }) => AiModelDefinition(
    connectionId: connectionId ?? this.connectionId,
    modelId: modelId ?? this.modelId,
    payloadJson: payloadJson ?? this.payloadJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AiModelDefinition copyWithCompanion(AiModelDefinitionsCompanion data) {
    return AiModelDefinition(
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiModelDefinition(')
          ..write('connectionId: $connectionId, ')
          ..write('modelId: $modelId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(connectionId, modelId, payloadJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiModelDefinition &&
          other.connectionId == this.connectionId &&
          other.modelId == this.modelId &&
          other.payloadJson == this.payloadJson &&
          other.updatedAt == this.updatedAt);
}

class AiModelDefinitionsCompanion extends UpdateCompanion<AiModelDefinition> {
  final Value<String> connectionId;
  final Value<String> modelId;
  final Value<String> payloadJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AiModelDefinitionsCompanion({
    this.connectionId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiModelDefinitionsCompanion.insert({
    required String connectionId,
    required String modelId,
    required String payloadJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : connectionId = Value(connectionId),
       modelId = Value(modelId),
       payloadJson = Value(payloadJson),
       updatedAt = Value(updatedAt);
  static Insertable<AiModelDefinition> custom({
    Expression<String>? connectionId,
    Expression<String>? modelId,
    Expression<String>? payloadJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (connectionId != null) 'connection_id': connectionId,
      if (modelId != null) 'model_id': modelId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiModelDefinitionsCompanion copyWith({
    Value<String>? connectionId,
    Value<String>? modelId,
    Value<String>? payloadJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AiModelDefinitionsCompanion(
      connectionId: connectionId ?? this.connectionId,
      modelId: modelId ?? this.modelId,
      payloadJson: payloadJson ?? this.payloadJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (connectionId.present) {
      map['connection_id'] = Variable<String>(connectionId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
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
    return (StringBuffer('AiModelDefinitionsCompanion(')
          ..write('connectionId: $connectionId, ')
          ..write('modelId: $modelId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiAssistantProfilesTable extends AiAssistantProfiles
    with TableInfo<$AiAssistantProfilesTable, AiAssistantProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiAssistantProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectionIdMeta = const VerificationMeta(
    'connectionId',
  );
  @override
  late final GeneratedColumn<String> connectionId = GeneratedColumn<String>(
    'connection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    connectionId,
    modelId,
    payloadJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_assistant_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiAssistantProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('connection_id')) {
      context.handle(
        _connectionIdMeta,
        connectionId.isAcceptableOrUnknown(
          data['connection_id']!,
          _connectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
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
  AiAssistantProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiAssistantProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      connectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection_id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AiAssistantProfilesTable createAlias(String alias) {
    return $AiAssistantProfilesTable(attachedDatabase, alias);
  }
}

class AiAssistantProfile extends DataClass
    implements Insertable<AiAssistantProfile> {
  final String id;
  final String connectionId;
  final String modelId;
  final String payloadJson;
  final DateTime updatedAt;
  const AiAssistantProfile({
    required this.id,
    required this.connectionId,
    required this.modelId,
    required this.payloadJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['connection_id'] = Variable<String>(connectionId);
    map['model_id'] = Variable<String>(modelId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AiAssistantProfilesCompanion toCompanion(bool nullToAbsent) {
    return AiAssistantProfilesCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      modelId: Value(modelId),
      payloadJson: Value(payloadJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AiAssistantProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiAssistantProfile(
      id: serializer.fromJson<String>(json['id']),
      connectionId: serializer.fromJson<String>(json['connectionId']),
      modelId: serializer.fromJson<String>(json['modelId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'connectionId': serializer.toJson<String>(connectionId),
      'modelId': serializer.toJson<String>(modelId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AiAssistantProfile copyWith({
    String? id,
    String? connectionId,
    String? modelId,
    String? payloadJson,
    DateTime? updatedAt,
  }) => AiAssistantProfile(
    id: id ?? this.id,
    connectionId: connectionId ?? this.connectionId,
    modelId: modelId ?? this.modelId,
    payloadJson: payloadJson ?? this.payloadJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AiAssistantProfile copyWithCompanion(AiAssistantProfilesCompanion data) {
    return AiAssistantProfile(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiAssistantProfile(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('modelId: $modelId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, modelId, payloadJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiAssistantProfile &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.modelId == this.modelId &&
          other.payloadJson == this.payloadJson &&
          other.updatedAt == this.updatedAt);
}

class AiAssistantProfilesCompanion extends UpdateCompanion<AiAssistantProfile> {
  final Value<String> id;
  final Value<String> connectionId;
  final Value<String> modelId;
  final Value<String> payloadJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AiAssistantProfilesCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiAssistantProfilesCompanion.insert({
    required String id,
    required String connectionId,
    required String modelId,
    required String payloadJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       connectionId = Value(connectionId),
       modelId = Value(modelId),
       payloadJson = Value(payloadJson),
       updatedAt = Value(updatedAt);
  static Insertable<AiAssistantProfile> custom({
    Expression<String>? id,
    Expression<String>? connectionId,
    Expression<String>? modelId,
    Expression<String>? payloadJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (modelId != null) 'model_id': modelId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiAssistantProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? connectionId,
    Value<String>? modelId,
    Value<String>? payloadJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AiAssistantProfilesCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      modelId: modelId ?? this.modelId,
      payloadJson: payloadJson ?? this.payloadJson,
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
    if (connectionId.present) {
      map['connection_id'] = Variable<String>(connectionId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
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
    return (StringBuffer('AiAssistantProfilesCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('modelId: $modelId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiConversationsTable extends AiConversations
    with TableInfo<$AiConversationsTable, AiConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assistantIdMeta = const VerificationMeta(
    'assistantId',
  );
  @override
  late final GeneratedColumn<String> assistantId = GeneratedColumn<String>(
    'assistant_id',
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assistantId,
    title,
    createdAt,
    updatedAt,
    archivedAt,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('assistant_id')) {
      context.handle(
        _assistantIdMeta,
        assistantId.isAcceptableOrUnknown(
          data['assistant_id']!,
          _assistantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assistantIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiConversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      assistantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assistant_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $AiConversationsTable createAlias(String alias) {
    return $AiConversationsTable(attachedDatabase, alias);
  }
}

class AiConversation extends DataClass implements Insertable<AiConversation> {
  final String id;
  final String assistantId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String payloadJson;
  const AiConversation({
    required this.id,
    required this.assistantId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['assistant_id'] = Variable<String>(assistantId);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  AiConversationsCompanion toCompanion(bool nullToAbsent) {
    return AiConversationsCompanion(
      id: Value(id),
      assistantId: Value(assistantId),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      payloadJson: Value(payloadJson),
    );
  }

  factory AiConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiConversation(
      id: serializer.fromJson<String>(json['id']),
      assistantId: serializer.fromJson<String>(json['assistantId']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assistantId': serializer.toJson<String>(assistantId),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  AiConversation copyWith({
    String? id,
    String? assistantId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? payloadJson,
  }) => AiConversation(
    id: id ?? this.id,
    assistantId: assistantId ?? this.assistantId,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  AiConversation copyWithCompanion(AiConversationsCompanion data) {
    return AiConversation(
      id: data.id.present ? data.id.value : this.id,
      assistantId: data.assistantId.present
          ? data.assistantId.value
          : this.assistantId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiConversation(')
          ..write('id: $id, ')
          ..write('assistantId: $assistantId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    assistantId,
    title,
    createdAt,
    updatedAt,
    archivedAt,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiConversation &&
          other.id == this.id &&
          other.assistantId == this.assistantId &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.payloadJson == this.payloadJson);
}

class AiConversationsCompanion extends UpdateCompanion<AiConversation> {
  final Value<String> id;
  final Value<String> assistantId;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const AiConversationsCompanion({
    this.id = const Value.absent(),
    this.assistantId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiConversationsCompanion.insert({
    required String id,
    required String assistantId,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assistantId = Value(assistantId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       payloadJson = Value(payloadJson);
  static Insertable<AiConversation> custom({
    Expression<String>? id,
    Expression<String>? assistantId,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assistantId != null) 'assistant_id': assistantId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? assistantId,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return AiConversationsCompanion(
      id: id ?? this.id,
      assistantId: assistantId ?? this.assistantId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assistantId.present) {
      map['assistant_id'] = Variable<String>(assistantId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiConversationsCompanion(')
          ..write('id: $id, ')
          ..write('assistantId: $assistantId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiMessageRecordsTable extends AiMessageRecords
    with TableInfo<$AiMessageRecordsTable, AiMessageRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiMessageRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    createdAt,
    status,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_message_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiMessageRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiMessageRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiMessageRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $AiMessageRecordsTable createAlias(String alias) {
    return $AiMessageRecordsTable(attachedDatabase, alias);
  }
}

class AiMessageRecord extends DataClass implements Insertable<AiMessageRecord> {
  final String id;
  final String conversationId;
  final DateTime createdAt;
  final String status;
  final String payloadJson;
  const AiMessageRecord({
    required this.id,
    required this.conversationId,
    required this.createdAt,
    required this.status,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  AiMessageRecordsCompanion toCompanion(bool nullToAbsent) {
    return AiMessageRecordsCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      createdAt: Value(createdAt),
      status: Value(status),
      payloadJson: Value(payloadJson),
    );
  }

  factory AiMessageRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiMessageRecord(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  AiMessageRecord copyWith({
    String? id,
    String? conversationId,
    DateTime? createdAt,
    String? status,
    String? payloadJson,
  }) => AiMessageRecord(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  AiMessageRecord copyWithCompanion(AiMessageRecordsCompanion data) {
    return AiMessageRecord(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiMessageRecord(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, conversationId, createdAt, status, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiMessageRecord &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.payloadJson == this.payloadJson);
}

class AiMessageRecordsCompanion extends UpdateCompanion<AiMessageRecord> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const AiMessageRecordsCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiMessageRecordsCompanion.insert({
    required String id,
    required String conversationId,
    required DateTime createdAt,
    required String status,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       createdAt = Value(createdAt),
       status = Value(status),
       payloadJson = Value(payloadJson);
  static Insertable<AiMessageRecord> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiMessageRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return AiMessageRecordsCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiMessageRecordsCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiConversationContextsTable extends AiConversationContexts
    with TableInfo<$AiConversationContextsTable, AiConversationContext> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiConversationContextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextVersionMeta = const VerificationMeta(
    'contextVersion',
  );
  @override
  late final GeneratedColumn<int> contextVersion = GeneratedColumn<int>(
    'context_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    conversationId,
    contextVersion,
    payloadJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_conversation_contexts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiConversationContext> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('context_version')) {
      context.handle(
        _contextVersionMeta,
        contextVersion.isAcceptableOrUnknown(
          data['context_version']!,
          _contextVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextVersionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
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
  Set<GeneratedColumn> get $primaryKey => {conversationId};
  @override
  AiConversationContext map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiConversationContext(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      contextVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}context_version'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AiConversationContextsTable createAlias(String alias) {
    return $AiConversationContextsTable(attachedDatabase, alias);
  }
}

class AiConversationContext extends DataClass
    implements Insertable<AiConversationContext> {
  final String conversationId;
  final int contextVersion;
  final String payloadJson;
  final DateTime updatedAt;
  const AiConversationContext({
    required this.conversationId,
    required this.contextVersion,
    required this.payloadJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['context_version'] = Variable<int>(contextVersion);
    map['payload_json'] = Variable<String>(payloadJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AiConversationContextsCompanion toCompanion(bool nullToAbsent) {
    return AiConversationContextsCompanion(
      conversationId: Value(conversationId),
      contextVersion: Value(contextVersion),
      payloadJson: Value(payloadJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AiConversationContext.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiConversationContext(
      conversationId: serializer.fromJson<String>(json['conversationId']),
      contextVersion: serializer.fromJson<int>(json['contextVersion']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<String>(conversationId),
      'contextVersion': serializer.toJson<int>(contextVersion),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AiConversationContext copyWith({
    String? conversationId,
    int? contextVersion,
    String? payloadJson,
    DateTime? updatedAt,
  }) => AiConversationContext(
    conversationId: conversationId ?? this.conversationId,
    contextVersion: contextVersion ?? this.contextVersion,
    payloadJson: payloadJson ?? this.payloadJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AiConversationContext copyWithCompanion(
    AiConversationContextsCompanion data,
  ) {
    return AiConversationContext(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      contextVersion: data.contextVersion.present
          ? data.contextVersion.value
          : this.contextVersion,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiConversationContext(')
          ..write('conversationId: $conversationId, ')
          ..write('contextVersion: $contextVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(conversationId, contextVersion, payloadJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiConversationContext &&
          other.conversationId == this.conversationId &&
          other.contextVersion == this.contextVersion &&
          other.payloadJson == this.payloadJson &&
          other.updatedAt == this.updatedAt);
}

class AiConversationContextsCompanion
    extends UpdateCompanion<AiConversationContext> {
  final Value<String> conversationId;
  final Value<int> contextVersion;
  final Value<String> payloadJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AiConversationContextsCompanion({
    this.conversationId = const Value.absent(),
    this.contextVersion = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiConversationContextsCompanion.insert({
    required String conversationId,
    required int contextVersion,
    required String payloadJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       contextVersion = Value(contextVersion),
       payloadJson = Value(payloadJson),
       updatedAt = Value(updatedAt);
  static Insertable<AiConversationContext> custom({
    Expression<String>? conversationId,
    Expression<int>? contextVersion,
    Expression<String>? payloadJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (contextVersion != null) 'context_version': contextVersion,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiConversationContextsCompanion copyWith({
    Value<String>? conversationId,
    Value<int>? contextVersion,
    Value<String>? payloadJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AiConversationContextsCompanion(
      conversationId: conversationId ?? this.conversationId,
      contextVersion: contextVersion ?? this.contextVersion,
      payloadJson: payloadJson ?? this.payloadJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (contextVersion.present) {
      map['context_version'] = Variable<int>(contextVersion.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
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
    return (StringBuffer('AiConversationContextsCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('contextVersion: $contextVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScriptRunsTable extends ScriptRuns
    with TableInfo<$ScriptRunsTable, ScriptRun> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScriptRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
    'run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scriptNameMeta = const VerificationMeta(
    'scriptName',
  );
  @override
  late final GeneratedColumn<String> scriptName = GeneratedColumn<String>(
    'script_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    runId,
    conversationId,
    source,
    scriptName,
    startedAt,
    finishedAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'script_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScriptRun> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('run_id')) {
      context.handle(
        _runIdMeta,
        runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta),
      );
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('script_name')) {
      context.handle(
        _scriptNameMeta,
        scriptName.isAcceptableOrUnknown(data['script_name']!, _scriptNameMeta),
      );
    } else if (isInserting) {
      context.missing(_scriptNameMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {runId};
  @override
  ScriptRun map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScriptRun(
      runId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}run_id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      scriptName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}script_name'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ScriptRunsTable createAlias(String alias) {
    return $ScriptRunsTable(attachedDatabase, alias);
  }
}

class ScriptRun extends DataClass implements Insertable<ScriptRun> {
  final String runId;
  final String conversationId;
  final String source;
  final String scriptName;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String status;
  const ScriptRun({
    required this.runId,
    required this.conversationId,
    required this.source,
    required this.scriptName,
    required this.startedAt,
    this.finishedAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['run_id'] = Variable<String>(runId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['source'] = Variable<String>(source);
    map['script_name'] = Variable<String>(scriptName);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ScriptRunsCompanion toCompanion(bool nullToAbsent) {
    return ScriptRunsCompanion(
      runId: Value(runId),
      conversationId: Value(conversationId),
      source: Value(source),
      scriptName: Value(scriptName),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      status: Value(status),
    );
  }

  factory ScriptRun.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScriptRun(
      runId: serializer.fromJson<String>(json['runId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      source: serializer.fromJson<String>(json['source']),
      scriptName: serializer.fromJson<String>(json['scriptName']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'runId': serializer.toJson<String>(runId),
      'conversationId': serializer.toJson<String>(conversationId),
      'source': serializer.toJson<String>(source),
      'scriptName': serializer.toJson<String>(scriptName),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'status': serializer.toJson<String>(status),
    };
  }

  ScriptRun copyWith({
    String? runId,
    String? conversationId,
    String? source,
    String? scriptName,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    String? status,
  }) => ScriptRun(
    runId: runId ?? this.runId,
    conversationId: conversationId ?? this.conversationId,
    source: source ?? this.source,
    scriptName: scriptName ?? this.scriptName,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    status: status ?? this.status,
  );
  ScriptRun copyWithCompanion(ScriptRunsCompanion data) {
    return ScriptRun(
      runId: data.runId.present ? data.runId.value : this.runId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      source: data.source.present ? data.source.value : this.source,
      scriptName: data.scriptName.present
          ? data.scriptName.value
          : this.scriptName,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScriptRun(')
          ..write('runId: $runId, ')
          ..write('conversationId: $conversationId, ')
          ..write('source: $source, ')
          ..write('scriptName: $scriptName, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    runId,
    conversationId,
    source,
    scriptName,
    startedAt,
    finishedAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScriptRun &&
          other.runId == this.runId &&
          other.conversationId == this.conversationId &&
          other.source == this.source &&
          other.scriptName == this.scriptName &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.status == this.status);
}

class ScriptRunsCompanion extends UpdateCompanion<ScriptRun> {
  final Value<String> runId;
  final Value<String> conversationId;
  final Value<String> source;
  final Value<String> scriptName;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<String> status;
  final Value<int> rowid;
  const ScriptRunsCompanion({
    this.runId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.source = const Value.absent(),
    this.scriptName = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScriptRunsCompanion.insert({
    required String runId,
    required String conversationId,
    required String source,
    required String scriptName,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : runId = Value(runId),
       conversationId = Value(conversationId),
       source = Value(source),
       scriptName = Value(scriptName),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<ScriptRun> custom({
    Expression<String>? runId,
    Expression<String>? conversationId,
    Expression<String>? source,
    Expression<String>? scriptName,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (runId != null) 'run_id': runId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (source != null) 'source': source,
      if (scriptName != null) 'script_name': scriptName,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScriptRunsCompanion copyWith({
    Value<String>? runId,
    Value<String>? conversationId,
    Value<String>? source,
    Value<String>? scriptName,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ScriptRunsCompanion(
      runId: runId ?? this.runId,
      conversationId: conversationId ?? this.conversationId,
      source: source ?? this.source,
      scriptName: scriptName ?? this.scriptName,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (scriptName.present) {
      map['script_name'] = Variable<String>(scriptName.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScriptRunsCompanion(')
          ..write('runId: $runId, ')
          ..write('conversationId: $conversationId, ')
          ..write('source: $source, ')
          ..write('scriptName: $scriptName, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScriptLogsTable extends ScriptLogs
    with TableInfo<$ScriptLogsTable, ScriptLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScriptLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
    'run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scriptNameMeta = const VerificationMeta(
    'scriptName',
  );
  @override
  late final GeneratedColumn<String> scriptName = GeneratedColumn<String>(
    'script_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stackTraceMeta = const VerificationMeta(
    'stackTrace',
  );
  @override
  late final GeneratedColumn<String> stackTrace = GeneratedColumn<String>(
    'stack_trace',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    runId,
    conversationId,
    source,
    scriptName,
    level,
    message,
    stackTrace,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'script_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScriptLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('run_id')) {
      context.handle(
        _runIdMeta,
        runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta),
      );
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('script_name')) {
      context.handle(
        _scriptNameMeta,
        scriptName.isAcceptableOrUnknown(data['script_name']!, _scriptNameMeta),
      );
    } else if (isInserting) {
      context.missing(_scriptNameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('stack_trace')) {
      context.handle(
        _stackTraceMeta,
        stackTrace.isAcceptableOrUnknown(data['stack_trace']!, _stackTraceMeta),
      );
    } else if (isInserting) {
      context.missing(_stackTraceMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScriptLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScriptLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      runId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}run_id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      scriptName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}script_name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      stackTrace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stack_trace'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ScriptLogsTable createAlias(String alias) {
    return $ScriptLogsTable(attachedDatabase, alias);
  }
}

class ScriptLog extends DataClass implements Insertable<ScriptLog> {
  final int id;
  final String runId;
  final String conversationId;
  final String source;
  final String scriptName;
  final String level;
  final String message;
  final String stackTrace;
  final DateTime timestamp;
  const ScriptLog({
    required this.id,
    required this.runId,
    required this.conversationId,
    required this.source,
    required this.scriptName,
    required this.level,
    required this.message,
    required this.stackTrace,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['run_id'] = Variable<String>(runId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['source'] = Variable<String>(source);
    map['script_name'] = Variable<String>(scriptName);
    map['level'] = Variable<String>(level);
    map['message'] = Variable<String>(message);
    map['stack_trace'] = Variable<String>(stackTrace);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ScriptLogsCompanion toCompanion(bool nullToAbsent) {
    return ScriptLogsCompanion(
      id: Value(id),
      runId: Value(runId),
      conversationId: Value(conversationId),
      source: Value(source),
      scriptName: Value(scriptName),
      level: Value(level),
      message: Value(message),
      stackTrace: Value(stackTrace),
      timestamp: Value(timestamp),
    );
  }

  factory ScriptLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScriptLog(
      id: serializer.fromJson<int>(json['id']),
      runId: serializer.fromJson<String>(json['runId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      source: serializer.fromJson<String>(json['source']),
      scriptName: serializer.fromJson<String>(json['scriptName']),
      level: serializer.fromJson<String>(json['level']),
      message: serializer.fromJson<String>(json['message']),
      stackTrace: serializer.fromJson<String>(json['stackTrace']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'runId': serializer.toJson<String>(runId),
      'conversationId': serializer.toJson<String>(conversationId),
      'source': serializer.toJson<String>(source),
      'scriptName': serializer.toJson<String>(scriptName),
      'level': serializer.toJson<String>(level),
      'message': serializer.toJson<String>(message),
      'stackTrace': serializer.toJson<String>(stackTrace),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ScriptLog copyWith({
    int? id,
    String? runId,
    String? conversationId,
    String? source,
    String? scriptName,
    String? level,
    String? message,
    String? stackTrace,
    DateTime? timestamp,
  }) => ScriptLog(
    id: id ?? this.id,
    runId: runId ?? this.runId,
    conversationId: conversationId ?? this.conversationId,
    source: source ?? this.source,
    scriptName: scriptName ?? this.scriptName,
    level: level ?? this.level,
    message: message ?? this.message,
    stackTrace: stackTrace ?? this.stackTrace,
    timestamp: timestamp ?? this.timestamp,
  );
  ScriptLog copyWithCompanion(ScriptLogsCompanion data) {
    return ScriptLog(
      id: data.id.present ? data.id.value : this.id,
      runId: data.runId.present ? data.runId.value : this.runId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      source: data.source.present ? data.source.value : this.source,
      scriptName: data.scriptName.present
          ? data.scriptName.value
          : this.scriptName,
      level: data.level.present ? data.level.value : this.level,
      message: data.message.present ? data.message.value : this.message,
      stackTrace: data.stackTrace.present
          ? data.stackTrace.value
          : this.stackTrace,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScriptLog(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('conversationId: $conversationId, ')
          ..write('source: $source, ')
          ..write('scriptName: $scriptName, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    runId,
    conversationId,
    source,
    scriptName,
    level,
    message,
    stackTrace,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScriptLog &&
          other.id == this.id &&
          other.runId == this.runId &&
          other.conversationId == this.conversationId &&
          other.source == this.source &&
          other.scriptName == this.scriptName &&
          other.level == this.level &&
          other.message == this.message &&
          other.stackTrace == this.stackTrace &&
          other.timestamp == this.timestamp);
}

class ScriptLogsCompanion extends UpdateCompanion<ScriptLog> {
  final Value<int> id;
  final Value<String> runId;
  final Value<String> conversationId;
  final Value<String> source;
  final Value<String> scriptName;
  final Value<String> level;
  final Value<String> message;
  final Value<String> stackTrace;
  final Value<DateTime> timestamp;
  const ScriptLogsCompanion({
    this.id = const Value.absent(),
    this.runId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.source = const Value.absent(),
    this.scriptName = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.stackTrace = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ScriptLogsCompanion.insert({
    this.id = const Value.absent(),
    required String runId,
    required String conversationId,
    required String source,
    required String scriptName,
    required String level,
    required String message,
    required String stackTrace,
    required DateTime timestamp,
  }) : runId = Value(runId),
       conversationId = Value(conversationId),
       source = Value(source),
       scriptName = Value(scriptName),
       level = Value(level),
       message = Value(message),
       stackTrace = Value(stackTrace),
       timestamp = Value(timestamp);
  static Insertable<ScriptLog> custom({
    Expression<int>? id,
    Expression<String>? runId,
    Expression<String>? conversationId,
    Expression<String>? source,
    Expression<String>? scriptName,
    Expression<String>? level,
    Expression<String>? message,
    Expression<String>? stackTrace,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runId != null) 'run_id': runId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (source != null) 'source': source,
      if (scriptName != null) 'script_name': scriptName,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (stackTrace != null) 'stack_trace': stackTrace,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ScriptLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? runId,
    Value<String>? conversationId,
    Value<String>? source,
    Value<String>? scriptName,
    Value<String>? level,
    Value<String>? message,
    Value<String>? stackTrace,
    Value<DateTime>? timestamp,
  }) {
    return ScriptLogsCompanion(
      id: id ?? this.id,
      runId: runId ?? this.runId,
      conversationId: conversationId ?? this.conversationId,
      source: source ?? this.source,
      scriptName: scriptName ?? this.scriptName,
      level: level ?? this.level,
      message: message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (scriptName.present) {
      map['script_name'] = Variable<String>(scriptName.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (stackTrace.present) {
      map['stack_trace'] = Variable<String>(stackTrace.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScriptLogsCompanion(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('conversationId: $conversationId, ')
          ..write('source: $source, ')
          ..write('scriptName: $scriptName, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AiDatabase extends GeneratedDatabase {
  _$AiDatabase(QueryExecutor e) : super(e);
  $AiDatabaseManager get managers => $AiDatabaseManager(this);
  late final $AiProviderConnectionsTable aiProviderConnections =
      $AiProviderConnectionsTable(this);
  late final $AiModelDefinitionsTable aiModelDefinitions =
      $AiModelDefinitionsTable(this);
  late final $AiAssistantProfilesTable aiAssistantProfiles =
      $AiAssistantProfilesTable(this);
  late final $AiConversationsTable aiConversations = $AiConversationsTable(
    this,
  );
  late final $AiMessageRecordsTable aiMessageRecords = $AiMessageRecordsTable(
    this,
  );
  late final $AiConversationContextsTable aiConversationContexts =
      $AiConversationContextsTable(this);
  late final $ScriptRunsTable scriptRuns = $ScriptRunsTable(this);
  late final $ScriptLogsTable scriptLogs = $ScriptLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    aiProviderConnections,
    aiModelDefinitions,
    aiAssistantProfiles,
    aiConversations,
    aiMessageRecords,
    aiConversationContexts,
    scriptRuns,
    scriptLogs,
  ];
}

typedef $$AiProviderConnectionsTableCreateCompanionBuilder =
    AiProviderConnectionsCompanion Function({
      required String id,
      required String payloadJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AiProviderConnectionsTableUpdateCompanionBuilder =
    AiProviderConnectionsCompanion Function({
      Value<String> id,
      Value<String> payloadJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AiProviderConnectionsTableFilterComposer
    extends Composer<_$AiDatabase, $AiProviderConnectionsTable> {
  $$AiProviderConnectionsTableFilterComposer({
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

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiProviderConnectionsTableOrderingComposer
    extends Composer<_$AiDatabase, $AiProviderConnectionsTable> {
  $$AiProviderConnectionsTableOrderingComposer({
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

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiProviderConnectionsTableAnnotationComposer
    extends Composer<_$AiDatabase, $AiProviderConnectionsTable> {
  $$AiProviderConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AiProviderConnectionsTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $AiProviderConnectionsTable,
          AiProviderConnection,
          $$AiProviderConnectionsTableFilterComposer,
          $$AiProviderConnectionsTableOrderingComposer,
          $$AiProviderConnectionsTableAnnotationComposer,
          $$AiProviderConnectionsTableCreateCompanionBuilder,
          $$AiProviderConnectionsTableUpdateCompanionBuilder,
          (
            AiProviderConnection,
            BaseReferences<
              _$AiDatabase,
              $AiProviderConnectionsTable,
              AiProviderConnection
            >,
          ),
          AiProviderConnection,
          PrefetchHooks Function()
        > {
  $$AiProviderConnectionsTableTableManager(
    _$AiDatabase db,
    $AiProviderConnectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiProviderConnectionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AiProviderConnectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiProviderConnectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiProviderConnectionsCompanion(
                id: id,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payloadJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AiProviderConnectionsCompanion.insert(
                id: id,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiProviderConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $AiProviderConnectionsTable,
      AiProviderConnection,
      $$AiProviderConnectionsTableFilterComposer,
      $$AiProviderConnectionsTableOrderingComposer,
      $$AiProviderConnectionsTableAnnotationComposer,
      $$AiProviderConnectionsTableCreateCompanionBuilder,
      $$AiProviderConnectionsTableUpdateCompanionBuilder,
      (
        AiProviderConnection,
        BaseReferences<
          _$AiDatabase,
          $AiProviderConnectionsTable,
          AiProviderConnection
        >,
      ),
      AiProviderConnection,
      PrefetchHooks Function()
    >;
typedef $$AiModelDefinitionsTableCreateCompanionBuilder =
    AiModelDefinitionsCompanion Function({
      required String connectionId,
      required String modelId,
      required String payloadJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AiModelDefinitionsTableUpdateCompanionBuilder =
    AiModelDefinitionsCompanion Function({
      Value<String> connectionId,
      Value<String> modelId,
      Value<String> payloadJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AiModelDefinitionsTableFilterComposer
    extends Composer<_$AiDatabase, $AiModelDefinitionsTable> {
  $$AiModelDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get connectionId => $composableBuilder(
    column: $table.connectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiModelDefinitionsTableOrderingComposer
    extends Composer<_$AiDatabase, $AiModelDefinitionsTable> {
  $$AiModelDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get connectionId => $composableBuilder(
    column: $table.connectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiModelDefinitionsTableAnnotationComposer
    extends Composer<_$AiDatabase, $AiModelDefinitionsTable> {
  $$AiModelDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get connectionId => $composableBuilder(
    column: $table.connectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AiModelDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $AiModelDefinitionsTable,
          AiModelDefinition,
          $$AiModelDefinitionsTableFilterComposer,
          $$AiModelDefinitionsTableOrderingComposer,
          $$AiModelDefinitionsTableAnnotationComposer,
          $$AiModelDefinitionsTableCreateCompanionBuilder,
          $$AiModelDefinitionsTableUpdateCompanionBuilder,
          (
            AiModelDefinition,
            BaseReferences<
              _$AiDatabase,
              $AiModelDefinitionsTable,
              AiModelDefinition
            >,
          ),
          AiModelDefinition,
          PrefetchHooks Function()
        > {
  $$AiModelDefinitionsTableTableManager(
    _$AiDatabase db,
    $AiModelDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiModelDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiModelDefinitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiModelDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> connectionId = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiModelDefinitionsCompanion(
                connectionId: connectionId,
                modelId: modelId,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String connectionId,
                required String modelId,
                required String payloadJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AiModelDefinitionsCompanion.insert(
                connectionId: connectionId,
                modelId: modelId,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiModelDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $AiModelDefinitionsTable,
      AiModelDefinition,
      $$AiModelDefinitionsTableFilterComposer,
      $$AiModelDefinitionsTableOrderingComposer,
      $$AiModelDefinitionsTableAnnotationComposer,
      $$AiModelDefinitionsTableCreateCompanionBuilder,
      $$AiModelDefinitionsTableUpdateCompanionBuilder,
      (
        AiModelDefinition,
        BaseReferences<
          _$AiDatabase,
          $AiModelDefinitionsTable,
          AiModelDefinition
        >,
      ),
      AiModelDefinition,
      PrefetchHooks Function()
    >;
typedef $$AiAssistantProfilesTableCreateCompanionBuilder =
    AiAssistantProfilesCompanion Function({
      required String id,
      required String connectionId,
      required String modelId,
      required String payloadJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AiAssistantProfilesTableUpdateCompanionBuilder =
    AiAssistantProfilesCompanion Function({
      Value<String> id,
      Value<String> connectionId,
      Value<String> modelId,
      Value<String> payloadJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AiAssistantProfilesTableFilterComposer
    extends Composer<_$AiDatabase, $AiAssistantProfilesTable> {
  $$AiAssistantProfilesTableFilterComposer({
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

  ColumnFilters<String> get connectionId => $composableBuilder(
    column: $table.connectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiAssistantProfilesTableOrderingComposer
    extends Composer<_$AiDatabase, $AiAssistantProfilesTable> {
  $$AiAssistantProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get connectionId => $composableBuilder(
    column: $table.connectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiAssistantProfilesTableAnnotationComposer
    extends Composer<_$AiDatabase, $AiAssistantProfilesTable> {
  $$AiAssistantProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get connectionId => $composableBuilder(
    column: $table.connectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AiAssistantProfilesTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $AiAssistantProfilesTable,
          AiAssistantProfile,
          $$AiAssistantProfilesTableFilterComposer,
          $$AiAssistantProfilesTableOrderingComposer,
          $$AiAssistantProfilesTableAnnotationComposer,
          $$AiAssistantProfilesTableCreateCompanionBuilder,
          $$AiAssistantProfilesTableUpdateCompanionBuilder,
          (
            AiAssistantProfile,
            BaseReferences<
              _$AiDatabase,
              $AiAssistantProfilesTable,
              AiAssistantProfile
            >,
          ),
          AiAssistantProfile,
          PrefetchHooks Function()
        > {
  $$AiAssistantProfilesTableTableManager(
    _$AiDatabase db,
    $AiAssistantProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiAssistantProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiAssistantProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiAssistantProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> connectionId = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiAssistantProfilesCompanion(
                id: id,
                connectionId: connectionId,
                modelId: modelId,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String connectionId,
                required String modelId,
                required String payloadJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AiAssistantProfilesCompanion.insert(
                id: id,
                connectionId: connectionId,
                modelId: modelId,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiAssistantProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $AiAssistantProfilesTable,
      AiAssistantProfile,
      $$AiAssistantProfilesTableFilterComposer,
      $$AiAssistantProfilesTableOrderingComposer,
      $$AiAssistantProfilesTableAnnotationComposer,
      $$AiAssistantProfilesTableCreateCompanionBuilder,
      $$AiAssistantProfilesTableUpdateCompanionBuilder,
      (
        AiAssistantProfile,
        BaseReferences<
          _$AiDatabase,
          $AiAssistantProfilesTable,
          AiAssistantProfile
        >,
      ),
      AiAssistantProfile,
      PrefetchHooks Function()
    >;
typedef $$AiConversationsTableCreateCompanionBuilder =
    AiConversationsCompanion Function({
      required String id,
      required String assistantId,
      required String title,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$AiConversationsTableUpdateCompanionBuilder =
    AiConversationsCompanion Function({
      Value<String> id,
      Value<String> assistantId,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> payloadJson,
      Value<int> rowid,
    });

class $$AiConversationsTableFilterComposer
    extends Composer<_$AiDatabase, $AiConversationsTable> {
  $$AiConversationsTableFilterComposer({
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

  ColumnFilters<String> get assistantId => $composableBuilder(
    column: $table.assistantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
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

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiConversationsTableOrderingComposer
    extends Composer<_$AiDatabase, $AiConversationsTable> {
  $$AiConversationsTableOrderingComposer({
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

  ColumnOrderings<String> get assistantId => $composableBuilder(
    column: $table.assistantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
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

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiConversationsTableAnnotationComposer
    extends Composer<_$AiDatabase, $AiConversationsTable> {
  $$AiConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assistantId => $composableBuilder(
    column: $table.assistantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$AiConversationsTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $AiConversationsTable,
          AiConversation,
          $$AiConversationsTableFilterComposer,
          $$AiConversationsTableOrderingComposer,
          $$AiConversationsTableAnnotationComposer,
          $$AiConversationsTableCreateCompanionBuilder,
          $$AiConversationsTableUpdateCompanionBuilder,
          (
            AiConversation,
            BaseReferences<_$AiDatabase, $AiConversationsTable, AiConversation>,
          ),
          AiConversation,
          PrefetchHooks Function()
        > {
  $$AiConversationsTableTableManager(
    _$AiDatabase db,
    $AiConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assistantId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsCompanion(
                id: id,
                assistantId: assistantId,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assistantId,
                required String title,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsCompanion.insert(
                id: id,
                assistantId: assistantId,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $AiConversationsTable,
      AiConversation,
      $$AiConversationsTableFilterComposer,
      $$AiConversationsTableOrderingComposer,
      $$AiConversationsTableAnnotationComposer,
      $$AiConversationsTableCreateCompanionBuilder,
      $$AiConversationsTableUpdateCompanionBuilder,
      (
        AiConversation,
        BaseReferences<_$AiDatabase, $AiConversationsTable, AiConversation>,
      ),
      AiConversation,
      PrefetchHooks Function()
    >;
typedef $$AiMessageRecordsTableCreateCompanionBuilder =
    AiMessageRecordsCompanion Function({
      required String id,
      required String conversationId,
      required DateTime createdAt,
      required String status,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$AiMessageRecordsTableUpdateCompanionBuilder =
    AiMessageRecordsCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<String> payloadJson,
      Value<int> rowid,
    });

class $$AiMessageRecordsTableFilterComposer
    extends Composer<_$AiDatabase, $AiMessageRecordsTable> {
  $$AiMessageRecordsTableFilterComposer({
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

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiMessageRecordsTableOrderingComposer
    extends Composer<_$AiDatabase, $AiMessageRecordsTable> {
  $$AiMessageRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiMessageRecordsTableAnnotationComposer
    extends Composer<_$AiDatabase, $AiMessageRecordsTable> {
  $$AiMessageRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$AiMessageRecordsTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $AiMessageRecordsTable,
          AiMessageRecord,
          $$AiMessageRecordsTableFilterComposer,
          $$AiMessageRecordsTableOrderingComposer,
          $$AiMessageRecordsTableAnnotationComposer,
          $$AiMessageRecordsTableCreateCompanionBuilder,
          $$AiMessageRecordsTableUpdateCompanionBuilder,
          (
            AiMessageRecord,
            BaseReferences<
              _$AiDatabase,
              $AiMessageRecordsTable,
              AiMessageRecord
            >,
          ),
          AiMessageRecord,
          PrefetchHooks Function()
        > {
  $$AiMessageRecordsTableTableManager(
    _$AiDatabase db,
    $AiMessageRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiMessageRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiMessageRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiMessageRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiMessageRecordsCompanion(
                id: id,
                conversationId: conversationId,
                createdAt: createdAt,
                status: status,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required DateTime createdAt,
                required String status,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => AiMessageRecordsCompanion.insert(
                id: id,
                conversationId: conversationId,
                createdAt: createdAt,
                status: status,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiMessageRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $AiMessageRecordsTable,
      AiMessageRecord,
      $$AiMessageRecordsTableFilterComposer,
      $$AiMessageRecordsTableOrderingComposer,
      $$AiMessageRecordsTableAnnotationComposer,
      $$AiMessageRecordsTableCreateCompanionBuilder,
      $$AiMessageRecordsTableUpdateCompanionBuilder,
      (
        AiMessageRecord,
        BaseReferences<_$AiDatabase, $AiMessageRecordsTable, AiMessageRecord>,
      ),
      AiMessageRecord,
      PrefetchHooks Function()
    >;
typedef $$AiConversationContextsTableCreateCompanionBuilder =
    AiConversationContextsCompanion Function({
      required String conversationId,
      required int contextVersion,
      required String payloadJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AiConversationContextsTableUpdateCompanionBuilder =
    AiConversationContextsCompanion Function({
      Value<String> conversationId,
      Value<int> contextVersion,
      Value<String> payloadJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AiConversationContextsTableFilterComposer
    extends Composer<_$AiDatabase, $AiConversationContextsTable> {
  $$AiConversationContextsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contextVersion => $composableBuilder(
    column: $table.contextVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiConversationContextsTableOrderingComposer
    extends Composer<_$AiDatabase, $AiConversationContextsTable> {
  $$AiConversationContextsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contextVersion => $composableBuilder(
    column: $table.contextVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiConversationContextsTableAnnotationComposer
    extends Composer<_$AiDatabase, $AiConversationContextsTable> {
  $$AiConversationContextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contextVersion => $composableBuilder(
    column: $table.contextVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AiConversationContextsTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $AiConversationContextsTable,
          AiConversationContext,
          $$AiConversationContextsTableFilterComposer,
          $$AiConversationContextsTableOrderingComposer,
          $$AiConversationContextsTableAnnotationComposer,
          $$AiConversationContextsTableCreateCompanionBuilder,
          $$AiConversationContextsTableUpdateCompanionBuilder,
          (
            AiConversationContext,
            BaseReferences<
              _$AiDatabase,
              $AiConversationContextsTable,
              AiConversationContext
            >,
          ),
          AiConversationContext,
          PrefetchHooks Function()
        > {
  $$AiConversationContextsTableTableManager(
    _$AiDatabase db,
    $AiConversationContextsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiConversationContextsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AiConversationContextsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiConversationContextsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> conversationId = const Value.absent(),
                Value<int> contextVersion = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiConversationContextsCompanion(
                conversationId: conversationId,
                contextVersion: contextVersion,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String conversationId,
                required int contextVersion,
                required String payloadJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AiConversationContextsCompanion.insert(
                conversationId: conversationId,
                contextVersion: contextVersion,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiConversationContextsTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $AiConversationContextsTable,
      AiConversationContext,
      $$AiConversationContextsTableFilterComposer,
      $$AiConversationContextsTableOrderingComposer,
      $$AiConversationContextsTableAnnotationComposer,
      $$AiConversationContextsTableCreateCompanionBuilder,
      $$AiConversationContextsTableUpdateCompanionBuilder,
      (
        AiConversationContext,
        BaseReferences<
          _$AiDatabase,
          $AiConversationContextsTable,
          AiConversationContext
        >,
      ),
      AiConversationContext,
      PrefetchHooks Function()
    >;
typedef $$ScriptRunsTableCreateCompanionBuilder =
    ScriptRunsCompanion Function({
      required String runId,
      required String conversationId,
      required String source,
      required String scriptName,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      required String status,
      Value<int> rowid,
    });
typedef $$ScriptRunsTableUpdateCompanionBuilder =
    ScriptRunsCompanion Function({
      Value<String> runId,
      Value<String> conversationId,
      Value<String> source,
      Value<String> scriptName,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<String> status,
      Value<int> rowid,
    });

class $$ScriptRunsTableFilterComposer
    extends Composer<_$AiDatabase, $ScriptRunsTable> {
  $$ScriptRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scriptName => $composableBuilder(
    column: $table.scriptName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScriptRunsTableOrderingComposer
    extends Composer<_$AiDatabase, $ScriptRunsTable> {
  $$ScriptRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scriptName => $composableBuilder(
    column: $table.scriptName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScriptRunsTableAnnotationComposer
    extends Composer<_$AiDatabase, $ScriptRunsTable> {
  $$ScriptRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get runId =>
      $composableBuilder(column: $table.runId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get scriptName => $composableBuilder(
    column: $table.scriptName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ScriptRunsTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $ScriptRunsTable,
          ScriptRun,
          $$ScriptRunsTableFilterComposer,
          $$ScriptRunsTableOrderingComposer,
          $$ScriptRunsTableAnnotationComposer,
          $$ScriptRunsTableCreateCompanionBuilder,
          $$ScriptRunsTableUpdateCompanionBuilder,
          (
            ScriptRun,
            BaseReferences<_$AiDatabase, $ScriptRunsTable, ScriptRun>,
          ),
          ScriptRun,
          PrefetchHooks Function()
        > {
  $$ScriptRunsTableTableManager(_$AiDatabase db, $ScriptRunsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScriptRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScriptRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScriptRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> runId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> scriptName = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScriptRunsCompanion(
                runId: runId,
                conversationId: conversationId,
                source: source,
                scriptName: scriptName,
                startedAt: startedAt,
                finishedAt: finishedAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String runId,
                required String conversationId,
                required String source,
                required String scriptName,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => ScriptRunsCompanion.insert(
                runId: runId,
                conversationId: conversationId,
                source: source,
                scriptName: scriptName,
                startedAt: startedAt,
                finishedAt: finishedAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScriptRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $ScriptRunsTable,
      ScriptRun,
      $$ScriptRunsTableFilterComposer,
      $$ScriptRunsTableOrderingComposer,
      $$ScriptRunsTableAnnotationComposer,
      $$ScriptRunsTableCreateCompanionBuilder,
      $$ScriptRunsTableUpdateCompanionBuilder,
      (ScriptRun, BaseReferences<_$AiDatabase, $ScriptRunsTable, ScriptRun>),
      ScriptRun,
      PrefetchHooks Function()
    >;
typedef $$ScriptLogsTableCreateCompanionBuilder =
    ScriptLogsCompanion Function({
      Value<int> id,
      required String runId,
      required String conversationId,
      required String source,
      required String scriptName,
      required String level,
      required String message,
      required String stackTrace,
      required DateTime timestamp,
    });
typedef $$ScriptLogsTableUpdateCompanionBuilder =
    ScriptLogsCompanion Function({
      Value<int> id,
      Value<String> runId,
      Value<String> conversationId,
      Value<String> source,
      Value<String> scriptName,
      Value<String> level,
      Value<String> message,
      Value<String> stackTrace,
      Value<DateTime> timestamp,
    });

class $$ScriptLogsTableFilterComposer
    extends Composer<_$AiDatabase, $ScriptLogsTable> {
  $$ScriptLogsTableFilterComposer({
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

  ColumnFilters<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scriptName => $composableBuilder(
    column: $table.scriptName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScriptLogsTableOrderingComposer
    extends Composer<_$AiDatabase, $ScriptLogsTable> {
  $$ScriptLogsTableOrderingComposer({
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

  ColumnOrderings<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scriptName => $composableBuilder(
    column: $table.scriptName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScriptLogsTableAnnotationComposer
    extends Composer<_$AiDatabase, $ScriptLogsTable> {
  $$ScriptLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get runId =>
      $composableBuilder(column: $table.runId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get scriptName => $composableBuilder(
    column: $table.scriptName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ScriptLogsTableTableManager
    extends
        RootTableManager<
          _$AiDatabase,
          $ScriptLogsTable,
          ScriptLog,
          $$ScriptLogsTableFilterComposer,
          $$ScriptLogsTableOrderingComposer,
          $$ScriptLogsTableAnnotationComposer,
          $$ScriptLogsTableCreateCompanionBuilder,
          $$ScriptLogsTableUpdateCompanionBuilder,
          (
            ScriptLog,
            BaseReferences<_$AiDatabase, $ScriptLogsTable, ScriptLog>,
          ),
          ScriptLog,
          PrefetchHooks Function()
        > {
  $$ScriptLogsTableTableManager(_$AiDatabase db, $ScriptLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScriptLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScriptLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScriptLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> runId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> scriptName = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> stackTrace = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ScriptLogsCompanion(
                id: id,
                runId: runId,
                conversationId: conversationId,
                source: source,
                scriptName: scriptName,
                level: level,
                message: message,
                stackTrace: stackTrace,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String runId,
                required String conversationId,
                required String source,
                required String scriptName,
                required String level,
                required String message,
                required String stackTrace,
                required DateTime timestamp,
              }) => ScriptLogsCompanion.insert(
                id: id,
                runId: runId,
                conversationId: conversationId,
                source: source,
                scriptName: scriptName,
                level: level,
                message: message,
                stackTrace: stackTrace,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScriptLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AiDatabase,
      $ScriptLogsTable,
      ScriptLog,
      $$ScriptLogsTableFilterComposer,
      $$ScriptLogsTableOrderingComposer,
      $$ScriptLogsTableAnnotationComposer,
      $$ScriptLogsTableCreateCompanionBuilder,
      $$ScriptLogsTableUpdateCompanionBuilder,
      (ScriptLog, BaseReferences<_$AiDatabase, $ScriptLogsTable, ScriptLog>),
      ScriptLog,
      PrefetchHooks Function()
    >;

class $AiDatabaseManager {
  final _$AiDatabase _db;
  $AiDatabaseManager(this._db);
  $$AiProviderConnectionsTableTableManager get aiProviderConnections =>
      $$AiProviderConnectionsTableTableManager(_db, _db.aiProviderConnections);
  $$AiModelDefinitionsTableTableManager get aiModelDefinitions =>
      $$AiModelDefinitionsTableTableManager(_db, _db.aiModelDefinitions);
  $$AiAssistantProfilesTableTableManager get aiAssistantProfiles =>
      $$AiAssistantProfilesTableTableManager(_db, _db.aiAssistantProfiles);
  $$AiConversationsTableTableManager get aiConversations =>
      $$AiConversationsTableTableManager(_db, _db.aiConversations);
  $$AiMessageRecordsTableTableManager get aiMessageRecords =>
      $$AiMessageRecordsTableTableManager(_db, _db.aiMessageRecords);
  $$AiConversationContextsTableTableManager get aiConversationContexts =>
      $$AiConversationContextsTableTableManager(
        _db,
        _db.aiConversationContexts,
      );
  $$ScriptRunsTableTableManager get scriptRuns =>
      $$ScriptRunsTableTableManager(_db, _db.scriptRuns);
  $$ScriptLogsTableTableManager get scriptLogs =>
      $$ScriptLogsTableTableManager(_db, _db.scriptLogs);
}
