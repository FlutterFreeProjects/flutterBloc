import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/data/models/characters_model.dart';
import 'package:flutterbloc/data/models/quotes_model.dart';
import 'package:flutterbloc/data/repository/character_repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharacterRepository characterRepository;
  List<CharactersModel> characters=[];

  CharactersCubit(this.characterRepository) : super(CharactersInitial());

  List<CharactersModel> getAllCharacters() {
    characterRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }

  void getQuotes(String charName) {
    characterRepository.getCharacterQuotes(charName).then((quotes) {
      emit(QuotesLoaded(quotes));
    });

  }

}
