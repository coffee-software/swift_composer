# 0.9.0

* update analyzer to 8.4.1 and sdk to ^3.9.0
* added linter rules and fixed issues and formatting
* fix error when compiled method part optional argument does not define default value explicitly
* remove deprecated field 'parent' in plugins
* add ComposeIfModule annotation for conditional composition
* prevent plugins on non-existing types to break compilation
* get methods from mixins. allows defining factories and method parts in mixins
* support map in type config
* add separate exception when type is missing in factory constructors
* allow special characters in annotation values
* override accessors feature
* add mixin fields after declared fields in method generation
* allow storing enum as string in config
* run parent compiled method bits parts first (before plugins)
* reorder config read, allow lowest level override
* allow enums in yaml config, added tests for inject config types
* add decorated method params to after plugin
* allow string lists in config
* support mixins in field method generators
* ignore analysis warnings for generated code
* allow translated constants in compiled methods parts
* bugfix: generating code for elements with setter only
* fix null error when computing annotation value
* support for using singletons in annotations for compiled methods

# 0.8.1

* update sdk dependency

# 0.8.0

* change name of config files
* add SubtypeInfo and refactor inject by type
* fix enums
* support for async method plugins
* refactor imports handling
* compiled methods optimisation
* fixes for widgets generation
* support for require annotation with value
* other bugfixes

# 0.7.0

* support for mixins
* widgets index functionality
* CompileFieldsOfType: add annotations as parameters and support for dynamic type
* add SubtypesOf<> class (deprecated InjectSubtypeNames) and baseClassName mapping
* fixes for generic interceptors

# 0.6.0

* update sdk and build system dependencies
* fix plugins generation for Lists
* separate generation bits for nullable and nonnullable fields
* add debug parameter
* improve instances creation performance
* feature to read config directory
* bugfixes

# 0.5.0

refactor type info logic and integration tests

# 0.4.0

fixes for dart 2.14 release, tests cleanup

# 0.3.0

null safety updates

# 0.2.0

added `@MethodPlugin`

# 0.1.0

initial release
