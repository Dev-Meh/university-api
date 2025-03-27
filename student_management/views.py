from django.shortcuts import render

from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Student, Subject
from .serializers import StudentSerializer, SubjectSerializer

class StudentListView(APIView):
    def get(self, request):
        # Ensure at least 10 students exist
        if Student.objects.count() < 10:
            # Populate with sample data if needed
            sample_students = [
                {'name': f'Student {i}', 'program': 'Software Engineering'}
                for i in range(1, 11)
            ]
            Student.objects.bulk_create([
                Student(**student) for student in sample_students
            ])
        
        students = Student.objects.all()[:10]
        serializer = StudentSerializer(students, many=True)
        return Response(serializer.data)

class SubjectListView(APIView):
    def get(self, request):
        # Populate subjects if not existing
        if Subject.objects.count() == 0:
            sample_subjects = [
                {'name': 'Introduction to Programming', 'year': 1},
                {'name': 'Discrete Mathematics', 'year': 1},
                {'name': 'Data Structures', 'year': 2},
                {'name': 'Computer Architecture', 'year': 2},
                {'name': 'Software Engineering', 'year': 3},
                {'name': 'Database Systems', 'year': 3},
                {'name': 'Machine Learning', 'year': 4},
                {'name': 'Capstone Project', 'year': 4}
            ]
            Subject.objects.bulk_create([
                Subject(**subject) for subject in sample_subjects
            ])
        
        # Group subjects by year
        subjects_by_year = {}
        for subject in Subject.objects.all():
            if subject.year not in subjects_by_year:
                subjects_by_year[subject.year] = []
            subjects_by_year[subject.year].append(subject.name)
        
        return Response(subjects_by_year)