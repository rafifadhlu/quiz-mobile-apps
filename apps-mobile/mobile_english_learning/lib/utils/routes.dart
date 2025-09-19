import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:mobile_english_learning/views/auth/edit-profile-screen.dart';
import 'package:mobile_english_learning/views/classroom/classroom_detail.dart';
import 'package:mobile_english_learning/views/classroom/home_teacher_classroom.dart';
import 'package:mobile_english_learning/views/home_auth_teacher.dart';
import 'package:mobile_english_learning/views/main_layout_teacher.dart';
import 'package:mobile_english_learning/views/quiz/quiz_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';

//layout
import 'package:mobile_english_learning/views/main_layout.dart';
import 'package:mobile_english_learning/views/classroom/classroom_layout.dart';

//Screens
import 'package:mobile_english_learning/views/auth/login_screen.dart';
import 'package:mobile_english_learning/views/auth/register_screen.dart';
import 'package:mobile_english_learning/views/home_screen.dart';

//viewmodels
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:mobile_english_learning/viewmodels/auth/app_state_view_models.dart';

GoRouter Createrouters(AuthViewModel authViewModel,
AppStateViewModel appStateViewModel,
ClassroomViewsModels classroomViewModel,
QuizViewModels quizViewModels){

  return GoRouter(
    refreshListenable: Listenable.merge([authViewModel, appStateViewModel,classroomViewModel,quizViewModels]),
    redirect: (context, state) {
      final isLoggedIn = authViewModel.isLoggedIn;
      final isFreshOpen = appStateViewModel.isFreshOpen;
      final isLoginPage = state.matchedLocation == '/login';
      final isRegisterPage = state.matchedLocation == '/register';
      
      
      debugPrint('Redirect check - isLoggedIn: $isLoggedIn, currentPath: ${state.matchedLocation}');
      debugPrint('Redirecting to login after logout. isFreshOpen: $isFreshOpen');

       if (!isLoggedIn && !isLoginPage && !isFreshOpen && !isRegisterPage ) {
          debugPrint('Redirecting to login after logout. isFreshOpen: $isFreshOpen');
          return '/login';
        }
      // If logged in and on login page, redirect to home
      if (isLoggedIn && isLoginPage) {
        debugPrint('Redirecting to home - user already authenticated');
        return '/';
      }

      return null;
    },
    routes: [
        GoRoute( 
          path: '/', 
          builder: (context, state) {
            if (!authViewModel.isLoggedIn) {
                return appStateViewModel.isFreshOpen ? HomeScreen() : AuthScreen();
              }
              // User is logged in
            final groups = authViewModel.user!.data.user.groups;
            if (groups[0] == 'Teachers') {
              return MainLayoutTeacher(indexNeeded: 0);
            } else {
              return const MainLayout(); // Your navbar stays here intentionally
            }
          },),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: AuthScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final offsetTween =
                      Tween(begin: const Offset(1, 0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut));

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(offsetTween),
                      child: child,
                    ),
                  );
                },
              );
          },
        ),
        GoRoute( 
          path: '/register', 
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: RegisterScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final offsetTween =
                      Tween(begin: const Offset(1, 0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut));

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(offsetTween),
                      child: child,
                    ),
                  );
                },
              ); 
          },),

          
        GoRoute(
          path: '/profile/details/:userID', 
          builder: (context, state) {
            return editProfileScreen(userID: state.pathParameters['userID']!);
            },
          ),

        GoRoute( 
          path: '/classrooms', 
          builder: (context, state) {
            return const MainLayout(indexNeeded: 1);
          },),

        GoRoute( 
          path: '/classrooms/detail/:classroomID', 
          builder: (context, state) {
            return ClassroomLayout(indexNeeded: 0,
            classroomID: state.pathParameters['classroomID']!,);
          },),

        GoRoute( 
          path: '/classrooms/:classroomID/quizzes/:quizID/questions', 
          builder: (context, state) {
            return QuizLayout(
            classroomID: state.pathParameters['classroomID']!,
            quizID:state.pathParameters['quizID']!);
          },),
        
        GoRoute( 
          path: '/profile', 
          builder: (context, state) {
            return const MainLayout();
          },),

        GoRoute(
          path: '/teacher/classrooms',
          builder: (context, state) {
            return ClassroomHomeTeacher();
            },
          ),

        GoRoute( 
          path: '/teacher/profile', 
          builder: (context, state) {
            return const MainLayoutTeacher(indexNeeded: 1);
          },),
          



      ], 
    );
}

// final GoRouter router = GoRouter(
  
// );
