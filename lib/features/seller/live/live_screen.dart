import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/seller/live/choose_product.dart';
import 'package:popcart/utils/text_styles.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

enum StreamingType { auction, liveSales }

enum ScheduleOption { instant, scheduled }

class _LiveScreenState extends State<LiveScreen> {
  StreamingType _streamingType = StreamingType.auction;
  ScheduleOption _scheduleOption = ScheduleOption.instant;
  final TextEditingController roomNameCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPrepareLiveSheet();
    });
  }

  DateTime _selectedDate = DateTime.now();

  Widget _buildDatePicker() {
    final now = DateTime.now();
    final initialDate = _selectedDate.isBefore(now) ? now : _selectedDate;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CupertinoDatePicker(
        initialDateTime: initialDate,
        backgroundColor: AppColors.darkGrey,
        minimumDate: now,
        maximumDate: now.add(const Duration(days: 7)),
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  void _showPrepareLiveSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Prepare to go live',
                          style: TextStyles.titleHeading,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Room name',
                        style: TextStyles.textTitle,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        validator: ValidationBuilder().required().build(),
                        controller: roomNameCtrl,
                        hintText: 'Room name',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      const Text('Type of streaming',
                          style: TextStyles.textTitle),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.darkGrey,
                                    borderRadius: BorderRadius.circular(19)),
                                padding:
                                    const EdgeInsets.only(left: 0, right: 50),
                                child: Row(
                                  children: [
                                    Radio<StreamingType>(
                                      value: StreamingType.auction,
                                      groupValue: _streamingType,
                                      onChanged: (value) {
                                        setStateModal(
                                            () => _streamingType = value!);
                                      },
                                    ),
                                    const Text('Auction',
                                        style:
                                            TextStyle(color: AppColors.white)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.darkGrey,
                                    borderRadius: BorderRadius.circular(19)),
                                padding:
                                    const EdgeInsets.only(left: 0, right: 50),
                                child: Row(
                                  children: [
                                    Radio<StreamingType>(
                                      value: StreamingType.liveSales,
                                      groupValue: _streamingType,
                                      onChanged: (value) {
                                        setStateModal(
                                            () => _streamingType = value!);
                                      },
                                    ),
                                    const Text('Live Sales',
                                        style:
                                            TextStyle(color: AppColors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('Streaming time', style: TextStyles.textTitle),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.darkGrey,
                                    borderRadius: BorderRadius.circular(19)),
                                padding:
                                    const EdgeInsets.only(left: 0, right: 50),
                                child: Row(
                                  children: [
                                    Radio<ScheduleOption>(
                                      value: ScheduleOption.instant,
                                      groupValue: _scheduleOption,
                                      onChanged: (value) {
                                        setStateModal(
                                            () => _scheduleOption = value!);
                                      },
                                    ),
                                    const Text('Instant',
                                        style:
                                            TextStyle(color: AppColors.white)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.darkGrey,
                                    borderRadius: BorderRadius.circular(19)),
                                padding:
                                    const EdgeInsets.only(left: 0, right: 50),
                                child: Row(
                                  children: [
                                    Radio<ScheduleOption>(
                                      value: ScheduleOption.scheduled,
                                      groupValue: _scheduleOption,
                                      onChanged: (value) {
                                        setStateModal(
                                            () => _scheduleOption = value!);
                                      },
                                    ),
                                    const Text('Scheduled',
                                        style:
                                            TextStyle(color: AppColors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (_scheduleOption == ScheduleOption.scheduled) ...{
                        _buildDatePicker(),
                        const SizedBox(
                          height: 20,
                        ),
                      },
                      CustomElevatedButton(
                        text: _streamingType == StreamingType.auction ? 'Next' :
                        _scheduleOption == ScheduleOption.scheduled ? 'Schedule live' :
                        'Go live',
                        showIcon: false,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if(_streamingType == StreamingType.auction) {
                              await showModalBottomSheet<void>(
                                  context: context,
                                  builder: (context) {
                                    return const ChooseProduct();
                                  },);
                            } else {

                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16), // Padding at the bottom
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: GestureDetector(
            onTap: _showPrepareLiveSheet,
            child: const Text('Your main screen content here')),
      ),
    );
  }
}
