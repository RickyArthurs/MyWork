#parasites_app
from pickle import TRUE
from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.models import AbstractUser
from django.template.defaultfilters import slugify
from django.urls import reverse
from django.utils import timezone
from PIL import Image
from ckeditor.fields import RichTextField
    
ROLES = (
    ('0','Researcher'),
    ('1','Clinician'),
    )

POST_TYPE = (
    ('0','Researcher'),
    ('1','Clinician'),
    ('2', 'Public'),
    )

FILE_TYPE = (
    ('0','Video'),
    ('1','Photo'),
    ('2','PDF'),
    ('3','Other'),
    )

class UserProfile(AbstractUser):
    picture = models.ImageField(upload_to='profile_images/', default='profile_images/default.png')
    role = models.CharField(max_length=1000, choices=ROLES, default='0')
    
    def __str__(self):
        return self.email
    
    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        #Locate image
        #resize for fluidity
        try:
            pic = Image.open(self.picture.path)
            if pic.width > 240 or pic.width  > 240:
                processed = (240, 240)
                pic.thumbnail(processed) #Resize
            pic.save(self.picture.path) # Override current picture with resized one
        except:
            pass

class Parasite(models.Model):
    name = models.CharField(max_length=128, unique=True)
    slug = models.SlugField(max_length=100, unique=True)
    description = RichTextField(blank=True, null=True)
    image = models.ImageField(upload_to='parasite_images', blank=True)
        
    def save(self, *args, **kwargs):
        self.slug = slugify(self.name)
        super(Parasite, self).save(*args, **kwargs)
        
    def __str__(self):
        return self.name
        
class AboutUs(models.Model):
    name = models.CharField(max_length=128, unique=True)
    slug = models.SlugField(max_length=100, unique=True)
    description = RichTextField(blank=True, null=True)
    image = models.ImageField(upload_to='aboutus_images', blank=True)
        
    def save(self, *args, **kwargs):
        self.slug = slugify(self.name)
        super(AboutUs, self).save(*args, **kwargs)
        
    class Meta:
        verbose_name_plural = 'About Us'
        
    def __str__(self):
        return self.name

class Post(models.Model):
    title = models.TextField(max_length=50)
    text = models.TextField()
    date_posted = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    parasite = models.ForeignKey(Parasite, default='None', on_delete=models.CASCADE)
    post_type = models.CharField(max_length=1000, choices=POST_TYPE, default='0')
    
    def __str__(self):
        return self.title + ': ' + str(self.pk)
    
    def get_absolute_url(self):
        return reverse('post', kwargs={'pk': self.pk})


    
class Comment(models.Model):
    user = models.ForeignKey(UserProfile, related_name="profile", on_delete=models.CASCADE)
    post = models.ForeignKey(Post, related_name="post", on_delete=models.CASCADE)
    text = models.TextField()
    date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.user.email + ': ' +   self.text
    
class File(models.Model):
    file = models.FileField(upload_to='user/%Y/%m/%d/', blank=True, null=True)
    file_type = models.CharField(max_length=1000, choices=FILE_TYPE, default='3')
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    number = models.IntegerField()
    
    def __str__(self):
        return self.post.title + ': ' + str(self.number)


