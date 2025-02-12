import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/bouncing_effect_widget.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class ScheduleSessionScreen extends HookWidget {
  const ScheduleSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final livestreamTitleController = useTextEditingController();
    final startTimeController = useTextEditingController();
    final isScheduled = useState(true);
    final startTime = useState<DateTime?>(null);
    final selectDate = useCallback(() async {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
      );
      if (selectedDate != null && context.mounted) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (selectedTime != null) {
          startTime.value = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          startTimeController.text = startTime.value!.toString();
        }
      }
    });
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: BouncingEffect(
          child: CustomElevatedButton(text: l10n.select_products),
          onTap: () {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              const SizedBox(height: 32),
              Text(
                l10n.start_a_livestream,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                controller: livestreamTitleController,
                hintText: l10n.livestream_title,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),
              ...[true, false].map((e) {
                return RadioListTile<bool>(
                  title: Text(e ? l10n.schedule_livestream : l10n.go_live),
                  value: e,
                  groupValue: isScheduled.value,
                  onChanged: (value) {
                    isScheduled.value = value!;
                  },
                );
              }),
              const SizedBox(height: 24),
              if (isScheduled.value)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: selectDate,
                  child: IgnorePointer(
                    child: CustomTextFormField(
                      controller: startTimeController,
                      hintText: l10n.start_time,
                      enabled: false,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
