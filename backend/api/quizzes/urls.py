from django.urls import path


from .views import UserQuizzesListView,UserCreateQuizzesView,UserDeleteQuizzesView,UserQuestionsView

app_name = 'quizzes'
urlpatterns = [
    path("classrooms/<int:classroom_id>/quizzes/list/",UserQuizzesListView.as_view(),name='list-quiz'),
    path("classrooms/<int:classroom_id>/quizzes/create-quiz/", UserCreateQuizzesView.as_view(),name='create-quiz'),
    path("classrooms/<int:classroom_id>/quizzes/<int:pk>/delete-quiz/", UserDeleteQuizzesView.as_view(),name='delete-quiz'),
    path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/questions/",UserQuestionsView.as_view(),name='question')
    # path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/update-quiz/", UserUpdatequizzes.as_view(),name='update-quiz'),
    # path("classrooms/<int:classroom_id>/quizzes/<int:quiz_id>/result/", UserResultQuizzes.as_view(),name='delete-quiz'),
]
