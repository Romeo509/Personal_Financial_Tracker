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
from Account.models import User, Account
from Finance.models import Transaction
from Account.serializers import UserSerializer, GetUserSerializer, UserLoginSerializer, AccountSerializer
from Account.validators import check_user
from Account.auth import Auth



class UserViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        hash_password = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt())
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
        


class AccountViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        created_at = str(datetime.datetime.now())
        data['created_at'] = created_at
        user = User.objects.mongo_find_one({'phone': data['phone']})
        if user:
            Account.objects.mongo_insert_one(data)
            response = dict({
                "Message": "Account created successfully"
            })
            return Response(response, status=201)
        else:
            response = dict({
                "Message": "User does not exist"
            })
            return Response(response, status=400)
    
    def put(self, request, pk=None):
        phone = request.query_params.get('phone')
        account = Account.objects.mongo_find_one({'phone': phone})
        if account:
            amount = json.loads(json.dumps(request.data))
            new_balance = float(account['balance']) + float(amount['amount'])
            Account.objects.mongo_update_one({'phone': phone}, {'$set': {'balance': str(new_balance)}})
            response = dict({
                "Message": "Account updated successfully"
            })
            return Response(response, status=200)
        else:
            response = dict({
                "Message": "Account does not exist"
            })
            return Response(response, status=400)
    
    def get(self, request, pk=None):
        _id = request.query_params.get('_id')
        account = Account.objects.mongo_find_one({'_id': ObjectId(_id)})
        if account:
            serializer = AccountSerializer(account)
            return Response(serializer.data, status=200)
        else:
            response = dict({
                "Message": "Account does not exist"
            })
            return Response(response, status=400)

    # def update(self, request, pk=None):
    #     transaction = Transaction.objects.mongo_find_one({'_id': ObjectId(pk)})
    #     if transaction:
    #         if transaction['remaining_days'] == 0:
    #             new_balance = float(Account['balance']) - float(transaction['amount'])
    #             Account.objects.mongo_update_one({'phone': Account['phone']}, {'$set': {'balance': str(new_balance)}})
    #             return Response({"Message": "Account updated successfully"}, status=200)
    #         else:
    #             response = dict({
    #                 "Message": "Transaction not due"
    #             })
    #             return Response(response, status=400)
    #     else:
    #         response = dict({
    #             "Message": "Transaction does not exist or not available"
    #         })
    #         return Response(response, status=400)
