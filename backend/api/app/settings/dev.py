from .base import *
import os
# from utils.supabaseFunc import get_signed_url


SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')
SUPABASE_BUCKET = os.getenv('SUPABASE_BUCKET')

SECRET_KEY = os.getenv('SECRET_KEY')



DEBUG = True
ALLOWED_HOSTS = [
    '127.0.0.1',
    '10.0.2.2',
    '192.168.1.9'
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

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
        "BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage",
    },
}


STATIC_URL = 'static/'
STATICFILES_DIRS = [
    BASE_DIR / "static",  # where your actual static files (before collectstatic) are
]