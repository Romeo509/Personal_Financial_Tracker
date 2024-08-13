# Create your views here.
import json
import datetime
from bson.json_util import dumps, loads
from rest_framework import viewsets
from rest_framework.response import Response
from Finance.models import Transaction
from Finance.serializers import TransactionSerializer


class FinanceViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        remaining_days = (datetime.datetime.strptime(data['deadline'], '%Y-%m-%d') - datetime.datetime.strptime(data['created_at'], '%Y-%m-%d')).days
        data['remaining_days'] = f"{remaining_days} days"
        transaction_serializer = TransactionSerializer(data=data)
        if transaction_serializer.is_valid():
            Transaction.objects.mongo_insert_one(data)
            response = dict({
                "Message": "Transaction created successfully"
            })
            return Response(response, status=201)
        else:
            response = dict({
                "Message": "Invalid data"
            })
            return Response(response, status=400)

