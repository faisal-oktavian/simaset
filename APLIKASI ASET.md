APLIKASI ASET

1. DATA ASET (TERKAIT TANAH)
    ### ASET TETAP
    # ASET TERKAIT TANAH - KIB A
    - NOMOR BARANG (KODE REKENING PER BARANG) + NAMA KODE REKENING
    - TANGGAL PEMBUKUAN (TGL SERAH TERIMA ANTARA PENYEDIA KE RS)
    - TGL PEROLEHAN (DUPLIKAT DARI TANGGAL PEMBUKUAN)
    - CARA PEROLEHAN
    - HARGA
    - DESKRIPSI ASET
    - LUAS (M2)
    - ALAMAT (CTH. JL. MAWAR)
    - DESA
    - KECAMATAN
    - KAB/KOTA
    - TITIK KOORDINAT
    - STATUS ()
    - NOMOR HAK (NOMOR SERTIFIKAT TANAH)
    - TANGGAL SERTIFIKAT
    - PERUNTUKAN (PENGGUNAAN) -> DIISI MANUAL
    - KONDISI (BAIK/RUSAK RINGAN/RUSAK SEDANG/RUSAK BERAT)
    - KETERANGAN -> ISI MANUAL

    # ASET TERKAIT PERALATAN & MESIN -  KIB B
    - NOMOR BARANG (KODE REKENING PER BARANG) + NAMA KODE REKENING
    - TANGGAL PEMBUKUAN (TGL SERAH TERIMA ANTARA PENYEDIA KE RS)
    - TGL PEROLEHAN (DUPLIKAT DARI TANGGAL PEMBUKUAN)
    - HARGA PEROLEHAN PER ITEM (HARGA DEAL DENGAN VENDOR)
    - NAMA BARANG
    - MERK
    - UKURAN (ISIAN TIDAK WAJIB)
    - BAHAN
    - WARNA
    - SERIAL NUMBER / NO PABRIK
    - NO RANGKA (KHUSUS KENDARAAN)
    - NO MESIN (KHUSUS KENDARAAN)
    - NOPOL (KHUSUS KENDARAAN)
    - NO BPKB (KHUSUS KENDARAAN)
    - KONDISI (BAIK/RUSAK RINGAN/RUSAK SEDANG/RUSAK BERAT)
    - RUANGAN
    
    # ASET TERKAIT GEDUNG DAN BANGUNAN - KIB C
    - NOMOR BARANG (KODE REKENING PER BARANG) + NAMA KODE REKENING
    - TANGGAL PEMBUKUAN (TGL SERAH TERIMA ANTARA PENYEDIA KE RS)
    - TGL PEROLEHAN (DUPLIKAT DARI TANGGAL PEMBUKUAN)
    - HARGA PEROLEHAN
    - DESKRIPSI
    - KONDISI
    - BETON (YA/TIDAK)
    - JUMLAH LANTAI
    - ALAMAT (CTH. JL. MAWAR)
    - DESA
    - KECAMATAN
    - KAB/KOTA
    - LUAS LANTAI
    - NAMA DOKUMEN
    - NO DOKUMEN
    - TANGGAL DOKUMEN
    - KIB A (ASET INI RELASI KE KIB A YANG MANA)
    - LUAS TANAH (TANYA DULU)
    - KETERANGAN

    # ASET TERKAIT JALAN, JARINGAN, & IRIGASI - KIB D
    - NOMOR BARANG (KODE REKENING PER BARANG) + NAMA KODE REKENING
    - TANGGAL PEMBUKUAN (TGL SERAH TERIMA ANTARA PENYEDIA KE RS)
    - TGL PEROLEHAN (DUPLIKAT DARI TANGGAL PEMBUKUAN)
    - HARGA PEROLEHAN
    - DESKRIPSI
    - KONSTRUKSI (PERMANEN, SEMI PERMANEN, DARURAT)
    - PANJANG
    - LEBAR
    - LUAS
    - NO RUAS
    - ALAMAT (CTH. JL. MAWAR)
    - DESA
    - KECAMATAN
    - KAB/KOTA
    - NAMA DOKUMEN
    - NO DOKUMEN
    - TANGGAL DOKUMEN
    - KIB A (ASET INI RELASI KE KIB A YANG MANA)
    - KONDISI
    - KETERANGAN

    # ASET TETAP LAINNYA - KIB E  (CTH. ASET BUKU ATAU KITAB SUCI DI RUANGAN)
    - NOMOR BARANG (KODE REKENING PER BARANG) + NAMA KODE REKENING
    - TANGGAL PEMBUKUAN (TGL SERAH TERIMA ANTARA PENYEDIA KE RS)
    - TGL PEROLEHAN (DUPLIKAT DARI TANGGAL PEMBUKUAN)
    - DESKRIPSI ASET
    - JUDUL
    - SPESIFIKASI
    - ASAL DAERAH
    - PENCIPTA
    - BAHAN
    - JENIS
    - UKURAN
    - JUMLAH
    - TAHUN
    - KONDISI
    - KETERANGAN

    # KONSTRUKSI DALAM PENGERJAAN - KIB F 
        - CTH. DALAM 1 PEMBANGUNAN ADA PERENCANAAN, KONSTRUKSI, PENGAWASAN
        JIKA PERENCANAAN SUDAH DILAKUKAN MAKA MASUK MENU INI (KONSTRUKSI DAN PENGAWASAN TIDAK MASUK DULU)
        - TUNGGU KETIGA ITEM SUDAH LENGKAP MAKA ADA AKSI UNTUK MERGE DAN DATANYA PINDAH KE KIB C
    

    ### ASET TIDAK BERWUJUD
    # KIB ATB
    - NOMOR BARANG (KODE REKENING PER BARANG) + NAMA KODE REKENING
    - TANGGAL PEMBUKUAN (TGL SERAH TERIMA ANTARA PENYEDIA KE RS)
    - TGL PEROLEHAN (DUPLIKAT DARI TANGGAL PEMBUKUAN)
    - DESKRIPSI ASET
    - VENDOR
    - PENGGGUNAAN
    - SPESIFIKASI
    - KETERANGAN

    ### ASET EKSTRAKOM
    - DATA YANG SUDAH TIDAK TERPAKAI DARI KIB B (DIKHUSUSKAN UNTUK KIB B)
    - KOLOM SESUAI DENGAN KIB B

    ### ASET KEMITRAAN
    
    ### ASET PROPERTI DAN INVESTASI
    
    ### ASET LAIN-LAIN
    # KIB ASET LAIN LAIN
    - DATA YANG KONDISINYA RUSAK BERAT (DARI ASET TETAP, ASET TAK BERWUJUD, ASET KEMITRAAN, ASET PROPERTI)
    - JADI DATA YANG RUSAK BERAT TIDAK LANGSUNG DIHAPUS TAPI LANGSUNG 
    
    - NOMOR BARANG (KODE REKENING PER BARANG) + NAMA KODE REKENING
    - KIB L (KIB ASAL) TANYA DULU
    - KODE BARANG (KODE UNTUK KELOMPOK)
    - NAMA KODE BARANG (DESKRIPSI)
    - SPESIFIKASI BARANG
    - TANGGAL PEROLEHAN
    - TANGGAL PEMBUKUAN
    - TANGGAL REKLAS (TANGGAL PINDAH DARI KIB ASAL KE ASET LAIN LAIN [AMBIL TANGGAL BPKAD])
    - JUMLAH (VOLUME)
    - HARGA PEROLEHAN
    - PENYUSUTAN (NILAI PENYUSUTAN SAAT DIPINDAH KE ASET LAIN LAIN, SETELAH ITU TIDAK ADA AKUMULASI PENYUSUTAN LAGI)


    # ADA FITUR CETAK LABEL (ISINYA DETAIL BARANG + FOTO + HISTORY MAINTENAN)
    # JIKA ASET BERUPA TANAH MAKA 
    # DATA ASET NYA TIDAK LANGSUNG OTOMATIS PINDAH, TAPI ALURNYA UNIT TERKAIT NOTIF KALAU ADA KERUSAKAN , LALU UNIT IT/ATEM/IPS TL, JIKA KONDISI BARANGNYA RUSAK BERAT MAKA INPUT DATA (ADA MENU LAGI) BARANG RUSAK, DATA INI AKAN MUNCUL DI USER ASET, ASET KONSUL KE BPKAD APAKAH DI APPROVAL ATAU TIDAK, JIKA DI APPROVAL MAKA ASETNYA MASUK ASET LAIN-LAIN DI KIB ASALNYA TIDAK PERLU DITAMPILKAN (ADA ISIAN TANGGAL BPKAD)

