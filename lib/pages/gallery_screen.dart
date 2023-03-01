import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigsaw_hints/pages/widgets/gallery_picture.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/ui/dialogs/box_cover_dialog.dart';
import 'package:jigsaw_hints/ui/dialogs/info_dialogs.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/utils/navigation_utils.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool canUseDeleteButton = true;
  bool canTap = true;

  final RoundedLoadingButtonController selectButtonController =
      RoundedLoadingButtonController();
  int selectedPictureIndex = 0;
  bool allowPop = true;

  void selectPicture(int index) {
    setState(() {
      selectedPictureIndex = index;
    });
  }

  void usePicture(BoxCover boxCover, BoxCoverProvider boxCoverProvider) async {
    setState(() {
      allowPop = false;
      canUseDeleteButton = false; // Disable delete button
      canTap = false; // Disable tap
    });
    Timer(const Duration(milliseconds: 800), () {
      boxCoverProvider.boxCover = boxCover;
      selectButtonController.success();
      Timer(const Duration(milliseconds: 400), () {
        NavigationUtils.popAll(context);
        showBoxCoverDialog(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (allowPop) {
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      },
      child: Consumer2<ImagesProvider, BoxCoverProvider>(
        builder: (context, images, box, child) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const JigsawAppBar(
                title: "Box Covers",
              ),
              body: GestureDetector(
                  onTap: () =>
                      setState(() => {if (canTap) selectedPictureIndex = 0}),
                  child: body(context, images, box)),
              floatingActionButton: selectedPictureIndex == 0
                  ? addNewPictureButton(box, context)
                  : pictureActionButtons(images, box),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat);
        },
      ),
    );
  }

  Padding addNewPictureButton(BoxCoverProvider box, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultContentPaddingBig),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.grey[400],
        onPressed: () {
          if (box.boxCover == null) {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          } else {
            showInfoDialog(
              context,
              title: "Before you continue...",
              content:
                  "Be aware that this will unselect current box cover. Are you sure?",
              titleBgColor: Colors.redAccent,
              rightButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: popButton(context, text: "Yes", onPressed: () {
                  box.boxCover = null;
                  NavigationUtils.popAll(context);
                }),
              ),
              leftButton: popButton(context, text: "No"),
            );
          }
        },
        label: const Text("Add New Box Cover"),
      ).animate().fade(),
    );
  }

  Widget body(context, ImagesProvider images, BoxCoverProvider box) {
    return images.capturedImages.isEmpty
        ? emptyGallery(context)
        : selectableGallery(images, box);
  }

  Widget selectableGallery(ImagesProvider images, BoxCoverProvider box) {
    return GridView.count(
      padding: const EdgeInsets.only(bottom: 100),
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: images.capturedImages.reversed
          .map((image) => GalleryPicture(
              image: image.image,
              onTap: () =>
                  selectPicture(images.capturedImages.indexOf(image) + 1),
              selected: selectedPictureIndex ==
                  images.capturedImages.indexOf(image) + 1))
          .toList(),
    ).animate().fadeIn(duration: 500.ms).then().shimmer();
  }

  Widget pictureActionButtons(ImagesProvider images, BoxCoverProvider box) {
    return Padding(
      padding: const EdgeInsets.all(defaultContentPaddingBig),
      child: Animate(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            deleteButton(images, box).animate().flip(),
            const SizedBox(
              width: defaultWhitespaceSmall,
            ),
            usePictureButton(images, box).animate().flip(),
          ],
        ),
      ),
    );
  }

  RoundedLoadingButton usePictureButton(
      ImagesProvider images, BoxCoverProvider box) {
    final selectedBoxCover = images.capturedImages[selectedPictureIndex - 1];
    return RoundedLoadingButton(
      successIcon: Icons.extension,
      controller: selectButtonController,
      color: themeLightBlue,
      successColor: Colors.green,
      borderRadius: defaultDialogBorderRadiusBig,
      onPressed: () {
        setState(() {
          return usePicture(selectedBoxCover, box);
        });
      },
      child: Text(
        'Use Box Cover',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }

  InkWell deleteButton(ImagesProvider images, BoxCoverProvider box) {
    final selectedBoxCover = images.capturedImages[selectedPictureIndex - 1];
    return InkWell(
      onTap: canUseDeleteButton
          ? () => deleteBoxCoverAction(selectedBoxCover, box, images)
          : null,
      child: Container(
        padding: const EdgeInsets.all(defaultContentPaddingMedium),
        decoration: BoxDecoration(
          color: themeLightRed,
          borderRadius: BorderRadius.circular(defaultDialogBorderRadiusBig),
        ),
        child: const Icon(
          Icons.delete_forever,
          color: Colors.white,
        ),
      ),
    );
  }

  void deleteBoxCoverAction(
      BoxCover selectedBoxCover, BoxCoverProvider box, ImagesProvider images) {
    showInfoDialog(context,
        title: "Removing saved box cover",
        content: "Are you sure?",
        titleBgColor: Colors.redAccent,
        rightButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: popButton(context, text: "Yes", onPressed: () {
            // Delete picture
            selectedBoxCover.delete();
            box.boxCover = null;
            selectedPictureIndex = 0;
            // Remove from list
            images.removeImage(selectedBoxCover);
            Navigator.of(context).pop();
          }),
        ),
        leftButton: popButton(context, text: "No"));
  }

  Widget emptyGallery(context) {
    return Center(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              "Looks like you don't have any saved boxes yet! 😲",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: defaultIconSize,
              ).animate().flipH(duration: 1.seconds),
              const SizedBox(width: defaultWhitespaceSmall),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "Go ahead a take your first picture of the jigsaw box, it will be show up here. 📷",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(backgroundColor: Colors.grey[200]),
                ),
              ).animate(delay: 1.seconds).fadeIn(duration: 2.seconds),
            ],
          ),
        ],
      ),
    );
  }
}
