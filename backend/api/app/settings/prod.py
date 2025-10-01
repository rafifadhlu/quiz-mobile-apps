from .base import *
import os
from storages.backends.s3boto3 import S3Boto3Storage

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_PUBLIC_KEY')
SUPABASE_BUCKET = os.getenv('SUPABASE_BUCKET')

DEBUG = os.getenv("DEBUG", "False") == "True"


ALLOWED_HOSTS = [
    'roughly-up-skink.ngrok-free.app',
    '203.83.46.48',
    'localhost',
    '127.0.0.1',
]

CSRF_TRUSTED_ORIGINS = [
    "http://203.83.46.48:40700",  # This is correct
    "http://203.83.46.48",         # Add this too
    "https://roughly-up-skink.ngrok-free.app",
]

CORS_ALLOWED_ORIGINS = [
    "http://localhost:5173",  # Your React dev server
    "http://localhost:3000",  # Alternative React port
    "http://203.83.46.48:40700",  # Your production frontend (if any)
]

# Add these CSRF settings
CSRF_COOKIE_DOMAIN = None
CSRF_COOKIE_SAMESITE = 'Lax'  # Add this
CSRF_USE_SESSIONS = False      # Add this

SESSION_COOKIE_DOMAIN = None
SESSION_COOKIE_SAMESITE = 'Lax'  # Add this too

# Since you're using HTTP (not HTTPS), these should be False
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False

CORS_ALLOW_ALL_ORIGINS = True  # Temporary for testing
CORS_ALLOW_CREDENTIALS = True


SECRET_KEY = os.getenv('SECRET_KEY')

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv("DB_NAME"),
        'USER': os.getenv("DB_USER"),
        'PASSWORD': os.getenv("DB_PASSWORD"),
        'HOST': os.getenv("DB_HOST"),
        'PORT': os.getenv("DB_PORT"),
        'OPTIONS': {
            'sslmode': 'require',
        },
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
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False
X_FRAME_OPTIONS = 'DENY'

# Increase upload limits
DATA_UPLOAD_MAX_MEMORY_SIZE = 10485760  # 10MB
FILE_UPLOAD_MAX_MEMORY_SIZE = 10485760  # 10MB

# Enable detailed error logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': 'DEBUG',
        },
    },
}