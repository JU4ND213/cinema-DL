import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants.dart';
import 'services/tmdb_api.dart';
import 'providers/movie_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final favProv = FavoritesProvider();
  await favProv.init();
  runApp(MyApp(favProv: favProv));
}

class MyApp extends StatelessWidget {
  final FavoritesProvider favProv;
  const MyApp({required this.favProv, super.key});

  @override
  Widget build(BuildContext context) {
    final api = TmdbApi(apiKey: TMDB_API_KEY);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider(api: api)),
        ChangeNotifierProvider(create: (_) => favProv),
      ],
      child: MaterialApp(
        title: 'Movies App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
