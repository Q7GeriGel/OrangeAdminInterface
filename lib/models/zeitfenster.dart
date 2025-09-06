class Zeitfenster {
  final DateTime beginn;
  final DateTime ende;
  Zeitfenster(this.beginn, this.ende);

  String get beschriftung {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(beginn.hour)}:${two(beginn.minute)} – ${two(ende.hour)}:${two(ende.minute)}';
  }
}
