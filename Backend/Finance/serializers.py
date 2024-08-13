# Description: this file contains data serialization classes for the Finance app.
from rest_framework import serializers
from Finance.models import Transaction


class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = ['transaction', 'amount', 'created_at', 'deadline']