from django.urls import path
from django.contrib import admin
from parasites_app import views
from django.conf import settings
from django.conf.urls.static import static

app_name = "parasites_app"

urlpatterns = [
    #login pages
    path('login/', views.user_login, name='login'),
    path('logout/', views.user_logout, name='logout'),
    path('admin/', admin.site.urls),
    #public content
    #the two following are repeaated
    path('', views.home, name='home'),
    path('home/', views.home, name='home'),
    path('public_post/<str:pk>/', views.public_post, name='public_post'),
    
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('parasites/', views.parasites, name='parasites'),
    path('parasites/<slug:parasite_name_slug>/',views.view_parasite, name='view_parasite'),
    
    #user pages
    path('edit_profile/', views.edit_profile, name='edit_profile'),
    path('change_password/', views.change_password, name='change_password'),
    path('profile/', views.profile, name='profile'),
    
    #researcher pages
    path('researcher/', views.researcher, name='researcher'),
    path('researcher_post/<str:pk>/', views.researcher_post, name='researcher_post'),
    path('add_researcher_post/', views.add_researcher_post, name='add_researcher_post'),

    
    #clinician pages
    path('clinician/', views.clinician, name='clinician'),
    path('clinician_post/<str:pk>/', views.clinician_post, name='clinician_post'),
    path('add_clinician_post/', views.add_clinician_post, name='add_clinician_post'),

  
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
