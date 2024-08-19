# Description: This file contains user authentication processes.
from Account.models import User
import uuid
import bcrypt


class Auth():
    def valid_login(self, data):
        user = User.objects.mongo_find_one({'phone': data['phone'], 'password': data['password']})
        if user:
            if bcrypt.checkpw(data['password'].encode('utf-8'), user['password'].encode('utf-8')):
                return True
            else:
                return False
        else:
            return False
