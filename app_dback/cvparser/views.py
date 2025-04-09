import os
import openai
from dotenv import load_dotenv
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

# Cargar clave desde .env
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

@csrf_exempt
def parse_cv(request):
    print("🔍 Función parse_cv invocada")

    if request.method == 'POST':
        data = json.loads(request.body)
        texto = data.get('texto', '')
        print("📄 Texto recibido:", texto)

        try:
            client = openai.OpenAI()

            response = client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {
                        "role": "system",
                        "content": "Sos un extractor de currículums. Devolveme los siguientes campos en formato JSON completo y valido sin explicaciones: nombre, correo, teléfono, dirección, experiencia, educación, habilidades. Responde SOLO con un JSON válido, sin explicaciones. Asegúrate de que el JSON esté correctamente cerrado con } y no esté truncado."
                    },
                    {
                        "role": "user",
                        "content": texto
                    }
                ],
                max_tokens=500,
                temperature=0.3
            )

            resultado = response.choices[0].message.content
            print("✅ Resultado obtenido:", resultado)
            return JsonResponse(json.loads(resultado))

        except Exception as e:
            print("❌ Error general:\n")
            print(e)
            return JsonResponse({"error": "Fallo al procesar el currículum con OpenAI"}, status=500)

    return JsonResponse({"error": "Solo se permite POST"}, status=400)
