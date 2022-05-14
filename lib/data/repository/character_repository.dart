import 'package:flutter/cupertino.dart';
import 'package:flutterbloc/data/api_services/characters_api_services.dart';
import 'package:flutterbloc/data/models/characters_model.dart';
import 'package:flutterbloc/data/models/quotes_model.dart';

class CharacterRepository {
  final CharactersApiServices charactersApiServices;

  CharacterRepository(this.charactersApiServices);

  Future<List<CharactersModel>> getAllCharacters() async {
    final character = await charactersApiServices.getAllCharacters();
    return character.map((char) => CharactersModel.fromJson(char)).toList();
  }

  Future<List<QuotesModel>> getCharacterQuotes(String charName) async {
    final quotes = await charactersApiServices.getCharacterQuotes(charName);
    return quotes.map((charQuote) => QuotesModel.fromJson(charQuote)).toList();
  }
}
