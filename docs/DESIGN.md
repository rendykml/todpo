# Desain Sistem Aplikasi

## 🧠 Konsep Aplikasi
Aplikasi tidak hanya berfungsi sebagai to-do list, tetapi sebagai sistem manajemen waktu dan kegiatan terjadwal yang terintegrasi dengan metode Pomodoro.

---

## 📊 Entity Relationship Diagram (ERD)

### Entity:
1. User
2. Task
3. PomodoroSession

### Relasi:
- User (1) → (N) Task
- User (1) → (N) PomodoroSession
- Task (1) → (N) PomodoroSession

---

## 📝 Task (Kegiatan Terjadwal)
Task merepresentasikan kegiatan yang dapat berupa:
- Harian (daily)
- Mingguan (weekly)
- Satu kali (once)

Task memiliki:
- Tanggal mulai
- Deadline
- Target cycle
- Progress cycle
- Visibility (private / public)

---

## ⏱️ Pomodoro Logic
- Focus: 25 menit
- Short break: 5 menit
- Long break: setiap 4 cycle
- Cycle dapat ditambah setelah target tercapai

---

## 👤 Profil & Sosial
### Profil Sendiri:
- Data diri
- Status sedang belajar
- Statistik fokus

### Kunjungi Profil Teman:
- Status belajar (ringkas)
- Statistik fokus
- Tidak menampilkan detail jadwal (privasi)

---

## 🔐 Aturan Privasi
- Task default: private
- Task public: hanya judul ringkas
- Tidak ada akses edit data user lain

---

## 🔄 Alur Sistem Singkat
Login → Home → Task → Pomodoro → Session → Statistik → Profil
