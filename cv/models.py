from django.db import models

class CV(models.Model):
    nombre = models.CharField(max_length=100)
    correo = models.EmailField()
    telefono = models.CharField(max_length=20, blank=True)
    direccion = models.CharField(max_length=255, blank=True)
    resumen_perfil = models.TextField(blank=True)
    archivo_original = models.FileField(upload_to='cvs/', blank=True)
    creado_en = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.nombre


class ExperienciaLaboral(models.Model):
    cv = models.ForeignKey(CV, on_delete=models.CASCADE, related_name='experiencias')
    empresa = models.CharField(max_length=100)
    cargo = models.CharField(max_length=100)
    descripcion = models.TextField(blank=True)
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField(null=True, blank=True)
    actual = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.cargo} en {self.empresa}"


class Educacion(models.Model):
    cv = models.ForeignKey(CV, on_delete=models.CASCADE, related_name='educacion')
    institucion = models.CharField(max_length=100)
    titulo = models.CharField(max_length=100)
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.titulo} en {self.institucion}"


class Habilidad(models.Model):
    cv = models.ForeignKey(CV, on_delete=models.CASCADE, related_name='habilidades')
    nombre = models.CharField(max_length=50)

    def __str__(self):
        return self.nombre


class Idioma(models.Model):
    cv = models.ForeignKey(CV, on_delete=models.CASCADE, related_name='idiomas')
    nombre = models.CharField(max_length=50)
    nivel = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.nombre} ({self.nivel})"
