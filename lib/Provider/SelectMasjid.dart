import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectMasjid extends ChangeNotifier {
  Map<String, bool> selectedMasjids = {};

  SelectMasjid() {
    loadSelectedMasjids();
  }

  bool isMasjidSelected(String documentId) {
    return selectedMasjids[documentId] ?? false;
  }

  void toggleMasjidSelection(String documentId) {
    selectedMasjids[documentId] = !selectedMasjids[documentId]!;
    notifyListeners();
    _saveSelectedMasjids();
  }

  void initializeMasjid(String documentId) {
    if (!selectedMasjids.containsKey(documentId)) {
      selectedMasjids[documentId] = false;
    }
  }

  void _saveSelectedMasjids() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedIds = selectedMasjids.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    await prefs.setStringList('selectedMasjids', selectedIds);
  }

  void loadSelectedMasjids() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedIds = prefs.getStringList('selectedMasjids') ?? [];
    for (String id in selectedIds) {
      selectedMasjids[id] = true;
    }
    notifyListeners();
  }
}
