from rest_framework.routers import DefaultRouter
from Account.views import UserViewSet


router = DefaultRouter()
app_name = 'Account'

router.register(r'user', UserViewSet, basename='user')
router.register(r'user/update', UserViewSet, basename='user_update')
router.register(r'user/get', UserViewSet, basename='user_get')

urlpatterns = [
    
] + router.urls
