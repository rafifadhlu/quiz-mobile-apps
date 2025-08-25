
from django.test import TestCase
from django.contrib.auth.models import User
from rest_framework.test import APITestCase
from accounts.serializers import UserAuthSerializer, UserCreateSerializer,UserRefreshTokenSerializer

class UserAuthSerializerTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpassword'
        )

    def test_user_success_auth(self):
        serializer = UserAuthSerializer(data={
            'username': 'testuser',
            'password': 'testpassword'
        })
        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.validated_data, self.user)

    def test_user_fail_auth(self):
        serializer = UserAuthSerializer(data={
            'username': 'testuser',
            'password': 'wrongpassword'
        })
        self.assertFalse(serializer.is_valid())
        self.assertEqual(serializer.errors['non_field_errors'], ["Invalid credentials"])

class UserCreateSerializerTests(TestCase):
    def setUp(self):
        self.user_data = {
            'username': 'newuser',
            'email': 'newuser@example.com',
            'password': 'newpassword'
        }

    def test_user_create_success(self):
        serializer = UserCreateSerializer(data=self.user_data)

        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.validated_data['username'], self.user_data['username'])
        self.assertEqual(serializer.validated_data['email'], self.user_data['email'])
        self.assertEqual(serializer.validated_data['password'], self.user_data['password'])


class UserRefreshTokenSerializerTests(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpassword'
        )

    def test_refresh_token_serializer(self):
        res = self.client.post('/api/v1/auth/login/', {
            'username': 'testuser',
            'password': 'testpassword'
        })

        refresh_token = res.data['data']['refresh']

        serializer = UserRefreshTokenSerializer(data={
            'refreshToken': refresh_token
        })
        
        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.validated_data['refreshToken'], refresh_token)