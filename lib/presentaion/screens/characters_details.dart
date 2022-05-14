import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/business_login/cubit/characters_cubit.dart';
import 'package:flutterbloc/constants/my_colors.dart';
import 'package:flutterbloc/data/models/characters_model.dart';

class CharactersDetailsScreen extends StatelessWidget {
  final CharactersModel character;

  CharactersDetailsScreen({Key? key, required this.character})
      : super(key: key);

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.nickname,
          style: const TextStyle(
            color: MyColors.myWhite,
          ),
          textAlign: TextAlign.start,
        ),
        background: Hero(
            tag: character.charId,
            child: Image.network(
              character.img,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: title,
            style: const TextStyle(
                color: MyColors.myWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        TextSpan(
            text: value,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontSize: 16,
            ))
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDevider(double endIndent) {
    return Divider(
      height: 30,
      endIndent: endIndent,
      color: MyColors.myYellow,
      thickness: 2,
    );
  }

  Widget checkIfCodesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: MyColors.myWhite, shadows: [
            Shadow(
                blurRadius: 7, color: MyColors.myYellow, offset: Offset(0, 0))
          ]),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [FlickerAnimatedText(quotes[randomQuoteIndex].quote)],
          ),
        ),
      );
    }
    return Container();
  }

  Widget showProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  characterInfo('job : ', character.occupation.join(' / ')),
                  buildDevider(340),
                  characterInfo(
                      'Appeared in : ', character.appearance.toString()),
                  buildDevider(300),
                  characterInfo('Season : ', character.appearance.join(' / ')),
                  buildDevider(280),
                  characterInfo('Status : ', character.status),
                  buildDevider(280),
                  // character.betterCallSaulAppearance!.isEmpty
                  //     ? characterInfo('Better Call Saul : ',
                  //         character.betterCallSaulAppearance!.join(' / '))
                  //     : Container(),
                  // character.betterCallSaulAppearance!.isEmpty
                  //     ? buildDevider(280)
                  //     : Container(),
                  characterInfo('Actor/Actoress : ', character.portrayed),
                  buildDevider(235),
                  const SizedBox(height: 20),
                  BlocBuilder<CharactersCubit, CharactersState>(
                      builder: ((context, state) {
                    return checkIfCodesAreLoaded(state);
                  }))
                ],
              ),
            ),
            const SizedBox(
              height: 600,
            )
          ])),
        ],
      ),
    );
  }
}
