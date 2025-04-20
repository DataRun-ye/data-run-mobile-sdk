import 'package:d2_remote/core/utilities/list_extensions.dart';

mixin TreeElement {
  String? get path;

  String? get name;
}

mixin TemplatePathWalkingService<T extends TreeElement> {
  Iterable<T> get flatFieldsList;

  /// Get parent of a specific path
  T? getParent(String path) {
    final pathSegments = path.split('.');
    if (pathSegments.length > 1) {
      final parentPath =
          pathSegments.sublist(0, pathSegments.length - 1).join('.');
      return getTemplateByPath(parentPath);
    }
    return null;
  }

  List<T> getImmediateChildren(String path) {
    // final normalizedPath =
    //     path.endsWith('.') ? path.substring(0, path.length - 1) : path;

    final depth = path.split('.').length + 1;
    final childElements = flatFieldsList.where((node) {
      return node.path!.startsWith('$path.') &&
          node.path!.split('.').length == depth;
    }).toList();
    return childElements;
  }

  /// Get ancestors of a specific path
  List<T> getAncestors(String path) {
    final ancestors = <T>[];
    while (path != '') {
      final parent = getParent(path);
      if (parent != null) {
        ancestors.add(parent);
        path = parent.path!;
      } else {
        break;
      }
    }
    return ancestors.reversed.toList();
  }

  /// Get descendants of a specific path
  T? getFirstById(String id) {
    final element =
        flatFieldsList.firstOrNullWhere((node) => node.path!.endsWith('$id'));
    return element;
  }

  /// Get element by path
  T? getTemplateByPath(String path) {
    return flatFieldsList.firstOrNullWhere((element) => element.path == path);
  }

  /// Get descendants of a specific path
  List<T> getDescendants(String path) {
    return flatFieldsList
        .where((node) => node.path!.startsWith('$path.'))
        .toList();
  }

  /// Get children of a specific path
  List<T> getChildren(String path) {
    final normalizedPath =
        path.endsWith('.') ? path.substring(0, path.length - 1) : path;

    return flatFieldsList
        .where((node) =>
            node.path!.startsWith('$normalizedPath.') &&
            node.path!.split('.').length == path.split('.').length + 1)
        .toList();
  }

  // /// Get descendants of a specific path
  // List<T> getChildrenOfType<E extends T>(String path) {
  //   return flatFieldsList
  //       .where((field) => field.path!.startsWith('$path.'))
  //       .whereType<E>()
  //       .toList();
  // }

  /// Get ImmediateChildren of a specific path
  List<T> getChildrenOfType<E extends T>(String path) {
    final normalizedPath =
        path.endsWith('.') ? path.substring(0, path.length - 1) : path;

    return flatFieldsList
        .where((node) =>
            node.path!.startsWith('$normalizedPath.') &&
            node.path!.split('.').length ==
                normalizedPath.split('.').length + 1)
        .whereType<E>()
        .toList();
  }

// /// Get siblings of a specific path, fixing the issue of differentiating
// /// siblings when the length of the path segments is different which should
// /// also match
// List<T> getSiblings2(String path) {
//   final parentPath =
//       path.split('.').sublist(0, path.split('.').length - 1).join('.');
//
//   return flatFieldsList
//       .where((element) =>
//           element.path!.startsWith(parentPath + '.') &&
//           element.path != path &&
//           element.path!.split('.').length ==
//               path.split('.').length) // Same level
//       .toList();
// }

// T? getScopedDependencyByName(String name, String currentPath) {
//   final pathSegments = currentPath.split('.');
//
//   // upwards in the path
//   for (int i = pathSegments.length - 1; i >= 0; i--) {
//     final currentPathSegment = pathSegments.sublist(0, i + 1).join('.');
//
//     // in the current scope
//     final element = getTemplateByPath(currentPathSegment + '.' + name);
//     if (element != null) {
//       return element;
//     }
//   }
//
//   // If not found, check the global scope
//   final rootElements =
//       fields.where((element) => element.path!.split('.').length == 1);
//
//   for (final rootElement in rootElements) {
//     final scopedElement = getScopedElement(rootElement, name);
//     if (scopedElement != null) {
//       return scopedElement;
//     }
//   }
//
//   return null;
// }

// T? getScopedElement(T rootElement, String name) {
//   if (rootElement.name == name) {
//     return rootElement;
//   }
//
//   if (rootElement is TreeSectionElement) {
//     for (final child in getDescendants(rootElement.path!)) {
//       final element = getScopedElement(child, name);
//       if (element != null) {
//         return element;
//       }
//     }
//   }
//
//   // // Check if it is a repeat section with children
//   // if (rootElement is RepeatSectionElement) {
//   //   for (final child in rootElement.fields) {
//   //     final element = getScopedElement(child as T, name);
//   //     if (element != null) {
//   //       return element;
//   //     }
//   //   }
//   // }
//
//   return null;
// }

// /// Get element by name (nearest in scope)
// T? getScopedDependencyByName2(String name, String currentPath) {
//   final pathSegments = currentPath.split('.');
//
//   // Look for the element in the current hierarchy, moving up through ancestors
//   for (int i = pathSegments.length - 1; i >= 0; i--) {
//     final currentPathSegment = pathSegments.sublist(0, i + 1).join('.');
//     final scopedElement = getTemplateByPath(currentPathSegment + '.' + name);
//
//     if (scopedElement != null) {
//       return scopedElement;
//     }
//   }
//
//   // Check for siblings (elements sharing the same parent path)
//   final parentPath = pathSegments.length > 1
//       ? pathSegments.sublist(0, pathSegments.length - 1).join('.')
//       : ''; // Root level has no parent path
//   final siblingElement = flatFieldsList.firstOrNullWhere((element) =>
//       element.name == name &&
//       element.path!.startsWith(parentPath) &&
//       element.path != currentPath && // Not the same element
//       element.path!.split('.').length ==
//           currentPath.split('.').length); // Same level
//
//   if (siblingElement != null) {
//     return siblingElement;
//   }
//
//   // Check global scope (elements at the root level)
//   return flatFieldsList.firstOrNullWhere((element) =>
//       element.name == name && element.path!.split('.').length == 1);
// }
}
