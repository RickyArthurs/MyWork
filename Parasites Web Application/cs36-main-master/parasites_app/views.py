from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from parasites_app.models import *
from parasites_app.forms import ContactForm, EditProfileForm, UserProfileForm, PostForm, CommentForm, FileForm, PasswordChangeCustomForm
from django.core.mail import send_mail
from django.urls import reverse
from django.shortcuts import get_object_or_404
from django.http import Http404
from django.contrib.auth import REDIRECT_FIELD_NAME
from django.contrib.auth.decorators import user_passes_test
from django.contrib.auth.forms import PasswordChangeForm
from django.contrib.auth import update_session_auth_hash
from django.contrib import messages
from django.core.mail import send_mail, BadHeaderError

#create decorators to dictate permissions
#@clinician_required
def clinician_required(function=None, redirect_field_name=REDIRECT_FIELD_NAME, login_url='login'):
    actual_decorator = user_passes_test(
        lambda u: (u.is_superuser or u.role == '1'),
        login_url=login_url,
        redirect_field_name=redirect_field_name
    )
    if function:
        return actual_decorator(function)
    return actual_decorator

#login pages
def user_login(request):
    context = {}
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(username=username, password=password)
        if user:
            if user.is_active:
                login(request, user)
                return redirect(reverse('home'), context)
            else:
                return HttpResponse("Your account does not exist.")
        else:
            print(f"Invalid login details: {username}, {password}")
            return HttpResponse("Invalid login details supplied.")
    else:
        return render(request, 'parasites_app/user_login.html', context)


@login_required(login_url='/login/')
def user_logout(request):
    logout(request)
    return redirect(reverse('home')) 

#public content
def home(request):
    context = {}
    parasite = request.GET.get('parasite')
    posts = Post.objects.filter(post_type='2').order_by('-date_posted')
    if parasite != None:
        posts = posts.filter(
            parasite__name=parasite)
    parasites = Parasite.objects.all()
    context['parasites'] = parasites
    context['posts'] = posts
    return render(request,'parasites_app/home.html', context) 

def public_post(request, pk):
    post = Post.objects.filter(pk = pk)[0]
    context_dict={}
    context_dict['post'] = post
    context_dict['profile'] = post.user
    context_dict['files'] = File.objects.filter(post=post)
    return render(request,'parasites_app/public_post.html',context = context_dict)
    
def parasites(request):
    context = {}
    c = Parasite.objects.all().order_by('name')
    context['c'] = c 
    return render(request, 'parasites_app/parasites.html',context)

def about(request):
    context = {}
    c = AboutUs.objects.all()
    context['c'] = c 
    return render(request, 'parasites_app/about.html',context)

def contact(request):
    if request.method == 'POST':
	    form = ContactForm(request.POST)
	    if form.is_valid():
		    subject = "Website Inquiry" 
		    body = {
		    'first_name': form.cleaned_data['first_name'], 
			'last_name': form.cleaned_data['last_name'], 
			'email': form.cleaned_data['email_address'], 
			'message':form.cleaned_data['message'], 
			}
		    message = "\n".join(body.values())

		    try:
			    send_mail(subject, message, 'parasitescontactus@gmail.com', ['parasitescontactus@gmail.com']) 
		    except BadHeaderError:
			    return HttpResponse('Invalid header found.')
      
    form = ContactForm()
    return render(request, "parasites_app/contact.html", {'form':form})

def view_parasite(request,parasite_name_slug):
    context_dict = {}
    try:
        parasite = Parasite.objects.get(slug=parasite_name_slug)
        context_dict['parasite'] = parasite
    except Parasite.DoesNotExist:
       context_dict['parasite'] = None
    return render(request, 'parasites_app/viewpara.html', context = context_dict)

@login_required(login_url='/login/')
def change_password(request):
    if request.method == 'POST':
        form = PasswordChangeCustomForm(request.user, request.POST)
        if form.is_valid():
            form.save()
            update_session_auth_hash(request, request.user)  # Important!
            messages.success(request, 'Your password was successfully updated!',extra_tags='alert-success')
            return redirect('change_password')
        else:
            messages.error(request, 'Please correct the error below.')
    else:
        form = PasswordChangeCustomForm(request.user)
    return render(request, 'parasites_app/change_password.html', {
        'form': form
    })

#user pages
@login_required(login_url='/login/')
def edit_profile(request):
    if request.method == 'POST':
        f = EditProfileForm(request.POST, instance=request.user)
        pf = UserProfileForm(request.POST, request.FILES, instance=request.user)
        if f.is_valid() and pf.is_valid():
            #Save user data to database
            f.save()
            pf.save()
            messages.success(request, 'Your profile was successfully edited')
            return redirect(reverse('profile'))
    else:
        form = EditProfileForm(instance=request.user)
        pf = UserProfileForm(instance=request.user)
        context = {}
        context['form'] = form
        context['profile_form'] = pf
        
        
        return render(request, 'parasites_app/edit_profile.html', context)

@login_required(login_url='/login/')
def profile(request):
    context_dict = {}
    try:
        profile = request.user
        #print(profile.query)
        context_dict['profile'] = profile
    except UserProfile.DoesNotExist:
        context_dict['profile'] = None
        print("failed")
    print(context_dict)
    return render(request, 'parasites_app/profile.html', context=context_dict)
 

