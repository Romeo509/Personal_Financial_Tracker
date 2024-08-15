# Let's create our models with djongo manager
from djongo import models


class User(models.Model):
    phone = models.TextField()
    email = models.TextField()
    username = models.TextField()
    password = models.TextField()
    first_name = models.TextField()
    last_name = models.TextField()
    objects = models.DjongoManager()

    def __str__(self):
        return self.username


class Account(models.Model):
    phone = models.ForeignKey(User, on_delete=models.CASCADE)
    balance = models.TextField()
    created_at = models.TextField()
    objects = models.DjongoManager()

    def __str__(self):
        return self.username
