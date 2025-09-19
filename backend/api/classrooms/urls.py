from django.urls import path
from .views import UserClassroomView,UserClassroomDetailView,UserCandidateClassroomView,UserDeleteClassroomView,UserRemoveClassroomMemberView


app_name = 'classrooms'
urlpatterns = [
    path('classrooms/', UserClassroomView.as_view(), name='classroom-list'), #GET list of classrooms, POST only for teachers 
    path('classrooms/<int:pk>/', UserDeleteClassroomView.as_view(), name='classroom-delete'), # DELETE classrooms
    path('classrooms/<int:classroom_id>/details/', UserClassroomDetailView.as_view(), name='classroom-member'), # GET Classrooms Detail 
    path('classrooms/<int:classroom_id>/candidate/', UserCandidateClassroomView.as_view(), name='classroom-candidate'),# GET List of candidate students, and POST add a new students
    path('classrooms/<int:classroom_id>/members/<int:student_id>/', UserRemoveClassroomMemberView.as_view(), name='classroom-remove-member'), # DELETE student
]
