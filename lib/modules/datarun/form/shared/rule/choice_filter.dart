import 'package:d2_remote/modules/datarun/form/shared/rule/expression_provider.dart';
import 'package:d2_remote/modules/metadatarun/option_set/entities/option.entity.dart';
import 'package:expressions/src/expressions.dart';

class ChoiceFilter
    implements ExpressionProvider, EvaluationEngine<List<Option>> {
  final List<Option> options;
  final String? expression;

  const ChoiceFilter({required this.expression, this.options = const []});

  @override
  Expression getExpression() {
    return Expression.parse(expression!);
  }

  @override
  List<Option> evaluate([Map<String, dynamic>? context]) {
    List<Option> result = options;
    if (expression != null || options.any((o) => o.filterExpression != null)) {
      result = options
          .where((option) => evaluator.eval(
              option.filterExpression != null
                  ? Expression.parse(option.evalFilterExpression!)
                  : getExpression(),
              option.toContext()..addAll(context ?? {})))
          .toList();
    } else {
      return options;
    }

    return result;
  }

  ChoiceFilter copyWith({
    List<Option>? options,
    String? expression,
  }) {
    return ChoiceFilter(
      options: options ?? this.options,
      expression: expression ?? this.expression,
    );
  }
}
