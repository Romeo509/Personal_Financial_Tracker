# Create your views here.
import json
import datetime
from bson.json_util import dumps, loads
from bson.objectid import ObjectId
from rest_framework import viewsets
from rest_framework.response import Response
from Finance.models import Transaction
from Finance.serializers import TransactionSerializer, GetTransactionSerializer


class FinanceViewSet(viewsets.ViewSet):
    def create(self, request):
        data = json.loads(json.dumps(request.data))
        remaining_days = (datetime.datetime.strptime(data['deadline'], '%Y-%m-%d') - datetime.datetime.strptime(data['created_at'], '%Y-%m-%d')).days
        data['remaining_days'] = f"{remaining_days} days"
        status = 'Upcoming'
        data['status'] = status
        transaction_serializer = TransactionSerializer(data=data)
        if transaction_serializer.is_valid():
            transaction = Transaction.objects.mongo_find_one({'transaction': data['transaction'],
                                                              'amount': data['amount'],
                                                              'created_at': data['created_at'],
                                                              'deadline': data['deadline']})
            if not transaction:
                Transaction.objects.mongo_insert_one(data)
                
                response = dict({
                    "Message": "Transaction created successfully"
                })
                return Response(response, status=201)
            else:
                response = dict({
                    "Message": "Transaction already exists"
                })
                return Response(response, status=400)
        else:
            response = dict({
                "Message": "Invalid data"
            })
            return Response(response, status=400)
    
    def update(self, request, pk=None):
        remaining_days = Transaction.objects.mongo_find_one({'remaining_days': remaining_days})
        if remaining_days == 0:
            Transaction.objects.mongo_update_one({'status': 'Completed'})
            return Response({"Message": "Transaction completed successfully"}, status=200)
        for day in remaining_days:
            day = int(day)
            if day == 0:
                remaining_days += 1
                Transaction.objects.mongo_update_one({'remaining_days': remaining_days})
            else:
                remaining_days -= 1
                Transaction.objects.mongo_update_one({'remaining_days': remaining_days})
        return Response({"Message": "Remaining days updated successfully"}, status=200)
    
    def list(self, request):
        transactions = Transaction.objects.mongo_find({})
        serializer = GetTransactionSerializer(transactions, many=True)
        return Response(serializer.data, status=200)
    
    def retrieve(self, request, pk=None):
        _id = request.query_params.get('_id')
        transaction = Transaction.objects.mongo_find_one({'_id': ObjectId(_id)})
        serializer = GetTransactionSerializer(transaction)
        return Response(serializer.data, status=200)

