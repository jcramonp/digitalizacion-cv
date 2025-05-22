from django.urls import path
from .views import save_cv
from .views import login
from .views import register
from .views import load_cv
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('save_cv/', save_cv, name='save_cv'),
    path('login/', login, name='login'),
    path('register/', register, name='register'),
    path('load_cv/', load_cv, name='load_cv'),
]