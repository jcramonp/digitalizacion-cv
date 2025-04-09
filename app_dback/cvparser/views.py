from django.http import JsonResponse
import spacy
import json
from django.views.decorators.csrf import csrf_exempt

# Cargar el modelo de spaCy (asegúrate de haberlo descargado previamente)
nlp = spacy.load("es_core_news_sm")

@csrf_exempt
def parse_cv(request):
    print("Funcion parse invocada")
    
    if request.method == 'POST':
        data = json.loads(request.body)
        texto = data.get('texto', '')

        # Procesar el texto con spaCy
        doc = nlp(texto)

        # Inicializar los campos como vacío
        nombre = ""
        correo = ""
        telefono = ""
        direccion = ""
        experiencia = ""
        educacion = ""
        habilidades = ""

        # Extraer información básica
        for ent in doc.ents:
            if ent.label_ == "PER":  # Buscar entidad "PER" para el nombre
                nombre = ent.text
            elif ent.label_ == "EMAIL":  # Buscar entidad "EMAIL" para el correo
                correo = ent.text
            elif ent.label_ == "PHONE":  # Suponiendo que spaCy puede detectar teléfono
                telefono = ent.text
            elif ent.label_ == "ADDRESS":  # Suponiendo que spaCy puede detectar dirección
                direccion = ent.text
                
            # agregar lógica para extraer experiencias, habilidades, etc. Spacy no esta diseñado para eso
           

        # Crear JSON con la información extraída (ahora con todos los campos, vacíos si no se encontraron)
        response_data = {
            "nombre": nombre,
            "correo": correo,
            "telefono": telefono,
            "direccion": direccion,
            "experiencia": experiencia,
            "educacion": educacion,
            "habilidades": habilidades,
            #"mensaje": "Procesado con spaCy"
        }

        return JsonResponse(response_data)
    
    return JsonResponse({"error": "Solo se permite POST"}, status=400)




