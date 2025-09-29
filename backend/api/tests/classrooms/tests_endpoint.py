from django.test import TestCase
from django.contrib.auth.models import User,Group
from rest_framework.test import APITestCase
from classrooms.models import classroom, classroom_member


class UserListClassroomTest(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpassword'
        )
        Group.objects.create(name='Teachers')
        group = Group.objects.get(name='Teachers')

        self.user.groups.add(group)

        user_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'testuser',
            'password': 'testpassword'
        })

        self.access_token = user_logged_in.data['data']['access']

        response = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.user.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}'
        )

    def test_user_list_classroom(self):
        response = self.client.get('/api/v1/classrooms/', HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        self.assertEqual(response.status_code, 200)

class UserCreateClassroomTest(APITestCase):

    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpassword'
        )

        Group.objects.create(name='Teachers')
        group = Group.objects.get(name='Teachers')
        self.user.groups.add(group)

    def test_user_create_classroom(self):
        user_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'testuser',
            'password': 'testpassword'
        })

        self.access_token = user_logged_in.data['data']['access']

        response = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.user.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}'
        )
        self.assertEqual(response.status_code, 201)

class UserDeleteClassroomTest(APITestCase):
    def setUp(self):
        self.teacher = User.objects.create_user(
            username='teacher',
            password='teacherpass'
        )

        group_teacher = Group.objects.create(name='Teachers')
        self.teacher.groups.add(group_teacher)
        
        user_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'teacher',
            'password': 'teacherpass'
        })

        self.access_token = user_logged_in.data['data']['access']

        response = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.teacher.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}'
        )

    def test_delete_classroom(self):
        instance = 1
        res = self.client.delete(f'/api/v1/classrooms/{instance}/', 
                                HTTP_AUTHORIZATION=f'Bearer {self.access_token}',format="json")
        
        self.assertEqual(res.data['status'], 200)

class UserAddClassroomMemberTest(APITestCase):
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

    def test_user_successfully_add_classroom_member(self):
        teacher_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'teacher',
            'password': 'teachpassword'
        })
        
        self.access_token = teacher_logged_in.data['data']['access']

        response = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.teacher.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}')

        user_added = User.objects.get(username='rafi')
        data = {'students': [user_added.id]}

        instance = classroom.objects.get(teacher=self.teacher.id)

        response = self.client.post(f'/api/v1/classrooms/{instance.id}/candidate/', 
                                    data, 
                                    HTTP_AUTHORIZATION=f'Bearer {self.access_token}',format="json")
        
        self.assertEqual(response.status_code, 201)

    def test_failed_successfully_add_classroom_member(self):
        teacher_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'teacher',
            'password': 'teachpassword'
        })
        
        self.access_token = teacher_logged_in.data['data']['access']

        response = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.teacher.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}')

        data = {'students': []}

        instance = classroom.objects.get(teacher=self.teacher.id)

        response = self.client.post(f'/api/v1/classrooms/{instance.id}/candidate/', 
                                    data, 
                                    HTTP_AUTHORIZATION=f'Bearer {self.access_token}',format="json")
        
        self.assertEqual(response.status_code, 400)

class UserViewClassroomMemberTest(APITestCase):
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

    def test_user_view_classroom_member(self):
        teacher_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'teacher',
            'password': 'teachpassword'
        })
        
        self.access_token = teacher_logged_in.data['data']['access']

        create_classroom = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.teacher.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}')

        user_added = User.objects.get(username='rafi')
        data = {'students': [user_added.id]}

        instance = classroom.objects.get(teacher=self.teacher.id)

        add_member_classroom = self.client.post(f'/api/v1/classrooms/{instance.id}/candidate', 
                                    data, 
                                    HTTP_AUTHORIZATION=f'Bearer {self.access_token}',format="json")
        
        response = self.client.get(f'/api/v1/classrooms/{instance.id}/candidate/', 
                                    HTTP_AUTHORIZATION=f'Bearer {self.access_token}',format="json")
        
        self.assertEqual(response.status_code, 200)

class UserSeeCandidateClassroomTest(APITestCase):
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

    def test_see_candidate_classroom(self):
        teacher_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'teacher',
            'password': 'teachpassword'
        })
        
        self.access_token = teacher_logged_in.data['data']['access']

        create_classroom = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.teacher.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}')

        instance = classroom.objects.get(teacher=self.teacher.id)

        res = self.client.get(f'/api/v1/classrooms/{instance.id}/candidate/', 
                                    HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        self.assertEqual(res.status_code, 200)

class UserRemoveClassroomTest(APITestCase):
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

        teacher_logged_in = self.client.post('/api/v1/auth/login/', {
            'username': 'teacher',
            'password': 'teachpassword'
        })
        
        self.access_token = teacher_logged_in.data['data']['access']

        create_classroom = self.client.post('/api/v1/classrooms/', {
            'class_name': 'English 10.1',
            'teacher': self.teacher.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}')

        user_added = User.objects.get(username='rafi')
        self.data = {'students': [user_added.id]}

        self.instance = classroom.objects.get(teacher=self.teacher.id)

        add_member = self.client.post(f'/api/v1/classrooms/{self.instance.id}/candidate/', 
                                    self.data, 
                                    HTTP_AUTHORIZATION=f'Bearer {self.access_token}',format="json")

    def test_remove_student_classroom(self):

        res = self.client.delete(f'/api/v1/classrooms/{self.instance.id}/members/{2}/',
                                    HTTP_AUTHORIZATION=f'Bearer {self.access_token}',format="json")

        self.assertEqual(res.status_code, 200)







