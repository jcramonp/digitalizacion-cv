from django.contrib import admin
from .models import CV, ExperienciaLaboral, Educacion, Habilidad, Idioma

class ExperienciaLaboralInline(admin.TabularInline):
    model = ExperienciaLaboral
    extra = 1

class EducacionInline(admin.TabularInline):
    model = Educacion
    extra = 1

class HabilidadInline(admin.TabularInline):
    model = Habilidad
    extra = 1

class IdiomaInline(admin.TabularInline):
    model = Idioma
    extra = 1

@admin.register(CV)
class CVAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'correo', 'telefono', 'creado_en')
    inlines = [ExperienciaLaboralInline, EducacionInline, HabilidadInline, IdiomaInline]
