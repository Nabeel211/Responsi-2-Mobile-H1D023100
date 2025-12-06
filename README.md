# **Data Diri**

Nama        : Daan Nabil<br>
NIM         : H1D023100<br>
Shift Lama  : I<br>
Shift Baru  : F

---

# **Demo Aplikasi**

https://github.com/Nabeel211/Responsi-2-Mobile-H1D023100/issues/1#issue-3701846054

---
# 📌 Penjelasan Lengkap Kode 

## 🔧 1. Konfigurasi `main.dart`
Kode ini menjalankan inisialisasi Supabase dan memuat file `.env` sebagai konfigurasi environment:

- `WidgetsFlutterBinding.ensureInitialized()` memastikan Flutter siap sebelum async task.
- `dotenv.load()` memuat variabel dari `.env`.
- `Supabase.initialize()` menyambungkan aplikasi ke project Supabase.
- Mengecek apakah user sudah login lewat `currentSession`.

## 🔐 2. Login Screen
Digunakan untuk mengotentikasi pengguna menggunakan email dan password.

- `signInWithPassword()` digunakan untuk login.
- Jika sukses, diarahkan ke `HomeScreen`.
- Jika gagal, tampilkan pesan error melalui `SnackBar`.

## 📝 3. Register Screen
Form untuk membuat akun pengguna baru:

- Menggunakan `signUp()` untuk registrasi.
- Jika registrasi berhasil, diarahkan kembali ke halaman login.
- Validasi email & password sebelum request ke Supabase.

## 🏠 4. HomeScreen
Halaman utama pengguna setelah login berhasil.

- Menampilkan data buku dari backend.
- Mengambil data melalui HTTP GET ke endpoint `${API_BASE}/books`.
- Tombol Logout menjalankan `supabase.auth.signOut()` untuk menghapus session login.
- Navigasi ke halaman Tambah/Edit buku menggunakan `BookFormScreen`.

## 📡 5. Mengambil Data Buku
HomeScreen memanggil `GET /books`:

- Data buku disimpan ke list `books`.
- Bila gagal, tampilkan SnackBar.
- Menggunakan `RefreshIndicator` agar pengguna bisa menarik untuk refresh.

## ❌ 6. Menghapus Buku
Mengirim HTTP DELETE ke endpoint:

- Jika berhasil → tampilkan pesan "Terhapus".
- Jika gagal → tampilkan pesan error.

## 🚪 7. Logout
Fungsi logout:

- Menghapus session Supabase.
- Mengarahkan user ke halaman Login menggunakan `Navigator.pushReplacement`.

## 🔑 8. File `.env`
Berisi konfigurasi Supabase dan API backend:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `API_BASE`
- `STORE_NAME`

Flutter membaca variabel ini melalui `flutter_dotenv`.

## 🌐 9. Akses API
Aplikasi memanggil REST API Node.js/Express melalui `http.get()` dan `http.delete()`.

## 📦 10. Dependency Utama
- `supabase_flutter` → Autentikasi dan akses database.
- `flutter_dotenv` → Membaca variabel lingkungan dari `.env`.
- `http` → Mengakses API backend.
- `intl` → Format angka/tanggal bila diperlukan.

## 📁 11. Behavior Navigasi
Aplikasi menggunakan:

- `pushReplacement` untuk mencegah user kembali ke halaman login setelah login.
- `push` untuk navigasi ke detail/form buku.

## 🔄 12. State Management
Menggunakan `setState()` langsung:

- Untuk loading state.
- Untuk update data buku.
- Untuk refresh UI setelah tambah/edit/hapus buku.

## ✔️ 13. Alur Aplikasi
1. App dijalankan → `.env` dimuat → Supabase siap.
2. Cek session:
   - Jika login → masuk Home.
   - Jika tidak → masuk Login.
3. User login → diarahkan ke Home.
4. Home memuat data dari API.
5. User dapat:
   - Menambah buku
   - Edit buku
   - Hapus buku
   - Logout
6. Logout → kembali ke Login.

