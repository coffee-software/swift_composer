library swift_composer.test;

import 'package:test/test.dart';

import 'compose/compose.dart' as compose_test;
import 'config/config.dart' as config_test;
import 'subtypes/subtypes.dart' as subtypes_test;
import 'factory/factory.dart' as factory_test;
import 'fields/fields.dart' as fields_test;
import 'plugins/plugins.dart' as plugins_test;
import 'generics/generics.dart' as generics_test;
import 'namespaces/namespaces.dart' as namespaces_test;

void main() {

    test('compose', () {
      var container = new compose_test.$Container(
          compose_test.$om.foo_Foo,
          compose_test.$om.generics_SimpleGeneric_foo_Foo_,
          compose_test.$om.generics_SimpleGeneric_String_,
          compose_test.$om.generics_ComplexGeneric_foo_Foo_foo_Foo_
      );

      expect(container.fooInjected.stringField, equals('FooField'));
      expect(container.fooCreated.stringField, equals('FooField'));
      expect(container.fooRequired.stringField, equals('FooField'));
    });

    test('config', () {
      expect(config_test.$om.toString(), isNotNull);
    });

    test('subtypes', () {
      expect(subtypes_test.$om.module_test1_Foo, isNotNull);
      expect(subtypes_test.$om.container.subtypes.allClassNames, equals(['module_test1.Foo', 'module_test1.FooChild', 'module_test1.FooChild2']));
      expect(subtypes_test.$om.container.subtypes.getCode<subtypes_test.Foo>(), equals('module_test1.Foo'));
    });

    test('factory', () {
      factory_test.$om.container.test();
    });

    test('fields', () {
      expect(
          fields_test.$om.childContainer.toJson(),
          equals({
              'six': {
                'name': 'six',
                'className': 'foo.Foo',
                'boolParam': true,
                'intParam_value': 3,
                'stringParam_value': 'test',
                'complexParam_value1': 5,
                'complexParam_value2': 'something',
                'value.stringField': 'FooField'
              },
              'fifth': {
                'name': 'fifth',
                'className': 'foo.Foo',
                'boolParam': false,
                'intParam_value': 1,
                'stringParam_value': 'test1',
                'complexParam_value1': 2,
                'complexParam_value2': 'test2',
                'value.stringField': 'FooField'
              },
              'one': {
                'name': 'one',
                'className': 'foo.Foo',
                'boolParam': false,
                'intParam_value': 1,
                'stringParam_value': 'test1',
                'complexParam_value1': 2,
                'complexParam_value2': 'test2',
                'value.stringField': 'FooField'
              },
              'two': {
                'name': 'two',
                'className': 'foo.Foo',
                'boolParam': false,
                'intParam_value': 1,
                'stringParam_value': 'test1',
                'complexParam_value1': 2,
                'complexParam_value2': 'test2',
                'value.stringField': 'FooField'
              },
              'three': {
                'name': 'three',
                'className': 'foo.FooChild',
                'boolParam': false,
                'intParam_value': 1,
                'stringParam_value': 'test1',
                'complexParam_value1': 2,
                'complexParam_value2': 'test2',
                'value.stringField': 'FooChildField'
              },
              'four': 'bar.BarChild'
          })
      );
      var created = fields_test.$om.container.fromJson({
        'one': 'one',
        'two': 'two',
        'three': 'three',
        'four': 'four',
        'fifth': 'bar',
      });
      expect(
          created.one.stringField,
          equals(
              'FooChildField'
          )
      );
    });

    test('plugins', () {
      expect(plugins_test.$om.foo_Foo.format('prefix'), equals('AFTER:Foo: prefix:BEFORE foo.Foo FooField 124'));

      expect(plugins_test.$om.genericTypedWithFoo.getDescription(
          plugins_test.$om.genericTypedWithFoo.element
      ), equals(
          'stringField=FooField'
      ));
    });

    test('generics', () {
      expect(generics_test.$om.typedGeneric2, isNotNull);
      expect(generics_test.$om.typedGeneric2.instancesOfFoo.length, equals(1));
    });

    test('namespaces', () {
      expect(namespaces_test.$om.foo2_module_Foo, isNotNull);
      expect(namespaces_test.$om.bar_module_Bar, isNotNull);
      expect(namespaces_test.$om.nested_module_CombinedFoo, isNotNull);
    });
}
