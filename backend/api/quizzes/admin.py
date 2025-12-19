from django.contrib import admin
from .models import student_answers,QuizAttempt,choices,questions,quizzes

# Register your models here.
class quizzesAdmin(admin.ModelAdmin):
    model:quizzes
    list_display = ('id','quiz_name','classroom_id','created_at')


class student_answersAdmin(admin.ModelAdmin):
    model:student_answers
    list_display = ('id','quiz_attempt_id','question_id','answer_id','is_correct')

class QuizAttemptAdmin(admin.ModelAdmin):
    model:QuizAttempt
    list_display = ('id','quiz_id','student_id','score','score','answered_at')

class choicesAdmin(admin.ModelAdmin):
    model:choices
    list_display = ('id','question_id','choice_text','is_correct')

class questionsAdmin(admin.ModelAdmin):
    model:questions
    list_display = ('id','question_text','quiz_id','question_audio','question_image')

admin.site.register(quizzes,quizzesAdmin)
admin.site.register(student_answers,student_answersAdmin)
admin.site.register(QuizAttempt,QuizAttemptAdmin)
admin.site.register(choices,choicesAdmin)
admin.site.register(questions,questionsAdmin)