2. KIR
    - KODE BARANG (KODE REKENING)
    - TANGGAL PEMBUKUAN (TGL SERAH TERIMA ANTARA PENYEDIA KE RS)
    - TGL PEROLEHAN (DUPLIKAT DARI TANGGAL PEMBUKUAN)
    - HARGA PEROLEHAN PER ITEM (HARGA DEAL DENGAN VENDOR)
    - NAMA BARANG
    - MERK
    - UKURAN (ISIAN TIDAK WAJIB)
    - BAHAN
    - WARNA
    - SERIAL NUMBER / NO PABRIK
    - NO RANGKA (KHUSUS KENDARAAN)
    - NO MESIN (KHUSUS KENDARAAN)
    - NOPOL (KHUSUS KENDARAAN)
    - NO BPKB (KHUSUS KENDARAAN)
    - TANGGAL BERAKHIR (MASA PAKAI)
    - NILAI BUKU (HARGA PEROLEHAN - AKUMULASI PENYUSUTAN)
    - KONDISI (BAIK/RUSAK RINGAN/RUSAK SEDANG/RUSAK BERAT)

    # ADA FILTER BARANG RUANGAN ATAU TIDAK
    # FITUR CETAK KIR
    
3. PENYUSUTAN
    - KIB B, C, D, F (SEBAGIAN TERGANTUNG KODE KELOMPOK)
    - JIKA BARANG DI KIB - B TANGGAL PEROLEHAN NYA 1 JANUARI 2024 LALU SUDAH BERJALAN 1 TAHUN (1 JANUARI 2025), LALU PER TANGGAL 2 JANUARI 2025 DIPINDAH KE ASET LAIN-LAIN, LALU INGIN EKSPORT DATA DARI 1 JANUARI 2024 SAMPAI 1 JANUARI 2025 MAKA DATA TERSEBUT MASIH ADA
    - PENYUSUTAN UNTUK GEDUNG JIKA MASA PAKAINYA 50 TAHUN LALU SUDAH BERJALAN 5 TAHUN MAKA KETIKA ADA RENOVASI MAKA NILAI PENYUSUTAN PER TAHUN AKAN BERUBAH (DATA YANG SUDAH TERJADI TIDAK TERPENGARUH)


