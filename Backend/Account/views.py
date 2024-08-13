# Let's our different views for our account app
import json
from rest_framework import viewsets
from rest_framework.response import Response
from bson.json_util import loads, dumps
from bson.objectid import ObjectId
from Backend.settings import DATABASES
from Account.models import User
from Account.serializers import UserSerializer, GetUserSerializer
from Account.validators import check_user


        
class UserViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        user_serializer = UserSerializer(data=data)
        if user_serializer.is_valid():
            user = User.objects.mongo_find_one({'phone': data['phone'], 'email': data['email']})
            if not user:
                User.objects.mongo_insert_one(data)
                response = dict({
                    "Message": "User created successfully"
                })
                return Response(response, status=201)
            else:
                response = dict({
                    "Message": "User already exists"
                })
                return Response(response, status=400)
        else:
            response = dict({
                "Message": "Invalid data"
            })
            return Response(response, status=400)
    
    def update(self, request, pk=None):
        phone = json.loads(json.dumps(request.query_params))
        user = User.objects.mongo_find_one({'phone': phone})
        if user:
            data = json.loads(json.dumps(request.data))
            user_serializer = UserSerializer(data=data)
            if user_serializer.is_valid():
                User.objects.mongo_update_one({'phone': phone}, data)
                response = dict({
                    "Message": "User updated successfully"
                })
                return Response(response, status=200)
            else:
                response = dict({
                    "Message": "Invalid data"
                })
                return Response(response, status=400)
        else:
            response = dict({
                "Message": "User does not exist"
            })
            return Response(response, status=400)
    
    def get(self, request, pk=None):
        phone = json.loads(json.dumps(request.query_params))
        user = User.objects.mongo_find_one({'phone': phone})
        if user:
            serializer = GetUserSerializer(user)
            return Response(serializer.data, status=200)
        else:
            response = dict({
                "Message": "User does not exist"
            })
            return Response(response, status=400)
