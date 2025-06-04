import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/live/choose_product.dart';
import 'package:popcart/utils/text_styles.dart';

class SellerLiveNav extends StatefulWidget {
  const SellerLiveNav({super.key});

  @override
  State<SellerLiveNav> createState() => _SellerLiveNavState();
}

enum StreamingType { auction, liveSales }

enum ScheduleOption { instant, scheduled }

class _SellerLiveNavState extends State<SellerLiveNav> {
  StreamingType _streamingType = StreamingType.auction;
  ScheduleOption _scheduleOption = ScheduleOption.instant;
  final TextEditingController roomNameCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Stream? generatedLiveStream;

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
                        text: _streamingType == StreamingType.auction
                            ? 'Next'
                            : _scheduleOption == ScheduleOption.scheduled
                                ? 'Schedule live'
                                : 'Go live',
                        loading: context
                                .watch<OpenLivestreamCubit>()
                                .state
                                .whenOrNull(
                                  loading: () => true,
                                ) ??
                            false,
                        showIcon: false,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_streamingType == StreamingType.auction) {
                              await showModalBottomSheet<void>(
                                context: context,
                                builder: (context) {
                                  return ChooseProduct(
                                    roomName: roomNameCtrl.text,
                                    scheduledDate: _scheduleOption ==
                                            ScheduleOption.scheduled
                                        ? _selectedDate
                                            .toUtc()
                                            .toIso8601String()
                                        : null,
                                  );
                                },
                              );
                            } else {
                              final openLivestream =
                                  context.read<OpenLivestreamCubit>();
                              await openLivestream.createLivestreamSession(
                                name: roomNameCtrl.text,
                                products: [],
                                scheduled:
                                    _scheduleOption == ScheduleOption.scheduled,
                                startTime: _scheduleOption ==
                                        ScheduleOption.scheduled
                                    ? _selectedDate.toUtc().toIso8601String()
                                    : null,
                              );
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
    final openLivestream = context.watch<OpenLivestreamCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<OpenLivestreamCubit, OpenLivestreamState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (liveStream) {
              generatedLiveStream = liveStream;
              openLivestream.generateAgoraToken(
                channelName: liveStream.id,
                agoraRole: 0,
                uid: 0,
              );
            },
            error: (message) {
              context.showError(message);
            },
            generateTokenSuccess: (token) {
              context.pushReplacementNamed(
                AppPath.authorizedUser.seller.live.goLive.path,
                extra: true,
                queryParameters: {
                  'token': token,
                  'channelName': generatedLiveStream?.id,
                },
              );
            },
            generateTokenError: (message) {
              context.showError(message);
            },
          );
        },
        child: Center(
          child: GestureDetector(
              onTap: _showPrepareLiveSheet,
              child: const Text('Click here to bring out the dialog')),
        ),
      ),
    );
  }
}
