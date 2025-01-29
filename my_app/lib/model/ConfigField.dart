class ConfigField {
  final String name;
  final String value;
  final String label;
  final String placeholder;
  final String tooltip;
  String? selectedValue;

  ConfigField({
    required this.name,
    required this.value,
    required this.label,
    required this.placeholder,
    required this.tooltip,
  });

  factory ConfigField.fromJson(Map<String, dynamic> json) {
    return ConfigField(
        name: json['name'] ?? '',
        value: json['value'] ?? '',
        label: json['label'] ?? '',
        placeholder: json['placeholder'] ?? '',
        tooltip: json['tooltip'] ?? '');
  }
}
