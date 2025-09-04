from rest_framework import serializers
from django.contrib.auth.models import User
from .models import quizzes,questions,choices,student_answers

class UserListQuizzesSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = quizzes
        fields = ['classroom','quiz_name','created_at']    

class UserCreateQuizzesSerializer(serializers.ModelSerializer):
    quiz_name = serializers.CharField(max_length=50)

    class Meta:
        model = quizzes
        fields = ['classroom','quiz_name']
        read_only_fields = ['classroom']

class ChoicesSerializer(serializers.ModelSerializer):
    class Meta:
        model = choices
        fields = ['id','choice_text','is_correct']

class QuestionsSerializer(serializers.ModelSerializer):
    choices = ChoicesSerializer(source='choices_set',many=True)

    class Meta:
        model = questions
        fields = ["id","quiz_id","question_text","question_audio","question_image", "choices"]

    def validate_question_image(self, value):
        if value and value.content_type not in ['image/jpeg', 'image/png']:
            raise serializers.ValidationError("Only JPG and PNG images are allowed.")
        return value

    def validate_question_audio(self, value):
        if value and value.content_type not in ['audio/mpeg', 'audio/wav']:
            raise serializers.ValidationError("Only MP3 and WAV audio files are allowed.")
        return value

class UserQuestionsSerializer(serializers.Serializer):
    questions = QuestionsSerializer(many=True)

    def create(self, validated_data):
        quiz_id = self.context.get("quiz_id")
        quiz_instance = quizzes.objects.get(id=quiz_id)
    
        for q_item in validated_data.get("questions", []):
            choices_data = q_item.pop('choices')
            questions_instance = questions.objects.create(quiz=quiz_instance,**q_item)
            for c_item in choices_data:
                choices.objects.create(question=questions_instance,**c_item)
            
        return validated_data

    # def create(self, validated_data):
    #     created_questions = []

    #     for q_data in questions:
    #         choices_data = q_data.pop('choices')
    #         questions_instance = questions.objects.create(**q_data)
    #         for c_data in choices_data:
    #             choices.objects.create(question=questions_instance,**c_data)
    #         created_questions.append(questions_instance)
    #     return created_questions
