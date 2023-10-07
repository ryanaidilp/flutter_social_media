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
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final form = FormGroup(
    {
      FormConstant.identifier: FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      FormConstant.password: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
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
    return SafeArea(
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LoggingIn) {
                  EasyLoading.show(status: 'Logging In...');
                } else if (state is LoginFailed) {
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.failure.toString()),
                    ),
                  );
                } else if (state is LoginSuccess) {
                  context.read<AppDataBloc>().add(
                        SaveTokenEvent(token: state.token),
                      );
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
                        const LoadProfileEvent(),
                      );
                } else if (state is AppDataProfileLoaded) {
                  EasyLoading.dismiss();
                  getIt<FSRouter>().replace(MainRoute());
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
                      'Login',
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
                            formControlName: FormConstant.identifier,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              labelText: 'Email/Username',
                            ),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (control) =>
                                form.control(FormConstant.password).focus(),
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'Email/Username must be filled!',
                            },
                          ),
                          16.verticalSpace,
                          ReactiveTextField(
                            formControlName: FormConstant.password,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              labelText: 'Password',
                            ),
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'Password must be filled!',
                              ValidationMessage.minLength: (error) =>
                                  'Password must be at least 8 characters!',
                            },
                            onSubmitted: (control) =>
                                form.control(FormConstant.password).unfocus(),
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
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
                                        context.read<AuthBloc>().add(
                                              AuthEvent.login(
                                                password: form
                                                    .control(
                                                      FormConstant.password,
                                                    )
                                                    .value
                                                    .toString(),
                                                identifier: form
                                                    .control(
                                                      FormConstant.identifier,
                                                    )
                                                    .value
                                                    .toString(),
                                              ),
                                            );
                                      },
                                child: const Text('Login'),
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
      ),
    );
  }
}
