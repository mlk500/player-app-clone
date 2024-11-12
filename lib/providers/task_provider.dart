import 'package:flutter/foundation.dart';
import 'package:flutter_player/utils/ApiUrls.dart';
import '../model/task_model.dart';
import '../webServices/ApiService.dart';

class QuestionProvider extends ChangeNotifier {
  List<Unit> units = [];
  bool isLoading = true;
  int correctAnswersCount = 0;
  int completedUnits = 0; // Track the number of completed units
  bool isHintDialogVisible = false;
  bool isWakeUpComplete = false;
  final String backend = ApiUrls.backendServiceAPI;
  Future<void> fetchTasksFromQRCode(String qrCodeUrl) async {
    try {
      final fetchedGame =
          await ApiService.fetchGameData('$backend/public/get-game/$qrCodeUrl');
      if (fetchedGame.units.isNotEmpty) {
        units = fetchedGame.units;
        correctAnswersCount = 0; // Reset correct answers count
        completedUnits = 0; // Reset completed units
        isLoading = false;
        notifyListeners();
      } else {
        throw Exception('No units found in the fetched game data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load tasks: $e');
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void goToNextUnit(int unitIndex) {
    if (unitIndex < units.length - 1) {
      completedUnits++; // Increment the completed units
      isHintDialogVisible = false;
      notifyListeners();
    }
  }

  void skipUnit(int unitIndex) {
    if (unitIndex < units.length - 1) {
      completedUnits++; // Increment the completed units
      isHintDialogVisible = false;
      notifyListeners();
    }
  }

  double get progressValue {
    if (units.isEmpty) return 0.0;
    return completedUnits / units.length;
  }

  void incrementCorrectAnswers() {
    correctAnswersCount++;
    notifyListeners();
  }

  bool isLastUnit(int unitIndex) {
    return unitIndex == units.length - 1;
  }

  void resetGame() {
    units.clear(); // Clear the list of units
    isLoading = true; // Reset loading state
    correctAnswersCount = 0; // Reset correct answers
    completedUnits = 0; // Reset completed units
    isHintDialogVisible = false; // Reset hint dialog visibility
    notifyListeners(); // Notify listeners about the state change
  }

  void showHintDialog() {
    isHintDialogVisible = true;
    notifyListeners();
  }

  void hideHintDialog() {
    isHintDialogVisible = false;
    notifyListeners();
  }

  Future<void> wakeUpService() async {
    try {
      await Future.wait([
        ApiService.wakeUpbackend(),
        ApiService.wakeUp(),
      ]);

      isWakeUpComplete = true; // Set this flag to true when wake-up is complete
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to wake up service: $e');
      }
    }
  }
}
