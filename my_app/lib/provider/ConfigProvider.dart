import 'package:flutter/material.dart';
import 'package:my_app/model/ConfigField.dart';
import 'package:my_app/services/ApiService.dart';

class ConfigProvider with ChangeNotifier {
  List<ConfigField> _config = [];
  bool _isLoading = true;

  List<ConfigField> get config => _config;
  bool get isLoading => _isLoading;
  Future<void> loadConfig() async {
    try {
      final List<dynamic> rawData = await ApiService().fetchConfig();
      _config = rawData.map((json) => ConfigField.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching config: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateConfig(String name, String newValue) {
    final index = _config.indexWhere((field) => field.name == name);
    if (index != -1) {
      _config[index] = ConfigField(
        name: _config[index].name,
        value: newValue,
        label: _config[index].label,
        placeholder: _config[index].placeholder,
        tooltip: _config[index].tooltip,
      );
      notifyListeners();
    }
  }
}
