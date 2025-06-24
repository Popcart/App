import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:popcart/route/route_constants.dart';

class SelectInterestsScreen extends StatefulWidget {
  const SelectInterestsScreen({super.key});

  @override
  State<SelectInterestsScreen> createState() => _SelectInterestsScreenState();
}

class _SelectInterestsScreenState extends State<SelectInterestsScreen> {
  final List<ProductCategory> selectedInterests = [];

  @override
  void initState() {
    super.initState();
    context.read<InterestCubit>().getInterests();
  }

  Future<void> saveInterest() async {
    final interests = context.read<InterestCubit>();
    final selected = selectedInterests.map((e) => e.id).toList();
    await interests.saveInterest(selected);
  }

  @override
  Widget build(BuildContext context) {
    final interestCubit = context.watch<InterestCubit>();
    final l10n = AppLocalizations.of(context);

    return BlocListener<InterestCubit, InterestListState>(
      listener: (context, state) {
        state.whenOrNull(
          saveInterestFailure: (message) {
            context.showError(message);
          },
          saveInterestSuccess: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              buyerHome,
                  (route) => false,
            );
          },
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBackButton(),
                const SizedBox(height: 32),
                Text(
                  l10n.select_interests,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  children: interestCubit.interestsList
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: ChoiceChip(
                            selectedColor: AppColors.orange,
                            showCheckmark: false,
                            backgroundColor: const Color(0xff24262b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                color: selectedInterests.contains(e)
                                    ? AppColors.orange
                                    : const Color(0xff50535b),
                              ),
                            ),
                            labelStyle: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            label: Text(e.name),
                            selected: selectedInterests.contains(e),
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  selectedInterests.add(e);
                                } else {
                                  selectedInterests.remove(e);
                                }
                              });
                            },
                          ),
                        ),
                      ).toList(),
                ),
                const SizedBox(height: 32),
                if (interestCubit.interestsList.isNotEmpty)...{
                  CustomElevatedButton(
                    text: l10n.next,
                    loading: context.watch<InterestCubit>().state.maybeWhen(
                          orElse: () => false,
                          loading: () => true,
                        ),
                    enabled: selectedInterests.isNotEmpty,
                    onPressed: () {
                      if (selectedInterests.isNotEmpty) {
                        saveInterest();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          buyerHome,
                              (route) => false,
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
