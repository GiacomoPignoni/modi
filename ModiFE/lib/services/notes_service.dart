import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/combo_dialog.dart';
import 'package:modi/models/moods.dart';
import 'package:modi/models/req/note_reqs.dart';
import 'package:modi/models/res/base_res.dart';
import 'package:modi/models/res/note_res.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/services/ad_service.dart';
import 'package:modi/services/http_service.dart';
import 'package:modi/services/message_service.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

/// Service that handle all the data for notes
/// 
/// With this service you get get, create, update and delete notes.
/// It uses HTTP request to save data on Firebase Firestore DB
class NotesService {
  final HttpService _httpSvc = GetIt.I.get<HttpService>();
  final MessageService _messageSvc = GetIt.I.get<MessageService>();
  final UserService _userSvc = GetIt.I.get<UserService>();
  final AdService _adSvc = GetIt.I.get<AdService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  /// Notes cache
  /// 
  /// They are cache by date string formatted with private method [_getDateKeyString]
  final Map<String, SingleNote> _notes = {};

  /// Partner notes cache
  /// 
  /// They are cache by date string formatted with private method [_getDateKeyString]
  final Map<String, SingleNote> _partnerNotes = {};

  /// List to keep track of loaded years
  final List<int> _loadedYears = [];

  /// List to keep track of loaded years
  final List<int> _partnerLoadedYears = [];

  /// Async get a single note, it will do a HTTP request and 
  /// wait for it if the notes are not already loaded
  /// 
  /// Notes are loaded by year
  Future<SingleNote?> asyncGet(DateTime date) async {
    if(_notes.isEmpty) {
      await _load();
    }

    return _notes[_getDateKeyString(date)];
  }

  /// Sync get a single note, it won't do a HTTP request, so you need to say to 
  /// the service to preload data with method [preloadYearNotes]
  SingleNote? get(DateTime date) {
    return _notes[_getDateKeyString(date)];
  }

  /// Sync get a single note of the partner, it won't do a HTTP request, so you need to say to 
  /// the service to preload data with method [preloadPartnerYearNotes]
  SingleNote? getPartnerNote(DateTime date) {
    return _partnerNotes[_getDateKeyString(date)];
  }

  /// Return all the unlocked notes for the given year
  /// 
  /// It won't make a HTTP request to download them, so pay attention to preload them
  List<SingleNote> getUnlocked(int year) {
    return _notes.values.where(
      (x) => x.date.year == year && x.unlocked == true
    ).toList();
  }

  /// Return all the unlocked partner notes for the given year
  /// 
  /// It won't make a HTTP request to download them, so pay attention to preload them
  Future<List<SingleNote>> getPartnerNotesUnlocked(int year, { bool forceRealod = false }) async {
    await preloadPartnerYearNotes(year, forceRealod: forceRealod);
    return _partnerNotes.values.where(
      (x) => x.date.year == year && x.unlocked == true
    ).toList();
  }

