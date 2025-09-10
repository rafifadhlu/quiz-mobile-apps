from django.urls import path


from .views import UserQuizzesView,UserDeleteQuizzesView,UserQuestionsView,UserUpdateQuestions,UserDeleteQuestion

app_name = 'quizzes'
urlpatterns = [
    # quizzes
    path("classrooms/<int:classroom_id>/quizzes/",UserQuizzesView.as_view(),name='list-quiz'), # GET and POST (Create) Quizzes
    path("classrooms/<int:classroom_id>/quizzes/<int:pk>/", UserDeleteQuizzesView.as_view(),name='delete-quiz'), #GET and DELETE quiz

    # questions
    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/questions/",UserQuestionsView.as_view(),name='question'), # GET and POSt (Create) Questions
    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/questions/<int:question_id>/", UserDeleteQuestion.as_view(),name='delete-questions'), # GET and DELETE Question

    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/questions/<int:question_id>", UserUpdateQuestions.as_view(),name='update-questions'),
    # path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/result/", UserResultQuizzes.as_view(),name='delete-quiz'),
]
