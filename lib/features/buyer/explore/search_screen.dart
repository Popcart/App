import 'package:flutter/material.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/gen/assets.gen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(
              children: [
                const AppBackButton(),
                const SizedBox(width: 20,),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search popcart',
                      hintStyle:
                          const TextStyle(color: Color(0xffD7D8D9), fontSize: 16),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AppAssets.icons.search.svg(),
                      ),
                      fillColor: const Color(0xff24262B),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
