# Description: This file contains the URL patterns for the Account app.

from rest_framework.routers import DefaultRouter
from Account.views import UserViewSet, AccountViewSet, UserLoginViewSet, UserLogoutViewSet


router = DefaultRouter()
app_name = 'Account'

router.register(r'user', UserViewSet, basename='user')
router.register(r'user/update', UserViewSet, basename='user_update')
router.register(r'user/get', UserViewSet, basename='user_get')
router.register(r'login/user', UserLoginViewSet, basename='user_login')
router.register(r'logout/user', UserLogoutViewSet, basename='user_logout')
router.register(r'account', AccountViewSet, basename='account')
router.register(r'account/add_balance', AccountViewSet, basename='account_update')
router.register(r'account/get', AccountViewSet, basename='account_get')

urlpatterns = [
    
] + router.urls
