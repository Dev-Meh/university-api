from django.urls import path
from .views import StudentListView, SubjectListView

urlpatterns = [
    path('students/', StudentListView.as_view(), name='student-list'),
    path('subjects/', SubjectListView.as_view(), name='subject-list'),
]