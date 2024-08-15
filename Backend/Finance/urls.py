# Description: This file contains the URL patterns for the Finance app.
from rest_framework.routers import DefaultRouter
from Finance.views import FinanceViewSet


router = DefaultRouter()
app_name = 'Finance'

router.register(r'transaction', FinanceViewSet, basename='transaction')
router.register(r'transactions/list', FinanceViewSet, basename='transaction_list')
router.register(r'transaction/get', FinanceViewSet, basename='transaction_get')

urlpatterns = [
    
] + router.urls
