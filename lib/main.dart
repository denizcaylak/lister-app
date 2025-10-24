import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/list_model.dart';
import 'screens/home_screen.dart';
import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final listsProvider = ListsProvider();
  await listsProvider.loadPreferences();

  runApp(
    ChangeNotifierProvider.value(
      value: listsProvider,
      child: const ListerApp(),
    ),
  );
}

class ListerApp extends StatelessWidget {
  const ListerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListsProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'Lister',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: provider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
