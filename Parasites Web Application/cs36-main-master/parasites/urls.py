"""parasites URL Configuration
"""
from django.contrib import admin
from django.urls import path, include
from parasites_app import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', include('parasites_app.urls')),
    path('admin/', admin.site.urls),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
