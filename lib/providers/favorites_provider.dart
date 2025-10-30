import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String boxName = 'favoritesBox';
  late Box box;

  List<Movie> favorites = [];

  Future<void> init() async {
    box = await Hive.openBox(boxName);
    _loadFromBox();
  }

  void _loadFromBox() {
    favorites = box.values.map((e) {
      final Map<String, dynamic> json = Map<String, dynamic>.from(e);
      return Movie.fromJson(json);
    }).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(Movie m) async {
    final exists = favorites.any((f) => f.id == m.id);
    if (exists) {
      final key = box.keys.firstWhere((k) => box.get(k)['id'] == m.id);
      await box.delete(key);
    } else {
      await box.add(m.toJson());
    }
    _loadFromBox();
  }

  bool isFavorite(int movieId) => favorites.any((f) => f.id == movieId);
}
