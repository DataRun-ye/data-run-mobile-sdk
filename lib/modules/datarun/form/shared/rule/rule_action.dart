

enum RuleActionType {
  // Expression must be logical (true, false)
  // Visibility,
  Show,
  Hide,
  Error,
  Warning,
  Filter,
  // Expression must be logical (true, false)
  Mandatory,
  // Expression result must be a compatible Value with the Field type
  // i.e for default Value
  Assign,

  // new
  WarningOnComplete, // deprecated, use Constraint
  ErrorOnComplete, // deprecated, use Constraint
  DisplayText,
  DisplayKeyValuePair,
  HideOption,
  HideOptionGroup,
  ShowOptionGroup,
  Unknown;

  static List<RuleActionType> get VISIBILITY_ACTIONS =>
      <RuleActionType>[Show, Hide];

  bool get isVisibility => VISIBILITY_ACTIONS.contains(this);

  static RuleActionType getAction(String? action) => RuleActionType.values
      .firstWhere((e) => e.name.toLowerCase() == action?.toLowerCase(),
          orElse: () => RuleActionType.Unknown);

  // static RuleActionType getAction(String? action) {
  //   switch (action?.toLowerCase()) {
  //     case 'show':
  //       return RuleActionType.Show;
  //     case 'hide':
  //       return RuleActionType.Hide;
  //     case 'error':
  //       return RuleActionType.Error;
  //     case 'warning':
  //       return RuleActionType.Warning;
  //     case 'filter':
  //       return RuleActionType.Filter;
  //     case 'mandatory':
  //       return RuleActionType.Mandatory;
  //     case 'assign':
  //       return RuleActionType.Assign;
  //     case 'assign':
  //       return RuleActionType.Assign;
  //     case 'assign':
  //       return RuleActionType.Assign;
  //     default:
  //       return RuleActionType.Unknown;
  //     // throw ArgumentError('Invalid value type: $valueType');
  //   }
  // }
}
