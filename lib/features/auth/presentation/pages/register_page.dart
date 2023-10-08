import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/core/constants/form_constant.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_social/router/fs_router.dart';
import 'package:flutter_social/shared/presentation/bloc/app_data_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final form = FormGroup(
    {
      FormConstant.name: FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      FormConstant.username: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
      FormConstant.email: FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
    },
  );

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is Registering) {
                await EasyLoading.show(status: 'Creating Your Account...');
              } else if (state is RegisterFailed) {
                await EasyLoading.dismiss();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.failure.toString()),
                    ),
                  );
                }
              } else if (state is RegisterSuccess) {
                await EasyLoading.dismiss();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Your account successfully created!'),
                    ),
                  );
                }
                getIt<FSRouter>().back();
              }
            },
          ),
          BlocListener<AppDataBloc, AppDataState>(
            listener: (context, state) {
              if (state is AppDataTokenNotStored) {
                EasyLoading.dismiss();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.failure.toString()),
                  ),
                );
              } else if (state is AppDataTokenStored) {
                context.read<AppDataBloc>().add(
                      const AppDataEvent.loadProfile(),
                    );
              } else if (state is AppDataProfileLoaded) {
                EasyLoading.dismiss();
                getIt<FSRouter>().replace(const MainRoute());
              }
            },
          ),
        ],
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(16.r),
            shrinkWrap: true,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: textTheme.headlineLarge,
                  ),
                  8.verticalSpace,
                  ReactiveForm(
                    formGroup: form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReactiveTextField(
                          formControlName: FormConstant.name,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Full Name',
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (control) =>
                              form.control(FormConstant.username).focus(),
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Full Name must be filled!',
                          },
                        ),
                        24.verticalSpace,
                        ReactiveTextField(
                          formControlName: FormConstant.username,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Username',
                            helperText:
                                'This also will be used as your password',
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (control) =>
                              form.control(FormConstant.email).focus(),
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Username must be filled!',
                            ValidationMessage.minLength: (error) =>
                                'Username must be at least 8 characters!',
                          },
                        ),
                        24.verticalSpace,
                        ReactiveTextField(
                          formControlName: FormConstant.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Email Address',
                          ),
                          textInputAction: TextInputAction.done,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Email must be filled!',
                            ValidationMessage.email: (error) =>
                                'Email must be a valid email address!',
                          },
                        ),
                        24.verticalSpace,
                        ReactiveFormConsumer(
                          builder: (_, formGroup, child) => SizedBox(
                            height: 48.h,
                            width: 1.sw,
                            child: FilledButton(
                              onPressed: formGroup.invalid
                                  ? null
                                  : () {
                                      if (form.invalid) {
                                        return;
                                      }
                                      log(form.value.toString());
                                      context.read<AuthBloc>().add(
                                            AuthEvent.register(
                                              name: form
                                                  .control(FormConstant.name)
                                                  .value
                                                  .toString(),
                                              username: form
                                                  .control(
                                                    FormConstant.username,
                                                  )
                                                  .value
                                                  .toString(),
                                              email: form
                                                  .control(FormConstant.email)
                                                  .value
                                                  .toString(),
                                              password: form
                                                  .control(
                                                    FormConstant.username,
                                                  )
                                                  .value
                                                  .toString(),
                                            ),
                                          );
                                    },
                              child: const Text('Register'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
