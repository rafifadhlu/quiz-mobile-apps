from django.shortcuts import render
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics  import CreateAPIView,ListAPIView,UpdateAPIView,DestroyAPIView,ListCreateAPIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.exceptions import ValidationError
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from utils.supabaseServices import delete_file,get_signed_urls


# from .serializers import

from classrooms.permissions import IsStudent,IsTeacher,IsTeacherOrReadOnly
from rest_framework.permissions import IsAuthenticated

from classrooms.models import classroom, classroom_member
from .models import quizzes,questions,choices,student_answers,QuizAttempt

from django.contrib.auth.models import Group, User

from typing import Any

from .serializer import UserQuizzesSerializer,QuestionsSerializer,UserQuestionsSerializer


# Create your views here.

class UserQuizzesView(ListCreateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserQuizzesSerializer

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
    
    def create(self, request, *args, **kwargs):
        classroom_id = self.kwargs.get("classroom_id")
        serializer =  self.get_serializer(data=request.data,context={"classroom_id":classroom_id})
        if serializer.is_valid():
            self.perform_create(serializer.save(classroom_id=classroom_id))
            return Response(status=status.HTTP_201_CREATED,
                            data={
                                "status":status.HTTP_201_CREATED,
                                "message":"successfully create new quiz",
                                "data" : serializer.data
                            })
        return Response(status=status.HTTP_400_BAD_REQUEST,
                        data={
                            "status" : status.HTTP_400_BAD_REQUEST,
                            "message" : serializer.errors
                        })
    
    
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
                            "data": {
                                "id": instance.id,
                                "quiz_name": instance.quiz_name
                            }
                        })
        
class UserQuestionsView(ListCreateAPIView):
    permission_classes = [IsAuthenticated,IsTeacherOrReadOnly]
    parser_classes=[MultiPartParser, FormParser,JSONParser]

    def get_queryset(self):
        classroom_id = self.kwargs["classroom_id"]
        quiz_id = self.kwargs["quiz_id"]

        return questions.objects.select_related('quiz') \
            .prefetch_related('choices_set') \
            .filter(
                quiz_id=quiz_id,
                quiz__classroom_id=classroom_id
            )

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        questions_list = list(queryset)

        # Collect all file names for batch signed URL generation
        file_names = []
        for q in questions_list:
            if q.question_image:
                file_names.append(q.question_image.name)
            if q.question_audio:
                file_names.append(q.question_audio.name)

        # Batch call to Supabase (implement get_signed_urls_batch)
        signed_urls = get_signed_urls(file_names)  # returns {file_name: signed_url}

        serializer = self.get_serializer(
            questions_list, many=True,
            context={'request': request, 'signed_url_map': signed_urls}
        )

        return Response({
            "status": 200,
            "message": "Questions fetched successfully.",
            "data": serializer.data
        })
        
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
        instance = serializer.save()
        self.perform_create(serializer)

        return Response(
            {
                "status": status.HTTP_201_CREATED,
                "message": "Questions added successfully.",
                "data": serializer.validated_data
            },
            status=status.HTTP_201_CREATED,
        )


class UserUpdateQuestions(UpdateAPIView):
    permission_classes = [IsAuthenticated,IsTeacher]
    serializer_class = QuestionsSerializer

    def get_object(self):
        classroom_id = self.kwargs.get('classroom_id')
        quiz_id = self.kwargs.get('quiz_id')
        questions_id = self.kwargs.get("question_id")

        return questions.objects.get(
            id=questions_id,
            quiz_id=quiz_id,
            quiz__classroom_id=classroom_id
        )

    def update(self, request, *args, **kwargs):
        serializer = self.get_serializer(
            instance=self.get_object(),
            data=request.data,
            partial=True
        )

        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(
            {
                "status": status.HTTP_200_OK,
                "message": "Questions updated successfully.",
                "data": serializer.data,
            },
            status=status.HTTP_200_OK,
        )
      
class UserDeleteQuestion(DestroyAPIView):
    permission_classes = [IsAuthenticated,IsTeacher]


    def get_queryset(self):
        return questions.objects.all()
    
    def get_object(self):
        question_id = self.kwargs.get("question_id")
        return get_object_or_404(questions, id=question_id)

    def perform_destroy(self, instance):
        path = instance.question_image.url
        if path:
            delete_file(path)
        
        return super().perform_destroy(instance) 
    
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()

        deleted_data = {
            "id": instance.id,
            "question_text": instance.question_text,  # adjust field names as needed
            "question_image": instance.question_image.url if instance.question_image else None,
            # Add other fields you want to return
        }
        

        self.perform_destroy(instance)
        return Response(status=status.HTTP_200_OK,
                        data={
                            "status": status.HTTP_200_OK,
                            "message": "Question deleted successfully.",
                            "data": deleted_data
                        })


    
