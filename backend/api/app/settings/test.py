from .base import *

SECRET_KEY = 'test-secret-key' 
SUPABASE_URL = os.getenv('SUPABASE_URL', 'http://dummy-url.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_KEY', 'dummy-key')
SUPABASE_BUCKET = os.getenv('SUPABASE_BUCKET', 'dummy-bucket')

DEBUG = True
ALLOWED_HOSTS = [
    os.getenv("ALLOWED_HOSTS", "127.0.0.1")
]


DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': ':memory:',
        }
    }


MEDIA_ROOT = BASE_DIR /'media'
MEDIA_URL = '/media/'

STATIC_URL = 'static/'
STATICFILES_DIRS = [
    BASE_DIR / "static", 
]