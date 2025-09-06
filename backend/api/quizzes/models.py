from django.db import models
from django.contrib.auth.models import Group, User
from django.core.validators import FileExtensionValidator

from classrooms.models import classroom, classroom_member
from utils.renamePath import renaming_question_file

# Create your models here.
class quizzes(models.Model):
    classroom = models.ForeignKey(classroom, on_delete=models.CASCADE)
    quiz_name = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)

class questions(models.Model):
    quiz = models.ForeignKey(quizzes, on_delete=models.CASCADE)
    question_text = models.CharField()
    question_image = models.ImageField(upload_to=renaming_question_file,blank=True, 
                                       null=True,
                                       validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png'])])
    question_audio = models.FileField(upload_to=renaming_question_file, blank=True, 
                                      null=True,
                                      validators=[FileExtensionValidator(allowed_extensions=['mp3', 'wav'])])

class choices(models.Model):
    question = models.ForeignKey(questions, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=150)
    is_correct = models.BooleanField(default=False)

class student_answers(models.Model):
    student = models.ForeignKey(User,on_delete=models.CASCADE),
    quiz = models.ForeignKey(quizzes,on_delete=models.CASCADE),
    question = models.ForeignKey(questions,on_delete=models.CASCADE),
    choice = models.ForeignKey(choices,on_delete=models.CASCADE),
    answered_at = models.DateField(auto_now=False, auto_now_add=True)