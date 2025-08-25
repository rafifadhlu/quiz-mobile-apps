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

        response = self.client.post('/api/v1/classrooms/create/', {
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

        response = self.client.post('/api/v1/classrooms/create/', {
            'class_name': 'English 10.1',
            'teacher': self.user.id
        }, HTTP_AUTHORIZATION=f'Bearer {self.access_token}'
        )
        self.assertEqual(response.status_code, 201)