#researcher pages
@login_required(login_url='/login/')
def researcher(request):
    context = {}
    parasite = request.GET.get('parasite')
    posts = Post.objects.filter(post_type='0').order_by('-date_posted')
    if parasite != None:
        posts = posts.filter(
            parasite__name=parasite)
    parasites = Parasite.objects.all()
    context['parasites'] = parasites
    context['posts'] = posts
    return render(request,'parasites_app/researcher.html', context)

@login_required(login_url='/login/')
def researcher_post(request, pk):
    post = Post.objects.filter(pk = pk)[0]
    comments = Comment.objects.filter(post=post)
    files = File.objects.filter(post=post)
    context_dict={}
    context_dict['post'] = post
    context_dict['profile'] = post.user
    context_dict['comments'] = comments
    context_dict['comment_form'] = CommentForm()
    context_dict['files'] = files
    if request.user.is_authenticated:
        if request.method == 'POST':
            if 'Comment' in request.POST:
                comment_form = CommentForm(request.POST)
                if comment_form.is_valid():
                    comment = comment_form.save(commit=False)
                    if request.user.is_superuser:
                        comment.user = request.user
                    else:
                        comment.user = request.user
                    comment.post = context_dict['post']
                    comment.save()
                return redirect(reverse('researcher_post', kwargs={'pk':pk}))
 
    return render(request,'parasites_app/researcher_post.html',context = context_dict)


#clinician pages
@clinician_required(login_url='/login/')
def clinician_post(request, pk):
    post = Post.objects.filter(pk = pk)[0]
    comments = Comment.objects.filter(post=post)
    files = File.objects.filter(post=post)
    context_dict={}
    context_dict['post'] = post
    context_dict['profile'] = post.user
    context_dict['comments'] = comments
    context_dict['comment_form'] = CommentForm()
    context_dict['files'] = files
    if request.user.is_authenticated:
        if request.method == 'POST':
            if 'Comment' in request.POST:
                comment_form = CommentForm(request.POST)
                if comment_form.is_valid():
                    comment = comment_form.save(commit=False)
                    if request.user.is_superuser:
                        comment.user = request.user
                    else:
                        comment.user = request.user
                    comment.post = context_dict['post']
                    comment.save()
                return redirect(reverse('clinician_post', kwargs={'pk':pk}))
    return render(request,'parasites_app/clinician_post.html',context = context_dict)

#Clinican page
@login_required(login_url='/login/')
@clinician_required
def clinician(request):
    context = {}
    parasite = request.GET.get('parasite')
    posts = Post.objects.filter(post_type='1').order_by('-date_posted')
    if parasite != None:
        posts = posts.filter(
            parasite__name=parasite)
    parasites = Parasite.objects.all()
    context['parasites'] = parasites
    context['posts'] = posts
    return render(request,'parasites_app/clinician.html', context)

#add either clinician or researcher post (must be last)
@login_required(login_url='/login/')
def add_researcher_post(request):
    context = {}
    if request.method == 'POST':
        post_form = PostForm(request.POST)
        context['post_form'] = post_form
        if request.user.is_authenticated and post_form.is_valid():
            post = post_form.save(commit=False)
            post.user = request.user
            post.parasite = get_object_or_404(Parasite, pk=request.POST.get('parasite'))
            post.post_type = '0'
            post.save()
            count = 1
            files = request.FILES.getlist('file')
            file_types = request.POST.getlist('file_type')
            types = []
            for t in file_types:
                types.append(t)
            for f in files:
                file_form = FileForm(request.POST, request.FILES)
                if file_form.is_valid():
                    context[str(count)] = file_form
                    file = File.objects.get_or_create(file=f, post=post, file_type=types[0],number=count)[0]
                    file.save()
                    count += 1
                    types.remove(types[0])
                else:
                    print(file_form.errors)  
            return redirect(reverse('researcher'))
        else:
            print(post_form.errors)
        context['post_form'] = post_form
    else:
        context['post_form'] = PostForm()
        context['1'] = FileForm()
        context['2'] = FileForm()
        context['3'] = FileForm()
        context['4'] = FileForm()
        context['5'] = FileForm()
    return render(request, 'parasites_app/add_researcher_post.html', context)
    
@login_required(login_url='/login/')
@clinician_required
def add_clinician_post(request):
    context = {}
    if request.method == 'POST':
        post_form = PostForm(request.POST)
        context['post_form'] = post_form
        if request.user.is_authenticated and post_form.is_valid():
            post = post_form.save(commit=False)
            post.user = request.user
            post.parasite = get_object_or_404(Parasite, pk=request.POST.get('parasite'))
            post.post_type = '1'
            post.save()
            count = 1
            files = request.FILES.getlist('file')
            file_types = request.POST.getlist('file_type')
            types = []
            for t in file_types:
                types.append(t)
            for f in files:
                file_form = FileForm(request.POST, request.FILES)
                if file_form.is_valid():
                    context[str(count)] = file_form
                    file = File.objects.get_or_create(file=f, post=post, file_type=types[0],number=count)[0]
                    file.save()
                    count += 1
                    types.remove(types[0])
                else:
                    print(file_form.errors)  
            return redirect(reverse('clinician'))
        else:
            print(post_form.errors)
        context['post_form'] = post_form
    else:
        context['post_form'] = PostForm()
        context['1'] = FileForm()
        context['2'] = FileForm()
        context['3'] = FileForm()
        context['4'] = FileForm()
        context['5'] = FileForm()
    return render(request, 'parasites_app/add_clinician_post.html', context)
