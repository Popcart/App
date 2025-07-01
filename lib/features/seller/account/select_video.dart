import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imgly_editor/imgly_editor.dart';
import 'package:popcart/features/seller/account/gallery_image_picker.dart';
import 'package:popcart/route/route_constants.dart';

class SelectVideo extends StatefulWidget {
  const SelectVideo({super.key});

  @override
  State<SelectVideo> createState() => _SelectVideoState();
}

class _SelectVideoState extends State<SelectVideo> {
  final settings = EditorSettings(
    license: 'iH3Dvnh2R48T6kcPiJMZp_855fGRrCwZHMTxLCHxL7XuXkmyyS9Jzi4K2LfbidDI',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Pop-play'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: GalleryImagePicker(
            onImageSelected: (asset) async {
              final file = await asset.file;
              final result = await IMGLYEditor.openEditor(
                  settings: settings,
                  preset: EditorPreset.video,
                  source: Source.fromVideo(file!.path));
              if (result == null) return;
              unawaited(
                Navigator.pushNamed(
                  context,
                  createPopPlay,
                  arguments: {
                    'artifact': result.artifact,
                    'thumbnail': result.thumbnail,
                  },
                ),
              );
            },
          ),
        ));
  }
}
