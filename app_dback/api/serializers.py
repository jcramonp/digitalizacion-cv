from rest_framework import serializers
from .models import CV

class CVSerializer2(serializers.ModelSerializer): # <- Funciona pero guarda listas
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())

    class Meta:
        model = CV
        fields = '__all__'

    def to_internal_value(self, data):
        def process_field(field_data):
            """Convierte los strings a listas de un solo elemento si es necesario"""
            if isinstance(field_data, str):
                return [field_data]
            elif isinstance(field_data, list):
                return field_data
            return []

        # Empaqueta los campos en la estructura 'data'
        processed_data = {
            'data': {
                'nombre': data.get('nombre', ''),
                'correo': data.get('correo', ''),
                'telefono': data.get('telefono', ''),
                'direccion': data.get('direccion', ''),
                'experiencia': process_field(data.get('experiencia')),
                'educacion': process_field(data.get('educacion')),
                'habilidades': process_field(data.get('habilidades')),
            }
        }
        return super().to_internal_value(processed_data)

    def to_representation(self, instance):
        """Transforma los datos guardados al formato que espera Flutter"""
        representation = super().to_representation(instance)
        cv_data = representation.get('data', {})

        return {
            'nombre': cv_data.get('nombre', ''),
            'correo': cv_data.get('correo', ''),
            'telefono': cv_data.get('telefono', ''),
            'direccion': cv_data.get('direccion', ''),
            'experiencia': cv_data.get('experiencia', []),
            'educacion': cv_data.get('educacion', []),
            'habilidades': cv_data.get('habilidades', []),
        }
        
from rest_framework import serializers
from .models import CV

class CVSerializer18(serializers.ModelSerializer): #<- funciono parcialmente
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())

    class Meta:
        model = CV
        fields = '__all__'

    def to_internal_value(self, data):
        # Empaqueta los campos directamente como texto plano
        processed_data = {
            'data': {
                'nombre': data.get('nombre', ''),
                'correo': data.get('correo', ''),
                'telefono': data.get('telefono', ''),
                'direccion': data.get('direccion', ''),
                'experiencia': data.get('experiencia', ''),
                'educacion': data.get('educacion', ''),
                'habilidades': data.get('habilidades', ''),
            }
        }
        return super().to_internal_value(processed_data)

    def to_representation(self, instance):
        """Transforma los datos guardados al formato que espera Flutter"""
        representation = super().to_representation(instance)
        cv_data = representation.get('data', {})

        return {
            'nombre': cv_data.get('nombre', ''),
            'correo': cv_data.get('correo', ''),
            'telefono': cv_data.get('telefono', ''),
            'direccion': cv_data.get('direccion', ''),
            'experiencia': cv_data.get('experiencia', ''),
            'educacion': cv_data.get('educacion', ''),
            'habilidades': cv_data.get('habilidades', ''),
        }

class CVSerializer21(serializers.ModelSerializer):
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())

    class Meta:
        model = CV
        fields = '__all__'
        
from rest_framework import serializers
from .models import CV

class CVSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())

    class Meta:
        model = CV
        fields = '__all__'

    def to_internal_value(self, data):
        # Ahora no necesitas la clave data, simplemente mapeamos los campos directamente.
        processed_data = {
            'nombre': data.get('nombre', ''),
            'correo': data.get('correo', ''),
            'telefono': data.get('telefono', ''),
            'direccion': data.get('direccion', ''),
            'experiencia': data.get('experiencia', ''),
            'educacion': data.get('educacion', ''),
            'habilidades': data.get('habilidades', ''),
        }
        return super().to_internal_value(processed_data)

    def to_representation(self, instance):
        # Ahora devolvemos los campos directamente desde la instancia
        return {
            'nombre': instance.nombre,
            'correo': instance.correo,
            'telefono': instance.telefono,
            'direccion': instance.direccion,
            'experiencia': instance.experiencia,
            'educacion': instance.educacion,
            'habilidades': instance.habilidades,
        }




