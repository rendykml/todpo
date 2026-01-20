# Dokumentasi API

Base URL:
http://localhost:8000/api

---

## 🔐 Authentication

### Login
POST /login

Request:
{
  "username": "user123",
  "password": "password123"
}

Response:
{
  "token": "jwt_token",
  "user": {
    "id_user": 1,
    "nama": "Andi"
  }
}

---

## 📝 Task (CRUD)

### Get All Tasks
GET /tasks

### Create Task
POST /tasks

Request:
{
  "judul_task": "Belajar Flutter",
  "deskripsi": "State management",
  "start_date": "2026-01-20",
  "deadline": "2026-01-30",
  "schedule_type": "daily",
  "target_cycle": 4,
  "priority": "high",
  "visibility": "public"
}

### Update Task
PUT /tasks/{id}

### Delete Task
DELETE /tasks/{id}

---

## ⏱️ Pomodoro Session

### Create Session
POST /sessions

Request:
{
  "id_task": 1,
  "cycle_number": 2,
  "type": "focus",
  "durasi": 25,
  "status": "selesai"
}

### Get Sessions
GET /sessions

---

## 📊 Statistik

### Statistik Fokus User
GET /users/{id}/stats

Response:
{
  "daily": 4,
  "weekly": 18,
  "monthly": 65,
  "average": 3.2
}

---

## 🎯 Status Sedang Belajar
GET /users/{id}/current-focus

Response:
{
  "title": "Belajar Flutter",
  "cycle_today": 3,
  "status": "focusing"
}