4. MASTER KODE KELOMPOK
    - ADA OPSI MENGGUNAKAN PENYUSUTAN ATAU TIDAK




=====================================================
30/09/2026 - MANAJEMEN ASET

    - aplikasi manajemen aset akan integrasi dengan siperiang ratu
    - ada aset yang tercatat di simas tapi tetap dipakai
    - di fitur manajemen aset ada keterangan pembeda antara data aset yang tercatat di simas atau tidak
    - ada fitur pinjam aset antar unit, dan ada keterangan dipinjam siapa dan status barangnya baik atau rusak
    - minta format untuk cetak kir
    - keterangan barang : baru, lama (barang hibah)
    - kursi ruang tunggu poli rajal akan ditaruh di luar semua dan nanti penanggung jawabnya aset, tidak masuk kir per unit, tapi masuk kir RS
    - ada peta untuk menampilkan (maps) dan ketika di klik maka muncul daftar aset yang ada di unit tersebut
    - di master unit ada opsi layanan dan non layanan
- di pemeliharaan aset ada inputan nominal, digunakan untuk pemeliharaan yang membutuhkan biaya (pemeliharaan menggunakan vendor) atau tidak (pemeliharaan dari IT, Atem, IPS), ada histori pemeliharaan
- fitur barcode, isinya foto barang, identitas umum, ada titik koordinat
- jika pemeliharaan ke vendor ada riwayatnya, surat jalan dari RS (ttd elektronik) disambungkan dengan WA (chat bot)
- ada stok opname per 6 bulan sekali (keliling semua unit untuk pengecekan)
- penyusutan semua kib ada perbedaan
- ketika ada barang rusak dari unit, maka alurnya unit melaporkan ke IT, ATEM, IPS, lalu ke 3 unit melakukan pengecekan jika dinyatakan rusak maka melaporkan ke aset, aset akan memverif (semua alurnya disertai dengan upload foto)
- ketika distribusi ada inputan untuk pengguna
- 

