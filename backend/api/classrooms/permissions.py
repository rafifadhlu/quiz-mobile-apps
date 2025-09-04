from rest_framework.permissions import BasePermission,SAFE_METHODS

class IsTeacher(BasePermission):
    def has_permission(self, request, view):
        return (
            request.user 
            and request.user.is_authenticated 
            and request.user.groups.filter(name="Teachers").exists()
        )


class IsStudent(BasePermission):
    def has_permission(self, request, view):
        return (
            request.user 
            and request.user.is_authenticated 
            and request.user.groups.filter(name="Students").exists()
        )

class IsTeacherOrReadOnly(BasePermission):
    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return (
            request.user 
            and request.user.is_authenticated 
            and request.user.groups.filter(name="Teachers").exists() 
            or  request.user.groups.filter(name="Students").exists() 
        )

        return (
            request.user 
            and request.user.is_authenticated 
            and request.user.groups.filter(name="Teachers").exists()
        )