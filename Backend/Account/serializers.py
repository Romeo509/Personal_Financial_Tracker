# Description: This file contains data serialization for Account app.
from rest_framework import serializers
from Account.models import User, Account


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['phone', 'email', 'username', 'password', 'first_name', 'last_name']


class GetUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['phone', 'email', 'username', 'first_name', 'last_name']


class UserLoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['phone', 'password']
    
    def validate(self, data):
        phone = data.get('phone')
        password = data.get('password')
        user = User.objects.mongo_find_one({'phone': phone})
        if not user:
            raise serializers.ValidationError("Invalid phone or password")
        return data

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['phone', 'balance', 'created_at']
