"""
ASGI config for app project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/asgi/
"""

import os
from dotenv import load_dotenv
from pathlib import Path

from django.core.asgi import get_asgi_application

BASE_DIR = Path(__file__).resolve().parent

ENV = os.environ.get("ENV", "dev")
dotenv_path = BASE_DIR / f'.env.{ENV}'
load_dotenv(dotenv_path)
get_current_env = os.getenv("DJANGO_SETTINGS_MODULE")


os.environ.setdefault('DJANGO_SETTINGS_MODULE', os.getenv("DJANGO_SETTINGS_MODULE"))

application = get_asgi_application()
