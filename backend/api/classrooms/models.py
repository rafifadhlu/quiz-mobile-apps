from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class classroom(models.Model):
    teacher = models.ForeignKey(User, on_delete=models.CASCADE)
    class_name = models.CharField(max_length=20)

    students = models.ManyToManyField(User, related_name='enrolled_classrooms', through='classroom_member')


class classroom_member(models.Model):
    classroom = models.ForeignKey(classroom, on_delete=models.CASCADE)
    student = models.ForeignKey(User, on_delete=models.CASCADE)
