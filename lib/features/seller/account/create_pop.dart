import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/seller/cubits/pop_play/pop_play_cubit.dart';
import 'package:popcart/features/seller/inventory/product_uploaded.dart';
import 'package:popcart/route/route_constants.dart';
import 'package:popcart/utils/text_styles.dart';

class CreatePopScreen extends StatefulWidget {
  const CreatePopScreen(
      {required this.thumbnail, required this.artifact, super.key});

  final String thumbnail;
  final String artifact;

  @override
  State<CreatePopScreen> createState() => _CreatePopScreenState();
}

class _CreatePopScreenState extends State<CreatePopScreen> {
  final TextEditingController caption = TextEditingController();
  String videoDuration = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<Duration> getVideoDuration(String path) async {
    final controller =
        CachedVideoPlayerPlusController.file(File(Uri.parse(path).path));
    await controller.initialize();
    final duration = controller.value.duration;
    await controller.dispose();
    return duration;
  }

  @override
  void initState() {
    getVideoDuration(widget.artifact).then((duration) {
      setState(() {
        videoDuration =
            '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Pop-play'),
          centerTitle: true,
        ),
        body: BlocListener<PopPlayCubit, PopPlayState>(
          listener: (context, state) {
            state.whenOrNull(
              loading: () {},
              uploadError: (message) {
                context.showError(message);
              },
              uploadSuccess: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  builder: (_) => Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const ProductUploaded(
                      title: 'Post Added Successfully!',
                      description: 'Your new post is now live',
                    ),
                  ),
                );
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == sellerHome);
              },
            );
          },
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: FileImage(File(
                                              Uri.parse(widget.thumbnail)
                                                  .path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: AppColors.greyDark,
                                        ),
                                        child: Text(
                                          videoDuration,
                                          style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text('Video Caption',
                                  style: TextStyles.textTitle),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                validator:
                                    ValidationBuilder().required().build(),
                                controller: caption,
                                hintText: 'Caption',
                                textInputAction: TextInputAction.next,
                              ),
                              const Spacer(),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomElevatedButton(
                                loading: context
                                        .watch<PopPlayCubit>()
                                        .state
                                        .whenOrNull(
                                          loading: () => true,
                                        ) ??
                                    false,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<PopPlayCubit>().uploadPost(
                                          video: widget.artifact,
                                          caption: caption.text,
                                        );
                                  }
                                },
                                text: 'Done',
                                showIcon: false,
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ));
  }
}
