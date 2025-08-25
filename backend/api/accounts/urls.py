from django.urls import path
from .views import UserViewSet,UserCreateView,UserRefreshTokenView,UserBlackListTokenView,UserUpdateView

app_name = 'auth'
urlpatterns = [
    path('auth/login/', UserViewSet.as_view()),      # login endpoint
    path('auth/register/', UserCreateView.as_view()), # registration endpoint
    path('auth/token/refresh/', UserRefreshTokenView.as_view()), # token refresh endpoint
    path('auth/profile/<int:user_id>/update/', UserUpdateView.as_view()), # profile update endpoint
    path('auth/logout/', UserBlackListTokenView.as_view()),   # logout endpoint

]