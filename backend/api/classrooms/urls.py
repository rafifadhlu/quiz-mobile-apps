from django.urls import path
from .views import UserCreateClassroomView,UserAddClassroomMemberView,UserListClassroomView,UserViewClassroomMemberView,UserSeeCandidateClassroomView


app_name = 'classrooms'
urlpatterns = [
    path('classrooms/', UserListClassroomView.as_view(), name='classroom-list'),
    path('classrooms/create/', UserCreateClassroomView.as_view(), name='classroom-create'),
    path('classrooms/<int:classroom_id>/candidate/', UserSeeCandidateClassroomView.as_view(), name='classroom-candidate'),
    path('classrooms/<int:classroom_id>/add/', UserAddClassroomMemberView.as_view(), name='classroom-add-member'),
    path('classrooms/<int:classroom_id>/members/', UserViewClassroomMemberView.as_view(), name='classroom-member-list'),
]
