import os
import re
import importlib
import warnings
import inspect
import tempfile

import parasites_app.models
from django.contrib.auth import authenticate
from django.urls import reverse, resolve
from django.test import TestCase, Client
from django.conf import settings
from parasites_app import forms, views
from django.db import models
from django.contrib.auth.models import *
from parasites_app.models import *
from populate_parasites import populate
from django.forms import fields as django_fields
from parasites_app.forms import *

FAILURE_HEADER = f"{os.linesep}{os.linesep}{os.linesep}================{os.linesep}TwD TEST FAILURE =({os.linesep}================{os.linesep}"
FAILURE_FOOTER = f"{os.linesep}"

class Tests(TestCase):
    
    def setUp(self):
        self.project_base_dir = os.getcwd()
        self.templates_dir = os.path.join(self.project_base_dir, 'templates')
        self.parasites_app_templates_dir = os.path.join(self.templates_dir, 'parasites_app')

    def test_templates_directory_exists(self):
        """
        Does the template / directory exist?
        """
        directory_exists = os.path.isdir(self.templates_dir)
        self.assertTrue(directory_exists, f"{FAILURE_HEADER}Your project's templates directory does not exist.{FAILURE_FOOTER}")

    def test_template_dir_setting(self):
        """
        Does the TEMPLATE_DIR setting exist, and does it point to the right directory?
        """
        variable_exists = 'TEMPLATE_DIR' in dir(settings)
        self.assertTrue(variable_exists, f"{FAILURE_HEADER}Your settings.py module does not have the variable TEMPLATE_DIR defined!{FAILURE_FOOTER}")

        template_dir_value = os.path.normpath(settings.TEMPLATE_DIR)
        template_dir_computed = os.path.normpath(self.templates_dir)
        self.assertEqual(template_dir_value, template_dir_computed, f"{FAILURE_HEADER}Your TEMPLATE_DIR setting does not point to the expected path. Check your configuration, and try again.{FAILURE_FOOTER}")

    def test_template_lookup_path(self):
        """
        Does the TEMPLATE_DIR value appear within the lookup paths for templates?
        """
        lookup_list = settings.TEMPLATES[0]['DIRS']
        found_path = False

        for entry in lookup_list:
            entry_normalised = os.path.normpath(entry)

            if entry_normalised == os.path.normpath(settings.TEMPLATE_DIR):
                found_path = True

        self.assertTrue(found_path, f"{FAILURE_HEADER}Your project's templates directory is not listed in the TEMPLATES>DIRS lookup list. Check your settings.py module.{FAILURE_FOOTER}")

    def test_templates_exist(self):
        """
        Do templates exist?
        """
        base_path = os.path.join(self.parasites_app_templates_dir, 'base.html')
        about_path = os.path.join(self.parasites_app_templates_dir, 'about.html')
        add_post_path = os.path.join(self.parasites_app_templates_dir, 'add_post.html')
        add_clinician_post_path = os.path.join(self.parasites_app_templates_dir, 'add_clinician_post.html')
        add_researcher_post_path = os.path.join(self.parasites_app_templates_dir, 'add_researcher_post.html')
        about_path = os.path.join(self.parasites_app_templates_dir, 'about.html')
        clinician_path = os.path.join(self.parasites_app_templates_dir, 'Clinician.html')
        clinician_post_path = os.path.join(self.parasites_app_templates_dir, 'clinician_post.html')
        contact_path = os.path.join(self.parasites_app_templates_dir, 'Contact.html')
        edit_profile_path = os.path.join(self.parasites_app_templates_dir, 'edit_profile.html')
        post_path = os.path.join(self.parasites_app_templates_dir, 'post.html')
        profile_path = os.path.join(self.parasites_app_templates_dir, 'profile.html')
        home_path = os.path.join(self.parasites_app_templates_dir, 'home.html')
        researcher_path = os.path.join(self.parasites_app_templates_dir, 'researcher.html')
        researcher_post_path = os.path.join(self.parasites_app_templates_dir, 'researcher_post.html')
        user_login_path = os.path.join(self.parasites_app_templates_dir, 'user_login.html')
        view_para_path = os.path.join(self.parasites_app_templates_dir, 'viewpara.html')
        
        self.assertTrue(os.path.isfile(base_path), f"{FAILURE_HEADER}Your base.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(about_path), f"{FAILURE_HEADER}Your about.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(add_post_path), f"{FAILURE_HEADER}Your add_post.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(add_clinician_post_path), f"{FAILURE_HEADER}Your add_clinician_post.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(add_researcher_post_path), f"{FAILURE_HEADER}Your add_researcher_post.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(clinician_path), f"{FAILURE_HEADER}Your clinician.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(clinician_post_path), f"{FAILURE_HEADER}Your clinician_post.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(contact_path), f"{FAILURE_HEADER}Your contact.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(edit_profile_path), f"{FAILURE_HEADER}Your edit_profile.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(post_path), f"{FAILURE_HEADER}Your post.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(profile_path), f"{FAILURE_HEADER}Your profile.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(home_path), f"{FAILURE_HEADER}Your home.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(researcher_path), f"{FAILURE_HEADER}Your researcher.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(researcher_post_path), f"{FAILURE_HEADER}Your researcher_post.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(user_login_path), f"{FAILURE_HEADER}Your user_login.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        self.assertTrue(os.path.isfile(view_para_path), f"{FAILURE_HEADER}Your view_para.html template does not exist, or is in the wrong location.{FAILURE_FOOTER}")
        
    def does_gitignore_include_database(self, path):
        """
        Takes the path to a .gitignore file, and checks to see whether the db.sqlite3 database is present in that file.
        """
        f = open(path, 'r')

        for line in f:
            line = line.strip()

            if line.startswith('db.sqlite3'):
                return True

        f.close()
        return False

    def test_databases_variable_exists(self):
        """
        Does the DATABASES settings variable exist, and does it have a default configuration?
        """
        self.assertTrue(settings.DATABASES, f"{FAILURE_HEADER}Your project's settings module does not have a DATABASES variable, which is required.{FAILURE_FOOTER}")
        self.assertTrue('default' in settings.DATABASES, f"{FAILURE_HEADER}You do not have a 'default' database configuration in your project's DATABASES configuration variable.{FAILURE_FOOTER}")

    def test_gitignore_for_database(self):
        """
        If you are using a Git repository and have set up a .gitignore, checks to see whether the database is present in that file.
        """
        git_base_dir = os.popen('git rev-parse --show-toplevel').read().strip()

        if git_base_dir.startswith('fatal'):
            warnings.warn("You don't appear to be using a Git repository for your codebase. Although not strictly required, it's *highly recommended*. Skipping this test.")
        else:
            gitignore_path = os.path.join(git_base_dir, '.gitignore')

            if os.path.exists(gitignore_path):
                self.assertTrue(self.does_gitignore_include_database(gitignore_path), f"{FAILURE_HEADER}Your .gitignore file does not include 'db.sqlite3' -- you should exclude the database binary file from all commits to your Git repository.{FAILURE_FOOTER}")
            else:
                warnings.warn("You don't appear to have a .gitignore file in place in your repository. We ask that you consider this! Read the Don't git push your Database paragraph in Chapter 5.")

    def views_use_correct_templates(self):
        
        """
        Do views use templates? Are they the correct ones?
        """
        
        self.user_login = self.client.get( 'parasites_app/user_login.html')
        self.user_logout = self.client.get('parasites_app/home.html')
        self.edit_profile = self.client.get('parasites_app/edit_profile.html')
        self.profile = self.client.get('parasites_app/profile.html')
        self.home = self.client.get('parasites_app/home.html')
        self.about = self.client.get('parasites_app/about.html')
        self.view_parasite = self.client.get('parasites_app/viewpara.html')
        self.researcher = self.client.get('parasites_app/researher.html')
        self.researcher_post = self.client.get('parasites_app/researcher_post.html')
        self.show_post = self.client.get('parasites_app/post.html')
        self.Research = self.client.get('parasites_app/Research.html')
        self.Contact = self.client.get('parasites_app/Contact.html')
        self.clinician_post = self.client.get('parasites_app/clinician_post.html')
        self.clinician = self.client.get('parasites_app/clinician.html')
        self.add_clinician_post = self.client.get('parasites_app/add_clinician_post.html')
        self.add_researcher_post = self.client.get('parasites_app/add_researcher_post.html')
        self.add_post = self.client.get('parasites_app/add_post.html')
        
        
        self.assertTemplateUsed(self.user_login, 'parasites_app/user_login.html', f"{FAILURE_HEADER}Your user_login() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.user_logout, 'parasites_app/user_logout.html', f"{FAILURE_HEADER}Your user_logout() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.edit_profile, 'parasites_app/edit_profile.html', f"{FAILURE_HEADER}Your edit_profile() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.profile, 'parasites_app/profile.html', f"{FAILURE_HEADER}Your profile() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.home, 'parasites_app/home.html', f"{FAILURE_HEADER}Your home() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.about, 'parasites_app/about.html', f"{FAILURE_HEADER}Your about() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.view_parasite, 'parasites_app/viewpara.html', f"{FAILURE_HEADER}Your view_parasite() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.researher, 'parasites_app/researher.html', f"{FAILURE_HEADER}Your researher() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.researcher_post, 'parasites_app/researcher_post.html', f"{FAILURE_HEADER}Your researcher_post() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.show_post, 'parasites_app/post.html', f"{FAILURE_HEADER}Your show_post() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.Research, 'parasites_app/Research.html', f"{FAILURE_HEADER}Your Research() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.Contact, 'parasites_app/Contact.html', f"{FAILURE_HEADER}Your Contact() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.clinician_post, 'parasites_app/clinician_post.html', f"{FAILURE_HEADER}Your clinician_post() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.clinician, 'parasites_app/clinician.html', f"{FAILURE_HEADER}Your clinician() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.add_post, 'parasites_app/add_post.html', f"{FAILURE_HEADER}Your add_post() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.add_clinician_post, 'parasites_app/add_clinician_post.html', f"{FAILURE_HEADER}Your add_clinician_post() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTemplateUsed(self.add_researcher_post, 'parasites_app/add_researcher_post.html', f"{FAILURE_HEADER}Your add_researcher_post() view does not use the expected template.{FAILURE_FOOTER}")
      
    def test_installed_apps(self):
        """
        Checks whether the 'django.contrib.auth' app has been included in INSTALLED_APPS.
        """
        self.assertTrue('django.contrib.auth' in settings.INSTALLED_APPS)
        
    def test_userprofile_class(self):
        """
        Does the UserProfile class exist in parasites_app.models? If so, are all the required attributes present?
        Assertion fails if we can't assign values to all the fields required (i.e. one or more missing).
        """
        self.assertTrue('UserProfile' in dir(parasites_app.models))

        user_profile = parasites_app.models.UserProfile()

        # Now check that all the required attributes are present.
        # We do this by building up a UserProfile instance, and saving it.
        expected_attributes = {
            'picture': tempfile.NamedTemporaryFile(suffix=".jpg").name,
            'role': '1',
        }

        expected_types = {
            'picture': models.ImageField,
            'role': models.CharField,
        }

        found_count = 0

        for attr in user_profile._meta.fields:
            attr_name = attr.name
            

            for expected_attr_name in expected_attributes.keys():
                if expected_attr_name == attr_name:
                    found_count += 1

                    self.assertEqual(type(attr), expected_types[attr_name], f"{FAILURE_HEADER}The type of attribute for '{attr_name}' was '{type(attr)}'; we expected '{expected_types[attr_name]}'. Check your definition of the UserProfile model.{FAILURE_FOOTER}")
                    setattr(user_profile, attr_name, expected_attributes[attr_name])

        self.assertEqual(found_count, len(expected_attributes.keys()), f"{FAILURE_HEADER}In the UserProfile model, we found {found_count} attributes, but were expecting {len(expected_attributes.keys())}. Check your implementation and try again.{FAILURE_FOOTER}")
        user_profile.save()
        
    def test_login_functionality(self):
        
        user_object = create_user_object()

        response = self.client.post('/login/', {'username': 'testuser', 'password': 'test123'})

        try:
            self.assertEqual(user_object.id, int(self.client.session['_auth_user_id']), f"{FAILURE_HEADER}We attempted to log a user in with an ID of {user_object.id}, but instead logged a user in with an ID of {self.client.session['_auth_user_id']}. Please check your login() view.{FAILURE_FOOTER}")
        except KeyError:
            self.assertTrue(False, f"{FAILURE_HEADER}When attempting to log in with your login() view, it didn't seem to log the user in. Please check your login() view implementation, and try again.{FAILURE_FOOTER}")

    #activate test when index view exists/when login redirects to something else than index
    
    def test_bad_request(self):
        """
        Tries to access the profile view when not logged in.
        This should redirect the user to the login page.
        """
        response = self.client.get('/profile/')

        self.assertEqual(response.status_code, 302, f"{FAILURE_HEADER}We tried to access a restricted view when not logged in. We expected to be redirected, but were not. Check your restricted() view.{FAILURE_FOOTER}")
        self.assertTrue(response.url.startswith('/login/'), f"{FAILURE_HEADER}We tried to access a restricted view when not logged in, and were expecting to be redirected to the login page. But we were not! Please check your view.{FAILURE_FOOTER}")
        
    def test_middleware_present(self):
        """
        Tests to see if the SessionMiddleware is present in the project configuration.
        """
        self.assertTrue('django.contrib.sessions.middleware.SessionMiddleware' in settings.MIDDLEWARE)

    def test_session_app_present(self):
        """
        Tests to see if the sessions app is present.
        """
        self.assertTrue('django.contrib.sessions' in settings.INSTALLED_APPS)       

def create_user_object():
    """
    Helper function to create a User object.
    """
    user = UserProfile.objects.get_or_create(username='testuser',
                                      email='test@test.com',)[0]
    user.set_password('test123')
    user.is_superuser = True
    user.save()

    return user 
    
class LoginTests(TestCase):
    
    
    def test_logged_in_links(self):
        
        #Checks for links that should only be displayed when the user is logged in.
        
        self.client.login(username='hannah.bialic', password='123')
        content = self.client.get('parasites_app/clininician.html').content.decode()

        # These should not be present.
        self.assertTrue('href="/parasites_app/login/"' not in content, f"{FAILURE_HEADER}Please check the links in your base.html have been updated correctly to change when users log in and out.{FAILURE_FOOTER}")

    def test_logged_out_links(self):
        
        #Checks for links that should only be displayed when the user is not logged in.
        
        content = self.client.get('parasites_app/clininician.html').content.decode()
        
        # These should not be present.
        self.assertTrue('href="/parasites_app/admin"' not in content, f"{FAILURE_HEADER}Please check the links in your base.html have been updated correctly to change when users log in and out.{FAILURE_FOOTER}")
        self.assertTrue('href="/parasites_app/clinician"' not in content, f"{FAILURE_HEADER}Please check the links in your base.html have been updated correctly to change when users log in and out.{FAILURE_FOOTER}")
        self.assertTrue('href="/parasites_app/researcher/"' not in content, f"{FAILURE_HEADER}Please check the links in your base.html have been updated correctly to change when users log in and out.{FAILURE_FOOTER}")
        
        #activate these when login/logout links in base.html are implemented
  
    
class ViewTests(TestCase):
    
    def setUp(self):
        self.project_base_dir = os.getcwd()
        self.templates_dir = os.path.join(self.project_base_dir, 'templates')
        self.parasites_app_templates_dir = os.path.join(self.templates_dir, 'parasites_app')
        
    def test_views(self): 
    
        #logout
        
        user_object = create_user_object()
        self.client.login(username='testuser', password='test123')
        
        logout = self.client.get('/logout/')
 
        self.assertTrue(logout.url.startswith(reverse('home')), f"{FAILURE_HEADER}We tried logging out and were expecting to be redirected to the home page. But we were not! Please check your logout view.{FAILURE_FOOTER}")
        
        
        #create clinician post
        
        user_object = create_user_object()
        self.client.login(username='testuser', password='test123')

        self.add_clinician_post = self.client.get('/add_clinician_post/')
        post_content = self.add_clinician_post.content.decode()
        post_context = self.add_clinician_post.context
        
        self.assertTemplateUsed(self.add_clinician_post, 'parasites_app/add_clinician_post.html', f"{FAILURE_HEADER}Your add_clinician_post() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTrue('post_form' in post_content, f"{FAILURE_HEADER}The clinician_post() view context dictionary should have an expected variable.{FAILURE_FOOTER}")
       
        #create researcher post
        
        user_object = create_user_object()
        self.client.login(username='testuser', password='test123')
        
        self.add_researcher_post = self.client.get('/add_researcher_post/')
        post_content = self.add_researcher_post.content.decode()
        post_context = self.add_researcher_post.context
        
        self.assertTemplateUsed(self.add_researcher_post, 'parasites_app/add_researcher_post.html', f"{FAILURE_HEADER}Your researcher_post() view does not use the expected template.{FAILURE_FOOTER}")
        self.assertTrue('post_form' in post_content, f"{FAILURE_HEADER}The researcher_post() view context dictionary should have an expected variable.{FAILURE_FOOTER}")
        
          

