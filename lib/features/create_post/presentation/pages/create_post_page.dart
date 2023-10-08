import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/media_store/media_store.dart';
import 'package:flutter_social/features/create_post/presentation/bloc/create_post_bloc.dart';
import 'package:flutter_social/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_social/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_social/shared/presentation/bloc/app_data_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final TextEditingController textEditingController;

  ValueNotifier<File?> file = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    file.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: BlocListener<CreatePostBloc, CreatePostState>(
        listener: (context, state) async {
          if (state is UploadingPost) {
            await EasyLoading.show(status: 'Uploading,,,');
          } else if (state is PostCreated) {
            await EasyLoading.showSuccess('Post created!');
            file.value = null;
            textEditingController.clear();
            if (context.mounted) {
              context.read<AppDataBloc>().add(
                    const AppDataEvent.loadProfile(isUpdated: true),
                  );
              context.read<HomeBloc>().add(const HomeEvent.refresh());
              context.read<ProfileBloc>().add(const ProfileEvent.refresh());
            }
          } else if (state is PostNotCreated) {
            await EasyLoading.dismiss();
            await EasyLoading.showError(
              state.failure.toString(),
            );
          }
        },
        child: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            ValueListenableBuilder(
              valueListenable: file,
              builder: (context, value, child) {
                if (value != null) {
                  return Stack(
                    children: [
                      ExtendedImage.file(
                        value,
                        width: 1.sw,
                        height: 0.25.sh,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.blueGrey.shade100),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 4.h,
                        right: 4.w,
                        child: IconButton.filled(
                          onPressed: () => file.value = null,
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  );
                }

                return Container(
                  width: 1.sw,
                  height: 0.15.sh,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.r),
                      onTap: () async {
                        final mediaStore = getIt<MediaStore>();

                        if (!(await mediaStore
                            .checkPermission(Permission.storage))) {
                          log('not Permitted');
                        }
                        final result = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );

                        if (result == null) {
                          return;
                        }

                        log(result.name);

                        file.value = File(result.path);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_upload_rounded,
                            ),
                            4.verticalSpace,
                            Text(
                              'Select image to upload',
                              style: textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            24.verticalSpace,
            MarkdownField(
              controller: textEditingController,
              emojiConvert: true,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                isDense: true,
                labelText: 'Caption',
              ),
            ),
            24.verticalSpace,
            BlocBuilder<AppDataBloc, AppDataState>(
              builder: (context, state) => switch (state) {
                AppDataProfileLoaded(profile: final profile) => SizedBox(
                    width: 1.sw,
                    height: 48.h,
                    child: FilledButton(
                      onPressed: () async {
                        if (file.value == null) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Select image for your post!'),
                            ),
                          );
                          return;
                        }

                        if (textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Caption must be filled!'),
                            ),
                          );
                          return;
                        }

                        final compressedFile =
                            await FlutterNativeImage.compressImage(
                          file.value!.path,
                        );

                        if (context.mounted) {
                          context.read<CreatePostBloc>().add(
                                CreatePostEvent.create(
                                  userID: profile.id,
                                  description: textEditingController.text,
                                  image: compressedFile,
                                ),
                              );
                        }
                      },
                      child: const Text('Post'),
                    ),
                  ),
                _ => const SizedBox.shrink()
              },
            ),
          ],
        ),
      ),
    );
  }
}
