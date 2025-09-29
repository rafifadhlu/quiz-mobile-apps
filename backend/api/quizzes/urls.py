from django.urls import path


from .views import UserQuizzesView,UserDeleteQuizzesView,UserQuestionsView,UserUpdateQuestions,UserDeleteQuestion,UserSubmitQuizzes,UserGetQuizzesResult,UserGetSpecifyQuizzesResult

app_name = 'quizzes'
urlpatterns = [
    # quizzes
    path("classrooms/<int:classroom_id>/quizzes/",UserQuizzesView.as_view(),name='list-quiz'), # GET Quizzes
    # path("classrooms/<int:classroom_id>/quizzes/",UserQuestionsView.as_view(),name='list-quiz'),

    path("classrooms/<int:classroom_id>/quizzes/<int:pk>/", UserDeleteQuizzesView.as_view(),name='delete-quiz'), #GET and DELETE quiz

    # questions
    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/questions/",UserQuestionsView.as_view(),name='question'), # GET and POSt (Create) Questions
    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/questions/<int:question_id>/", UserDeleteQuestion.as_view(),name='delete-questions'), # GET and DELETE Question

    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/questions/<int:question_id>", UserUpdateQuestions.as_view(),name='update-questions'),
    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/answer/", UserSubmitQuizzes.as_view(),name='submit-quiz'),

    # result for specify user
    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/result/<int:pk>", UserGetSpecifyQuizzesResult.as_view(), name='quizzes-result'),
    
    # for teacher
    path("classrooms/<int:classroom_id>/quizzes/<int:pk>/result/", UserGetQuizzesResult.as_view(), name='quizzes-result'),
]
