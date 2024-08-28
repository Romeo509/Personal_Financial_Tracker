# Description: This file contains the URL patterns for the Account app.

from rest_framework.routers import DefaultRouter
from Account.views import UserViewSet, UserLoginViewSet, UserLogoutViewSet


router = DefaultRouter()
app_name = 'Account'

router.register(r'user', UserViewSet, basename='user')
router.register(r'user/update_balance', UserViewSet, basename='user_update')
router.register(r'user/get', UserViewSet, basename='user_get')
router.register(r'login/user', UserLoginViewSet, basename='user_login')
router.register(r'logout/user', UserLogoutViewSet, basename='user_logout')

urlpatterns = [
    
] + router.urls
