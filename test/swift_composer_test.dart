library swift_composer.test;

import 'package:test/test.dart';

import 'compose/compose.dart' as compose_test;
import 'config/config.dart' as config_test;
import 'factory/factory.dart' as factory_test;
import 'fields/fields.dart' as fields_test;
import 'generics/generics.dart' as generics_test;
import 'namespaces/namespaces.dart' as namespaces_test;
import 'plugins/plugins.dart' as plugins_test;
import 'subtypes/subtypes.dart' as subtypes_test;

void main() {

    test('config', () {
      expect(config_test.$om.toString(), isNotNull);
    });

    test('plugins', () {
      expect(plugins_test.$om.module_test1_Foo.format('prefix'), equals('AFTER:prefix:BEFOREmodule_test1.FooFooField124'));
    });

    test('namespaces', () {
      expect(namespaces_test.$om.test_module1_Bar, isNotNull);
    });

    test('subtypes', () {
      expect(subtypes_test.$om.module_test1_Foo, isNotNull);
    });

    test('compose', () {

      expect(compose_test.$om.m1_Foo.stringField, equals(
        'FooField'
      ));

      expect(compose_test.$om.genericTypedWithFoo.getDescription(
          compose_test.$om.genericTypedWithFoo.element
      ), equals(
        'stringField=FooField'
      ));

    });

    test('generics', () {
      expect(generics_test.$om.typedGeneric2, isNotNull);
      expect(generics_test.$om.typedGeneric2.instancesOfFoo.length, equals(1));
    });

    test('factory', () {
      var foo = factory_test.$om.container.createFoo();
      var sub = factory_test.$om.container.createSubFoo('module_test.FooChild');
      factory_test.$om.container.createComplex('test', foo);
    });

    test('fields', () {
      expect(
        fields_test.$om.container.toJson(),
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
      var created = fields_test.$om.container.fromJson({
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
