import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'parasites.settings')

import django
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'parasites.settings')

import django
django.setup()
from parasites_app.models import *
from django.contrib.auth.models import User
from django.utils import timezone
#from django.core.files import File
from django.contrib.auth.hashers import make_password

#python manage.py help flush

def populate():
    
    parasites = [
        {"name": "Plasmodium", 
        "description":"Malaria is a disease caused by parasites from the genus Plasmodia that are transmitted to humans by Anopheles mosquitoes. Two related parasite species cause the majority of disease and death from malaria in humans. They are Plasmodium falciparum and Plasmodium vivax. P. falciparum is the more lethal of the two and is prevalent in Sub-Saharan Africa.  According to the 2013 World Malaria Report, 3.4 billion people (almost half of the world’s population) are at risk of malaria, and in 2013 it caused an estimated 584 000 deaths mostly among African children. However, malaria mortality rates among children in Africa have been reduced by an estimated 58% since 2000.\n Symptoms of malaria include fever, headache, and vomiting, and usually appear between 10 and 15 days after the mosquito bite. If not treated, malaria can quickly become life-threatening by disrupting the blood supply to vital organs including the brain. In many parts of the world, the parasites have developed resistance to a number of malaria medicines.\n Malaria has a complex lifecycle which involves sexual reproduction in the female Anopheles mosquito, and asexual reproduction in human hepatocytes (liver cells) and erythrocytes (red blood cells). This complexity makes creating effective therapeutics and vaccines challenging.  Increasing resistance to anti-malarial drugs is also having an impact on treatment in endemic regions.",},
        {"name": "Helmninths", 
        "description":"‌Helminths are multicellular parasitic worms that are characterised by either an elongated, flat body (platyhelminths) or by a round body (nemotodes). Like many parasites, helminths have a complex life cycle and develop through egg, larval (juvenile), and adult stages. Helminths live in and feed on living hosts. They receive nourishment and protection while disrupting their hosts' nutrient absorption which can ultimately cause weakness and disease of the infected animal. Helminths can survive in their mammalian hosts for many years due to their ability to manipulate the immune response by secreting immunomodulatory products.\n At the WCIP there are two strands of research relating to helminths: one exploring schistosomiasis and its persistence in human populations; the second exploring the immunomodulatory effects of Heligmosomoides polygyrus, a nematode parasite of mice.\n Dr Poppy Lamberton and her group work on neglected tropical diseases, such as schistosomiasis and onchocerciasis. Their multidisciplinary work focuses on reducing disease transmission at a community level and improving treatment success and drug efficacy monitoring at an individual level. The Lamberton Lab (https://www.poppylamberton.com/) utilise field epidemiological data, laboratory experiments, parasite population genetics, ethnographic methods, engineering and economics to address applied research questions. Much of their fieldwork is carried out in Uganda. \n Professor Rick Maizels and his group are testing the hypothesis that helminth parasites exploit the body's own safety mechanisms which have evolved to minimise the risk of autoimmunity. For example, regulatory T cells naturally arise to limit autoreactivity, but are also associated with chronic helminth infection. The expansion of regulatory T cell populations may underlie the epidemiological association between infection and reduced levels of allergy.",},
        {"name": "Trypanosoma", 
        "description":"Trypanosomes are responsible for causing Human African Trypanosomiasis (HAT), also known as sleeping sickness. Trypanosomes are transmitted to humans through infected tsetse flies, which breed in warm and humid areas across sub-Saharan Africa.  Tsetse flies also come into contact with cattle and wild animals which all act as reservoirs for the Trypanosoma parasites.  The WHO estimates that 60 million people are at risk in 36 Sub-Saharan countries.The infection attacks the central nervous system causing severe neurological disorders, and is fatal without treatment. More than 95 percent of reported cases are caused by the parasite Trypanosoma brucei gambiense, which is found in western and central Africa.  Animal African Trypanosomiasis (AAT) affects livestock in this region and is a huge impediment to economic development.",},
        {"name": "Toxoplasma", 
        "description":"he Toxoplasma gondii parasite is found all over the world, and in other animal species.  Infection can occur through eating undercooked meat or from accidently ingesting cat faeces (e.g. if you change a cat’s litter tray and don’t wash your hands afterwards).   There is also maternal transmission if a woman becomes infected with T. gondii during, or shortly before her pregnancy.  Many infected individuals do not display any symptoms, although some can experience mild flu-like symptoms (e.g. high temperature and aching muscles).  However, if a person has a weakened immune system (e.g. due to HIV/AIDS or treatment for cancer), toxoplasmosis can be dangerous and lead to inflammation in the brain, heart and lungs, which can be fatal.  Congenital toxoplasmosis can cause miscarriage or still birth, blindness, deafness, hydrocephalus (water on the brain) and brain damage.  Some babies may appear fine at birth but develop visual or hearing problems later in life or have learning difficulties.\n About 80% people infected with Toxoplasma fight the infection naturally – they get no ill effects, and the parasite lies dormant in their bodies for life and normally no treatment is required.  However, if they then become immunosuppressed, the parasite can reactivate and cause disease.  Similarly, if an immunosuppressed person encounters Toxoplasma for the first time, they may also get disease symptoms.  Then a patient will be treated with one or more antibiotics for several weeks. It has also been suggested that Toxoplasmosis can alter a person’s behaviour, although this remains controversial.\n To prevent infection, wear gloves and wash your hands after handling soil, changing cat litter trays etc.  Wash fruit and veg before eating, and don’t eat raw or undercooked meat.  There is no vaccine available against Toxoplasma.",},
        {"name": "Leishmania", 
        "description":"Leishmaniasis is caused by protozoan parasites of the Leishmania genus which are transmitted by the bite of a sandfly.  The disease manifests with a wide range of clinical features, and there are several types of presentation. \n Cutaneous Leishmaniasis \n One or more painless skin ulcers, which usually self-heal.  However, this can take months or years and leaves a scar. \n Mucocutaneous Leishmaniasis \n Skin lesions that appear on the face, with destruction of tissues including the mucous membranes of the nose and mouth.  It can be very disfiguring and does not heal spontaneously. \n Visceral Leishmaniasis \n Symptoms include fever, weight loss, enlarged spleen and liver, and anaemia.  It is usually fatal if not treated.  Immunocompromised patients (e.g. those suffering from HIV/AIDS) patients are particularly susceptible. Leishmaniasis is endemic in 98 countries, 80 of which are in the developing world.  Approximately 90% of new cases of visceral leishmaniasis occur in Bangladesh, Brazil, India, Nepal and Sudan.  Mucocutaneous leishmaniasis occurs mainly in Bolivia, Brazil, Peru and Sudan, while 90% of cases of cutaneous leishmaniasis occur in Afghanistan, Brazil, Iran, Peru, Saudi Arabia and Syria.",},
    ]

    for p in parasites:
        add_parasite(p['name'], p['description'])
        
    superusers = [
        {"username":"hannah.bialic", "password":"123", "email":"hannah.bialic@glasgow.ac.uk"},
        {"username":"alex.mackay", "password":"123", "email":"alex.mackay@glasgow.ac.uk"}
        ] 
    for user in superusers:
        add_user(user.get("username"), user.get("password"), True, "Clinician", user.get("email"))
    
    users = [
        {"username":"michael.barrett", "email":"michael.barrett@glasgow.ac.uk", "password":"012", "role":"1"},
        {"username":"andy.waters", "email":"andy.waters@glasgow.ac.uk", "password":"012", "role":"0"},
        ]
    userprofiles = [
        {"role":"Clinician",},
        {"role":"Researcher",},
        ]
    
    for user in users:
        add_user(user.get("username"), user.get("password"), False, user.get("role"), user.get("email"))
    
    aboutUs = [
        {"name":"INTRODUCING THE WELLCOME CENTRE FOR INTEGRATIVE PARASITOLOGY", 
        "description":"There is a long history of parasitology in Glasgow, with some of the most significant discoveries made by scientists trained by, or based at, the University of Glasgow. The involvement of Wellcome in parasitology research in Glasgow is also long standing. \n In 1987, the Wellcome Unit of Molecular Parasitology was established, representing not only the excellence of this research in Glasgow, but also the first UK-based collective that Wellcome had funded.  The Unit transitioned to a Centre in 1999 and has enjoyed successful growth and evolution of activities and goals.  The success of the Centre has been the result of excellent basic biological research on the (largely protozoan) parasites that cause diseases such as malaria and sleeping sickness in tropical regions. \n Our Centre funding was renewed in 2014 for 7 years and we are now part of a wider group of 14 Wellcome Centres. This renewal also saw an expansion of our public engagement activities, greater interactions in low and middle income (LMIC) regions, and involvement in the Wellcome Liverpool Glasgow Centre for Global Health Research (WLGCGHR). All reflecting our leadership role in driving a Scottish (and wider) agenda in Global Health Research. We have focused on discovery research into parasite biology and host/parasite/vector interactions with a broadened portfolio of pathogens and technologies. \n However, as a Centre, we are continuing to develop and broaden. The number of research groups has increased from 9 to 15 and we have new programmes examining immunity to helminths (this includes parasitic worms such as schistosomes). Technologically we have expanded. We have created a national metabolomics facility, enhanced our imaging capabilities, and have expanded our work in drug discovery. \n Recent engagement and collaborations in Malawi has been particularly fruitful, and we are currently establishing a molecular diagnostics facility in partnership with the College of Medicine in Blantyre with significant funding from the Scottish Government. This facility represents the first step in a partnership programme that seeks to establish the Blantyre-Blantyre Research Facility.  Blantyre-Blantyre will examine the interface between infectious disease and existing (and burgeoning) African non-communicable disease profiting from the Glasgow experience.  We aim to develop a model of investigation and therapy development that will ultimately benefit both African and UK populations. \n  These recent developments have significantly shaped our research agenda as we integrate and foster the engagement of additional and wide-ranging expertise into our programmes as part of an aspiring global health agenda.  As we make this realignment, we have renamed the Centre, Wellcome Centre for Integrative Parasitology, and look forward to an expanded research portfolio and new global partnerships and collaborations."},
        ]
        
    for a in aboutUs:
        add_aboutUs(a['name'], a['description'])
        

    #Populate artwork with a specific directory in the media files to find the image
    posts = [
        {"title":"Plasmodium image", "text":"Picture of Plasmodium", "user":"michael.barrett", "parasite":"Plasmodium", "post_type":"1"},
        {"title":"Clinician post", "text":"only visible to clinician", "user":"michael.barrett", "parasite":"Toxoplasma", "post_type":"1"},
        {"title":"Researcher post", "text":"only visible to researchers and clinicians", "user":"andy.waters", "parasite":"Plasmodium", "post_type":"0"},
        {"title":"Public post", "text":"public engagement post", "user":"hannah.bialic", "parasite":"Plasmodium", "post_type":"2"},
        ]
    for post in posts:
        add_post(post.get("text"), post.get("title"), post.get("user"), post.get("parasite"), post.get("post_type"))
    
    files = [
        {"file":"populate_database/plasmodium.jpeg", "file_type":"1", "post":"Researcher post", "number":"1"},
        ]
    for file in files:
        add_file(file.get("file"),file.get("file_type"),file.get("post"),file.get("number"), )

    #Comments associated with a user and artwork
    comments = [
        {"user":"andy.waters", "post_title":"Plasmodium image","text":"Great find!"},
        ]
    for comment in comments:
        add_comment(comment.get("user"), comment.get("post_title"), comment.get("text"))

