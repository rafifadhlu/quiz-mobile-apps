from .base import *
import os



SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')
SUPABASE_BUCKET = os.getenv('SUPABASE_BUCKET')

SECRET_KEY = os.getenv('SECRET_KEY')



DEBUG = True
ALLOWED_HOSTS = [
    '127.0.0.1'
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

MEDIA_ROOT = BASE_DIR /'media'
MEDIA_URL = '/media/'

STATIC_URL = 'static/'
STATICFILES_DIRS = [
    BASE_DIR / "static",  # where your actual static files (before collectstatic) are
]