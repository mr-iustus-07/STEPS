// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStreakModelCollection on Isar {
  IsarCollection<StreakModel> get streakModels => this.collection();
}

const StreakModelSchema = CollectionSchema(
  name: r'StreakModel',
  id: -1150190822398184549,
  properties: {
    r'achievedAt': PropertySchema(
      id: 0,
      name: r'achievedAt',
      type: IsarType.dateTime,
    ),
    r'milestoneReached': PropertySchema(
      id: 1,
      name: r'milestoneReached',
      type: IsarType.long,
    ),
    r'rewardClaimed': PropertySchema(
      id: 2,
      name: r'rewardClaimed',
      type: IsarType.string,
    ),
    r'routineId': PropertySchema(
      id: 3,
      name: r'routineId',
      type: IsarType.long,
    ),
    r'routineTitleSnapshot': PropertySchema(
      id: 4,
      name: r'routineTitleSnapshot',
      type: IsarType.string,
    ),
    r'tier': PropertySchema(
      id: 5,
      name: r'tier',
      type: IsarType.byte,
      enumMap: _StreakModeltierEnumValueMap,
    )
  },
  estimateSize: _streakModelEstimateSize,
  serialize: _streakModelSerialize,
  deserialize: _streakModelDeserialize,
  deserializeProp: _streakModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'routineId': IndexSchema(
      id: -7971259615846791236,
      name: r'routineId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'routineId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _streakModelGetId,
  getLinks: _streakModelGetLinks,
  attach: _streakModelAttach,
  version: '3.1.0+1',
);

int _streakModelEstimateSize(
  StreakModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.rewardClaimed;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.routineTitleSnapshot.length * 3;
  return bytesCount;
}

void _streakModelSerialize(
  StreakModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.achievedAt);
  writer.writeLong(offsets[1], object.milestoneReached);
  writer.writeString(offsets[2], object.rewardClaimed);
  writer.writeLong(offsets[3], object.routineId);
  writer.writeString(offsets[4], object.routineTitleSnapshot);
  writer.writeByte(offsets[5], object.tier.index);
}

StreakModel _streakModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StreakModel();
  object.achievedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.milestoneReached = reader.readLong(offsets[1]);
  object.rewardClaimed = reader.readStringOrNull(offsets[2]);
  object.routineId = reader.readLong(offsets[3]);
  object.routineTitleSnapshot = reader.readString(offsets[4]);
  object.tier =
      _StreakModeltierValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          StreakTier.standard;
  return object;
}

P _streakModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (_StreakModeltierValueEnumMap[reader.readByteOrNull(offset)] ??
          StreakTier.standard) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _StreakModeltierEnumValueMap = {
  'standard': 0,
  'superStreak': 1,
  'godTier': 2,
};
const _StreakModeltierValueEnumMap = {
  0: StreakTier.standard,
  1: StreakTier.superStreak,
  2: StreakTier.godTier,
};

Id _streakModelGetId(StreakModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _streakModelGetLinks(StreakModel object) {
  return [];
}

void _streakModelAttach(
    IsarCollection<dynamic> col, Id id, StreakModel object) {
  object.id = id;
}

extension StreakModelQueryWhereSort
    on QueryBuilder<StreakModel, StreakModel, QWhere> {
  QueryBuilder<StreakModel, StreakModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhere> anyRoutineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'routineId'),
      );
    });
  }
}

