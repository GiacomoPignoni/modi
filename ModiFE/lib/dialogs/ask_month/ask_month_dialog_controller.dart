import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';

class AskMonthDialogController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  
  final monthNums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  final ValueNotifier<int?> selectedMonth = ValueNotifier(null);

  void onSelectedMonthChange(int? newValue) {
    selectedMonth.value = newValue;
  }

  void confirm() {
    if(selectedMonth.value != null) {
      _navigationSvc.pop(selectedMonth.value);
    }
  }

  void cancel() {
    _navigationSvc.pop(null);
  }

  void dispose() {
    selectedMonth.dispose();
  }
}
