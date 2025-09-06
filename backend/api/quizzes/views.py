from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework_simplejwt.exceptions import TokenError, InvalidToken
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics  import CreateAPIView,ListAPIView,UpdateAPIView,DestroyAPIView,ListCreateAPIView
from rest_framework_simplejwt.tokens import RefreshToken

# from .serializers import

from classrooms.permissions import IsStudent,IsTeacher,IsTeacherOrReadOnly
from rest_framework.permissions import IsAuthenticated

from classrooms.models import classroom, classroom_member
from .models import quizzes,questions,choices,student_answers

from django.contrib.auth.models import Group, User

from .serializer import UserListQuizzesSerializer,UserCreateQuizzesSerializer,QuestionsSerializer,UserQuestionsSerializer


# Create your views here.

class UserQuizzesListView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserListQuizzesSerializer

    def get_queryset(self):
        classroom_id = self.kwargs.get("classroom_id")
        return quizzes.objects.filter(classroom_id=classroom_id)
    
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        return Response(
            {
                "status": status.HTTP_200_OK,
                "message": "Fetched quizzes successfully",
                "data": serializer.data,   # will be [] if empty
            },
            status=status.HTTP_200_OK,
        )
    
class UserCreateQuizzesView(CreateAPIView):
    permission_classes = [IsAuthenticated, IsTeacher]
    serializer_class = UserCreateQuizzesSerializer

    def perform_create(self, serializer):
        pk = self.kwargs.get("classroom_id")
        instance = classroom.objects.get(id=pk)
        serializer.save(classroom=instance)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        
        if serializer.is_valid():
            self.perform_create(serializer)
            return Response(status=status.HTTP_201_CREATED,
                            data={
                                "status":status.HTTP_201_CREATED,
                                "message":"successfully create new quiz",
                                "data" : serializer.data
                            })
        
        return Response(status=status.HTTP_400_BAD_REQUEST,
                        data={
                            "status" : status.HTTP_400_BAD_REQUEST,
                            "message" : serializer.errors })
    
class UserDeleteQuizzesView(DestroyAPIView):
    permission_classes = [IsAuthenticated,IsTeacher]
    queryset = quizzes.objects.all()

    def get_queryset(self):
        classroom_id = self.kwargs.get("classroom_id")
        classroom_instance = classroom.objects.get(id=classroom_id)
        return quizzes.objects.filter(classroom=classroom_instance) 
    
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_200_OK,
                        data={
                            "status": status.HTTP_200_OK,
                            "message": "Classroom deleted successfully.",
                        })
        
class UserQuestionsView(ListCreateAPIView):
    permission_classes = [IsAuthenticated,IsTeacherOrReadOnly]

    def get_queryset(self):
        quiz_id = self.kwargs.get('quiz_id')
        return questions.objects.filter(quiz=quiz_id)
    
    def get_serializer_class(self):
        if self.request.method == 'GET':
            return QuestionsSerializer
        return UserQuestionsSerializer
    
    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['quiz_id'] = self.kwargs.get('quiz_id')
        return context
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        return Response(
            {
                "status": status.HTTP_201_CREATED,
                "message": "Questions added successfully.",
                "data": serializer.data,
            },
            status=status.HTTP_201_CREATED,
        )
