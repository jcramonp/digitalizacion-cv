from django.db import models
from django.contrib.auth.models import User
from django.db.models import JSONField  

class CV3(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    data = models.JSONField(default=dict) 

class CV(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='cvs')
    nombre = models.CharField(max_length=255)
    correo = models.CharField(max_length=255)
    telefono = models.CharField(max_length=50)
    direccion = models.TextField()
    experiencia = models.TextField()
    educacion = models.TextField()
    habilidades = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"CV de {self.user.username}"




