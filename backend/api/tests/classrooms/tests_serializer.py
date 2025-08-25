from django.test import TestCase
from django.contrib.auth.models import User,Group
from classrooms.models import classroom, classroom_member
from rest_framework.test import APITestCase
from classrooms.serializers import UserListClassroomSerializer,UserCreateClassroomSerializer,UserAddClassroomMemberSerializer,UserClassroomMemberSerializer,UserCandidateClassroomSerializer,UserRemoveClassroomMemberSerializer


class UserListClassroomTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpassword'
        )
        
        self.classrooms_data = [
            {
                "class_name": "English 10.1",
                "teacher": 1
            }
        ]

        self.classroom = classroom.objects.create(
            class_name='English 10.1',
            teacher=self.user
        )


    def test_user_list_classroom_serializer(self):
        serializer = UserListClassroomSerializer(data=self.classrooms_data, many=True)

        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.data, self.classrooms_data)

class UserCreateClassroomTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpassword'
        )

    def test_user_create_classroom_serializer(self):
        data = {
            "class_name": "English 10.1",
            "teacher": self.user
        }

        serializer = UserCreateClassroomSerializer(data=data)

        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.data["class_name"], data["class_name"])

class UserAddClassroomMemberTest(TestCase):
    def setUp(self):
        self.teacher = User.objects.create_user(
            username='teacher',
            password='teachpassword'
        )

        group_teacher = Group.objects.create(name='Teachers')
        group_student = Group.objects.create(name='Students')
        self.teacher.groups.add(group_teacher)
        
        users_data = [
                {"username": "rafi", "email": "rafi@example.com", "password": "pw1"},
                {"username": "andi", "email": "andi@example.com", "password": "pw2"},
                {"username": "siti", "email": "siti@example.com", "password": "pw3"},
                ]
        
        for data in users_data:
            Created_user = User.objects.create_user(**data)
            Created_user.groups.add(group_student)

        self.classroom = classroom.objects.create(
            class_name='English 10.1',
            teacher=self.teacher
        )

    def test_user_add_classroom_member_serializer(self):
        
        data = {
            "students" : [user.id for user in User.objects.filter(groups__name="Students")],
        }

        serializer = UserAddClassroomMemberSerializer(data=data)
        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.data["students"], data["students"])

class UserClassroomMemberTest(TestCase):
    def setUp(self):
        self.teacher = User.objects.create_user(
            username='teacher',
            password='teachpassword'
        )

        group_teacher = Group.objects.create(name='Teachers')
        group_student = Group.objects.create(name='Students')
        self.teacher.groups.add(group_teacher)
        
        self.classroom = classroom.objects.create(
            class_name='English 10.1',
            teacher=self.teacher
        )

        users_data = [
                {"username": "rafi", "email": "rafi@example.com", "password": "pw1"},
                {"username": "andi", "email": "andi@example.com", "password": "pw2"},
                {"username": "siti", "email": "siti@example.com", "password": "pw3"},
                ]
        
        for data in users_data:
            Created_user = User.objects.create_user(**data)
            Created_user.groups.add(group_student)
            classroom_member.objects.create(
                student=Created_user,
                classroom=self.classroom
            )

        self.ExpectedData = [
                {
                    "id": 1,
                    "class_name": "English 10.1",
                    "teacher": 1,
                    "students": [
                    {"id": 2, "email": "rafi@example.com", "student_first_name": ""},
                    {"id": 3, "email": "andi@example.com", "student_first_name": ""},
                    {"id": 4, "email": "siti@example.com", "student_first_name": ""}
                    ]
                }
            ]



        

    def test_user_classroom_member_serializer(self):
        queryset = classroom.objects.prefetch_related('students').filter(id=self.classroom.id)

        serializer = UserClassroomMemberSerializer(queryset, many=True)
        self.assertEqual(serializer.data, self.ExpectedData)

class UserCandidateClassroomTest(TestCase):
    def setUp(self):
        self.teacher = User.objects.create_user(
            username='teacher',
            password='teachpassword'
        )

        group_teacher = Group.objects.create(name='Teachers')
        group_student = Group.objects.create(name='Students')
        self.teacher.groups.add(group_teacher)
        
        self.classroom = classroom.objects.create(
            class_name='English 10.1',
            teacher=self.teacher
        )

        users_data = [
                {"username": "rafi", "email": "rafi@example.com", "password": "pw1"},
                {"username": "andi", "email": "andi@example.com", "password": "pw2"},
                {"username": "siti", "email": "siti@example.com", "password": "pw3"},
                ]
        
        for data in users_data:
            Created_user = User.objects.create_user(**data)
            Created_user.groups.add(group_student)
            classroom_member.objects.create(
                student=Created_user,
                classroom=self.classroom
            )
        
        self.expectedData = self.expectedData = [
            {"id": 2, "first_name": "", "last_name": "", "email": "rafi@example.com", "is_joined": True},
            {"id": 3, "first_name": "", "last_name": "", "email": "andi@example.com", "is_joined": True},
            {"id": 4, "first_name": "", "last_name": "", "email": "siti@example.com", "is_joined": True}
        ]


    
    def test_user_candidate_classroom(self):
        classroom_id = self.classroom
        queryset = User.objects.filter(groups__name="Students")

        serializer = UserCandidateClassroomSerializer(queryset, many=True, context={'classroom_id' : classroom_id})
        self.assertEqual(serializer.data,self.expectedData)

class UserRemoveClassroomMemberTest(TestCase):
    def setUp(self):
        self.teacher = User.objects.create_user(
            username='teacher',
            password='teachpassword'
        )

        self.group_teacher = Group.objects.create(name='Teachers')
        self.group_student = Group.objects.create(name='Students')
        self.teacher.groups.add(self.group_teacher)
        
        self.classroom = classroom.objects.create(
            class_name='English 10.1',
            teacher=self.teacher
        )

        users_data = [
                {"username": "rafi", "email": "rafi@example.com", "password": "pw1"},
                {"username": "andi", "email": "andi@example.com", "password": "pw2"},
                {"username": "siti", "email": "siti@example.com", "password": "pw3"},
                ]
        
        for data in users_data:
            Created_user = User.objects.create_user(**data)
            Created_user.groups.add(self.group_student)
            classroom_member.objects.create(
                student=Created_user,
                classroom=self.classroom
            )

    def test_success_remove_classroom_member(self):
        classroom_id = self.classroom
        data = {'students' : [2,3]}

        serializer = UserRemoveClassroomMemberSerializer(data=data, context={'classroom_id':classroom_id})
        serializer.is_valid()
        print(serializer.is_valid())
        print(serializer.errors)

    def test_failed_remove_classroom_member(self):        
        new_user = User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="test123fail@gmail.com"
        )

        new_user.groups.add(self.group_student)
        user_fail = User.objects.get(username='testuser')
        data = {'students' : [user_fail.id]}

        serializer = UserRemoveClassroomMemberSerializer(data=data)
        self.assertFalse(serializer.is_valid())
        self.assertEqual(
            serializer.errors["students"][0],
            f"Students [{user_fail.id}] are not in this classroom"
        )




