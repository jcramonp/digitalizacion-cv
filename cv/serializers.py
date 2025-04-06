from rest_framework import serializers
from .models import CV, ExperienciaLaboral, Educacion, Habilidad, Idioma

class ExperienciaLaboralSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExperienciaLaboral
        fields = '__all__'

class EducacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Educacion
        fields = '__all__'

class HabilidadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Habilidad
        fields = '__all__'

class IdiomaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Idioma
        fields = '__all__'

class CVSerializer(serializers.ModelSerializer):
    experiencias = ExperienciaLaboralSerializer(many=True)
    educacion = EducacionSerializer(many=True)
    habilidades = HabilidadSerializer(many=True)
    idiomas = IdiomaSerializer(many=True)

    class Meta:
        model = CV
        fields = '__all__'

    def create(self, validated_data):
        experiencias_data = validated_data.pop('experiencias')
        educacion_data = validated_data.pop('educacion')
        habilidades_data = validated_data.pop('habilidades')
        idiomas_data = validated_data.pop('idiomas')

        cv = CV.objects.create(**validated_data)

        for exp in experiencias_data:
            ExperienciaLaboral.objects.create(cv=cv, **exp)
        for edu in educacion_data:
            Educacion.objects.create(cv=cv, **edu)
        for hab in habilidades_data:
            Habilidad.objects.create(cv=cv, **hab)
        for idi in idiomas_data:
            Idioma.objects.create(cv=cv, **idi)

        return cv
