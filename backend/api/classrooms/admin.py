from django.contrib import admin
from .models import classroom, classroom_member

class ClassroomAdmin(admin.ModelAdmin):
    model = classroom
    list_display = ('id', 'class_name', 'teacher')
    search_fields = ('class_name', 'teacher')


class ClassroomMemberAdmin(admin.ModelAdmin):
    model = classroom_member
    list_display = ('id', 'classroom', 'student')
    search_fields = ('classroom', 'student')


admin.site.register(classroom, ClassroomAdmin)
admin.site.register(classroom_member, ClassroomMemberAdmin)
