import 'package:quran/injection_container.dart';
import 'package:quran/features/presentation/bloc/main_bloc.dart';
import 'package:quran/features/presentation/page/home_page.dart';

import 'injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MainBloc>(
              create: (context) => MainBloc(searchQuranUseCase: sl(), detectReciterUseCase: sl()))
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          // theme: IPTheme.getTheme(),
          theme: ThemeData(fontFamily: 'Cairo'),
          home: const HomePage(),
        ));
  }
}
