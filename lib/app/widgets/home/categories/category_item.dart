import 'package:flutter/material.dart';
import 'package:talent_pitch/app/enums/category.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/widgets/home/categories/challenges/item.dart';
import 'package:talent_pitch/app/widgets/home/categories/companies/item.dart';
import 'package:talent_pitch/app/widgets/home/categories/talents/item.dart';

class CategoryItem extends StatelessWidget {
  /// Item [category]
  final Category category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              '${category.title} (${category.models.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          switch (category.type) {
            CategoryType.talentees => TalentsItem(
                category: category,
              ),
            CategoryType.challenges => ChallengesItem(
                category: category,
              ),
            CategoryType.companies => CompaniesItem(
                category: category,
              ),
          },
        ],
      ),
    );
  }
}
