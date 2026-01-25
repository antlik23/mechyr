import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uzis_app/auth_notifier.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/layouts/app_layout.dart';
import 'package:uzis_app/core/routes/auth_routes.dart';
import 'package:uzis_app/core/services/notification_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/auth/models/user_model.dart';
import 'package:uzis_app/features/auth/screens/forgotten_password_screen.dart';
import 'package:uzis_app/features/auth/screens/login_screen.dart';
import 'package:uzis_app/features/forms/screens/create_diary_form_screen.dart';
import 'package:uzis_app/features/forms/screens/record_input_create_screen.dart';
import 'package:uzis_app/features/forms/screens/record_input_detail_screen.dart';
import 'package:uzis_app/features/forms/screens/record_output_create_screen.dart';
import 'package:uzis_app/features/forms/screens/record_output_detail_screen.dart';
import 'package:uzis_app/features/voiding_diary/screens/voiding_diary_screen.dart';
import 'package:uzis_app/shared/screens/no_connection_screen.dart';
import 'package:uzis_app/shared/screens/patient_only_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final authNotifier = AuthNotifier();
  await authNotifier.loadUser();

  NotificationService().initNotification();

  runApp(
    ChangeNotifierProvider<AuthNotifier>.value(
      value: authNotifier,
      child: const MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  GoRouter _router(BuildContext context) {
    return GoRouter(
      initialLocation: context.read<AuthNotifier>().initialLocation,
      refreshListenable: context.read<AuthNotifier>(),
      navigatorKey: navigatorKey,
      redirect: (context, GoRouterState state) {
        final Set<String> unauthenticatedRoutes = {
          AuthRoutes.Login,
          AuthRoutes.ForgottenPassword,
        };
        final Set<String> noCennectionRoutes = {
          "/no-connection",
          "/no-connection/record-output",
          "/no-connection/record-input",
        };
        final isConnected = context.read<AuthNotifier>().isConnected;
        final String? fullPath = state.fullPath;
        final isLogged = context.read<AuthNotifier>().isLogged;
        final roles = context.read<AuthNotifier>().userRoles;
        final uncompletedDiaryId =
            context.read<AuthNotifier>().uncompletedDiaryId;

        if (isLogged && !isConnected && noCennectionRoutes.contains(fullPath)) {
          return null;
        }
        if (isLogged &&
            !isConnected &&
            !noCennectionRoutes.contains(fullPath)) {
          return "/no-connection";
        }
        if (isLogged &&
            fullPath == "/no-connection" &&
            uncompletedDiaryId != null) {
          return "/voiding-diary/$uncompletedDiaryId";
        }
        if (isLogged && fullPath == "/" && uncompletedDiaryId != null) {
          return "/voiding-diary/$uncompletedDiaryId";
        }
        if (!isLogged && unauthenticatedRoutes.contains(fullPath)) return null;
        if (!isLogged && !unauthenticatedRoutes.contains(fullPath)) {
          return AuthRoutes.Login;
        }

        if (isLogged && !roles.contains(UserRole.patient)) {
          return "/patient-only";
        }

        if (isLogged && unauthenticatedRoutes.contains(fullPath)) return "/";

        return null;
      },
      routes: [
        GoRoute(
          path: AuthRoutes.Login,
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: AuthRoutes.ForgottenPassword,
          builder: (context, state) {
            return const ForgottenPasswordScreen();
          },
        ),
        ShellRoute(
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              key: state.pageKey,
              child: AppLayout(child: child),
            );
          },
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) {
                return const CreateDiaryFormScreen();
              },
            ),
            GoRoute(
                path: "/no-connection",
                builder: (context, state) {
                  return const NoConnectionScreen();
                },
                routes: [
                  GoRoute(
                    path: "record-output",
                    builder: (context, state) {
                      return RecordOutputCreateScreen(
                        diaryId: state.pathParameters['diaryId'],
                      );
                    },
                  ),
                  GoRoute(
                    path: "record-input",
                    builder: (context, state) {
                      return RecordInputCreateScreen(
                        diaryId: state.pathParameters['diaryId'],
                      );
                    },
                  ),
                ]),
            GoRoute(
              path: '/patient-only',
              builder: (context, state) => const PatientOnlyScreen(),
            ),
            GoRoute(
              path: "/voiding-diary/:diaryId",
              builder: (context, state) {
                return VoidingDiaryScreen(
                  diaryId: state.pathParameters['diaryId']!,
                );
              },
              routes: [
                GoRoute(
                  path: "record-output",
                  builder: (context, state) {
                    return RecordOutputCreateScreen(
                      diaryId: state.pathParameters['diaryId'],
                    );
                  },
                ),
                GoRoute(
                  path: "record-output/:recordId",
                  builder: (context, state) {
                    return RecordOutputDetailScreen(
                      diaryId: state.pathParameters['diaryId']!,
                      recordId: state.pathParameters['recordId']!,
                    );
                  },
                ),
                GoRoute(
                  path: "record-input",
                  builder: (context, state) {
                    return RecordInputCreateScreen(
                      diaryId: state.pathParameters['diaryId']!,
                    );
                  },
                ),
                GoRoute(
                  path: "record-input/:recordId",
                  builder: (context, state) {
                    return RecordInputDetailScreen(
                      diaryId: state.pathParameters['diaryId']!,
                      recordId: state.pathParameters['recordId']!,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ovládni Měchýř',
      routerConfig: _router(context),
      locale: const Locale('cs', "CZ"),
      supportedLocales: const [
        Locale('cs', "CZ"),
      ],
      localizationsDelegates: const [
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: CustomSnackbar.key,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.darkBlueBase,
          primary: AppColors.darkBlueBase,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.darkBlueBase,
        ),
        useMaterial3: true,
        fontFamily: 'NotoSans',
        datePickerTheme: DatePickerThemeData(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadius.md,
          ),
          dividerColor: AppColors.gray100,
          confirmButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(AppColors.darkBlueBase),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 16),
            ),
          ),
          cancelButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(AppColors.darkBlueBase),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 16),
            ),
          ),
          headerHeadlineStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headerForegroundColor: AppColors.darkBlueBase,
          headerHelpStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadius.md,
          ),
          confirmButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(AppColors.darkBlueBase),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 16),
            ),
          ),
          cancelButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(AppColors.darkBlueBase),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          hourMinuteColor: AppColors.gray100,
          helpTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlueBase,
          ),
        ),
      ),
    );
  }
}
