import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/di/service_locator.dart'; 
import 'logic/cubits/country_cubit.dart';
import 'logic/cubits/favorites_cubit.dart';
import 'presentation/screens/main_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CountryCubit()..getAllCountries(),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(prefs),
        ),
      ],
      child: MaterialApp(
        title: 'Countries App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        themeMode: ThemeMode.system,
        home: const MainWrapper(),
      ),
    );
  }
}