import 'package:d2_remote/core/datarun/exception/exception.dart';
import 'package:d2_remote/core/value_type_validator/value_type/validators/validators.dart';

enum ValueType {
  Progress(TextValidator()),
  Section(TextValidator()),
  RepeatableSection(TextValidator()),
  Attribute(TextValidator()),
  Text(TextValidator()),
  LongText(LongTextValidator()),
  Letter(LetterValidator()),
  PhoneNumber(PhoneNumberValidator()),
  Email(EmailValidator()),
  Boolean(BooleanValidator()),
  TrueOnly(TrueOnlyValidator()),
  Date(DateValidator()),
  DateTime(DateTimeValidator()),
  Time(TimeValidator()),
  Number(NumberValidator()),
  UnitInterval(UnitIntervalValidator()),
  Percentage(PercentageValidator()),
  Integer(IntegerValidator()),
  IntegerPositive(IntegerPositiveValidator()),
  IntegerNegative(IntegerNegativeValidator()),
  IntegerZeroOrPositive(IntegerZeroOrPositiveValidator()),
  TrackerAssociate(UidValidator()),
  Username(TextValidator()),
  Coordinate(CoordinateValidator()),
  OrganisationUnit(UidValidator()),
  Team(UidValidator()),
  Reference(TextValidator()),
  Age(NumberValidator()),
  FullName(FullNameValidator()),
  URL(UrlValidator()),
  FileResource(UidValidator()),
  Image(UidValidator()),
  // split by  `,`
  SelectMulti(TextValidator()),
  SelectOne(TextValidator()),
  YesNo(TextValidator()),
  GeoJson(TextValidator()),
  Calculated(TextValidator()),
  ScannedCode(TextValidator()),
  Unknown(TextValidator());

  const ValueType(this._validator);

  final ValueTypeValidator<DException> _validator;

  ValueTypeValidator<DException> get validator => _validator;

  static const List<ValueType> INTEGER_TYPES = <ValueType>[
    Integer,
    IntegerPositive,
    IntegerNegative,
    IntegerZeroOrPositive
  ];

  static const List<ValueType> NUMERIC_TYPES = <ValueType>[
    Integer,
    Number,
    IntegerPositive,
    IntegerNegative,
    IntegerZeroOrPositive,
    UnitInterval,
    Percentage
  ];

  static const List<ValueType> DECIMAL_TYPES = <ValueType>[
    ValueType.Number,
    ValueType.UnitInterval,
    ValueType.Percentage
  ];

  static const List<ValueType> BASIC_TYPES = <ValueType>[
    Text,
    LongText,
    Letter,
    Time,
    Integer,
    Number,
    IntegerPositive,
    IntegerNegative,
    IntegerZeroOrPositive,
    UnitInterval,
    Percentage
  ];

  static const List<ValueType> SECTION_TYPES = <ValueType>[
    Section,
    RepeatableSection
  ];

  static const List<ValueType> WITH_OPTIONS_TYPES = <ValueType>[
    SelectOne,
    SelectMulti
  ];

  static const List<ValueType> BOOLEAN_TYPES = <ValueType>[Boolean, TrueOnly];

  static const List<ValueType> TEXT_TYPES = <ValueType>[
    Text,
    LongText,
    Letter,
    Coordinate,
    FullName,
    Integer,
    Number,
    IntegerPositive,
    IntegerNegative,
    IntegerZeroOrPositive,
    UnitInterval,
    Percentage
  ];

  static const List<ValueType> DATE_TYPES = <ValueType>[Date, DateTime, Time];

  static const List<ValueType> FILE_TYPES = <ValueType>[Image, FileResource];

  bool get isBasicType => BASIC_TYPES.contains(this);

  bool get isInteger => INTEGER_TYPES.contains(this);

  bool get isDecimal => DECIMAL_TYPES.contains(this);

  bool get isSectionType => SECTION_TYPES.contains(this);

  bool get isSection => this == ValueType.Section;

  bool get isRepeatSection => this == ValueType.RepeatableSection;

  bool get selectTypes => WITH_OPTIONS_TYPES.contains(this);

  bool get isSelectType => WITH_OPTIONS_TYPES.contains(this);

  bool get isNumeric => NUMERIC_TYPES.contains(this);

  bool get isBoolean => BOOLEAN_TYPES.contains(this);

  bool get isText => TEXT_TYPES.contains(this);

  bool get isDateTime => DATE_TYPES.contains(this);

  bool get isCalculate => this == ValueType.Calculated;

  bool get isDate => this == ValueType.Date;

  bool get isTime => this == ValueType.Time;

  bool get isFile => FILE_TYPES.contains(this);

  bool get isCoordinate => this == Coordinate;

  static ValueType getValueType(String? valueType) {
    switch (valueType?.toLowerCase()) {
      // case 'section':
      //   return ValueType.Section;
      // case 'repeatablesection':
      //   return ValueType.RepeatableSection;
      case 'scannedcode':
        return ValueType.ScannedCode;
      case 'text':
        return ValueType.Text;
      case 'longtext':
        return ValueType.LongText;
      case 'letter':
        return ValueType.Letter;
      case 'phonenumber':
        return ValueType.PhoneNumber;
      case 'email':
        return ValueType.Email;
      case 'boolean':
        return ValueType.Boolean;
      case 'trueonly':
        return ValueType.TrueOnly;
      case 'date':
        return ValueType.Date;
      case 'datetime':
        return ValueType.DateTime;
      case 'time':
        return ValueType.Time;
      case 'number':
        return ValueType.Number;
      case 'unitinterval':
        return ValueType.UnitInterval;
      case 'percentage':
        return ValueType.Percentage;
      case 'progress':
        return ValueType.Progress;
      case 'integer':
        return ValueType.Integer;
      case 'integerpositive':
        return ValueType.IntegerPositive;
      case 'integernegative':
        return ValueType.IntegerNegative;
      case 'integerzeroorpositive':
        return ValueType.IntegerZeroOrPositive;
      case 'trackerassociate':
        return ValueType.TrackerAssociate;
      case 'username':
        return ValueType.Username;
      case 'coordinate':
        return ValueType.Coordinate;
      case 'organisationunit':
        return ValueType.OrganisationUnit;
      case 'team':
        return ValueType.Team;
      case 'reference':
        return ValueType.Reference;
      case 'age':
        return ValueType.Age;
      case 'fullname':
        return ValueType.FullName;
      case 'url':
        return ValueType.URL;
      case 'fileresource':
        return ValueType.FileResource;
      case 'image':
        return ValueType.Image;
      case 'selectmulti':
        return ValueType.SelectMulti;
      case 'selectone':
        return ValueType.SelectOne;
      case 'yesno':
        return ValueType.YesNo;
      case 'geojson':
        return ValueType.GeoJson;
      case 'attribute':
        return ValueType.Attribute;
      case 'calculated':
        return ValueType.Calculated;
      default:
        return ValueType.Unknown;
      // throw ArgumentError('Invalid value type: $valueType'); Attribute
    }
  }
}
