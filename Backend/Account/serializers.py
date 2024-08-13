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