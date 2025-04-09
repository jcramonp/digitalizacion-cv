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
        
        print(texto)
        print(data)

        # Inicializar campos
        nombre = ""
        correo = ""
        telefono = ""
        direccion = ""
        experiencia = ""
        educacion = ""
        habilidades = ""

        # spaCy para nombre (opcional, pero limitado)
        doc = nlp(texto)
        for ent in doc.ents:
            if ent.label_ == "PER":
                nombre = ent.text
                break

        # Regex para los demás
        import re
        correo_match = re.search(r'\b[\w\.-]+@[\w\.-]+\.\w+\b', texto)
        telefono_match = re.search(r'\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{4}', texto)
        direccion_match = re.search(r'Calle\s+\w+.*|lugar', texto, flags=re.IGNORECASE)


        correo = correo_match.group() if correo_match else ""
        telefono = telefono_match.group() if telefono_match else ""
        direccion = direccion_match.group() if direccion_match else ""

        def extraer_seccion(texto, seccion):
            patron = re.compile(seccion + r"\n(.*?)(?=\n[A-ZÁÉÍÓÚÑ ]{3,}|\Z)", re.DOTALL | re.IGNORECASE)
            match = patron.search(texto)
            return match.group(1).strip() if match else ""

        experiencia = extraer_seccion(texto, "EXPERIENCIA")
        educacion = extraer_seccion(texto, "EDUCACIÓN")
        habilidades = extraer_seccion(texto, "HABILIDADES")

        # Crear respuesta
        response_data = {
            "nombre": nombre,
            "correo": correo,
            "telefono": telefono,
            "direccion": direccion,
            "experiencia": experiencia,
            "educacion": educacion,
            "habilidades": habilidades,
        }

        return JsonResponse(response_data)
    
    return JsonResponse({"error": "Solo se permite POST"}, status=400)
