
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
        //make sure maps are modifiable.
        first[prefixedKey] = other[key] is Map ? Map.from(other[key]) : other[key];
      }
    }
  }

}

class OutputWriter {
  bool debug;
  OutputWriter(this.debug);

  List<String> _lines = [];

  writeLn(String line, {bool debug = false}) {
    if (this.debug == true || debug == false) {
      _lines.add(line);
    }
  }

  writeMany(List<String> lines, {bool debug = false}) {
    if (this.debug == true || debug == false) {
      _lines.addAll(lines);
    }
  }

  writeSplit() {
    this.writeLn('// **************************************************************************');
  }

  String getOutput() => _lines.join("\n");
}