def add_user(username, password, superuser, role, email, firstName = "", lastName = ""):
    invalidInputs = ["", None]

    if username.strip() in invalidInputs or password.strip() in invalidInputs:
        return None

    user = UserProfile(
        username = username,
        email = email,
        first_name = firstName,
        last_name = lastName,
        role = role,
    )
    user.set_password(password)
    user.is_superuser = superuser
    user.is_staff = superuser
    user.save()

    return user

def add_userprofile(user, role):
    p = UserProfile.objects.get_or_create(user = user, role=role)[0]
    p.save()
    print("Added a new user profile - {}".format(user.username))
    
def add_parasite(name, description):
    c = Parasite.objects.filter(name=name, description=description)
    if c.exists():
        pass
    else:
        c = Parasite.objects.create(name=name, description=description)
        c.save()
        print("Added a new parasite - {}".format(name))
    return c

def add_aboutUs(name, description):
    c = AboutUs.objects.filter(name=name, description=description)
    if c.exists():
        pass
    else:
        c = AboutUs.objects.create(name=name, description=description)
        c.save()
        print("Added a new about us - {}".format(name))
    return c
    
def add_post(text, title, username, parasite, post_type):
    user = UserProfile.objects.filter(username=username)[0]
    par = Parasite.objects.filter(name = parasite)[0]
    a = Post.objects.get_or_create(text = text, title=title, date_posted = timezone.now(), user = user, parasite = par, post_type = post_type)[0]
    a.save()
    print("Added a new post - {}".format(title))

def add_file(file, file_type, post, number):
    post = Post.objects.filter(title = post)[0]
    f = File.objects.get_or_create(file=file, file_type=file_type,number=number, post=post)[0]
    f.save()
    print("Added a new file - {}".format(file))
 
def add_comment(username, post_title, text):
    post = Post.objects.filter(title = post_title)[0]
    user = UserProfile.objects.filter(username=username)[0]
    c = Comment.objects.get_or_create(user = user, post = post, text = text, date = timezone.now())[0]
    c.save()
    print("Added a new comment - {}".format(text))

#Run the population script
if __name__ == '__main__':
   populate()
    
