const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const app = express();

app.use(express.json());

// 1. SETUP DATABASE SQLITE UNTUK USER
const db = new sqlite3.Database('./database.sqlite', (err) => {
    if (err) {
        console.error("Gagal menghubungkan ke SQLite:", err.message);
    } else {
        console.log("Berjaya menghubungkan ke database SQLite bagi User Service.");
    }
});

// Create Table untuk simpan data Pengguna (Users)
db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT,
    peranan TEXT, -- Contoh: Mangsa, Sukarelawan, Admin
    no_telefon TEXT
)`);

// 2. ENDPOINT POST: Untuk Pendaftaran User Baharu
app.post('/users', (req, res) => {
    const { nama, peranan, no_telefon } = req.body;
    
    const sql = `INSERT INTO users (nama, peranan, no_telefon) VALUES (?, ?, ?)`;
    db.run(sql, [nama, peranan, no_telefon], function(err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({
            status: "Success",
            message: "Data pengguna berjaya disimpan!",
            user_id: this.lastID
        });
    });
});

// 3. ENDPOINT GET: Untuk Ambil Senarai Pengguna
app.get('/users', (req, res) => {
    db.all(`SELECT * FROM users`, [], (err, rows) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({
            status: "Success",
            data: rows
        });
    });
});

// 4. DYNAMIC PORT UNTUK USER SERVICE (Guna port 3001 untuk lokal)
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`User Service berjalan di port ${PORT}`);
});