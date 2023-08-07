// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResourceChange extends ResourceChange {
  @override
  final ChangeAction? action;
  @override
  final String? logicalResourceId;
  @override
  final String? physicalResourceId;
  @override
  final String? resourceType;
  @override
  final Replacement? replacement;
  @override
  final _i2.BuiltList<ResourceAttribute>? scope;
  @override
  final _i2.BuiltList<ResourceChangeDetail>? details;
  @override
  final String? changeSetId;
  @override
  final ModuleInfo? moduleInfo;

  factory _$ResourceChange([void Function(ResourceChangeBuilder)? updates]) =>
      (new ResourceChangeBuilder()..update(updates))._build();

  _$ResourceChange._(
      {this.action,
      this.logicalResourceId,
      this.physicalResourceId,
      this.resourceType,
      this.replacement,
      this.scope,
      this.details,
      this.changeSetId,
      this.moduleInfo})
      : super._();

  @override
  ResourceChange rebuild(void Function(ResourceChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResourceChangeBuilder toBuilder() =>
      new ResourceChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResourceChange &&
        action == other.action &&
        logicalResourceId == other.logicalResourceId &&
        physicalResourceId == other.physicalResourceId &&
        resourceType == other.resourceType &&
        replacement == other.replacement &&
        scope == other.scope &&
        details == other.details &&
        changeSetId == other.changeSetId &&
        moduleInfo == other.moduleInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, logicalResourceId.hashCode);
    _$hash = $jc(_$hash, physicalResourceId.hashCode);
    _$hash = $jc(_$hash, resourceType.hashCode);
    _$hash = $jc(_$hash, replacement.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, changeSetId.hashCode);
    _$hash = $jc(_$hash, moduleInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }
}

class ResourceChangeBuilder
    implements Builder<ResourceChange, ResourceChangeBuilder> {
  _$ResourceChange? _$v;

  ChangeAction? _action;
  ChangeAction? get action => _$this._action;
  set action(ChangeAction? action) => _$this._action = action;

  String? _logicalResourceId;
  String? get logicalResourceId => _$this._logicalResourceId;
  set logicalResourceId(String? logicalResourceId) =>
      _$this._logicalResourceId = logicalResourceId;

  String? _physicalResourceId;
  String? get physicalResourceId => _$this._physicalResourceId;
  set physicalResourceId(String? physicalResourceId) =>
      _$this._physicalResourceId = physicalResourceId;

  String? _resourceType;
  String? get resourceType => _$this._resourceType;
  set resourceType(String? resourceType) => _$this._resourceType = resourceType;

  Replacement? _replacement;
  Replacement? get replacement => _$this._replacement;
  set replacement(Replacement? replacement) =>
      _$this._replacement = replacement;

  _i2.ListBuilder<ResourceAttribute>? _scope;
  _i2.ListBuilder<ResourceAttribute> get scope =>
      _$this._scope ??= new _i2.ListBuilder<ResourceAttribute>();
  set scope(_i2.ListBuilder<ResourceAttribute>? scope) => _$this._scope = scope;

  _i2.ListBuilder<ResourceChangeDetail>? _details;
  _i2.ListBuilder<ResourceChangeDetail> get details =>
      _$this._details ??= new _i2.ListBuilder<ResourceChangeDetail>();
  set details(_i2.ListBuilder<ResourceChangeDetail>? details) =>
      _$this._details = details;

  String? _changeSetId;
  String? get changeSetId => _$this._changeSetId;
  set changeSetId(String? changeSetId) => _$this._changeSetId = changeSetId;

  ModuleInfoBuilder? _moduleInfo;
  ModuleInfoBuilder get moduleInfo =>
      _$this._moduleInfo ??= new ModuleInfoBuilder();
  set moduleInfo(ModuleInfoBuilder? moduleInfo) =>
      _$this._moduleInfo = moduleInfo;

  ResourceChangeBuilder();

  ResourceChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _logicalResourceId = $v.logicalResourceId;
      _physicalResourceId = $v.physicalResourceId;
      _resourceType = $v.resourceType;
      _replacement = $v.replacement;
      _scope = $v.scope?.toBuilder();
      _details = $v.details?.toBuilder();
      _changeSetId = $v.changeSetId;
      _moduleInfo = $v.moduleInfo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResourceChange other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ResourceChange;
  }

  @override
  void update(void Function(ResourceChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResourceChange build() => _build();

  _$ResourceChange _build() {
    _$ResourceChange _$result;
    try {
      _$result = _$v ??
          new _$ResourceChange._(
              action: action,
              logicalResourceId: logicalResourceId,
              physicalResourceId: physicalResourceId,
              resourceType: resourceType,
              replacement: replacement,
              scope: _scope?.build(),
              details: _details?.build(),
              changeSetId: changeSetId,
              moduleInfo: _moduleInfo?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        _scope?.build();
        _$failedField = 'details';
        _details?.build();

        _$failedField = 'moduleInfo';
        _moduleInfo?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ResourceChange', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
