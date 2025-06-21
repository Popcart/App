import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';

class InterestFilter extends StatefulHookWidget {
  const InterestFilter({super.key});

  @override
  State<InterestFilter> createState() => _InterestFilterState();
}

class _InterestFilterState extends State<InterestFilter> {
  final selectedInterests = ValueNotifier<Set<ProductCategory>>({});

  @override
  Widget build(BuildContext context) {
    final interestListCubit = context.watch<InterestCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text('Filter', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Styles', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),)),
          const SizedBox(height: 10,),
          Expanded(
            child: SingleChildScrollView(
              child: ValueListenableBuilder<Set<ProductCategory>>(
                valueListenable: selectedInterests,
                builder: (context, selected, _) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: interestListCubit.state.maybeWhen(
                      orElse: () => [],
                      loaded: (interests) => interests.map((interest) {
                        final isSelected = selected.contains(interest);
                        return GestureDetector(
                          onTap: () {
                            final current = selectedInterests.value;
                            if (isSelected) {
                              selectedInterests.value = {...current}..remove(interest);
                            } else {
                              selectedInterests.value = {...current, interest};
                            }
                          },
                          child: Chip(
                            label: Text(interest.name),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xff676C75),
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            backgroundColor:
                            isSelected ? const Color(0xff676C75) : const Color(0xff111214),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10,),
          CustomElevatedButton(
            text: 'Save Interest',
            showIcon: false,
            onPressed: (){
              Navigator.pop(context, selectedInterests.value.toList());
            },
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
