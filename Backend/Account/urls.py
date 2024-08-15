# Description: This file contains the URL patterns for the Account app.

from rest_framework.routers import DefaultRouter
from Account.views import UserViewSet, AccountViewSet


router = DefaultRouter()
app_name = 'Account'

router.register(r'user', UserViewSet, basename='user')
router.register(r'user/update', UserViewSet, basename='user_update')
router.register(r'user/get', UserViewSet, basename='user_get')
router.register(r'user/login', UserViewSet, basename='user_login')
router.register(r'account', AccountViewSet, basename='account')
router.register(r'account/update', AccountViewSet, basename='account_update')
router.register(r'account/get', AccountViewSet, basename='account_get')

urlpatterns = [
    
] + router.urls