extension StreakModelQueryWhere
    on QueryBuilder<StreakModel, StreakModel, QWhereClause> {
  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> routineIdEqualTo(
      int routineId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'routineId',
        value: [routineId],
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> routineIdNotEqualTo(
      int routineId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineId',
              lower: [],
              upper: [routineId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineId',
              lower: [routineId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineId',
              lower: [routineId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineId',
              lower: [],
              upper: [routineId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause>
      routineIdGreaterThan(
    int routineId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'routineId',
        lower: [routineId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> routineIdLessThan(
    int routineId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'routineId',
        lower: [],
        upper: [routineId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterWhereClause> routineIdBetween(
    int lowerRoutineId,
    int upperRoutineId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'routineId',
        lower: [lowerRoutineId],
        includeLower: includeLower,
        upper: [upperRoutineId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StreakModelQueryFilter
    on QueryBuilder<StreakModel, StreakModel, QFilterCondition> {
  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      achievedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achievedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      achievedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'achievedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      achievedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'achievedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      achievedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'achievedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      milestoneReachedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'milestoneReached',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      milestoneReachedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'milestoneReached',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      milestoneReachedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'milestoneReached',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      milestoneReachedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'milestoneReached',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rewardClaimed',
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rewardClaimed',
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardClaimed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rewardClaimed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rewardClaimed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rewardClaimed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rewardClaimed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rewardClaimed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rewardClaimed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rewardClaimed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardClaimed',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      rewardClaimedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rewardClaimed',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routineId',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'routineId',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'routineId',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'routineId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routineTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'routineTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'routineTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'routineTitleSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'routineTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'routineTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'routineTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'routineTitleSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routineTitleSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition>
      routineTitleSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'routineTitleSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> tierEqualTo(
      StreakTier value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tier',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> tierGreaterThan(
    StreakTier value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tier',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> tierLessThan(
    StreakTier value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tier',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterFilterCondition> tierBetween(
    StreakTier lower,
    StreakTier upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StreakModelQueryObject
    on QueryBuilder<StreakModel, StreakModel, QFilterCondition> {}

extension StreakModelQueryLinks
    on QueryBuilder<StreakModel, StreakModel, QFilterCondition> {}

extension StreakModelQuerySortBy
    on QueryBuilder<StreakModel, StreakModel, QSortBy> {
  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> sortByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> sortByAchievedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      sortByMilestoneReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'milestoneReached', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      sortByMilestoneReachedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'milestoneReached', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> sortByRewardClaimed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      sortByRewardClaimedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> sortByRoutineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineId', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> sortByRoutineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineId', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      sortByRoutineTitleSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineTitleSnapshot', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      sortByRoutineTitleSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineTitleSnapshot', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> sortByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> sortByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.desc);
    });
  }
}

extension StreakModelQuerySortThenBy
    on QueryBuilder<StreakModel, StreakModel, QSortThenBy> {
  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByAchievedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      thenByMilestoneReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'milestoneReached', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      thenByMilestoneReachedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'milestoneReached', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByRewardClaimed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      thenByRewardClaimedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByRoutineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineId', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByRoutineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineId', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      thenByRoutineTitleSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineTitleSnapshot', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy>
      thenByRoutineTitleSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineTitleSnapshot', Sort.desc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.asc);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QAfterSortBy> thenByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.desc);
    });
  }
}

extension StreakModelQueryWhereDistinct
    on QueryBuilder<StreakModel, StreakModel, QDistinct> {
  QueryBuilder<StreakModel, StreakModel, QDistinct> distinctByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievedAt');
    });
  }

  QueryBuilder<StreakModel, StreakModel, QDistinct>
      distinctByMilestoneReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'milestoneReached');
    });
  }

  QueryBuilder<StreakModel, StreakModel, QDistinct> distinctByRewardClaimed(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewardClaimed',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QDistinct> distinctByRoutineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routineId');
    });
  }

  QueryBuilder<StreakModel, StreakModel, QDistinct>
      distinctByRoutineTitleSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routineTitleSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StreakModel, StreakModel, QDistinct> distinctByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tier');
    });
  }
}

extension StreakModelQueryProperty
    on QueryBuilder<StreakModel, StreakModel, QQueryProperty> {
  QueryBuilder<StreakModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StreakModel, DateTime, QQueryOperations> achievedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievedAt');
    });
  }

  QueryBuilder<StreakModel, int, QQueryOperations> milestoneReachedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'milestoneReached');
    });
  }

  QueryBuilder<StreakModel, String?, QQueryOperations> rewardClaimedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewardClaimed');
    });
  }

  QueryBuilder<StreakModel, int, QQueryOperations> routineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routineId');
    });
  }

  QueryBuilder<StreakModel, String, QQueryOperations>
      routineTitleSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routineTitleSnapshot');
    });
  }

  QueryBuilder<StreakModel, StreakTier, QQueryOperations> tierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tier');
    });
  }
}
