import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';

class ProductSearch extends StatefulHookWidget {
  const ProductSearch({super.key});

  @override
  State<ProductSearch> createState() => _InterestFilterState();
}

class _InterestFilterState extends State<ProductSearch> {

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text('Similar Products Available', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        ],
      ),
    );
  }
}
