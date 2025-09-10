from .base import *
import os
from storages.backends.s3boto3 import S3Boto3Storage

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')
SUPABASE_BUCKET = os.getenv('SUPABASE_BUCKET')

DEBUG = os.getenv("DEBUG", "False") == "True"
ALLOWED_HOSTS = ['roughly-up-skink.ngrok-free.app','localhost','127.0.0.1']


CSRF_TRUSTED_ORIGINS = [
    "http://203.83.46.48:40700/ep/"
]

SECRET_KEY = os.getenv('SECRET_KEY')

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv("DB_NAME"),
        'USER': os.getenv("DB_USER"),
        'PASSWORD': os.getenv("DB_PASSWORD"),
        'HOST': os.getenv("DB_HOST"),
        'PORT': os.getenv("DB_PORT"),
    }
}

# AWS/Supabase S3 Configuration
# AWS_ACCESS_KEY_ID = os.getenv("SUPABASE_ACCESS_KEY")
# AWS_SECRET_ACCESS_KEY = os.getenv("SUPABASE_SECRET_KEY")
# AWS_S3_ENDPOINT_URL = os.getenv("SUPABASE_S3_STORAGE_URL")
# AWS_S3_REGION_NAME = os.getenv("SUPABASE_REGION")
# AWS_STORAGE_BUCKET_NAME = os.getenv("SUPABASE_STATIC_BUCKET")
# AWS_DEFAULT_ACL = 'public-read'
# AWS_QUERYSTRING_AUTH = False

STORAGES = {
    "default": {
        "BACKEND": "storages.backends.s3boto3.S3Boto3Storage",
        "OPTIONS": {
            "access_key": os.getenv("SUPABASE_ACCESS_KEY"),
            "secret_key": os.getenv("SUPABASE_SECRET_KEY"),
            "bucket_name": os.getenv("SUPABASE_MEDIA_BUCKET"),
            "endpoint_url": os.getenv("SUPABASE_S3_STORAGE_URL"),
            "region_name": os.getenv("SUPABASE_REGION"),
            "default_acl": "public-read",
            "querystring_auth": False,
        },
    },
    "staticfiles": {
        "BACKEND": "storages.backends.s3boto3.S3Boto3Storage",
        "OPTIONS": {
            "access_key": os.getenv("SUPABASE_ACCESS_KEY"),
            "secret_key": os.getenv("SUPABASE_SECRET_KEY"),
            "bucket_name": os.getenv("SUPABASE_STATIC_BUCKET"),
            "endpoint_url": os.getenv("SUPABASE_S3_STORAGE_URL"),
            "region_name": os.getenv("SUPABASE_REGION"),
            "default_acl": "public-read",
            "querystring_auth": False,
            "custom_domain": f"{os.getenv('SUPABASE_URL').replace('https://', '')}/storage/v1/object/public/{os.getenv('SUPABASE_STATIC_BUCKET')}",
            "url_protocol": "https:",
        },
    },
}

# Keep these URL settings:
STATIC_URL = f"{os.getenv('SUPABASE_URL')}/storage/v1/object/public/{os.getenv('SUPABASE_STATIC_BUCKET')}/"
MEDIA_URL = f"{os.getenv('SUPABASE_URL')}/storage/v1/object/public/{os.getenv('SUPABASE_MEDIA_BUCKET')}/"
STATIC_ROOT = BASE_DIR / 'staticfiles'  # Still needed for collectstatic process

SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
X_FRAME_OPTIONS = 'DENY'
