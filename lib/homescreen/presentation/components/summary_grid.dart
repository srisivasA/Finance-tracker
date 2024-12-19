import 'package:flutter/material.dart';

import 'summary_card.dart';

class SummaryGrid extends StatelessWidget {
  final List<SummaryCard> cards;

  const SummaryGrid({Key? key, required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return cards[index];
        },
      ),
    );
  }
}
