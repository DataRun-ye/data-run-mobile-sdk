part of 'form_version.entity.dart';

extension FormTraverseExtension on FormVersion {
  // IMap<String, Template> get formFlatFields {
  //   try {
  //     if ((flattenFieldsMap ?? IMap()).isEmpty) {
  //       final allFields = sections.addAll(fields);
  //       flattenFieldsMap = allFields.asMap().map((k, v) => MapEntry(v.path, v));
  //     }
  //   } catch (e) {
  //     logError('error parsing formFlatFields');
  //     rethrow;
  //   }
  //
  //   return flattenFieldsMap ?? IMap();
  // }

  Map<String, Template> get formFlatFields =>
      IMap.fromIterable([...sections, ...fields],
          keyMapper: (template) => template.path,
          valueMapper: (template) => template).unlockView;

  /// Get element by path
  Template? getTemplateByPath(String path) {
    return formFlatFields[path];
  }

  // Template? findFieldByPath(String path) {
  //   for (var field in formTreeFields) {
  //     var found = field.findFieldByPath(path);
  //     if (found != null) return found;
  //   }
  //   return null;
  // }

  /// Get children of a specific path
  List<Template> getChildren(String path) {
    final normalizedPath =
        path.endsWith('.') ? path.substring(0, path.length - 1) : path;

    return formFlatFields.values
        .where((field) =>
            field.path.startsWith('$normalizedPath.') &&
            field.path.split('.').length == path.split('.').length + 1)
        .toList();
  }

  /// Get descendants of a specific path
  List<Template> getChildrenOfType<E extends Template>(String path) {
    return formFlatFields.values
        .where((field) => field.path.startsWith('$path.'))
        .whereType<E>()
        .toList();
  }

  /// Get descendants of a specific path
  List<Template> getDescendants(String path, [ValueType? type]) {
    return formFlatFields.values
        .where((field) =>
            field.path.startsWith('$path.') &&
            (type == null || field.type == type))
        .toList();
  }

  Template? getScopedDependencyByName(String id, String currentPath) {
    final pathSegments = currentPath.split('.');

    // upwards in the path
    for (int i = pathSegments.length - 1; i >= 0; i--) {
      final currentPathSegment = pathSegments.sublist(0, i + 1).join('.');

      // in the current scope
      final element = getTemplateByPath(currentPathSegment + '.' + id);
      if (element != null) {
        return element;
      }
    }

    // If not found, check the global scope
    final rootElements =
        formFlatFields.values.where((element) => element.path.split('.').length == 1);

    for (final rootElement in rootElements) {
      final scopedElement = getScopedElement(rootElement, id);
      if (scopedElement != null) {
        return scopedElement;
      }
    }

    return null;
  }

  Template? getScopedElement(Template rootElement, String id) {
    if (rootElement.id == id) {
      return rootElement;
    }

    for (final child in getDescendants(rootElement.path)) {
      final element = getScopedElement(child, id);
      if (element != null) {
        return element;
      }
    }
    return null;
  }
}

extension PathMaterializedFormUtil on FormVersion {
  List<Template> getImmediateChildren(String nodePath) {
    final depth = nodePath.split('.').length + 1;
    return formFlatFields.values.where((node) {
      return node.path.startsWith('$nodePath.') &&
          node.path.split('.').length == depth;
    }).toList();
  }

  Template? getParent(String fieldPath) {
    final parentPath = fieldPath.split('.')..removeLast();
    if (parentPath.isEmpty) return null; // Root node has no parent
    return formFlatFields.values
        .firstOrNullWhere((n) => n.path == parentPath.join('.'));
  }

// List<Template> getSiblings(String fieldPath) {
//   final parentPath = fieldPath.split('.')..removeLast();
//   if (parentPath.isEmpty) return []; // Root node has no siblings
//   final depth = fieldPath.split('.').length;
//   return formFlatFields.values.where((n) {
//     return n.path!.split('.').length == depth &&
//         n.path!.startsWith(parentPath.join('.')) &&
//         n.path != fieldPath;
//   }).toList();
// }
}

extension FieldTemplatePathExtension on Template {
  String? get parentPath {
    final parentPath = path.split('.')..removeLast();
    if (parentPath.isEmpty) return null; // Root node has no parent
    return parentPath.join('.');
  }

  // bool get isSectionType => (type?.isSelectType ?? false);

  // bool get isSection => (type?.isSection ?? false) || repeatable;

  // bool get isRepeat => (type?.isRepeatSection ?? false);

  // bool get isSelectType => (type?.isSelectType ?? false);
  //
  // bool get isCalculate => (type?.isCalculate ?? false);
  //
  // bool get isTextType => (type?.isText ?? false);

  // bool get withChoiceFilter => choiceFilter != null;

  bool get isNumeric => (type?.isNumeric ?? false);

// Template? findFieldByPath(String path, [ValueType? valueType]) {
//   if (this.path == path) return this;
//   for (var field in treeFields) {
//     var found = field.findFieldByPath(path);
//     if (found != null) return found;
//   }
//   return null;
// }

// Template? findFieldByPathAndType(String path, ValueType type) {
//   if (this.path == path && this.type == type) return this;
//   for (var field in treeFields) {
//     var found = field.findFieldByPathAndType(path, type);
//     if (found != null) return found;
//   }
//   return null;
// }
//
// Template? findFieldByName(String name) {
//   if (this.name == name) return this;
//   for (var field in treeFields) {
//     var found = field.findFieldByName(name);
//     if (found != null) return found;
//   }
//   return null;
// }
}
