
library swift_composer;

class DiConfig {
  Map<String, dynamic> config = {};

  void append(Map config, String? prefix) {
    _mergeMaps(this.config, config, prefix);
  }

  void _mergeMaps(Map first, Map other, String? prefix) {
    for (var key in other.keys) {
      String prefixedKey = (prefix != null) ? prefix + '.' + key : key;
      if (first.containsKey(prefixedKey) && first[prefixedKey] is Map) {
        _mergeMaps(first[prefixedKey] as Map, other[key], null);
      } else {
        first[prefixedKey] = other[key];
      }
    }
  }

}

class OutputWriter {
  List<String> _lines = [];

  writeLn(String line) {
    _lines.add(line);
  }

  writeMany(List<String> lines) {
    _lines.addAll(lines);
  }

  writeSplit() {
    this.writeLn('// **************************************************************************');
  }

  String getOutput() => _lines.join("\n");
}