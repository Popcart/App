import 'package:flutter/material.dart';
import 'package:popcart/gen/assets.gen.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SearchTextField(),
          ],
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search popcart',
        hintStyle: const TextStyle(color: Color(0xffD7D8D9), fontSize: 16),
        prefixIcon: AppAssets.images.search.image(),
        fillColor: const Color(0xff24262B),
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
