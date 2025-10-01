from operator import index
from rest_framework import serializers
from django.contrib.auth.models import User
from .models import quizzes,questions,choices,student_answers,QuizAttempt
import json

class UserQuizzesSerializer(serializers.ModelSerializer):
    quiz_name = serializers.CharField(max_length=50)
    
    class Meta:
        model = quizzes
        fields = ['id','classroom','quiz_name','created_at']
        read_only_fields = ['id','classroom','created_at']


class ChoicesSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=False)
    class Meta:
        model = choices
        fields = ['id','choice_text','is_correct']

class QuestionsSerializer(serializers.ModelSerializer):
    # id = serializers.IntegerField(required=False)
    choices = ChoicesSerializer(many=True, write_only=True)
    question_image = serializers.ImageField(required=False, allow_null=True,write_only=True)
    question_audio = serializers.FileField(required=False, allow_null=True,write_only=True)
    
    question_image_url = serializers.SerializerMethodField(read_only=True)
    question_audio_url = serializers.SerializerMethodField(read_only=True)
    choices_list = ChoicesSerializer(source='choices_set',many=True,read_only=True)

    class Meta:
        model = questions
        fields = ["id","quiz_id","question_text","question_audio","question_image","question_audio_url","question_image_url", "choices", "choices_list"]

    # for get request
    def get_question_image_url(self, obj):
        context = self.context or {}
        signed_map = context.get('signed_url_map', {})
        return signed_map.get(obj.question_image.name) if obj.question_image else None

    def get_question_audio_url(self, obj):
        signed_map = self.context.get('signed_url_map', {})
        return signed_map.get(obj.question_audio.name) if obj.question_audio else None
    
    def can_view_question(self, question, user):
        if user.groups.filter(name='Teachers').exists():
            return True
        elif question.quiz.classroom.students.filter(id=user.id).exists():
            return True
        return False
    
    # for incoming files validation
    def validate_question_image(self, value):
        if value and value.content_type not in ['image/jpeg', 'image/png']:
            raise serializers.ValidationError("Only JPG and PNG images are allowed.")
        return value

    def validate_question_audio(self, value):
        if value and value.content_type not in ['audio/mpeg', 'audio/wav']:
            raise serializers.ValidationError("Only MP3 and WAV audio files are allowed.")
        return value
    
    def update(self, instance, validated_data):
        # Update question fields
        instance.question_text = validated_data.get("question_text", instance.question_text)
        instance.question_image = validated_data.get("question_image", instance.question_image)
        instance.question_audio = validated_data.get("question_audio", instance.question_audio)

        # Handle choices
        choices_data = validated_data.pop("choices", None)
        if choices_data is not None:
            existing_ids = [c.id for c in instance.choices_set.all()]
            sent_ids = [c.get("id") for c in choices_data if c.get("id") is not None]

            # Delete removed choices
            for choice_id in existing_ids:
                if choice_id not in sent_ids:
                    instance.choices_set.filter(id=choice_id).delete()

            # Update or create
            for c_item in choices_data:
                choice_id = c_item.get("id", None)

                if choice_id is not None:  # update existing
                    try:
                        choice_instance = instance.choices_set.get(id=choice_id)
                        choice_instance.choice_text = c_item.get("choice_text", choice_instance.choice_text)
                        choice_instance.is_correct = c_item.get("is_correct", choice_instance.is_correct)
                        choice_instance.save()
                    except choice_instance.DoesNotExist:
                        # fallback: create new if ID doesn't exist
                        c_item.pop("id", None)
                        choice_instance.objects.create(question=instance, **c_item)
                else:  # new choice
                    c_item.pop("id", None)  # ✅ make sure "id" isn't passed
                    choice_instance.objects.create(question=instance, **c_item)

        instance.save()
        return instance



 
        
    
