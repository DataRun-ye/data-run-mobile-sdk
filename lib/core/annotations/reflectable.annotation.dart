import 'package:reflectable/reflectable.dart';

class AnnotationReflection extends Reflectable {
  const AnnotationReflection()
      : super(
            invokingCapability,
            declarationsCapability,
            reflectedTypeCapability,
            newInstanceCapability,
            metadataCapability,
            staticInvokeCapability,
            typeRelationsCapability,
            typeCapability,
            superclassQuantifyCapability,
            // NMC
            libraryCapability);
}

const AnnotationReflectable = AnnotationReflection();
