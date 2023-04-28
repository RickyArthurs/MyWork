#parasites_app
from django.contrib import admin
from django import forms
from django.contrib.auth.admin import UserAdmin
from parasites_app.models import *


admin.site.register(Comment)
admin.site.register(Post)
admin.site.register(Parasite)
admin.site.register(AboutUs)
admin.site.register(File)


admin.autodiscover()
admin.site.enable_nav_sidebar = False

admin.site.register(UserProfile, admin.ModelAdmin)