  /// Make HTTP Request to get notes from Firebase Firestore DB and save it in [_notes]
  /// 
  /// If not year be passed, it will use current year
  Future<void> _load([int? year]) async {
    final selectedYear = year ?? DateTime.now().year;
    final dateFrom = DateTime(selectedYear, 01, 01);
    final dateTo = DateTime(selectedYear, 12, 31);

    final res = await _httpSvc.get<GetManyNotesRes>(
      "/notes/many?dateFrom=$dateFrom&dateTo=$dateTo",
      serializer: (json) => GetManyNotesRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        for(var note in res.notes) {
          _notes[_getDateKeyString(note.date)] = note;
        }
        _loadedYears.add(selectedYear);
      } else {
        _messageSvc.showErrorDialog(res.message);
      }
    }
  }

  /// Preload in cache the notes for the given year
  Future<void> preloadYearNotes(int year) async {
    if(_loadedYears.contains(year) == false) {
      return await _load(year);
    }
  }

  /// Preload in cache the partner notes for the given year
  Future<void> preloadPartnerYearNotes(int year, { bool forceRealod = false }) async {
    if(_partnerLoadedYears.contains(year) == false || forceRealod) {
      final res = await _httpSvc.get<GetManyNotesRes>(
        "/notes/partner/$year",
        serializer: (json) => GetManyNotesRes.fromJson(json)
      );

      if(res != null) {
        if(res.isNotError) {
          for(var note in res.notes) {
            _partnerNotes[_getDateKeyString(note.date)] = note;
          }

          if(res.notes.isNotEmpty) {
            _partnerLoadedYears.add(year);
          }
        } else {
          _messageSvc.showErrorDialog(res.message);
        }
      }
    }
  }

  /// Add a note and save it on Firebase Firestore DB with a HTTP request
  Future<bool> add(String text, Mood mood, DateTime date) async {
    final input = AddNoteReq(
      date: date,
      text: text,
      mood: mood.index,
      timezoneOffset: DateTime.now().timeZoneOffset
    );

    final res = await _httpSvc.post<AddNotesRes>(
      "/notes/add",
      input,
      serializer: (json) => AddNotesRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        _notes[_getDateKeyString(date)] = res.note!;
        _userSvc.updateTokens(res.tokens);
        _userSvc.updateCombo(res.comboCounter);
        
        final now = DateTime.now();
        // If is today show an AD
        if(now.day == date.day && now.month == date.month && date.year == now.year) {
          await _adSvc.showFullPage();
        }

        _messageSvc.showSnackBar(type: MessageType.success, text: tr("notesService.noteSubmitted"));

        if(res.comboType != null) {
          ComboDialog.show(
            _navigationSvc.currentContext, 
            comboType: res.comboType!,
            gainedTokens: res.gainedTokens,
            tokens: res.tokens
          );
        }

        return true;
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: res.message);
      }
    }

    return false;
  }

  /// Update a note and save it on Firebase Firestore DB with a HTTP request
  Future<bool> update(String id, String text, Mood mood) async {
    final input = UpdateNoteReq(
      id: id,
      text: text,
      mood: mood.index,
      timezoneOffset: DateTime.now().timeZoneOffset
    );

    final res = await _httpSvc.put<UpdateNoteRes>(
      "/notes/update",
      input,
      serializer: (json) => UpdateNoteRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        _messageSvc.showSnackBar(type: MessageType.success, text: tr("notesService.noteUpdated"));
        _notes[_getDateKeyString(res.note!.date)] = res.note!;
        return true;
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: res.message);
      }
    }

    return false;
  }

  /// Delete a note and save it on Firebase Firestore DB with a HTTP request
  Future<bool> delete(String id) async {
    final res = await _httpSvc.delete<BaseRes>(
      "/notes/delete/$id",
      serializer: (json) => BaseRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        _notes.removeWhere((key, value) => value.id == id);
        _messageSvc.showSnackBar(type: MessageType.success, text: tr("notesService.noteDeleted"));
        return  true;
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: res.message);
      }
    }

    return false;
  } 

  Map<Mood, int> getMoodsCount(int year) {
    final notes = _notes.values.where((x) => x.date.year == year);
    final Map<Mood, int> moodsMap = {};

    for (var mood in Mood.values) {
      moodsMap[mood] = notes.fold<int>(0, (a, b) => (b.mood == mood) ? a + 1 : a);
    }

    return moodsMap;
  }

  Future<Map<Mood, int>> getPartnerMoodsCount(int year, { bool forceRealod = false }) async {
    await preloadPartnerYearNotes(year, forceRealod: forceRealod);

    final notes = _partnerNotes.values.where((x) => x.date.year == year);
    final Map<Mood, int> moodsMap = {};

    for (var mood in Mood.values) {
      moodsMap[mood] = notes.fold<int>(0, (a, b) => (b.mood == mood) ? a + 1 : a);
    }

    return moodsMap;
  }

  void addNoteToCache(SingleNote note) {
    _notes[_getDateKeyString(note.date)] = note;
  }

  String _getDateKeyString(DateTime date) {
    return "${date.day.toString().padLeft(2, "0")}${date.month.toString().padLeft(2, "0")}${date.year}";
  }
}
