

import 'package:analyzer/dart/element/element.dart' as annotationTest;
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

class Param {
  final String name;
  final int id;

  const Param(this.name, this.id);
}

@Param("test", 1)
class TestModel {}

class TestGenerator extends GeneratorForAnnotation<Param> {
  @override
  generateForAnnotatedElement(annotationTest.Element element, ConstantReader annotation, BuildStep buildStep) {
    return "class Wang {}";
  }
}

LibraryBuilder testBuilder(_) {
  return LibraryBuilder(TestGenerator());
}