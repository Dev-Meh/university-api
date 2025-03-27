from django.db import models

class Student(models.Model):
    name = models.CharField(max_length=100)
    program = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class Subject(models.Model):
    name = models.CharField(max_length=100)
    year = models.IntegerField()
    program = models.CharField(max_length=100, default='Software Engineering')

    def __str__(self):
        return f"{self.name} (Year {self.year})"