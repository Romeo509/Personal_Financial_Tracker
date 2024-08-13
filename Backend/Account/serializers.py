# Description: This file contains data serialization for Account app.
from rest_framework import serializers
from Account.models import User


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
        user = User.objects.mongo_find_one({'phone': phone, 'password': password})
        if not user:
            raise serializers.ValidationError("Invalid phone or password")
        return data
    