KIB b : barang masuk ke gudang lalu distribusi ke unit

kib c : barang masuk ke gudang lalu distribusi ke unit RS (unit khusus tandon)


mas afriz, cocokin data aset yang terpasang, belum terpasang (baru), rusak
barang yang rusak harus tetap dikumpulkan, dan harus sesuai jumlahnya


Alur Manajemen Aset
Perencanaan/Pengadaan -> Barang Datang -> 
alurnya sampai penghapusan/pelepasan

perencanaan -> penerimaan -> penatausahaan -> distribusi -> pemeliharaan -> penghapusan -> pelaporan 


1. Perencanaan 
    Aset tetap
        KiB A - KIB F

    Aset Extrakom
        kib b, c, d, e

    aset lain-lain (data aset yang rusak)
        data aset tetap, tak berwujud, extrakom 

    aset tak berwujud

    perawatan dan perbaikan barang
    
    pemanfaatan barang
    
    penghapusan barang
        usulan penghapusan
        data penghapusan barang
        ......

2. master
    kode lokasi
    kode barang
        kolom : kode barang, deskripsi, umur ekonomis, nilai residu
    kode barang 108

    Unit: RS untuk tandon aset yang tidak masuk ke ruangan




================================================================================================
USULAN NAMA APLIKASINYA -> SIMASET (Sistem Informasi Manajemen Aset)

SIMASET
│
├── Dashboard
│
├── Peta Aset
│
├── Master Data
│   ├── Barang
│   ├── Kategori Barang
│   ├── KIB
│   ├── Unit
│   ├── Gedung
│   ├── Ruangan
│   ├── Sumber Perolehan
│   ├── Sumber Dana
│   ├── Vendor
│   ├── Kondisi
│   └── Tim Teknis
│
├── Aset
│   ├── Semua Aset
│   ├── KIB A
│   ├── KIB B
│   ├── KIB C
│   ├── KIB D
│   ├── KIB E
│   └── KIB F
│
├── KIR
│   ├── KIR Unit
│   ├── KIR Ruangan
│   ├── KIR RS
│   └── Cetak KIR
│
├── Mutasi
│   ├── Pengajuan
│   ├── Persetujuan
│   ├── Mutasi Masuk
│   ├── Mutasi Keluar
│   └── Histori
│
├── Peminjaman
│   ├── Pengajuan
│   ├── Persetujuan
│   ├── Sedang Dipinjam
│   ├── Pengembalian
│   └── Histori
│
├── Inventarisasi
│   ├── Kegiatan
│   ├── Scan QR
│   ├── Pemeriksaan
│   ├── Rekonsiliasi
│   └── Hasil
│
├── Pemeliharaan
│   ├── Internal
│   ├── Vendor
│   ├── Aset Keluar
│   ├── Aset Kembali
│   └── Histori
│
├── Kerusakan
│   ├── Laporan Unit
│   ├── Pemeriksaan IT
│   ├── Pemeriksaan ATEM
│   ├── Pemeriksaan IPS
│   ├── Kesimpulan
│   └── Histori
│
├── Penghapusan
│   ├── Usulan
│   ├── Verifikasi
│   ├── Persetujuan
│   └── Histori
│
├── Laporan
│   ├── Daftar Aset
│   ├── KIB A-F
│   ├── KIR
│   ├── Mutasi
│   ├── Peminjaman
│   ├── Inventarisasi
│   ├── Pemeliharaan
│   ├── Kerusakan
│   ├── Penghapusan
│   └── Rekonsiliasi
│
└── Administrasi
    ├── User
    ├── Role
    ├── Permission
    ├── Approval
    ├── Tanda Tangan Elektronik
    ├── Audit Trail
    └── Pengaturan
