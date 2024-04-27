import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/company.dart';
import 'package:talent_pitch/app/states/categories.dart';
import 'package:talent_pitch/app/states/playlist.dart';
import 'package:talent_pitch/app/states/repositories/company.dart';

class CompaniesItem extends ConsumerStatefulWidget {
  /// Item [category]
  final Category category;

  /// [companyRepository]
  final CompanyRepository companyRepository = CompanyRepository();

  CompaniesItem({super.key, required this.category});

  @override
  CompaniesItemState createState() => CompaniesItemState();
}

class CompaniesItemState extends ConsumerState<CompaniesItem>
    with AutomaticKeepAliveClientMixin {
  late final Future<List<Company>> futureCompanies;

  @override
  void initState() {
    futureCompanies =
        widget.companyRepository.categoryUrlCompanies(widget.category.url);
    futureCompanies.then(
      (List<Company> companies) => ref
          .read(asyncCategoriesProvider.notifier)
          .setCategoryModels(widget.category, companies),
    );
    super.initState();
  }

  void onTapCompany(int index, Company company) {
    ref
        .read(playlistNotifierProvider.notifier)
        .setCategory(widget.category, index);
    context
        .pushNamed('/viewer')

        /// Temporal fix to Pop Callback
        .then((value) {
      ref.read(playlistNotifierProvider.notifier).onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Company>>(
      future: futureCompanies,
      builder: (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
        return CompanyItem(
          loading: snapshot.connectionState == ConnectionState.waiting,
          category: widget.category,
          companies: snapshot.data,
          onTap: onTapCompany,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CompanyItem extends StatelessWidget {
  /// [loading]
  final bool loading;

  /// Parent [category]
  final Category category;

  /// List of [companies]
  final List<Company>? companies;

  /// [onTap] on talent
  final void Function(int index, Company company) onTap;

  const CompanyItem(
      {super.key,
      required this.loading,
      this.companies,
      required this.category,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: !loading && (companies?.isEmpty ?? true)
          ? const Center(
              child: Text('Sin resultados'),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (category.image != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageUrl: category.image!,
                        placeholder: (BuildContext context, String url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget:
                            (BuildContext context, String url, Object? error) =>
                                const Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                if (loading && companies == null)
                  Skeletonizer(
                      child: Row(
                    children: List.generate(
                        3,
                        (index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: LoadingCompany(),
                            )),
                  )),
                if (companies != null)
                  Row(
                    children: companies!
                        .mapIndexed((int index, Company company) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: CompanyContent(
                                  company: company,
                                  onTap: () {
                                    onTap(index, company);
                                  }),
                            ))
                        .toList(),
                  )
              ],
            ),
    );
  }
}

class CompanyContent extends StatelessWidget {
  /// [company]
  final Company company;

  /// [onTap] callback
  final VoidCallback onTap;

  const CompanyContent({super.key, required this.company, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: company.logo != null
                  ? Image.network(company.logo!).image
                  : null,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          GestureDetector(
            onTap: onTap,
            child: Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  company.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          OutlinedButton(onPressed: () {}, child: const Text('Follow')),
        ],
      ),
    );
  }
}

class LoadingCompany extends StatelessWidget {
  const LoadingCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 25,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        const Text('Company name'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        OutlinedButton(onPressed: () {}, child: const Text('Follow')),
      ],
    );
  }
}
