library swift_composer.test;

import 'package:test/test.dart';

import 'sources/compose.dart' as compose;
import 'sources/factory.dart' as factory_test;
import 'sources/fields.dart' as fields;
import 'sources/generics.dart' as generics;

void main() {

    test('compose', () {

      expect(compose.$om.m1_Foo.stringField, equals(
        'FooField'
      ));

      expect(compose.$om.genericTypedWithFoo.getDescription(
          compose.$om.genericTypedWithFoo.element
      ), equals(
        'stringField=FooField'
      ));

    });

    test('generics', () {
      expect(generics.$om.typedGeneric2, isNotNull);
      expect(generics.$om.typedGeneric2.instancesOfFoo.length, equals(1));
    });

    test('factory', () {
      var foo = factory_test.$om.container.createFoo();
      var sub = factory_test.$om.container.createSubFoo('module_test.FooChild');
      factory_test.$om.container.createComplex('test', foo);
    });

    test('fields', () {
      expect(
        fields.$om.container.toJson(),
        equals(
          {
            'one': 'FooField',
            'two': 'FooField',
            'three': 'FooChildField',
            'four': 'FooField',
            'bar': 'module_test.BarChild'
          }
        )
      );
      var created = fields.$om.container.fromJson({
          'one': 'one',
          'two': 'two',
          'three': 'three',
          'four': 'four',
          'bar': 'bar',
      });
      expect(
        created.one.stringField,
        equals(
          'FooChildField'
        )
      );
    });

}
