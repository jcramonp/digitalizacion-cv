from rest_framework import status
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from .serializers import CVSerializer
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from rest_framework.permissions import AllowAny

from django.contrib.auth.models import User

from .models import CV
from .serializers import CVSerializer  

@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def load_cv(request):
    cv = CV.objects.last()

    if cv is None:
        return Response({"error": "CV not found"}, status=404)

    serializer = CVSerializer(cv)  # Serializar un único objeto
    return Response(serializer.data)  # Devolver solo el CV serializado


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def save_cv(request):
    try:
        serializer = CVSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])  # Solo el decorador para indicar que es un POST
@permission_classes([AllowAny])
def login(request):
    print(f"Request data: {request.data}")  # Ver qué datos está recibiendo Django
    
    username = request.data.get('username')
    password = request.data.get('password')
    
    # Verifica si los datos son válidos
    if not username or not password:
        return Response({"error": "Username and password are required"}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(username=username).first()  # Buscar al usuario por nombre
    if user and user.check_password(password):  # Verificar si la contraseña es correcta
        # Si el usuario existe y la contraseña es correcta, generar o recuperar el token
        token, created = Token.objects.get_or_create(user=user)
        return Response({"token": token.key}, status=status.HTTP_200_OK)

    return Response({"error": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([AllowAny])
#@csrf_exempt
def register(request):
    print(f"Request data: {request.data}")  # Ver qué datos está recibiendo Django
    username = request.data.get('username')
    password = request.data.get('password')

    if not username or not password:
        return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)

    User.objects.create_user(username=username, password=password)
    return Response({'message': 'User created successfully'}, status=status.HTTP_201_CREATED)






