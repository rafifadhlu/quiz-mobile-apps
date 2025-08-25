from .base import *
import os

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')
SUPABASE_BUCKET = os.getenv('SUPABASE_BUCKET')

DEBUG = os.getenv("DEBUG", "False") == "True"
ALLOWED_HOSTS = ['roughly-up-skink.ngrok-free.app','localhost','127.0.0.1']


CSRF_TRUSTED_ORIGINS = [
    "https://try-docker-with-django-production.up.railway.app"
]

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

STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'static'

ECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
X_FRAME_OPTIONS = 'DENY'
