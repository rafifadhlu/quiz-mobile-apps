#!/bin/sh

# Exit on any error
set -e

#!/bin/sh

set -e

echo "🔧 Applying database migrations..."
python manage.py migrate --noinput

echo "📑 Collecting static files..."
python manage.py collectstatic --noinput --verbosity=2

echo "🚀 Starting Gunicorn in production mode..."
exec gunicorn app.wsgi:application --bind 0.0.0.0:8000