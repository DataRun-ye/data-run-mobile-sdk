enum RuleActionType {
  // Expression must be logical (true, false)
  // Visibility,
  Show, // deprecated, use Visibility
  Hide, // deprecated, use Visibility
  HideSection, // deprecated, use Visibility
  Error, // deprecated, use Constraint
  ErrorOnComplete, // deprecated, use Constraint
  Warning, // deprecated, use Constraint
  WarningOnComplete, // deprecated, use Constraint
  Filter, // deprecated, use choice Filter
  // Expression must be logical (true, false)
  StopRepeat,
  // Expression must be logical (true, false)
  Mandatory,
  DisplayText,
  DisplayKeyValuePair,

  HideOption,
  HideOptionGroup,
  ShowOptionGroup,
  // Expression result must be numerical >= 0
  Count,
  // Expression result must be a compatible Value with the Field type
  // i.e for default Value
  Assign,
  Unknown;

  static List<RuleActionType> get VISIBILITY_ACTIONS =>
      <RuleActionType>[Show, Hide];

  bool get isVisibility => VISIBILITY_ACTIONS.contains(this);

  static RuleActionType getAction(String? action) {
    switch (action?.toLowerCase()) {
      case 'show':
        return RuleActionType.Show;
      case 'hide':
        return RuleActionType.Hide;
      case 'error':
        return RuleActionType.Error;
      case 'warning':
        return RuleActionType.Warning;
      case 'filter':
        return RuleActionType.Filter;
      case 'stopRepeat':
        return RuleActionType.StopRepeat;
      case 'mandatory':
        return RuleActionType.Mandatory;
      case 'count':
        return RuleActionType.Count;
      case 'assign':
        return RuleActionType.Assign;
      default:
        return RuleActionType.Unknown;
      // throw ArgumentError('Invalid value type: $valueType');
    }
  }
}
