#!/bin/sh

# Exit on any error
set -e

echo "🔧 DJANGO_SETTINGS_MODULE = $ENV"
echo "📑 Collecting static files..."
python manage.py collectstatic --noinput
echo "🚀 Starting Gunicorn in production mode..."
exec gunicorn app.wsgi:application --bind 0.0.0.0:8000