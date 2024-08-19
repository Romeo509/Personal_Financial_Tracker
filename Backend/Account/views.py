# Let's our different views for our account app
import json
import datetime
import bcrypt
import uuid
from rest_framework import viewsets
from rest_framework.response import Response
from bson.json_util import loads, dumps
from bson.objectid import ObjectId
from Backend.settings import DATABASES
from Account.models import User
from Finance.models import Transaction
from Account.serializers import UserSerializer, GetUserSerializer, UserLoginSerializer
from Account.validators import check_user
from Account.auth import Auth



class UserViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        hash_password = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt())
        created_at = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        data['created_at'] = created_at
        data['password'] = hash_password.decode('utf-8')
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
        phone = request.query_params.get('phone')
        user = User.objects.mongo_find_one({'phone': phone})
        if user:
            data = json.loads(json.dumps(request.data))
            user_serializer = UserSerializer(data=data)
            if user_serializer.is_valid():
                User.objects.mongo_update_one({'phone': phone}, {'$set': data})
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
        phone = request.query_params.get('phone')
        user = User.objects.mongo_find_one({'phone': phone})
        if user:
            serializer = GetUserSerializer(user)
            return Response(serializer.data, status=200)
        else:
            response = dict({
                "Message": "User does not exist"
            })
            return Response(response, status=400)
    
    def add_balance(self, request, pk=None):
        # update user balance
        phone = request.query_params.get('phone')
        user = User.objects.mongo_find_one({'phone': phone})
        if user:
            amount = json.loads(json.dumps(request.data))
            new_balance = int(user['balance']) + int(amount)
            User.objects.mongo_update_one({'phone': phone}, {'$set': {'balance': new_balance}})
            response = dict({
                "Message": "Balance updated successfully"
            })
            return Response(response, status=200)
        else:
            response = dict({
                "Message": "User does not exist"
            })
            return Response(response, status=400)


class UserLoginViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        user = User.objects.mongo_find_one({'phone': data['phone']})
        if user:
            if bcrypt.checkpw(data['password'].encode('utf-8'), user['password'].encode('utf-8')):
                token = str(uuid.uuid4())
                user['session'] = token
                User.objects.mongo_update_one({'phone': data['phone']}, {'$set': {'session': token}})
                response = dict({
                    "Message": "User logged in successfully",
                    "Token": token
                })
                return Response(response, status=200)
            else:
                response = dict({
                    "Message": "Invalid phone or password"
                })
                return Response(response, status=400)
        else:
            response = dict({
                "Message": "User does not exist"
            })
            return Response(response, status=400)

class UserLogoutViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        user = User.objects.mongo_find_one({'phone': data['phone']})
        if user:
            if user['session'] == data['session']:
                User.objects.mongo_update_one({'phone': data['phone']}, {'$set': {'session': ''}})
                response = dict({
                    "Message": "User logged out successfully"
                })
                return Response(response, status=200)
            else:
                response = dict({
                    "Message": "Invalid session"
                })
                return Response(response, status=400)
        else:
            response = dict({
                "Message": "User does not exist"
            })
            return Response(response, status=400)
