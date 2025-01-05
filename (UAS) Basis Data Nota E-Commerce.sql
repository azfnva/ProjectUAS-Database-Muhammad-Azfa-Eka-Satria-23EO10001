CREATE TABLE Pembeli (
    ID_Pembeli SERIAL PRIMARY KEY,
    Nama VARCHAR(100),
    Alamat TEXT
);

CREATE TABLE Penjual (
    ID_Penjual SERIAL PRIMARY KEY,
    Nama VARCHAR(100)
);

CREATE TABLE Produk (
    ID_Produk SERIAL PRIMARY KEY,
    Nama_Produk VARCHAR(100),
    Harga_Satuan DECIMAL(10, 2)
);

CREATE TABLE Invoice (
    ID_Invoice SERIAL PRIMARY KEY,
    Nomor_Invoice VARCHAR(50),
    Tanggal_Pembelian DATE,
    Total_Harga DECIMAL(10, 2),
    Sub_Total_Harga DECIMAL(10, 2),
    Total_Ongkos_Kirim DECIMAL(10, 2),
    Diskon_Ongkos_Kirim DECIMAL(10, 2),
    Total_Belanja DECIMAL(10, 2),
    Biaya_Jasa_Aplikasi DECIMAL(10, 2),
    Total_Tagihan DECIMAL(10, 2),
    Metode_Pembayaran VARCHAR(50),
    ID_Pembeli INT REFERENCES Pembeli(ID_Pembeli),
    ID_Penjual INT REFERENCES Penjual(ID_Penjual)
);

CREATE TABLE Invoice_Produk (
    ID_Invoice INT REFERENCES Invoice(ID_Invoice),
    ID_Produk INT REFERENCES Produk(ID_Produk),
    Jumlah INT,
    PRIMARY KEY (ID_Invoice, ID_Produk)
);

CREATE TABLE Users (
    ID_User SERIAL PRIMARY KEY,
    Username VARCHAR(50) UNIQUE,
    Password VARCHAR(255),
    Role VARCHAR(20) CHECK (Role IN ('superuser', 'admin', 'user'))
);

INSERT INTO Users (Username, Password, Role) 
VALUES ('superuser', 'hashed_password', 'superuser');
INSERT INTO Users (Username, Password, Role) 
VALUES ('admin', 'hashed_password', 'admin');
INSERT INTO Users (Username, Password, Role) 
VALUES ('user', 'hashed_password', 'user');

select*from users;

BEGIN;  -- Memulai transaksi

-- Menambahkan data pembeli
INSERT INTO Pembeli (Nama, Alamat) 
VALUES ('Azfa', 'Dede Sumiati, UPTD Puskesmas Kroya II Gentasari, Kecamatan Kroya, Kabupaten Cilacap, Jawa Tengah');

-- Menambahkan data penjual
INSERT INTO Penjual (Nama) 
VALUES ('Infinix Official Store');

-- Menambahkan data produk
INSERT INTO Produk (Nama_Produk, Harga_Satuan) 
VALUES ('Infinix Note 10 Pro 6/64 NFC - Helio G95 - Hitam', 1949000);

-- Menambahkan data invoice
INSERT INTO Invoice (Nomor_Invoice, Tanggal_Pembelian, Total_Harga, Sub_Total_Harga, Total_Ongkos_Kirim, Diskon_Ongkos_Kirim, Total_Belanja, Biaya_Jasa_Aplikasi, Total_Tagihan, Metode_Pembayaran, ID_Pembeli, ID_Penjual)
VALUES ('inv/20220803/2543397198', '2022-08-03', 1949000, 1949000, 17000, 17000, 1949000, 1000, 1950000, 'OVO', (SELECT ID_Pembeli FROM Pembeli WHERE Nama = 'Azfa'), (SELECT ID_Penjual FROM Penjual WHERE Nama = 'Infinix Official Store'));

-- Menambahkan data ke Invoice_Produk
INSERT INTO Invoice_Produk (ID_Invoice, ID_Produk, Jumlah)
VALUES ((SELECT ID_Invoice FROM Invoice WHERE Nomor_Invoice = 'inv/20220803/2543397198'), (SELECT ID_Produk FROM Produk WHERE Nama_Produk = 'Infinix Note 10 Pro 6/64 NFC - Helio G95 - Hitam'), 1);

COMMIT;  -- Menyimpan semua perubahan jika semua operasi berhasil

BEGIN;

-- Contoh operasi kalau gagal
INSERT INTO Pembeli (Nama, Alamat) VALUES ('Azfa', 'Dede Sumiati, UPTD Puskesmas Kroya II Gentasari, Kecamatan Kroya, Kabupaten Cilacap, Jawa Tengah');

-- Jika terjadi kesalahan, kita bisa membatalkan transaksi
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;  -- Membatalkan semua perubahan
        RAISE;      -- Mengangkat kesalahan
END;