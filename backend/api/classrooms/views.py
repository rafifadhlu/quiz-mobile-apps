from rest_framework.views import APIView
from rest_framework_simplejwt.exceptions import TokenError, InvalidToken
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics  import CreateAPIView,ListAPIView,UpdateAPIView,DestroyAPIView,ListCreateAPIView
from rest_framework_simplejwt.tokens import RefreshToken

from .serializers import UserClassroomSerializer,UserAddClassroomMemberSerializer,UserClassroomMemberSerializer,UserCandidateClassroomSerializer
from .permissions import IsStudent,IsTeacher,IsTeacherOrReadOnly
from rest_framework.permissions import IsAuthenticated

from .models import classroom, classroom_member
from django.contrib.auth.models import Group, User

# Create your views here.

class UserClassroomView(ListCreateAPIView):
    permission_classes = [IsAuthenticated,IsTeacherOrReadOnly]
    serializer_class = UserClassroomSerializer

    def get_queryset(self):
        user = self.request.user
        if user.groups.filter(name="Teachers").exists():
            return classroom.objects.filter(teacher=user).distinct()
        return classroom.objects.filter(classroom_member__student=user).distinct()

    
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset() 
        if queryset.exists():
            serializer = self.get_serializer(queryset, many=True)
            return Response(status=status.HTTP_200_OK,
                            data={
                                "status":status.HTTP_200_OK,
                                "message":"data fetched successfully",
                                "data":serializer.data
                            })
        return Response(status=status.HTTP_404_NOT_FOUND,
                        data={
                            "status": status.HTTP_404_NOT_FOUND,
                            "message":"No classrooms found for this user."
                        })

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
    
class UserDeleteClassroomView(DestroyAPIView):
    permission_classes = [IsAuthenticated, IsTeacher]
    queryset = classroom.objects.all()

    def get_queryset(self): 
        return classroom.objects.filter(teacher=self.request.user)
    
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_200_OK,
                        data={
                            "status": status.HTTP_200_OK,
                            "message": "Classroom deleted successfully."
                        })

class UserClassroomDetailView(ListAPIView):
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

class UserCandidateClassroomView(ListCreateAPIView):
    """
    API endpoint for viewing a candidate's classroom.
    """
    permission_classes = [IsAuthenticated,IsTeacher]
    serializer_class = UserCandidateClassroomSerializer

    def get_queryset(self):
        return User.objects.filter(groups__name="Students")
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return UserAddClassroomMemberSerializer
        if self.request.method == 'GET':
            return UserCandidateClassroomSerializer
        
    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['classroom_id'] = self.kwargs.get('classroom_id')
        return context

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
   
        if serializer.is_valid():
            serializer.save()
            return Response(status=status.HTTP_201_CREATED,
                            data={
                                "status": status.HTTP_201_CREATED,
                                "message": "Successfully added members to the classroom.",
                                "data": serializer.data
                            })
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

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

class UserRemoveClassroomMemberView(APIView):
    permission_classes = [IsAuthenticated, IsTeacher]
    
    def get_queryset(self):
        return classroom_member.objects.all()
    
    def delete(self, request,*args, **kwargs):
        classroom_id = self.kwargs.get('classroom_id')
        student_id = self.kwargs.get('student_id')
        self.get_queryset().filter(student_id=student_id, classroom_id=classroom_id).delete()


        return Response(status=status.HTTP_200_OK,
                        data={
                            "status": status.HTTP_200_OK,
                            "message": f"Removed a student from classroom {classroom_id}.",
                            "data" : {
                                "member_removed" : student_id
                            }
                        })