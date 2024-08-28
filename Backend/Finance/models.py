# Create our models here.
from djongo import models


class Transaction(models.Model):
    transaction = models.TextField()
    amount = models.TextField()
    created_at = models.TextField()
    deadline = models.TextField()
    remaining_days = models.TextField(default=None)
    status = models.TextField(default=None)
    objects = models.DjongoManager()

    def __str__(self):
        return self.transaction
