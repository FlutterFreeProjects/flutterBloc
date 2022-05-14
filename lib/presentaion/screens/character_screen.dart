import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/business_login/cubit/characters_cubit.dart';
import 'package:flutterbloc/constants/my_colors.dart';
import 'package:flutterbloc/data/models/characters_model.dart';
import 'package:flutterbloc/presentaion/widgets/character_item.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({Key? key}) : super(key: key);

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late List<CharactersModel> allCharacters;
  late List<CharactersModel> searchedForCharacters;
  bool _isSearching = false;
  final _seachTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allCharacters =
        BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _seachTextController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
          hintText: 'Find Characters...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 10)),
      style: const TextStyle(color: MyColors.myGrey, fontSize: 10),
      onChanged: (searchChar) {
        addItemToSearchList(searchChar);
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
        ),
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearch,
            icon: const Icon(
              Icons.search,
              color: MyColors.myGrey,
            ))
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _seachTextController.clear();
    });
  }

  void addItemToSearchList(String searchChar) {
    searchedForCharacters = allCharacters
        .where(
            (character) => character.name.toLowerCase().startsWith(searchChar))
        .toList();
    setState(() {});
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: ((context, state) {
      if (state is CharactersLoaded) {
        allCharacters = (state).characters;
        return buildLoadedLiestWidget();
      } else {
        return Text('HELLO');
        // showLoadingIndicator();
      }
    }));
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildLoadedLiestWidget() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [buildCharacterList()],
        ),
      ),
    );
  }

  Widget buildCharacterList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _seachTextController.text.isEmpty
          ? allCharacters.length
          : searchedForCharacters.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (ctx, index) {
        return CharacterItem(
            character: _seachTextController.text.isEmpty
                ? allCharacters[index]
                : searchedForCharacters[index]);
      },
    );
  }

  Widget _buildAppBarTitle() {
    return const Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(allCharacters);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        leading: _isSearching
            ? BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
      ),
      body: buildBlocWidget(),
    );
  }
}