class UserQuestionsSerializer(serializers.Serializer):
    questions = serializers.JSONField(write_only=True)  # Changed this!
    images_files = serializers.ListField(
        child=serializers.ImageField(), required=False, write_only=True
    )
    audio_files = serializers.ListField(
        child=serializers.FileField(), required=False, write_only=True
    )

    def validate_questions(self, value):
        if not value:
            raise serializers.ValidationError("Questions list cannot be empty.")
        
        # Handle both string (from multipart) and object (from JSON) data
        if isinstance(value, str):
            try:
                parsed_questions = json.loads(value)
            except json.JSONDecodeError:
                raise serializers.ValidationError("Invalid JSON format for questions.")
        else:
            parsed_questions = value
        
        if not isinstance(parsed_questions, list):
            raise serializers.ValidationError("Questions must be a list.")
        
        # Validate each question using QuestionsSerializer
        validated_questions = []
        for question_data in parsed_questions:
            question_serializer = QuestionsSerializer(data=question_data)
            if question_serializer.is_valid():
                validated_questions.append(question_serializer.validated_data)
            else:
                raise serializers.ValidationError(f"Invalid question data: {question_serializer.errors}")
        
        return validated_questions

    def create(self, validated_data):
        quiz_id = self.context.get("quiz_id")
        quiz_instance = quizzes.objects.get(id=quiz_id)
        request = self.context.get("request")

        image_from_field = validated_data.pop("images_files",[])
        audio_from_field = validated_data.pop("audio_files",[])

        created_questions = []
        questions_data = validated_data["questions"]

        for index, q_item in enumerate(questions_data):
            choices_data = q_item.pop("choices", [])

            if index < len(image_from_field) and image_from_field[index]:
                q_item["question_image"] = image_from_field[index]

            if index < len(audio_from_field) and audio_from_field[index]:
                q_item["question_audio"] = audio_from_field[index] 
            
            question_instance = questions.objects.create(
                quiz=quiz_instance, **q_item
            )

            for c_item in choices_data:
                choices.objects.create(question=question_instance, **c_item)

            created_questions.append(question_instance)

        return created_questions
    

class UserSubmitAnswerSerializer(serializers.ModelSerializer):

    quiz_id = serializers.IntegerField(write_only=True)
    question_id = serializers.IntegerField(write_only=True)
    answer_id = serializers.IntegerField(write_only=True)

    class Meta:
        model = student_answers
        fields = ['quiz_id', 'question_id', 'answer_id', 'answer', 'is_correct']
        read_only_fields = ['answer', 'is_correct']

    def validate(self, data):
        # Validate quiz, question, and choice existence
        quiz = quizzes.objects.get(id=data["quiz_id"])
        if not quiz:
            raise serializers.ValidationError({"quiz_id": "Quiz not found."})

        question = questions.objects.get(id=data["question_id"], quiz_id=quiz.id)

        if not question:
            raise serializers.ValidationError({"question_id": "Question not found or not in this quiz."})

        choice = choices.objects.get(id=data["answer_id"], question=question)

        if not choice:
            raise serializers.ValidationError({"answer_id": "Answer not found or not for this question."})

        # attach objects to serializer for reuse in create()
        data["quiz"] = quiz
        data["question"] = question
        data["choice"] = choice
        return data

    def create(self, validated_data):
        user = self.context["user"]
        quiz = validated_data["quiz"]
        question = validated_data["question"]
        choice = validated_data["choice"]

        attempt, create = QuizAttempt.objects.get_or_create(
            student=user,
            quiz=quiz
        )

        obj, created = student_answers.objects.update_or_create(
            question=question,
            quiz_attempt=attempt,
            defaults={
                "answer":choice,
                "is_correct":choice.is_correct
            }
        )

        get_all_count_questions = student_answers.objects.filter(
                quiz_attempt_id=attempt,
            ).count() 
        
        get_correct_questions = student_answers.objects.filter(
                quiz_attempt_id=attempt,
                is_correct = True
            ).count()

        attempt.score = (get_correct_questions/get_all_count_questions)*100 
        attempt.save()

        return obj
        

class QuizAttemptSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuizAttempt
        fields = "__all__"

    

    




