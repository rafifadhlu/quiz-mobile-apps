from rest_framework import serializers
from django.contrib.auth.models import User, Group
from django.contrib.auth import authenticate


class UserAuthSerializer(serializers.ModelSerializer):
    username = serializers.CharField()
    password = serializers.CharField()
    role = serializers.SlugRelatedField(
        many=True,
        read_only=True,
        slug_field="name"  # show group names instead of IDs
    )
    class Meta:
        model = User
        fields = ['username', 'password','role']

    def validate_username(self, value):
        if not value:
            raise serializers.ValidationError("Username is required")
        if not User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Username not found")
        return value

    def validate_password(self, value):
        if not value:
            raise serializers.ValidationError("Password is required")

        return value

    def validate(self, data):
        print(f"Attempting to authenticate with: {data}")

        user = authenticate(**data)
        if user is None:
            raise serializers.ValidationError("Invalid credentials")
        data['user'] = user

        return data

class UserCreateSerializer(serializers.ModelSerializer):

    username = serializers.CharField(
        max_length=150,
        help_text="Enter your username"

    )
    email = serializers.EmailField(
        help_text="Enter your email address"
    )

    first_name = serializers.CharField(
        max_length=30,
        help_text="Enter your first name"
    )

    last_name = serializers.CharField(
        max_length=30,
        help_text="Enter your last name"
    )

    password = serializers.CharField(
        write_only=True,  # This ensures password is not returned in responses
        min_length=8,
        help_text="Enter your password (minimum 8 characters)"
    )

    def validate_email(self, value):
        if not value:
            raise serializers.ValidationError("Email is required")
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists")
        return value
    
    def validate_username(self, value):
        if not value:
            raise serializers.ValidationError("Username is required")
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Username already exists")
        return value


    class Meta:
        model = User
        fields = ['first_name','last_name','username', 'email','password']

    def to_internal_value(self, data):
        data = super().to_internal_value(data)
        data['first_name'] = data['first_name'].capitalize()
        data['last_name'] = data['last_name'].capitalize()
        return data

    def create(self, validated_data):
        group = Group.objects.get(name='Students')
        user = User(**validated_data)
        user.set_password(validated_data['password'])
        user.save()
        user.groups.add(group)
        return user


class UserCreateTeacherSerializer(serializers.ModelSerializer):

    username = serializers.CharField(
        max_length=150,
        help_text="Enter your username"

    )
    email = serializers.EmailField(
        help_text="Enter your email address"
    )

    first_name = serializers.CharField(
        max_length=30,
        help_text="Enter your first name"
    )

    last_name = serializers.CharField(
        max_length=30,
        help_text="Enter your last name"
    )

    password = serializers.CharField(
        write_only=True,  # This ensures password is not returned in responses
        min_length=8,
        help_text="Enter your password (minimum 8 characters)"
    )

    def validate_email(self, value):
        if not value:
            raise serializers.ValidationError("Email is required")
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists")
        return value
    
    def validate_username(self, value):
        if not value:
            raise serializers.ValidationError("Username is required")
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Username already exists")
        return value


    class Meta:
        model = User
        fields = ['first_name','last_name','username', 'email','password']

    def to_internal_value(self, data):
        data = super().to_internal_value(data)
        data['first_name'] = data['first_name'].capitalize()
        data['last_name'] = data['last_name'].capitalize()
        return data

    def create(self, validated_data):
        group = Group.objects.get(name='Teachers')
        user = User(**validated_data)
        user.set_password(validated_data['password'])
        user.save()
        user.groups.add(group)
        return user


class UserRefreshTokenSerializer(serializers.Serializer):

    refreshToken = serializers.CharField(required=True)

    def validate(self, data):
        return data

class UserUpdateSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = User
        fields = ['username','first_name', 'last_name', 'email']