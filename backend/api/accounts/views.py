# Create your views here.
from django.contrib.auth.models import Group, User
from rest_framework_simplejwt.exceptions import TokenError, InvalidToken
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics  import CreateAPIView,UpdateAPIView,RetrieveUpdateAPIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import AllowAny


from .serializers import UserCreateSerializer,UserAuthSerializer,UserRefreshTokenSerializer, UserUpdateSerializer 


class UserViewSet(CreateAPIView):
    """
    API endpoint for user to log in, and get authentication tokens.
    """
    permission_classes = [AllowAny]
    serializer_class = UserAuthSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            user = serializer.validated_data['user']
            refresh = RefreshToken.for_user(user)

            return Response(status=status.HTTP_200_OK, data={
                "status": status.HTTP_200_OK,
                "message": "Login successful",
                "data" :{   
                    "refresh": str(refresh), 
                    "access": str(refresh.access_token),
                    "user": {
                        "id":user.id,
                        "username":user.username,
                        "email":user.email,
                        "firstname":user.first_name,
                        "lastname":user.last_name,
                        "groups" : [g.name for g in user.groups.all()]
                    }
                }
            })

        return Response(status=status.HTTP_401_UNAUTHORIZED,
                        data=serializer.errors)

class UserRefreshTokenView(CreateAPIView):
    """
    API Endpoint for refreshing JWT tokens.
    """
    serializer_class = UserRefreshTokenSerializer
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        refresh_token_string = serializer.validated_data.get("refreshToken")

        try:
            refresh_token_obj  = RefreshToken(refresh_token_string)
            new_access_token = str(refresh_token_obj.access_token)
        except TokenError as e:
            raise InvalidToken({
                "detail": "Invalid or expired refresh token",
                "messages": str(e)
            })

        return Response(status=status.HTTP_200_OK, 
                        data={
            "status": status.HTTP_200_OK,
            "message": "Token refreshed successfully",
            "data": {
                "refreshToken": str(refresh_token_obj),
                "accessToken": new_access_token
            }
        })

class UserCreateView(CreateAPIView):

    """
    API endpoint for user registration.
    """
    serializer_class = UserCreateSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            return Response(status=status.HTTP_201_CREATED,
                            data={
                                "status": status.HTTP_201_CREATED,
                                "message": "User created successfully",
                                "user": serializer.data
                            })
        return Response(status=status.HTTP_400_BAD_REQUEST,
                        data=serializer.errors)
    
class UserBlackListTokenView(CreateAPIView):

    def create(self, request, *args, **kwargs):
        refresh_token = request.data.get('refreshToken')
        if not refresh_token:
            return Response(
                status=status.HTTP_400_BAD_REQUEST,
                data={"status": status.HTTP_400_BAD_REQUEST, "message": "refreshToken is required"}
            )
        
        try:
            current_token = RefreshToken(refresh_token)
            current_token.blacklist()
        except Exception as e:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"status": status.HTTP_400_BAD_REQUEST,
                                  "message": "Failed to blacklist token",
                                  "error": str(e)})
        return Response(status=status.HTTP_200_OK,
                        data={"status": status.HTTP_200_OK,
                              "message": "Token blacklisted successfully"})

class UserUpdateView(RetrieveUpdateAPIView):
    """
    API endpoint for updating user profile.
    """
    serializer_class = UserUpdateSerializer
    lookup_field = 'user_id'

    def get_object(self):
        user_id = self.kwargs.get('user_id')
        return User.objects.get(id=user_id)

    def update(self, request, *args, **kwargs):
        # partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save()
            return Response(status=status.HTTP_200_OK,
                            data={
                                "status": status.HTTP_200_OK,
                                "message": "Profile updated successfully",
                                "data": serializer.data
                            })
        
        return Response(status=status.HTTP_400_BAD_REQUEST,
                        data=serializer.errors)