from django import forms
from parasites_app.models import UserProfile, Comment, Post, File
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from django.contrib.auth.forms import PasswordChangeForm

class PasswordChangeCustomForm(PasswordChangeForm):
    def __init__(self, user, *args, **kwargs):
        super(PasswordChangeCustomForm, self).__init__(user,*args, **kwargs)
        for field in self.fields:
            self.fields['old_password'].widget.attrs.update({'class': 'form-control'})
            self.fields['new_password1'].widget.attrs.update({'class': 'form-control'})
            self.fields['new_password2'].widget.attrs.update({'class': 'form-control'})
            
class ContactForm(forms.Form):
    first_name = forms.CharField(max_length = 50)
    last_name = forms.CharField(max_length = 50)
    email_address = forms.EmailField(max_length = 150)
    message = forms.CharField(widget = forms.Textarea, max_length = 2000)


class EditProfileForm(forms.ModelForm):
    email = forms.EmailField()

    class Meta:
        model = User
        fields = ('email',
                   'username'
                 )

class UserProfileForm(forms.ModelForm):
    class Meta:
        model = UserProfile
        fields = ('picture',)
            

class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = ('title', 'text','parasite')
            
class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = ('text',)

        widgets = {
            'text': forms.TextInput(attrs={'class':'form-control', 'placeholder':'Post a comment...'}),
}
class FileForm(forms.ModelForm):
    class Meta:
        model = File
        fields = ('file', 'file_type')
