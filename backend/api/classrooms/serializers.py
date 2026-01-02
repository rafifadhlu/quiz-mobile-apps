from rest_framework import serializers
from django.contrib.auth.models import User
from .models import classroom, classroom_member

class UserClassroomSerializer(serializers.ModelSerializer):
    """
    Serializer for listing users in a classroom.
    """
    class_name = serializers.CharField(max_length=20)
    teacher =  serializers.SerializerMethodField()

    class Meta:
        model = classroom
        fields = ['id', 'class_name', 'teacher']
        read_only_fields = ['teacher']
    
    def get_teacher(self, obj):
        """Return teacher's full name"""
        return f"{obj.teacher.first_name} {obj.teacher.last_name}"

class UserAddClassroomMemberSerializer(serializers.Serializer):
    """
    Serializer for adding a user to a classroom.
    """
    students = serializers.ListField(
        child=serializers.IntegerField(),
        allow_empty=False
    )


    def validate_students(self, value):
        classroom_id = self.context.get("classroom_id")

        # Get all existing student IDs in this classroom
        existing_student_ids = set(
            classroom_member.objects.filter(
                classroom_id=classroom_id
            ).values_list('student_id', flat=True)
        )

        duplicates = [s for s in value if s in existing_student_ids]

        if duplicates:
            raise serializers.ValidationError(
                f"Students {duplicates} are already in this classroom"
            )
        return value

    def create(self, validated_data):
        classroom_id = self.context.get("classroom_id")
        classroom_instance = classroom.objects.get(id=classroom_id)

    
        for student_id in validated_data.get("students", []):
            student = User.objects.get(id=student_id)
            classroom_member.objects.create(classroom=classroom_instance, student=student)

        return validated_data

class MemberListSerializer(serializers.ModelSerializer):
    student_first_name = serializers.CharField(source='first_name', read_only=True)
    student_last_name = serializers.CharField(source='last_name', read_only=True)

    class Meta:
        model = User
        fields = ['id', 'email', 'student_first_name','student_last_name']

class UserClassroomMemberSerializer(serializers.ModelSerializer):
    """
    Serializer for listing members of a classroom.
    """
    students = MemberListSerializer(many=True)

    class Meta:
        model = classroom
        fields = ['id', 'class_name', 'teacher', 'students']

class UserCandidateClassroomSerializer(serializers.ModelSerializer):
    """
    Serializer for viewing a candidate's classroom.
    """

    is_joined = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'first_name','last_name', 'email','is_joined']

    def get_is_joined(self, obj):
        classroom_id = self.context.get("classroom_id")
        return classroom_member.objects.filter(classroom=classroom_id, student=obj).exists()
    