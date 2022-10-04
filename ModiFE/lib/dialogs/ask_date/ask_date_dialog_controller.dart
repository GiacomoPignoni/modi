import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';

class AskDateDialogController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  DateTime selectedDateTime = DateTime.now();

  void onDateTimeChange(DateTime newValue) {
    selectedDateTime = newValue;
  }

  void confirm() {
    _navigationSvc.pop(selectedDateTime);
  }

  void cancel() {
    _navigationSvc.pop(null);
  }

  void dispose() {
    
  }
}
