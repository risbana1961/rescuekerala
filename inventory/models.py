from django.db import models
from django.contrib.auth.models import User


class Unit(models.Model):
    name = models.CharField(max_length=30)

    def __str__(self):
        return self.name


class Item(models.Model):
    name = models.CharField(max_length=30)
    code = models.CharField(max_length=5)
    unit = models.ForeignKey(Unit, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField()

    def __str__(self):
        return "{}: {}".format(self.code, self.name)


class ItemLog(models.Model):
    item = models.ForeignKey(Item, on_delete=models.CASCADE)
    change_in_quantity = models.IntegerField()
    changer = models.ForeignKey(User, on_delete=models.CASCADE)
    datetime = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return "{} changed @ : {}".format(self.item, self.datetime)
