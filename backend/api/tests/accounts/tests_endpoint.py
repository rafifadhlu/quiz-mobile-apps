
from django.test import TestCase
from django.contrib.auth.models import User,Group
from rest_framework.test import APITestCase
from accounts.views import UserViewSet

class UserViewSetTest(TestCase):
    """
    Login View TestCase /auth/login/
    """
    def setUp(self):
        self.user = User.objects.create_user(username='testuser', password='testpassword')

    def test_user_success_auth(self):
        res = self.client.post('/api/v1/auth/login/', {
            'username': 'testuser',
            'password': 'testpassword'
        })
        self.assertEqual(res.status_code, 200)

    def test_user_fail_auth(self):
        res = self.client.post('/api/v1/auth/login/', {
            'username': 'testuser',
            'password': 'wrongpassword'
        })
        self.assertEqual(res.status_code, 401)

class UserCreateViewTest(APITestCase):
    """
    User Registration View TestCase /auth/register/
    """
    def setUp(self):
        self.user_data = {
            'username': 'testuser',
            'email': 'testuser@example.com',
            'first_name' :'test',
            'last_name' : 'newuser',
            'password': 'testpassword'
        }
        group = Group.objects.create(name='Students')

    def test_user_success_registration(self):
        res = self.client.post('/api/v1/auth/register/', self.user_data)
        self.assertEqual(res.status_code, 201)

    def test_user_fail_registration(self):
        # Test registration with existing username
        existing_user = User.objects.create_user(**self.user_data)
        res = self.client.post('/api/v1/auth/register/', self.user_data)
        self.assertEqual(res.status_code, 400)

class UserRefreshTokenViewTest(APITestCase):
    """
    User Refresh Token View TestCase /auth/token/refresh/
    """
    def setUp(self):
        self.user = User.objects.create_user(username='testuser', password='testpassword')

    def test_user_success_refresh_token(self):
        user_login = self.client.post('/api/v1/auth/login/', {
            'username': 'testuser',
            'password': 'testpassword'
        })

        refresh_token = user_login.data['data']['refresh']

        res = self.client.post('/api/v1/auth/token/refresh/', {
            'refreshToken': refresh_token
        })

        self.assertEqual(res.status_code, 200)

    def test_user_fail_refresh_token(self):
        refreshToken = 'invalid_token'
        
        res = self.client.post('/api/v1/auth/token/refresh/', {
            'refreshToken': refreshToken
        })
        self.assertEqual(res.data['detail'], "Invalid or expired refresh token")

class UserBlackListTokenViewTest(APITestCase):
    def setUp(self):
        self.user_data = {
            "username": "testuser",
            "password": "testpassword"
        }
        self.user = User.objects.create_user(**self.user_data)

    def test_user_blacklist_token(self):
        res = self.client.post('/api/v1/auth/login/', self.user_data)
        refresh_token = res.data['data']['refresh']

        res = self.client.post('/api/v1/auth/logout/', {
            'refreshToken': refresh_token
        })
        self.assertEqual(res.status_code, 200)