import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/business_login/cubit/characters_cubit.dart';
import 'package:flutterbloc/data/models/characters_model.dart';
import 'package:flutterbloc/data/repository/character_repository.dart';
import 'package:flutterbloc/presentaion/screens/character_screen.dart';
import 'package:flutterbloc/presentaion/screens/characters_details.dart';
import 'package:flutterbloc/presentaion/screens/signin.dart';
import 'package:flutterbloc/presentaion/screens/signup.dart';

import 'business_login/bloc/auth_bloc.dart';
import 'data/api_services/characters_api_services.dart';
import 'data/repository/auth_repository.dart';

class AppRoute {
  late CharacterRepository characterRepository;
  late CharactersCubit charactersCubit;

  AppRoute() {
    characterRepository = CharacterRepository(CharactersApiServices());
    charactersCubit = CharactersCubit(characterRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => RepositoryProvider(
            create: (context) => AuthRepository(),
            child: BlocProvider(
              create: (BuildContext context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context)),
              child: SignIn(),
            ),
          ),
        );
        // case '/':
        // return MaterialPageRoute(
        //   builder: (_) => RepositoryProvider(
        //     create: (context) => AuthRepository(),
        //     child: BlocProvider(
        //       create: (BuildContext context) => AuthBloc(
        //   authRepository: RepositoryProvider.of<AuthRepository>(context)),
        //       child: SignUp(),
        //     ),
        //   ),
        // );
      case '/characters_screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: CharacterScreen(),
          ),
        );
      case '/characters_details':
        final character = settings.arguments as CharactersModel;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) => charactersCubit,
                  child: CharactersDetailsScreen(
                    character: character,
                  ),
                ));
    }
    return null;
  }
}
