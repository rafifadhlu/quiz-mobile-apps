from django.contrib.auth.models import Group, User
from rest_framework_simplejwt.exceptions import TokenError, InvalidToken
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics  import CreateAPIView,ListAPIView,UpdateAPIView
from rest_framework_simplejwt.tokens import RefreshToken

from .serializers import UserListClassroomSerializer,UserCreateClassroomSerializer,UserAddClassroomMemberSerializer,UserClassroomMemberSerializer,UserCandidateClassroomSerializer
from .permissions import IsStudent,IsTeacher
from .models import classroom, classroom_member

from rest_framework.permissions import IsAuthenticated

# Create your views here.

# All Role 
class UserListClassroomView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserListClassroomSerializer

    def get_queryset(self):
        user = self.request.user
        # If teacher: return classrooms created by them
        if user.groups.filter(name="Teachers").exists():
            return classroom.objects.filter(teacher=user)

        # Default: no access
        return classroom.objects.none()


# Teacher Role

# Classroom Related
class UserCreateClassroomView(CreateAPIView):
    permission_classes = [IsAuthenticated, IsTeacher]
    serializer_class = UserCreateClassroomSerializer

    def perform_create(self, serializer):
        serializer.save(teacher=self.request.user)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        
        if serializer.is_valid():
            self.perform_create(serializer)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(status=status.HTTP_401_UNAUTHORIZED,
                        data={"status" : status.HTTP_401_UNAUTHORIZED,
                            "detail": "Unauthorized!"})
    
class UserAddClassroomMemberView(CreateAPIView):
    permission_classes = [IsAuthenticated, IsTeacher]
    serializer_class = UserAddClassroomMemberSerializer

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['classroom_id'] = self.kwargs.get('classroom_id')
        return context

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
   
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserViewClassroomMemberView(ListAPIView):
    """
    API endpoint for listing all members of a classroom.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = UserClassroomMemberSerializer

    def get_queryset(self):
        wanted_id = self.kwargs.get("classroom_id")
        return classroom.objects.prefetch_related('students').filter(id=wanted_id)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if queryset.exists():
            serializer = self.get_serializer(queryset, many=True)
            return Response(status=status.HTTP_200_OK,
                            data={
                                "status": status.HTTP_200_OK,
                                "message": "Fetched member class successfully",
                                "data": serializer.data
                            })

        return Response(status=status.HTTP_404_NOT_FOUND,
                        data={
                            "status": status.HTTP_404_NOT_FOUND,
                            "detail": "No members found for this classroom."
                        })

class UserSeeCandidateClassroomView(ListAPIView):
    """
    API endpoint for viewing a candidate's classroom.
    """
    permission_classes = [IsAuthenticated,IsTeacher]
    serializer_class = UserCandidateClassroomSerializer

    def get_queryset(self):
        return User.objects.filter(groups__name="Students")

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if queryset.exists():
            classroom_id = self.kwargs.get("classroom_id")
            serializer = self.get_serializer(queryset, many=True, context={"classroom_id": classroom_id})

            return Response(status=status.HTTP_200_OK,
                            data={
                                "status": status.HTTP_200_OK,
                                "message": "Fetched candidate classrooms successfully",
                                "data": serializer.data
                            })

        return Response(
            status=status.HTTP_400_BAD_REQUEST,
            data={
                "status": status.HTTP_400_BAD_REQUEST,
                "detail": "Data not found."
            }
        )
    