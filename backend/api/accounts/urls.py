from django.urls import path
from .views import UserViewSet,UserCreateView,UserRefreshTokenView,UserBlackListTokenView,UserUpdateView,UserCreateTeacherView

app_name = 'auth'
urlpatterns = [
    path('auth/login/', UserViewSet.as_view()),      # login endpoint
    path('auth/register/', UserCreateView.as_view()), # registration endpoint
    path('auth/teacher/register/', UserCreateTeacherView.as_view()), # registration endpoint
    
    path('auth/token/', UserRefreshTokenView.as_view()), # token refresh endpoint
    path('auth/profile/<int:user_id>/', UserUpdateView.as_view()), # profile update endpoint
    path('auth/logout/', UserBlackListTokenView.as_view()),   # POST logout endpoint blacklist token

]