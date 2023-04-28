# **Institute of Infection, Immunity and Inflammation**

# **Description**

This is a 3rd year group project of University of Glasgow team CS36. The application created is for the Institute of Infection, Immunity and Inflammation to help with the communication between Malawi and Glasgow University Institute. It serves as an online platform for sharing posts with images, videos and other files in order to improve communication between researchers and clinicians. It aslo has a public interface for general public information. 

# **Requirements**

In order to successfuly run the project, some packages have to be installed. These can be found in requirements.txt and installed on your own machine by running the command: pip install -r requirements.txt

Here's the list of these packages:

- certifi 2020.12.5
- Django 2.2.17
- Pillow 8.1.0
- pytz 2020.5
- sqlparse 0.4.1
- wincertstore 0.2
- django-ckeditor 6.0.0
- django-jquery

# **Development**

Our application was developed using Django web framework, which all team members had previous experience with. Further, we chose Django thanks to its  robustness and simplicity to help us develop clean and efficient application. Its customizability will help future programmers further develop our code if the customers choose to do so. 

# **How to install and run the project**

Navigate to the directory where you would like to store the project and run these command in your command prompt:

- $ git clone https://stgit.dcs.gla.ac.uk/team-project-h/2021/cs36/cs36-main.git
- $ cd directory-you-cloned-the-gitlab-repository-into
- $ pip install -r requirements.txt
- $ python manage.py makemigrations
- $ python manage.py migrate
- $ python populate_parasites.py
- $ python manage.py runserver

Run the http://127.0.0.1:8000/ and you can successfully view our project. 

# **Licencing**

This project is licensed under the MIT License which grants the permision to to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software.

Further information about the license can be found in the main directory of the project in the file named LICENSE.


# **Credits**

This application was developed by Team project 2021-2022 Group CS36 at the University of Glasgow.

Team members:

- Martina Karaskova 2478724k@student.gla.ac.uk
- Tara Nally 2439105n@student.gla.ac.uk
- Connot Tucker 2455252t@student.gla.ac.uk
- Ricky Arthurs 2465714a@student.gla.ac.uk

# **Release Update - March 18,2022**

# Features

- Public interface for public access with posts and information about different parasites and about us section
- Private interface with different functionalities for Clinicians and Researchers (adding posts with multiple files, commenting)
- Admin Interface to administrate the website (post content for both public and private interface, administrate accounts and comments)

# Bug Fixes

- Errors no longer display when sending email through contact us due to Gmail Authentication

# Known Bugs
- Unable to change password.
- Unable to sign in with new user added due to password hashing errors
