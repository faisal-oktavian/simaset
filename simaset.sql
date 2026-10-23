-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table simaset.approval_action
CREATE TABLE IF NOT EXISTS `approval_action` (
  `idapproval_action` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key tindakan approval. Contoh: 1',
  `idapproval_request` bigint unsigned NOT NULL COMMENT 'ID permintaan approval. Contoh: 1',
  `idapproval_step` bigint unsigned NOT NULL COMMENT 'ID tahapan approval yang diproses. Contoh: 1',
  `iduser` bigint unsigned NOT NULL COMMENT 'ID user yang melakukan tindakan approval. Contoh: 10',
  `action` enum('APPROVE','REJECT','RETURN','CANCEL') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tindakan yang dilakukan pada approval. Contoh: APPROVE',
  `action_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan dari pemberi approval. Contoh: Disetujui untuk dilanjutkan',
  `action_date` datetime NOT NULL COMMENT 'Tanggal dan waktu tindakan approval. Contoh: 2026-10-05 10:00:00',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Alamat IP user saat approval. Contoh: 192.168.1.10',
  `user_agent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Browser/perangkat saat approval. Contoh: Chrome Windows',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-05 10:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang membuat histori action. Contoh: kepala_unit',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data diperbarui. Contoh: 2026-10-05 10:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui action. Contoh: kepala_unit',
  `status` int DEFAULT '1' COMMENT 'Status record action. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idapproval_action`) USING BTREE,
  KEY `idapproval_request` (`idapproval_request`) USING BTREE,
  KEY `idapproval_step` (`idapproval_step`) USING BTREE,
  KEY `iduser` (`iduser`) USING BTREE,
  KEY `action` (`action`) USING BTREE,
  KEY `action_date` (`action_date`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_approval_action_request` FOREIGN KEY (`idapproval_request`) REFERENCES `approval_request` (`idapproval_request`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_approval_action_step` FOREIGN KEY (`idapproval_step`) REFERENCES `approval_step` (`idapproval_step`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_approval_action_user` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Histori seluruh tindakan pada proses approval';

-- Dumping data for table simaset.approval_action: ~0 rows (approximately)
INSERT INTO `approval_action` (`idapproval_action`, `idapproval_request`, `idapproval_step`, `iduser`, `action`, `action_note`, `action_date`, `ip_address`, `user_agent`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(4, 5, 3, 2, 'APPROVE', 'Mutasi dapat dilanjutkan.', '2026-10-05 10:00:00', '192.168.1.10', 'Chrome Windows', '2026-10-05 10:00:00', 'kepala_unit', NULL, NULL, 1);

-- Dumping structure for table simaset.approval_request
CREATE TABLE IF NOT EXISTS `approval_request` (
  `idapproval_request` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key permintaan approval. Contoh: 1',
  `approval_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor permintaan approval. Contoh: APR-2026-000001',
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Modul yang membutuhkan approval. Contoh: Mutation',
  `reference_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Jenis transaksi yang membutuhkan approval. Contoh: MUTATION',
  `reference_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID transaksi yang membutuhkan approval. Contoh: 1',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Judul permintaan approval. Contoh: Persetujuan Mutasi Aset',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Penjelasan permintaan approval. Contoh: Persetujuan pemindahan aset ke unit lain',
  `requested_by` bigint unsigned NOT NULL COMMENT 'ID user yang mengajukan approval. Contoh: 25',
  `requested_at` datetime NOT NULL COMMENT 'Tanggal dan waktu pengajuan approval. Contoh: 2026-10-05 09:00:00',
  `current_step` int unsigned NOT NULL DEFAULT '1' COMMENT 'Nomor tahapan approval yang sedang aktif. Contoh: 1',
  `status_approval` enum('PENDING','IN_PROGRESS','APPROVED','REJECTED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'Status keseluruhan approval. Contoh: IN_PROGRESS',
  `completed_at` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu seluruh proses approval selesai. Contoh: 2026-10-05 10:00:00',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan approval secara umum. Contoh: Menunggu persetujuan kepala bagian',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-05 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat approval. Contoh: petugas_aset',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data diperbarui. Contoh: 2026-10-05 10:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui approval. Contoh: kepala_bagian',
  `status` int DEFAULT '1' COMMENT 'Status record approval. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idapproval_request`) USING BTREE,
  UNIQUE KEY `approval_number` (`approval_number`) USING BTREE,
  KEY `module` (`module`) USING BTREE,
  KEY `reference_type` (`reference_type`) USING BTREE,
  KEY `reference_id` (`reference_id`) USING BTREE,
  KEY `requested_by` (`requested_by`) USING BTREE,
  KEY `status_approval` (`status_approval`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_approval_request_user` FOREIGN KEY (`requested_by`) REFERENCES `user` (`iduser`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Header permintaan approval transaksi SIMASET';

-- Dumping data for table simaset.approval_request: ~0 rows (approximately)
INSERT INTO `approval_request` (`idapproval_request`, `approval_number`, `module`, `reference_type`, `reference_id`, `title`, `description`, `requested_by`, `requested_at`, `current_step`, `status_approval`, `completed_at`, `notes`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(5, 'APR-2026-000001', 'Mutation', 'MUTATION', '1', 'Persetujuan Mutasi Aset', 'Persetujuan transaksi mutasi aset MUT-2026-000001.', 2, '2026-10-05 09:00:00', 1, 'IN_PROGRESS', NULL, NULL, '2026-10-05 09:00:00', 'petugas_aset', '2026-10-05 09:00:00', 'petugas_aset', 1);

-- Dumping structure for table simaset.approval_step
CREATE TABLE IF NOT EXISTS `approval_step` (
  `idapproval_step` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key tahapan approval. Contoh: 1',
  `idapproval_request` bigint unsigned NOT NULL COMMENT 'ID permintaan approval. Contoh: 1',
  `step_number` int unsigned NOT NULL COMMENT 'Nomor urutan tahapan approval. Contoh: 1',
  `role_id` bigint unsigned DEFAULT NULL COMMENT 'ID role yang berhak melakukan approval. Contoh: 5',
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'ID user tertentu yang berhak melakukan approval. Contoh: 10',
  `step_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama tahapan approval. Contoh: Persetujuan Kepala Unit',
  `is_required` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Menentukan apakah tahapan wajib dilakukan. Contoh: 1=wajib',
  `status_step` enum('PENDING','IN_PROGRESS','APPROVED','REJECTED','SKIPPED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'Status tahapan approval. Contoh: PENDING',
  `started_at` datetime DEFAULT NULL COMMENT 'Tanggal tahapan mulai aktif. Contoh: 2026-10-05 09:00:00',
  `completed_at` datetime DEFAULT NULL COMMENT 'Tanggal tahapan selesai. Contoh: 2026-10-05 10:00:00',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-05 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat step. Contoh: petugas_aset',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-05 10:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui step. Contoh: kepala_unit',
  `status` int DEFAULT '1' COMMENT 'Status record step. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idapproval_step`) USING BTREE,
  UNIQUE KEY `approval_step_number` (`idapproval_request`,`step_number`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `status_step` (`status_step`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_approval_step_request` FOREIGN KEY (`idapproval_request`) REFERENCES `approval_request` (`idapproval_request`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_approval_step_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`iduser`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tahapan dan pihak yang berwenang dalam proses approval';

-- Dumping data for table simaset.approval_step: ~2 rows (approximately)
INSERT INTO `approval_step` (`idapproval_step`, `idapproval_request`, `step_number`, `role_id`, `user_id`, `step_name`, `is_required`, `status_step`, `started_at`, `completed_at`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(3, 5, 1, 5, NULL, 'Persetujuan Kepala Unit', 1, 'IN_PROGRESS', '2026-10-05 09:00:00', NULL, '2026-10-05 09:00:00', 'petugas_aset', '2026-10-05 09:00:00', 'petugas_aset', 1),
	(4, 5, 2, 7, NULL, 'Persetujuan Pengurus Barang', 1, 'PENDING', NULL, NULL, '2026-10-05 09:00:00', 'petugas_aset', '2026-10-05 09:00:00', 'petugas_aset', 1);

-- Dumping structure for table simaset.asset
CREATE TABLE IF NOT EXISTS `asset` (
  `idasset` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key untuk data aset. Contoh: 1',
  `asset_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode unik internal aset SIMASET. Contoh: AST-2026-000001',
  `asset_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama aset. Contoh: Patient Monitor',
  `idmaster_product` bigint unsigned NOT NULL COMMENT 'ID master produk/barang. Contoh: 10',
  `idmaster_kib` bigint unsigned NOT NULL COMMENT 'ID master KIB aset. Contoh: 2 untuk KIB B',
  `asset_source_type` enum('SIMAS','NON_SIMAS') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SIMAS' COMMENT 'Sumber pencatatan aset. Contoh: SIMAS atau NON_SIMAS',
  `simas_asset_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor aset yang berasal dari sistem SIMAS. Contoh: SIMAS-2026-00125',
  `simas_register_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor register aset dari SIMAS. Contoh: REG-B-000125',
  `acquisition_condition` enum('NEW','OLD') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NEW' COMMENT 'Kondisi aset saat diperoleh. Contoh: NEW atau OLD',
  `idmaster_acquisition_source` bigint unsigned NOT NULL COMMENT 'ID sumber perolehan aset. Contoh: 1 untuk Procurement',
  `idmaster_funding_source` bigint unsigned DEFAULT NULL COMMENT 'ID sumber dana perolehan aset. Contoh: 1 untuk BLUD',
  `acquisition_date` date DEFAULT NULL COMMENT 'Tanggal aset diperoleh. Contoh: 2026-01-15',
  `acquisition_year` year DEFAULT NULL COMMENT 'Tahun perolehan aset. Contoh: 2026',
  `acquisition_value` decimal(18,2) DEFAULT NULL COMMENT 'Nilai perolehan aset. Contoh: 12500000.00',
  `idmaster_vendor` bigint unsigned DEFAULT NULL COMMENT 'ID vendor/pemasok aset. Contoh: 5',
  `purchase_document_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor dokumen pembelian/perolehan aset. Contoh: PO/RS/001/2026',
  `brand` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Merek aset. Contoh: Mindray',
  `model` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Model atau tipe aset. Contoh: PM-60',
  `serial_number` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor seri aset dari produsen. Contoh: PM60-2026-00125',
  `asset_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor identifikasi fisik yang ditempel pada aset. Contoh: INV-B-000125',
  `idmaster_condition` bigint unsigned NOT NULL COMMENT 'ID kondisi terkini aset. Contoh: 1 untuk kondisi baik',
  `idmaster_unit` bigint unsigned NOT NULL COMMENT 'ID unit yang bertanggung jawab terhadap aset. Contoh: 3',
  `idmaster_building` bigint unsigned NOT NULL COMMENT 'ID gedung tempat aset berada. Contoh: 1',
  `idmaster_room` bigint unsigned DEFAULT NULL COMMENT 'ID ruangan tempat aset berada. Contoh: 12',
  `asset_usage_type` enum('SERVICE','NON_SERVICE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SERVICE' COMMENT 'Jenis penggunaan aset. Contoh: SERVICE',
  `asset_status` enum('ACTIVE','BORROWED','MAINTENANCE','DAMAGED','DISPOSAL','DISPOSED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE' COMMENT 'Status operasional aset. Contoh: ACTIVE',
  `responsible_person` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nama penanggung jawab aset. Contoh: Budi Santoso',
  `responsible_user_id` bigint unsigned DEFAULT NULL COMMENT 'ID user yang menjadi penanggung jawab aset. Contoh: 25',
  `latitude` decimal(10,7) DEFAULT NULL COMMENT 'Latitude lokasi aset. Contoh: -7.7234567',
  `longitude` decimal(10,7) DEFAULT NULL COMMENT 'Longitude lokasi aset. Contoh: 112.3456789',
  `location_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Keterangan tambahan lokasi aset. Contoh: Sisi kanan nurse station',
  `description_asset` text COLLATE utf8mb4_unicode_ci COMMENT 'Keterangan tambahan mengenai aset. Contoh: Digunakan untuk monitoring pasien',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data aset dibuat. Contoh: 2026-10-02 10:30:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang membuat data aset. Contoh: superadmin',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data aset terakhir diperbarui. Contoh: 2026-10-02 10:30:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang terakhir memperbarui data aset. Contoh: superadmin',
  `status` int DEFAULT '1' COMMENT 'Status data aset. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset`) USING BTREE,
  UNIQUE KEY `asset_code` (`asset_code`) USING BTREE,
  UNIQUE KEY `serial_number` (`serial_number`) USING BTREE,
  KEY `idmaster_product` (`idmaster_product`) USING BTREE,
  KEY `idmaster_kib` (`idmaster_kib`) USING BTREE,
  KEY `idmaster_acquisition_source` (`idmaster_acquisition_source`) USING BTREE,
  KEY `idmaster_funding_source` (`idmaster_funding_source`) USING BTREE,
  KEY `idmaster_vendor` (`idmaster_vendor`) USING BTREE,
  KEY `idmaster_condition` (`idmaster_condition`) USING BTREE,
  KEY `idmaster_unit` (`idmaster_unit`) USING BTREE,
  KEY `idmaster_building` (`idmaster_building`) USING BTREE,
  KEY `idmaster_room` (`idmaster_room`) USING BTREE,
  KEY `asset_status` (`asset_status`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_asset_acquisition_source` FOREIGN KEY (`idmaster_acquisition_source`) REFERENCES `master_acquisition_source` (`idmaster_acquisition_source`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_building` FOREIGN KEY (`idmaster_building`) REFERENCES `master_building` (`idmaster_building`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_condition` FOREIGN KEY (`idmaster_condition`) REFERENCES `master_condition` (`idmaster_condition`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_funding_source` FOREIGN KEY (`idmaster_funding_source`) REFERENCES `master_funding_source` (`idmaster_funding_source`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_kib` FOREIGN KEY (`idmaster_kib`) REFERENCES `master_kib` (`idmaster_kib`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_product` FOREIGN KEY (`idmaster_product`) REFERENCES `master_product` (`idmaster_product`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_room` FOREIGN KEY (`idmaster_room`) REFERENCES `master_room` (`idmaster_room`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_unit` FOREIGN KEY (`idmaster_unit`) REFERENCES `master_unit` (`idmaster_unit`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_asset_vendor` FOREIGN KEY (`idmaster_vendor`) REFERENCES `master_vendor` (`idmaster_vendor`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master data seluruh aset yang dikelola oleh SIMASET';

-- Dumping data for table simaset.asset: ~3 rows (approximately)
INSERT INTO `asset` (`idasset`, `asset_code`, `asset_name`, `idmaster_product`, `idmaster_kib`, `asset_source_type`, `simas_asset_number`, `simas_register_number`, `acquisition_condition`, `idmaster_acquisition_source`, `idmaster_funding_source`, `acquisition_date`, `acquisition_year`, `acquisition_value`, `idmaster_vendor`, `purchase_document_number`, `brand`, `model`, `serial_number`, `asset_number`, `idmaster_condition`, `idmaster_unit`, `idmaster_building`, `idmaster_room`, `asset_usage_type`, `asset_status`, `responsible_person`, `responsible_user_id`, `latitude`, `longitude`, `location_note`, `description_asset`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'AST-2026-000001', 'Patient Monitor Mindray PM-60', 1, 2, 'SIMAS', 'SIMAS-2026-00125', 'REG-B-000125', 'NEW', 1, 1, '2026-01-15', '2026', 12500000.00, 1, 'PO/RS/001/2026', 'Mindray', 'PM-60', 'PM60-2026-00125', 'INV-B-000125', 1, 3, 1, 1, 'SERVICE', 'ACTIVE', 'Budi Santoso', 25, -7.7234567, 112.3456789, 'Sisi kanan nurse station', 'Patient monitor untuk monitoring kondisi pasien.', '2026-10-02 10:30:00', 'superadmin', '2026-10-02 10:30:00', 'superadmin', 1),
	(2, 'AST-2026-000002', 'Komputer Desktop Lenovo ThinkCentre', 2, 2, 'NON_SIMAS', NULL, NULL, 'OLD', 2, 2, '2026-02-10', '2026', 4500000.00, 2, 'BAST/RS/002/2026', 'Lenovo', 'ThinkCentre', 'LEN-THK-2020-0098', 'INV-B-000126', 1, 5, 1, 4, 'NON_SERVICE', 'ACTIVE', 'Siti Rahma', 26, -7.7234123, 112.3456123, 'Meja administrasi', 'Komputer lama yang diperoleh melalui hibah.', '2026-10-02 10:35:00', 'superadmin', '2026-10-02 10:35:00', 'superadmin', 1),
	(3, 'AST-2026-000003', 'AC Split Daikin 2 PK', 3, 2, 'SIMAS', 'SIMAS-2026-00126', 'REG-B-000126', 'NEW', 1, 1, '2026-03-05', '2026', 8500000.00, 3, 'PO/RS/003/2026', 'Daikin', 'FTKC50TVM4', 'DKN-2026-00256', 'INV-B-000127', 1, 3, 1, 1, 'SERVICE', 'ACTIVE', 'Agus Pratama', 27, -7.7234011, 112.3456001, 'Dinding depan ruangan', 'AC untuk mendukung kenyamanan pelayanan pasien.', '2026-10-02 10:40:00', 'superadmin', '2026-10-02 10:40:00', 'superadmin', 1);

-- Dumping structure for table simaset.asset_borrowing
CREATE TABLE IF NOT EXISTS `asset_borrowing` (
  `idasset_borrowing` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key transaksi peminjaman. Contoh: 1',
  `borrowing_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor transaksi peminjaman. Contoh: PINJAM-2026-000001',
  `borrowing_date` date NOT NULL COMMENT 'Tanggal pengajuan peminjaman. Contoh: 2026-10-06',
  `borrower_unit_id` bigint unsigned NOT NULL COMMENT 'Unit yang meminjam aset. Contoh: 5',
  `borrower_person` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama orang yang bertanggung jawab atas pinjaman. Contoh: Siti Rahma',
  `purpose` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tujuan peminjaman. Contoh: Digunakan untuk kegiatan pelayanan',
  `planned_return_date` date DEFAULT NULL COMMENT 'Rencana tanggal pengembalian. Contoh: 2026-10-20',
  `actual_return_date` date DEFAULT NULL COMMENT 'Tanggal aktual pengembalian. Contoh: 2026-10-18',
  `status_borrowing` enum('DRAFT','SUBMITTED','APPROVED','REJECTED','BORROWED','RETURN_REQUESTED','RETURNED','VERIFIED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT 'Status peminjaman. Contoh: BORROWED',
  `approved_at` datetime DEFAULT NULL COMMENT 'Tanggal persetujuan peminjaman. Contoh: 2026-10-06 10:00:00',
  `returned_at` datetime DEFAULT NULL COMMENT 'Tanggal aset dikembalikan. Contoh: 2026-10-18 14:00:00',
  `verified_at` datetime DEFAULT NULL COMMENT 'Tanggal verifikasi pengembalian. Contoh: 2026-10-18 15:00:00',
  `approved_by` bigint unsigned DEFAULT NULL COMMENT 'ID user pemberi persetujuan. Contoh: 10',
  `verified_by` bigint unsigned DEFAULT NULL COMMENT 'ID user pemeriksa pengembalian. Contoh: 15',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan peminjaman. Contoh: Digunakan sementara selama kegiatan',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-06 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat transaksi. Contoh: unit_rawat_jalan',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-18 15:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui transaksi. Contoh: petugas_aset',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_borrowing`),
  UNIQUE KEY `borrowing_number` (`borrowing_number`),
  KEY `borrower_unit_id` (`borrower_unit_id`),
  KEY `status_borrowing` (`status_borrowing`),
  KEY `status` (`status`),
  CONSTRAINT `fk_borrowing_unit` FOREIGN KEY (`borrower_unit_id`) REFERENCES `master_unit` (`idmaster_unit`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Header transaksi peminjaman aset antar unit';

-- Dumping data for table simaset.asset_borrowing: ~0 rows (approximately)
INSERT INTO `asset_borrowing` (`idasset_borrowing`, `borrowing_number`, `borrowing_date`, `borrower_unit_id`, `borrower_person`, `purpose`, `planned_return_date`, `actual_return_date`, `status_borrowing`, `approved_at`, `returned_at`, `verified_at`, `approved_by`, `verified_by`, `notes`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'PINJAM-2026-000001', '2026-10-06', 5, 'Dewi Lestari', 'Digunakan untuk kegiatan pelayanan', '2026-10-20', NULL, 'APPROVED', '2026-10-06 10:00:00', NULL, NULL, 10, NULL, NULL, '2026-10-06 09:00:00', 'unit_rekmed', '2026-10-06 10:00:00', 'superadmin', 1);

-- Dumping structure for table simaset.asset_borrowing_detail
CREATE TABLE IF NOT EXISTS `asset_borrowing_detail` (
  `idasset_borrowing_detail` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key detail peminjaman. Contoh: 1',
  `idasset_borrowing` bigint unsigned NOT NULL COMMENT 'ID transaksi peminjaman. Contoh: 1',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang dipinjam. Contoh: 2',
  `condition_before` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset saat diserahkan. Contoh: GOOD',
  `condition_after` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset saat dikembalikan. Contoh: GOOD',
  `completeness_before` text COLLATE utf8mb4_unicode_ci COMMENT 'Kelengkapan aset saat diserahkan. Contoh: Unit, adaptor, kabel',
  `completeness_after` text COLLATE utf8mb4_unicode_ci COMMENT 'Kelengkapan aset saat dikembalikan. Contoh: Unit, adaptor, kabel',
  `return_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan pemeriksaan pengembalian. Contoh: Kondisi dan kelengkapan sesuai',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-06 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat detail. Contoh: petugas_aset',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-18 15:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui detail. Contoh: petugas_aset',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_borrowing_detail`),
  UNIQUE KEY `borrowing_asset` (`idasset_borrowing`,`idasset`),
  KEY `idasset` (`idasset`),
  KEY `status` (`status`),
  CONSTRAINT `fk_borrowing_detail_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_borrowing_detail_header` FOREIGN KEY (`idasset_borrowing`) REFERENCES `asset_borrowing` (`idasset_borrowing`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detail aset dalam transaksi peminjaman';

-- Dumping data for table simaset.asset_borrowing_detail: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_damage
CREATE TABLE IF NOT EXISTS `asset_damage` (
  `idasset_damage` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key laporan kerusakan. Contoh: 1',
  `damage_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor laporan kerusakan. Contoh: DMG-2026-000001',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang mengalami kerusakan. Contoh: 1',
  `reported_by_unit_id` bigint unsigned NOT NULL COMMENT 'Unit yang melaporkan kerusakan. Contoh: 3',
  `report_date` datetime NOT NULL COMMENT 'Tanggal dan waktu laporan dibuat. Contoh: 2026-10-08 08:30:00',
  `damage_description` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Deskripsi kerusakan yang dilaporkan. Contoh: Monitor tidak dapat menyala',
  `initial_condition` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi awal aset saat laporan. Contoh: MAJOR_DAMAGE',
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEDIUM' COMMENT 'Prioritas penanganan kerusakan. Contoh: HIGH',
  `status_damage` enum('REPORTED','WAITING_INSPECTION','IN_INSPECTION','WAITING_CONCLUSION','APPROVED_REPAIR','IN_REPAIR','WAITING_VERIFICATION','COMPLETED','PROPOSED_DISPOSAL','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'REPORTED' COMMENT 'Status laporan kerusakan. Contoh: WAITING_INSPECTION',
  `conclusion` text COLLATE utf8mb4_unicode_ci COMMENT 'Kesimpulan pemeriksaan kerusakan. Contoh: Perlu penggantian power supply',
  `recommended_action` enum('REPAIR','MONITORING','DISPOSAL','NO_ACTION') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Rekomendasi penanganan. Contoh: REPAIR',
  `conclusion_date` datetime DEFAULT NULL COMMENT 'Tanggal kesimpulan dibuat. Contoh: 2026-10-08 14:00:00',
  `concluded_by` bigint unsigned DEFAULT NULL COMMENT 'ID user yang membuat kesimpulan. Contoh: 30',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan laporan kerusakan. Contoh: Menunggu spare part',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-08 08:30:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat laporan. Contoh: unit_melati',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-08 14:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui. Contoh: petugas_atem',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_damage`),
  UNIQUE KEY `damage_number` (`damage_number`),
  KEY `idasset` (`idasset`),
  KEY `reported_by_unit_id` (`reported_by_unit_id`),
  KEY `status_damage` (`status_damage`),
  KEY `status` (`status`),
  CONSTRAINT `fk_damage_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_damage_unit` FOREIGN KEY (`reported_by_unit_id`) REFERENCES `master_unit` (`idmaster_unit`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Laporan dan proses penanganan kerusakan aset';

-- Dumping data for table simaset.asset_damage: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_damage_inspection
CREATE TABLE IF NOT EXISTS `asset_damage_inspection` (
  `idasset_damage_inspection` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key pemeriksaan kerusakan. Contoh: 1',
  `idasset_damage` bigint unsigned NOT NULL COMMENT 'ID laporan kerusakan. Contoh: 1',
  `technical_team_id` bigint unsigned NOT NULL COMMENT 'Tim teknis pemeriksa. Contoh: 2',
  `inspection_date` datetime NOT NULL COMMENT 'Tanggal dan waktu pemeriksaan. Contoh: 2026-10-08 10:00:00',
  `inspection_result` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Hasil pemeriksaan teknis. Contoh: Power supply mengalami kerusakan',
  `condition_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset hasil pemeriksaan. Contoh: MAJOR_DAMAGE',
  `recommendation` text COLLATE utf8mb4_unicode_ci COMMENT 'Rekomendasi teknis. Contoh: Ganti power supply',
  `inspection_status` enum('ASSIGNED','IN_PROGRESS','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ASSIGNED' COMMENT 'Status pemeriksaan. Contoh: COMPLETED',
  `inspected_by` bigint unsigned DEFAULT NULL COMMENT 'ID petugas pemeriksa. Contoh: 30',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-08 10:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat pemeriksaan. Contoh: petugas_atem',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-08 12:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui. Contoh: petugas_atem',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_damage_inspection`),
  KEY `idasset_damage` (`idasset_damage`),
  KEY `technical_team_id` (`technical_team_id`),
  KEY `status` (`status`),
  CONSTRAINT `fk_damage_inspection_damage` FOREIGN KEY (`idasset_damage`) REFERENCES `asset_damage` (`idasset_damage`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_damage_inspection_team` FOREIGN KEY (`technical_team_id`) REFERENCES `master_technical_team` (`idmaster_technical_team`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pemeriksaan teknis terhadap laporan kerusakan aset';

-- Dumping data for table simaset.asset_damage_inspection: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_damage_photo
CREATE TABLE IF NOT EXISTS `asset_damage_photo` (
  `idasset_damage_photo` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key foto kerusakan. Contoh: 1',
  `idasset_damage` bigint unsigned NOT NULL COMMENT 'ID laporan kerusakan. Contoh: 1',
  `photo_type` enum('BEFORE','AFTER') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Jenis foto kerusakan. Contoh: BEFORE',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama file foto setelah kompresi. Contoh: DMG-2026-000001-BEFORE.jpg',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lokasi file foto pada server. Contoh: uploads/damage/2026/10/DMG-2026-000001-BEFORE.jpg',
  `file_extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ekstensi foto. Contoh: jpg',
  `file_size` bigint unsigned DEFAULT NULL COMMENT 'Ukuran foto setelah kompresi dalam byte. Contoh: 250000',
  `photo_width` int unsigned DEFAULT NULL COMMENT 'Lebar foto. Contoh: 1200',
  `photo_height` int unsigned DEFAULT NULL COMMENT 'Tinggi foto. Contoh: 900',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-08 08:30:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username uploader. Contoh: unit_melati',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-08 14:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui foto. Contoh: petugas_atem',
  `status` int DEFAULT '1' COMMENT 'Status foto. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_damage_photo`),
  UNIQUE KEY `damage_photo_type` (`idasset_damage`,`photo_type`),
  KEY `status` (`status`),
  CONSTRAINT `fk_damage_photo` FOREIGN KEY (`idasset_damage`) REFERENCES `asset_damage` (`idasset_damage`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Foto sebelum dan sesudah penanganan kerusakan aset';

-- Dumping data for table simaset.asset_damage_photo: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_disposal
CREATE TABLE IF NOT EXISTS `asset_disposal` (
  `idasset_disposal` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key transaksi penghapusan aset. Contoh: 1',
  `disposal_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor usulan penghapusan. Contoh: HAPUS-2026-000001',
  `proposal_date` date NOT NULL COMMENT 'Tanggal usulan penghapusan. Contoh: 2026-10-15',
  `proposal_reason` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Alasan penghapusan aset. Contoh: Rusak berat dan tidak ekonomis diperbaiki',
  `disposal_method` enum('DESTROYED','SOLD','TRANSFERRED','OTHER') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Metode pelaksanaan penghapusan. Contoh: DESTROYED',
  `disposal_date` date DEFAULT NULL COMMENT 'Tanggal pelaksanaan penghapusan. Contoh: 2026-11-01',
  `document_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor dokumen penghapusan. Contoh: BA-HAPUS-001/2026',
  `verification_result` text COLLATE utf8mb4_unicode_ci COMMENT 'Hasil verifikasi penghapusan. Contoh: Layak diusulkan untuk penghapusan',
  `approval_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan persetujuan penghapusan. Contoh: Disetujui untuk dihapus',
  `status_disposal` enum('DRAFT','SUBMITTED','VERIFIED','REJECTED','APPROVED','PROCESSING','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT 'Status proses penghapusan. Contoh: VERIFIED',
  `verified_at` datetime DEFAULT NULL COMMENT 'Tanggal verifikasi. Contoh: 2026-10-16 10:00:00',
  `approved_at` datetime DEFAULT NULL COMMENT 'Tanggal persetujuan. Contoh: 2026-10-20 10:00:00',
  `completed_at` datetime DEFAULT NULL COMMENT 'Tanggal penghapusan selesai. Contoh: 2026-11-01 14:00:00',
  `verified_by` bigint unsigned DEFAULT NULL COMMENT 'ID user verifikator. Contoh: 10',
  `approved_by` bigint unsigned DEFAULT NULL COMMENT 'ID user pemberi persetujuan. Contoh: 5',
  `completed_by` bigint unsigned DEFAULT NULL COMMENT 'ID user pelaksana penghapusan. Contoh: 15',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan penghapusan. Contoh: Telah dibuat berita acara',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-15 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat usulan. Contoh: petugas_aset',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-11-01 14:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui. Contoh: petugas_aset',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_disposal`),
  UNIQUE KEY `disposal_number` (`disposal_number`),
  KEY `status_disposal` (`status_disposal`),
  KEY `disposal_date` (`disposal_date`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Header transaksi usulan dan pelaksanaan penghapusan aset';

-- Dumping data for table simaset.asset_disposal: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_disposal_detail
CREATE TABLE IF NOT EXISTS `asset_disposal_detail` (
  `idasset_disposal_detail` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key detail penghapusan. Contoh: 1',
  `idasset_disposal` bigint unsigned NOT NULL COMMENT 'ID transaksi penghapusan. Contoh: 1',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang diusulkan untuk dihapus. Contoh: 1',
  `asset_condition` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset saat diusulkan. Contoh: MAJOR_DAMAGE',
  `asset_value` decimal(18,2) DEFAULT NULL COMMENT 'Nilai aset saat penghapusan. Contoh: 5000000.00',
  `disposal_reason` text COLLATE utf8mb4_unicode_ci COMMENT 'Alasan penghapusan untuk aset tersebut. Contoh: Rusak berat',
  `verification_status` enum('PENDING','ELIGIBLE','NOT_ELIGIBLE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'Hasil verifikasi aset. Contoh: ELIGIBLE',
  `verification_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan verifikasi. Contoh: Tidak ekonomis untuk diperbaiki',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-15 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat detail. Contoh: petugas_aset',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-20 10:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui. Contoh: verifikator',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_disposal_detail`),
  UNIQUE KEY `disposal_asset` (`idasset_disposal`,`idasset`),
  KEY `idasset` (`idasset`),
  KEY `verification_status` (`verification_status`),
  KEY `status` (`status`),
  CONSTRAINT `fk_disposal_detail_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_disposal_detail_header` FOREIGN KEY (`idasset_disposal`) REFERENCES `asset_disposal` (`idasset_disposal`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detail aset dalam usulan penghapusan';

-- Dumping data for table simaset.asset_disposal_detail: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_inventory
CREATE TABLE IF NOT EXISTS `asset_inventory` (
  `idasset_inventory` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key kegiatan inventarisasi. Contoh: 1',
  `inventory_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor kegiatan inventarisasi. Contoh: INV-2026-000001',
  `inventory_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama kegiatan inventarisasi. Contoh: Inventarisasi Aset Oktober 2026',
  `inventory_date` date NOT NULL COMMENT 'Tanggal kegiatan inventarisasi. Contoh: 2026-10-10',
  `idmaster_unit` bigint unsigned DEFAULT NULL COMMENT 'Unit yang menjadi objek inventarisasi. Contoh: 3',
  `idmaster_building` bigint unsigned DEFAULT NULL COMMENT 'Gedung yang menjadi objek inventarisasi. Contoh: 1',
  `idmaster_room` bigint unsigned DEFAULT NULL COMMENT 'Ruangan yang menjadi objek inventarisasi. Contoh: 1',
  `inventory_method` enum('QR_SCAN','MANUAL','QR_AND_MANUAL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'QR_SCAN' COMMENT 'Metode inventarisasi. Contoh: QR_SCAN',
  `status_inventory` enum('DRAFT','OPEN','IN_PROGRESS','RECONCILIATION','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT 'Status kegiatan inventarisasi. Contoh: IN_PROGRESS',
  `started_at` datetime DEFAULT NULL COMMENT 'Tanggal mulai kegiatan. Contoh: 2026-10-10 08:00:00',
  `completed_at` datetime DEFAULT NULL COMMENT 'Tanggal selesai kegiatan. Contoh: 2026-10-10 15:00:00',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan kegiatan inventarisasi. Contoh: Inventarisasi seluruh ruangan Melati',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-10 08:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat kegiatan. Contoh: petugas_inventaris',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-10 15:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui. Contoh: petugas_inventaris',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_inventory`),
  UNIQUE KEY `inventory_number` (`inventory_number`),
  KEY `idmaster_unit` (`idmaster_unit`),
  KEY `idmaster_building` (`idmaster_building`),
  KEY `idmaster_room` (`idmaster_room`),
  KEY `status_inventory` (`status_inventory`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Kegiatan inventarisasi aset';

-- Dumping data for table simaset.asset_inventory: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_inventory_detail
CREATE TABLE IF NOT EXISTS `asset_inventory_detail` (
  `idasset_inventory_detail` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key detail inventarisasi. Contoh: 1',
  `idasset_inventory` bigint unsigned NOT NULL COMMENT 'ID kegiatan inventarisasi. Contoh: 1',
  `idasset` bigint unsigned DEFAULT NULL COMMENT 'ID aset yang ditemukan atau diperiksa. Contoh: 1',
  `scanned_qr_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kode QR yang dipindai. Contoh: QR-AST-2026-000001',
  `scan_date` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu QR dipindai. Contoh: 2026-10-10 09:00:00',
  `verification_status` enum('MATCH','LOCATION_MISMATCH','NOT_FOUND','NEW_FINDING','CONDITION_MISMATCH','DUPLICATE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MATCH' COMMENT 'Hasil pencocokan inventarisasi. Contoh: MATCH',
  `condition_before` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset berdasarkan data sebelum pemeriksaan. Contoh: GOOD',
  `condition_after` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset setelah pemeriksaan. Contoh: MINOR_DAMAGE',
  `location_before` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lokasi aset menurut sistem sebelum pemeriksaan. Contoh: Gedung Utama / Ruang Melati',
  `location_after` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lokasi fisik aset saat pemeriksaan. Contoh: Gedung Utama / Ruang Anggrek',
  `verification_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan pemeriksaan. Contoh: Aset ditemukan di ruangan berbeda',
  `verified_by` bigint unsigned DEFAULT NULL COMMENT 'ID petugas pemeriksa. Contoh: 15',
  `verified_at` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu verifikasi. Contoh: 2026-10-10 09:15:00',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-10 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat detail. Contoh: petugas_inventaris',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-10 09:15:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui. Contoh: petugas_inventaris',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_inventory_detail`),
  KEY `idasset_inventory` (`idasset_inventory`),
  KEY `idasset` (`idasset`),
  KEY `verification_status` (`verification_status`),
  KEY `status` (`status`),
  CONSTRAINT `fk_inventory_detail_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_inventory_detail_header` FOREIGN KEY (`idasset_inventory`) REFERENCES `asset_inventory` (`idasset_inventory`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detail hasil pemeriksaan inventarisasi aset';

-- Dumping data for table simaset.asset_inventory_detail: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_inventory_photo
CREATE TABLE IF NOT EXISTS `asset_inventory_photo` (
  `idasset_inventory_photo` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key foto inventarisasi. Contoh: 1',
  `idasset_inventory_detail` bigint unsigned NOT NULL COMMENT 'ID detail pemeriksaan inventarisasi. Contoh: 1',
  `photo_type` enum('BEFORE','AFTER') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Jenis foto inventarisasi. Contoh: BEFORE',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama file setelah kompresi. Contoh: INV-2026-000001-BEFORE.jpg',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lokasi file pada server. Contoh: uploads/inventory/2026/10/INV-2026-000001-BEFORE.jpg',
  `file_extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ekstensi file. Contoh: jpg',
  `file_size` bigint unsigned DEFAULT NULL COMMENT 'Ukuran file setelah kompresi dalam byte. Contoh: 250000',
  `photo_width` int unsigned DEFAULT NULL COMMENT 'Lebar foto. Contoh: 1200',
  `photo_height` int unsigned DEFAULT NULL COMMENT 'Tinggi foto. Contoh: 900',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-10 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username uploader. Contoh: petugas_inventaris',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-10 09:15:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui foto. Contoh: petugas_inventaris',
  `status` int DEFAULT '1' COMMENT 'Status foto. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_inventory_photo`),
  UNIQUE KEY `inventory_photo_type` (`idasset_inventory_detail`,`photo_type`),
  KEY `status` (`status`),
  CONSTRAINT `fk_inventory_photo_detail` FOREIGN KEY (`idasset_inventory_detail`) REFERENCES `asset_inventory_detail` (`idasset_inventory_detail`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Foto sebelum dan sesudah pemeriksaan inventarisasi';

-- Dumping data for table simaset.asset_inventory_photo: ~0 rows (approximately)

-- Dumping structure for table simaset.asset_maintenance
CREATE TABLE IF NOT EXISTS `asset_maintenance` (
  `idasset_maintenance` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key kegiatan pemeliharaan. Contoh: 1',
  `maintenance_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor kegiatan pemeliharaan. Contoh: MNT-2026-000001',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang dipelihara. Contoh: 1',
  `maintenance_type` enum('PREVENTIVE','CORRECTIVE') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Jenis pemeliharaan. Contoh: CORRECTIVE',
  `maintenance_method` enum('INTERNAL','VENDOR') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Metode pelaksanaan pemeliharaan. Contoh: INTERNAL',
  `maintenance_date` date NOT NULL COMMENT 'Tanggal mulai pemeliharaan. Contoh: 2026-10-07',
  `technical_team_id` bigint unsigned DEFAULT NULL COMMENT 'ID tim teknis pelaksana. Contoh: 1',
  `vendor_id` bigint unsigned DEFAULT NULL COMMENT 'ID vendor apabila dikerjakan vendor. Contoh: 5',
  `problem_description` text COLLATE utf8mb4_unicode_ci COMMENT 'Deskripsi masalah atau kebutuhan pemeliharaan. Contoh: AC tidak dingin',
  `action_taken` text COLLATE utf8mb4_unicode_ci COMMENT 'Tindakan yang dilakukan. Contoh: Pembersihan filter dan pengecekan refrigerant',
  `maintenance_result` text COLLATE utf8mb4_unicode_ci COMMENT 'Hasil pemeliharaan. Contoh: AC kembali berfungsi normal',
  `condition_before` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset sebelum pemeliharaan. Contoh: MINOR_DAMAGE',
  `condition_after` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Kondisi aset setelah pemeliharaan. Contoh: GOOD',
  `maintenance_cost` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Biaya pemeliharaan. Contoh: 350000.00',
  `asset_out` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Menandakan aset keluar dari rumah sakit. Contoh: 1=keluar',
  `out_date` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu aset keluar. Contoh: 2026-10-07 10:00:00',
  `return_date` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu aset kembali. Contoh: 2026-10-10 15:00:00',
  `status_maintenance` enum('DRAFT','SUBMITTED','APPROVED','IN_PROGRESS','WAITING_RETURN','VERIFICATION','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT 'Status pemeliharaan. Contoh: IN_PROGRESS',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan pemeliharaan. Contoh: Pemeliharaan berkala',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-07 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data. Contoh: petugas_atem',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-10 15:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui. Contoh: petugas_atem',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_maintenance`),
  UNIQUE KEY `maintenance_number` (`maintenance_number`),
  KEY `idasset` (`idasset`),
  KEY `technical_team_id` (`technical_team_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `status_maintenance` (`status_maintenance`),
  KEY `status` (`status`),
  CONSTRAINT `fk_maintenance_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_maintenance_team` FOREIGN KEY (`technical_team_id`) REFERENCES `master_technical_team` (`idmaster_technical_team`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_maintenance_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `master_vendor` (`idmaster_vendor`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Transaksi pemeliharaan dan perbaikan aset';

-- Dumping data for table simaset.asset_maintenance: ~0 rows (approximately)
INSERT INTO `asset_maintenance` (`idasset_maintenance`, `maintenance_number`, `idasset`, `maintenance_type`, `maintenance_method`, `maintenance_date`, `technical_team_id`, `vendor_id`, `problem_description`, `action_taken`, `maintenance_result`, `condition_before`, `condition_after`, `maintenance_cost`, `asset_out`, `out_date`, `return_date`, `status_maintenance`, `notes`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'MNT-2026-000001', 3, 'PREVENTIVE', 'INTERNAL', '2026-10-07', 3, NULL, 'Pembersihan AC berkala.', 'Membersihkan filter dan unit indoor.', 'AC berfungsi normal.', 'GOOD', 'GOOD', 0.00, 0, NULL, NULL, 'COMPLETED', NULL, '2026-10-07 09:00:00', 'petugas_ips', '2026-10-07 12:00:00', 'petugas_ips', 1);

-- Dumping structure for table simaset.asset_maintenance_photo
CREATE TABLE IF NOT EXISTS `asset_maintenance_photo` (
  `idasset_maintenance_photo` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key foto pemeliharaan. Contoh: 1',
  `idasset_maintenance` bigint unsigned NOT NULL COMMENT 'ID kegiatan pemeliharaan. Contoh: 1',
  `photo_type` enum('BEFORE','AFTER') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Jenis foto pemeliharaan. Contoh: BEFORE',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama file setelah kompresi. Contoh: MNT-2026-000001-BEFORE.jpg',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lokasi file pada server. Contoh: uploads/maintenance/2026/10/MNT-2026-000001-BEFORE.jpg',
  `file_extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ekstensi file. Contoh: jpg',
  `file_size` bigint unsigned DEFAULT NULL COMMENT 'Ukuran file setelah kompresi dalam byte. Contoh: 245678',
  `photo_width` int unsigned DEFAULT NULL COMMENT 'Lebar foto setelah resize. Contoh: 1200',
  `photo_height` int unsigned DEFAULT NULL COMMENT 'Tinggi foto setelah resize. Contoh: 900',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data foto dibuat. Contoh: 2026-10-07 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username uploader. Contoh: petugas_atem',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data foto diperbarui. Contoh: 2026-10-07 09:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui foto. Contoh: petugas_atem',
  `status` int DEFAULT '1' COMMENT 'Status foto. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_maintenance_photo`),
  UNIQUE KEY `maintenance_photo_type` (`idasset_maintenance`,`photo_type`),
  KEY `status` (`status`),
  CONSTRAINT `fk_maintenance_photo` FOREIGN KEY (`idasset_maintenance`) REFERENCES `asset_maintenance` (`idasset_maintenance`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Foto sebelum dan sesudah kegiatan pemeliharaan aset';

-- Dumping data for table simaset.asset_maintenance_photo: ~2 rows (approximately)
INSERT INTO `asset_maintenance_photo` (`idasset_maintenance_photo`, `idasset_maintenance`, `photo_type`, `file_name`, `file_path`, `file_extension`, `file_size`, `photo_width`, `photo_height`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 'BEFORE', 'MNT-2026-000001-BEFORE.jpg', 'uploads/maintenance/2026/10/MNT-2026-000001-BEFORE.jpg', 'jpg', 210345, 1200, 900, '2026-10-07 09:00:00', 'petugas_ips', '2026-10-07 09:00:00', 'petugas_ips', 1),
	(2, 1, 'AFTER', 'MNT-2026-000001-AFTER.jpg', 'uploads/maintenance/2026/10/MNT-2026-000001-AFTER.jpg', 'jpg', 198765, 1200, 900, '2026-10-07 12:00:00', 'petugas_ips', '2026-10-07 12:00:00', 'petugas_ips', 1);

-- Dumping structure for table simaset.asset_mutation
CREATE TABLE IF NOT EXISTS `asset_mutation` (
  `idasset_mutation` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key transaksi mutasi aset. Contoh: 1',
  `mutation_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor transaksi mutasi aset. Contoh: MUT-2026-000001',
  `mutation_type` enum('TRANSFER_UNIT','TRANSFER_ROOM','TRANSFER_BOTH','CHANGE_RESPONSIBLE') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Jenis mutasi aset. Contoh: TRANSFER_ROOM',
  `mutation_date` date NOT NULL COMMENT 'Tanggal pengajuan atau pelaksanaan mutasi. Contoh: 2026-10-05',
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Alasan mutasi aset. Contoh: Pemindahan aset ke ruang baru',
  `document_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor dokumen pendukung mutasi. Contoh: BA-MUT-001/2026',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan transaksi mutasi. Contoh: Pemindahan karena renovasi ruangan',
  `status_mutation` enum('DRAFT','SUBMITTED','APPROVED','REJECTED','PROCESSING','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT 'Status proses mutasi. Contoh: SUBMITTED',
  `submitted_at` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu pengajuan mutasi. Contoh: 2026-10-05 09:00:00',
  `approved_at` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu persetujuan mutasi. Contoh: 2026-10-05 10:00:00',
  `completed_at` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu mutasi selesai. Contoh: 2026-10-05 14:00:00',
  `submitted_by` bigint unsigned DEFAULT NULL COMMENT 'ID user yang mengajukan mutasi. Contoh: 25',
  `approved_by` bigint unsigned DEFAULT NULL COMMENT 'ID user yang menyetujui mutasi. Contoh: 10',
  `completed_by` bigint unsigned DEFAULT NULL COMMENT 'ID user yang menyelesaikan mutasi. Contoh: 15',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-05 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat transaksi. Contoh: superadmin',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data diperbarui. Contoh: 2026-10-05 14:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui transaksi. Contoh: petugas_aset',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_mutation`),
  UNIQUE KEY `mutation_number` (`mutation_number`),
  KEY `status_mutation` (`status_mutation`),
  KEY `mutation_date` (`mutation_date`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Header transaksi mutasi aset';

-- Dumping data for table simaset.asset_mutation: ~0 rows (approximately)
INSERT INTO `asset_mutation` (`idasset_mutation`, `mutation_number`, `mutation_type`, `mutation_date`, `reason`, `document_number`, `notes`, `status_mutation`, `submitted_at`, `approved_at`, `completed_at`, `submitted_by`, `approved_by`, `completed_by`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'MUT-2026-000001', 'TRANSFER_ROOM', '2026-10-05', 'Pemindahan aset ke ruang baru', 'BA-MUT-001/2026', 'Pemindahan komputer dari ruang administrasi ke ruang Rekam Medis.', 'COMPLETED', '2026-10-05 09:00:00', '2026-10-05 10:00:00', '2026-10-05 14:00:00', 25, 10, 15, '2026-10-05 09:00:00', 'superadmin', '2026-10-05 14:00:00', 'petugas_aset', 1);

-- Dumping structure for table simaset.asset_mutation_detail
CREATE TABLE IF NOT EXISTS `asset_mutation_detail` (
  `idasset_mutation_detail` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key detail mutasi. Contoh: 1',
  `idasset_mutation` bigint unsigned NOT NULL COMMENT 'ID transaksi mutasi. Contoh: 1',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang dimutasi. Contoh: 1001',
  `old_unit_id` bigint unsigned DEFAULT NULL COMMENT 'Unit aset sebelum mutasi. Contoh: 3',
  `old_building_id` bigint unsigned DEFAULT NULL COMMENT 'Gedung aset sebelum mutasi. Contoh: 1',
  `old_room_id` bigint unsigned DEFAULT NULL COMMENT 'Ruangan aset sebelum mutasi. Contoh: 1',
  `old_responsible_person` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Penanggung jawab sebelum mutasi. Contoh: Budi Santoso',
  `new_unit_id` bigint unsigned DEFAULT NULL COMMENT 'Unit aset setelah mutasi. Contoh: 5',
  `new_building_id` bigint unsigned DEFAULT NULL COMMENT 'Gedung aset setelah mutasi. Contoh: 1',
  `new_room_id` bigint unsigned DEFAULT NULL COMMENT 'Ruangan aset setelah mutasi. Contoh: 4',
  `new_responsible_person` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Penanggung jawab setelah mutasi. Contoh: Siti Rahma',
  `mutation_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan mutasi aset. Contoh: Dipindahkan ke ruang Rekam Medis',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal data dibuat. Contoh: 2026-10-05 09:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat detail. Contoh: superadmin',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal data diperbarui. Contoh: 2026-10-05 14:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir memperbarui detail. Contoh: petugas_aset',
  `status` int DEFAULT '1' COMMENT 'Status data. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_mutation_detail`),
  UNIQUE KEY `mutation_asset` (`idasset_mutation`,`idasset`),
  KEY `idasset` (`idasset`),
  KEY `status` (`status`),
  CONSTRAINT `fk_mutation_detail_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_mutation_detail_header` FOREIGN KEY (`idasset_mutation`) REFERENCES `asset_mutation` (`idasset_mutation`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detail perubahan lokasi dan penanggung jawab aset';

-- Dumping data for table simaset.asset_mutation_detail: ~0 rows (approximately)
INSERT INTO `asset_mutation_detail` (`idasset_mutation_detail`, `idasset_mutation`, `idasset`, `old_unit_id`, `old_building_id`, `old_room_id`, `old_responsible_person`, `new_unit_id`, `new_building_id`, `new_room_id`, `new_responsible_person`, `mutation_note`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 2, 5, 1, 4, 'Siti Rahma', 5, 1, 5, 'Dewi Lestari', 'Aset dipindahkan ke ruang baru.', '2026-10-05 09:00:00', 'superadmin', '2026-10-05 14:00:00', 'petugas_aset', 1);

-- Dumping structure for table simaset.asset_photo
CREATE TABLE IF NOT EXISTS `asset_photo` (
  `idasset_photo` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key untuk data foto aset. Contoh: 1',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang memiliki foto utama. Contoh: 1',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama file foto setelah proses resize dan kompresi. Contoh: AST-2026-000001.jpg',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lokasi file foto pada server. Contoh: uploads/assets/2026/10/AST-2026-000001.jpg',
  `file_extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ekstensi file foto setelah diproses. Contoh: jpg',
  `file_size` bigint unsigned DEFAULT NULL COMMENT 'Ukuran file setelah kompresi dalam byte. Contoh: 245678',
  `photo_width` int unsigned DEFAULT NULL COMMENT 'Lebar foto setelah resize dalam pixel. Contoh: 1200',
  `photo_height` int unsigned DEFAULT NULL COMMENT 'Tinggi foto setelah resize dalam pixel. Contoh: 900',
  `photo_date` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu foto dibuat atau diunggah. Contoh: 2026-10-02 10:30:00',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data foto dibuat. Contoh: 2026-10-02 10:30:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang mengunggah foto. Contoh: superadmin',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data foto diperbarui. Contoh: 2026-10-02 10:30:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang memperbarui foto. Contoh: superadmin',
  `status` int DEFAULT '1' COMMENT 'Status data foto. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_photo`) USING BTREE,
  UNIQUE KEY `idasset` (`idasset`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_asset_photo_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Menyimpan satu foto utama untuk setiap aset';

-- Dumping data for table simaset.asset_photo: ~3 rows (approximately)
INSERT INTO `asset_photo` (`idasset_photo`, `idasset`, `file_name`, `file_path`, `file_extension`, `file_size`, `photo_width`, `photo_height`, `photo_date`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 'AST-2026-000001.jpg', 'uploads/assets/2026/10/AST-2026-000001.jpg', 'jpg', 245678, 1200, 900, '2026-10-02 10:30:00', '2026-10-02 10:30:00', 'superadmin', '2026-10-02 10:30:00', 'superadmin', 1),
	(2, 2, 'AST-2026-000002.jpg', 'uploads/assets/2026/10/AST-2026-000002.jpg', 'jpg', 198432, 1200, 900, '2026-10-02 10:35:00', '2026-10-02 10:35:00', 'superadmin', '2026-10-02 10:35:00', 'superadmin', 1),
	(3, 3, 'AST-2026-000003.jpg', 'uploads/assets/2026/10/AST-2026-000003.jpg', 'jpg', 221876, 1200, 900, '2026-10-02 10:40:00', '2026-10-02 10:40:00', 'superadmin', '2026-10-02 10:40:00', 'superadmin', 1);

-- Dumping structure for table simaset.asset_qr
CREATE TABLE IF NOT EXISTS `asset_qr` (
  `idasset_qr` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key untuk data QR aset. Contoh: 1',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang terkait dengan QR. Contoh: 1',
  `qr_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode QR unik aset. Contoh: QR-AST-2026-000001',
  `qr_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Token unik untuk mengakses halaman detail aset. Contoh: 8f3d9c7a1b...',
  `qr_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'URL tujuan ketika QR dipindai. Contoh: https://sim aset.rsud.local/asset/8f3d9c7a1b',
  `qr_image_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lokasi file gambar QR pada server. Contoh: uploads/qr/2026/10/QR-AST-2026-000001.png',
  `generated_at` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu QR dibuat. Contoh: 2026-10-02 10:45:00',
  `printed_at` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu QR terakhir dicetak. Contoh: 2026-10-02 11:00:00',
  `print_count` int unsigned NOT NULL DEFAULT '0' COMMENT 'Jumlah QR telah dicetak. Contoh: 2',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Status QR. Contoh: 1=aktif, 0=tidak aktif',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data QR dibuat. Contoh: 2026-10-02 10:45:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang membuat QR. Contoh: superadmin',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data QR diperbarui. Contoh: 2026-10-02 10:45:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang memperbarui QR. Contoh: superadmin',
  `status` int DEFAULT '1' COMMENT 'Status data QR. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idasset_qr`) USING BTREE,
  UNIQUE KEY `idasset` (`idasset`) USING BTREE,
  UNIQUE KEY `qr_code` (`qr_code`) USING BTREE,
  UNIQUE KEY `qr_token` (`qr_token`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_asset_qr_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Menyimpan identitas QR unik untuk setiap aset';

-- Dumping data for table simaset.asset_qr: ~2 rows (approximately)
INSERT INTO `asset_qr` (`idasset_qr`, `idasset`, `qr_code`, `qr_token`, `qr_url`, `qr_image_path`, `generated_at`, `printed_at`, `print_count`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 'QR-AST-2026-000001', '8f3d9c7a1b5e42c891d7f0a65b3c4e12', 'https://simaset.rsudsumberglagah.local/asset/8f3d9c7a1b5e42c891d7f0a65b3c4e12', 'uploads/qr/2026/10/QR-AST-2026-000001.png', '2026-10-02 10:45:00', '2026-10-02 11:00:00', 1, 1, '2026-10-02 10:45:00', 'superadmin', '2026-10-02 11:00:00', 'superadmin', 1),
	(2, 2, 'QR-AST-2026-000002', '2a7c4f91e6b835d0c12f9a3b7e641d25', 'https://simaset.rsudsumberglagah.local/asset/2a7c4f91e6b835d0c12f9a3b7e641d25', 'uploads/qr/2026/10/QR-AST-2026-000002.png', '2026-10-02 10:46:00', NULL, 0, 1, '2026-10-02 10:46:00', 'superadmin', '2026-10-02 10:46:00', 'superadmin', 1);

-- Dumping structure for table simaset.audit_trail
CREATE TABLE IF NOT EXISTS `audit_trail` (
  `idaudit_trail` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key untuk audit trail. Contoh: 1',
  `iduser` bigint unsigned DEFAULT NULL COMMENT 'ID user yang melakukan aktivitas. Contoh: 25',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username saat aktivitas dilakukan. Disimpan sebagai snapshot. Contoh: petugas_aset',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Jenis aktivitas yang dilakukan. Contoh: UPDATE',
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama modul tempat aktivitas dilakukan. Contoh: Asset',
  `entity_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Jenis data/entitas yang diproses. Contoh: asset',
  `entity_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID record yang diproses. Contoh: 1001',
  `reference_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Jenis transaksi yang menjadi referensi aktivitas. Contoh: MUTATION',
  `reference_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID transaksi referensi. Contoh: 15',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Deskripsi aktivitas. Contoh: Mengubah lokasi aset dari Ruang Melati ke Ruang Anggrek',
  `before_data` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Data sebelum perubahan dalam format JSON. Contoh: {"idmaster_room":1}',
  `after_data` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Data setelah perubahan dalam format JSON. Contoh: {"idmaster_room":5}',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Alamat IP user saat aktivitas dilakukan. Contoh: 192.168.1.25',
  `user_agent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Informasi browser atau perangkat user. Contoh: Chrome Windows',
  `request_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL yang digunakan saat aktivitas dilakukan. Contoh: /asset/update/1001',
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'HTTP method yang digunakan. Contoh: POST',
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID transaksi untuk mengelompokkan beberapa audit dalam satu proses. Contoh: TXN-20261002-000001',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu aktivitas dilakukan. Contoh: 2026-10-02 15:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat record audit. Biasanya sama dengan username aktivitas. Contoh: petugas_aset',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu record audit diperbarui. Contoh: 2026-10-02 15:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang memperbarui record audit. Contoh: petugas_aset',
  `status` int DEFAULT '1' COMMENT 'Status record audit. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idaudit_trail`) USING BTREE,
  KEY `iduser` (`iduser`) USING BTREE,
  KEY `action` (`action`) USING BTREE,
  KEY `module` (`module`) USING BTREE,
  KEY `entity_type` (`entity_type`) USING BTREE,
  KEY `entity_id` (`entity_id`) USING BTREE,
  KEY `reference_type` (`reference_type`) USING BTREE,
  KEY `reference_id` (`reference_id`) USING BTREE,
  KEY `transaction_id` (`transaction_id`) USING BTREE,
  KEY `created` (`created`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Audit trail seluruh aktivitas penting pengguna dan transaksi SIMASET';

-- Dumping data for table simaset.audit_trail: ~2 rows (approximately)
INSERT INTO `audit_trail` (`idaudit_trail`, `iduser`, `username`, `action`, `module`, `entity_type`, `entity_id`, `reference_type`, `reference_id`, `description`, `before_data`, `after_data`, `ip_address`, `user_agent`, `request_url`, `request_method`, `transaction_id`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 'superadmin', 'CREATE', 'Asset', 'asset', '1', NULL, NULL, 'Membuat data aset baru Patient Monitor Mindray PM-60', NULL, '{"asset_code":"AST-2026-000001","asset_name":"Patient Monitor Mindray PM-60"}', '192.168.1.10', 'Chrome Windows', '/asset/save', 'POST', 'TXN-20261002-000001', '2026-10-02 10:30:00', 'superadmin', NULL, NULL, 1),
	(2, 15, 'petugas_aset', 'UPDATE', 'Asset', 'asset', '2', NULL, NULL, 'Mengubah lokasi aset dari Ruang Administrasi ke Ruang Rekam Medis', '{"idmaster_unit":5,"idmaster_building":1,"idmaster_room":4,"responsible_person":"Siti Rahma"}', '{"idmaster_unit":5,"idmaster_building":1,"idmaster_room":5,"responsible_person":"Dewi Lestari"}', '192.168.1.25', 'Chrome Windows', '/asset/update/2', 'POST', 'TXN-20261005-000001', '2026-10-05 14:00:00', 'petugas_aset', NULL, NULL, 1),
	(3, 10, 'kepala_bagian', 'APPROVE', 'Mutation', 'asset_mutation', '1', 'MUTATION', '1', 'Menyetujui transaksi mutasi MUT-2026-000001', NULL, '{"status_mutation":"APPROVED","approved_by":10}', NULL, NULL, NULL, NULL, 'TXN-20261005-000002', '2026-10-05 10:00:00', 'kepala_bagian', NULL, NULL, 1);

-- Dumping structure for table simaset.kir
CREATE TABLE IF NOT EXISTS `kir` (
  `idkir` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key untuk dokumen KIR. Contoh: 1',
  `kir_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor dokumen KIR. Contoh: KIR-RI-MELATI-2026-001',
  `kir_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama atau judul KIR. Contoh: KIR Ruang Melati Periode Oktober 2026',
  `kir_scope` enum('UNIT','ROOM','HOSPITAL') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lingkup KIR. Contoh: ROOM',
  `idmaster_unit` bigint unsigned DEFAULT NULL COMMENT 'ID unit yang menjadi objek KIR. Contoh: 3',
  `idmaster_building` bigint unsigned DEFAULT NULL COMMENT 'ID gedung yang menjadi objek KIR. Contoh: 1',
  `idmaster_room` bigint unsigned DEFAULT NULL COMMENT 'ID ruangan yang menjadi objek KIR. Contoh: 1',
  `kir_date` date NOT NULL COMMENT 'Tanggal pelaksanaan KIR. Contoh: 2026-10-02',
  `period_start` date DEFAULT NULL COMMENT 'Tanggal awal periode KIR. Contoh: 2026-10-01',
  `period_end` date DEFAULT NULL COMMENT 'Tanggal akhir periode KIR. Contoh: 2026-10-31',
  `responsible_person` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nama penanggung jawab KIR. Contoh: Budi Santoso',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan umum KIR. Contoh: Pemeriksaan inventaris ruangan',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data KIR dibuat. Contoh: 2026-10-02 10:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang membuat KIR. Contoh: superadmin',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data KIR diperbarui. Contoh: 2026-10-02 10:00:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang memperbarui KIR. Contoh: superadmin',
  `status` int DEFAULT '1' COMMENT 'Status data KIR. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idkir`) USING BTREE,
  UNIQUE KEY `kir_number` (`kir_number`) USING BTREE,
  KEY `idmaster_unit` (`idmaster_unit`) USING BTREE,
  KEY `idmaster_building` (`idmaster_building`) USING BTREE,
  KEY `idmaster_room` (`idmaster_room`) USING BTREE,
  KEY `kir_scope` (`kir_scope`) USING BTREE,
  KEY `kir_date` (`kir_date`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_kir_building` FOREIGN KEY (`idmaster_building`) REFERENCES `master_building` (`idmaster_building`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_kir_room` FOREIGN KEY (`idmaster_room`) REFERENCES `master_room` (`idmaster_room`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_kir_unit` FOREIGN KEY (`idmaster_unit`) REFERENCES `master_unit` (`idmaster_unit`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Header dokumen KIR untuk pencatatan dan pemeriksaan inventaris aset';

-- Dumping data for table simaset.kir: ~3 rows (approximately)
INSERT INTO `kir` (`idkir`, `kir_number`, `kir_name`, `kir_scope`, `idmaster_unit`, `idmaster_building`, `idmaster_room`, `kir_date`, `period_start`, `period_end`, `responsible_person`, `notes`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'KIR-RI-MELATI-2026-001', 'KIR Ruang Melati Periode Oktober 2026', 'ROOM', 3, 1, 1, '2026-10-02', '2026-10-01', '2026-10-31', 'Budi Santoso', 'Pemeriksaan inventaris aset Ruang Melati.', '2026-10-02 09:00:00', 'superadmin', '2026-10-02 09:00:00', 'superadmin', 1),
	(2, 'KIR-REKMED-2026-001', 'KIR Unit Rekam Medis Tahun 2026', 'UNIT', 5, NULL, NULL, '2026-10-02', '2026-10-01', '2026-10-31', 'Siti Rahma', 'Pemeriksaan inventaris aset Unit Rekam Medis.', '2026-10-02 11:00:00', 'superadmin', '2026-10-02 11:00:00', 'superadmin', 1),
	(3, 'KIR-RS-2026-001', 'KIR Aset Bersama RSUD Sumberglagah Tahun 2026', 'HOSPITAL', NULL, NULL, NULL, '2026-10-02', '2026-10-01', '2026-10-31', 'Pengurus Barang', 'Pemeriksaan aset bersama yang digunakan lintas unit.', '2026-10-02 11:30:00', 'superadmin', '2026-10-02 11:30:00', 'superadmin', 1);

-- Dumping structure for table simaset.kir_detail
CREATE TABLE IF NOT EXISTS `kir_detail` (
  `idkir_detail` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key untuk detail KIR. Contoh: 1',
  `idkir` bigint unsigned NOT NULL COMMENT 'ID dokumen KIR. Contoh: 1',
  `idasset` bigint unsigned NOT NULL COMMENT 'ID aset yang diperiksa dalam KIR. Contoh: 1',
  `sequence_number` int unsigned NOT NULL DEFAULT '1' COMMENT 'Nomor urut aset dalam dokumen KIR. Contoh: 1',
  `asset_condition_snapshot` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Snapshot kondisi aset saat KIR dilakukan. Contoh: GOOD',
  `location_snapshot` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Snapshot lokasi aset saat KIR dilakukan. Contoh: Gedung Utama / Ruang Melati',
  `verification_status` enum('NOT_CHECKED','MATCH','MISMATCH','NOT_FOUND','NEW_FINDING') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NOT_CHECKED' COMMENT 'Hasil pemeriksaan aset. Contoh: MATCH',
  `verification_date` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu pemeriksaan aset. Contoh: 2026-10-02 10:30:00',
  `verification_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan hasil pemeriksaan aset. Contoh: Kondisi dan lokasi sesuai data sistem',
  `verified_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nama atau username petugas yang melakukan verifikasi. Contoh: petugas_inventaris',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu detail KIR dibuat. Contoh: 2026-10-02 10:00:00',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang membuat detail KIR. Contoh: superadmin',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu detail KIR diperbarui. Contoh: 2026-10-02 10:30:00',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username yang memperbarui detail KIR. Contoh: petugas_inventaris',
  `status` int DEFAULT '1' COMMENT 'Status detail KIR. Contoh: 1=aktif, 0=nonaktif',
  PRIMARY KEY (`idkir_detail`) USING BTREE,
  UNIQUE KEY `kir_asset` (`idkir`,`idasset`) USING BTREE,
  KEY `idasset` (`idasset`) USING BTREE,
  KEY `verification_status` (`verification_status`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_kir_detail_asset` FOREIGN KEY (`idasset`) REFERENCES `asset` (`idasset`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_kir_detail_kir` FOREIGN KEY (`idkir`) REFERENCES `kir` (`idkir`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detail aset yang tercatat dan diperiksa dalam dokumen KIR';

-- Dumping data for table simaset.kir_detail: ~2 rows (approximately)
INSERT INTO `kir_detail` (`idkir_detail`, `idkir`, `idasset`, `sequence_number`, `asset_condition_snapshot`, `location_snapshot`, `verification_status`, `verification_date`, `verification_note`, `verified_by`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 1, 1, 'GOOD', 'Gedung Utama / Ruang Melati', 'MATCH', '2026-10-02 10:30:00', 'Kondisi, identitas dan lokasi aset sesuai dengan data SIMASET.', 'petugas_inventaris', '2026-10-02 10:00:00', 'superadmin', '2026-10-02 10:30:00', 'petugas_inventaris', 1),
	(2, 1, 3, 2, 'GOOD', 'Gedung Utama / Ruang Melati', 'MATCH', '2026-10-02 10:35:00', 'Aset ditemukan dan kondisi sesuai.', 'petugas_inventaris', '2026-10-02 10:00:00', 'superadmin', '2026-10-02 10:35:00', 'petugas_inventaris', 1);

-- Dumping structure for table simaset.master_acquisition_source
CREATE TABLE IF NOT EXISTS `master_acquisition_source` (
  `idmaster_acquisition_source` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key sumber perolehan aset.',
  `source_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode sumber perolehan. Contoh: PROCUREMENT, DONATION, TRANSFER.',
  `source_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama sumber perolehan. Contoh: Pengadaan.',
  `description_source` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi sumber perolehan.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_acquisition_source`),
  UNIQUE KEY `uk_source_code` (`source_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master sumber perolehan aset.';

-- Dumping data for table simaset.master_acquisition_source: ~7 rows (approximately)
INSERT INTO `master_acquisition_source` (`idmaster_acquisition_source`, `source_code`, `source_name`, `description_source`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'PROCUREMENT', 'Pengadaan', 'Aset diperoleh melalui proses pengadaan.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'DONATION', 'Hibah', 'Aset diperoleh melalui hibah.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'TRANSFER', 'Transfer', 'Aset diperoleh melalui transfer dari instansi/unit lain.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 'DROPPING', 'Dropping', 'Aset diperoleh melalui dropping.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(5, 'RECLASSIFICATION', 'Reklasifikasi', 'Aset berasal dari proses reklasifikasi.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(6, 'INVENTORY_FINDING', 'Temuan Inventarisasi', 'Aset ditemukan melalui kegiatan inventarisasi.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(7, 'OTHER', 'Lainnya', 'Sumber perolehan lainnya.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_building
CREATE TABLE IF NOT EXISTS `master_building` (
  `idmaster_building` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key gedung. Contoh: 1 = Gedung Rawat Inap.',
  `building_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode gedung. Contoh: G-RAWAT.',
  `building_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama gedung. Contoh: Gedung Rawat Inap.',
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Alamat atau lokasi gedung. Contoh: Area Utara RSUD Sumberglagah.',
  `latitude` decimal(10,7) DEFAULT NULL COMMENT 'Koordinat latitude gedung untuk peta. Contoh: -7.1234567.',
  `longitude` decimal(10,7) DEFAULT NULL COMMENT 'Koordinat longitude gedung untuk peta. Contoh: 112.1234567.',
  `description_building` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi gedung.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif gedung. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-02 10:48:14.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data. Contoh: superadmin.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui. Contoh: 2026-10-02 10:48:14.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data. Contoh: superadmin.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_building`),
  UNIQUE KEY `uk_building_code` (`building_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master gedung lokasi aset rumah sakit.';

-- Dumping data for table simaset.master_building: ~4 rows (approximately)
INSERT INTO `master_building` (`idmaster_building`, `building_code`, `building_name`, `address`, `latitude`, `longitude`, `description_building`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'G-RAWAT', 'Gedung Rawat Inap', 'Area Rawat Inap RSUD Sumberglagah', -7.1234567, 112.1234567, 'Gedung pelayanan rawat inap.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'G-RJ', 'Gedung Rawat Jalan', 'Area Rawat Jalan RSUD Sumberglagah', -7.1235000, 112.1235000, 'Gedung pelayanan rawat jalan.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'G-PENUNJANG', 'Gedung Penunjang', 'Area Penunjang RSUD Sumberglagah', -7.1235500, 112.1235500, 'Gedung unit penunjang dan workshop.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 'G-ADMIN', 'Gedung Administrasi', 'Area Administrasi RSUD Sumberglagah', -7.1236000, 112.1236000, 'Gedung administrasi rumah sakit.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_category_product
CREATE TABLE IF NOT EXISTS `master_category_product` (
  `idmaster_category_product` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key kategori barang. Contoh: 1 = Peralatan IT.',
  `category_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode kategori barang. Contoh: IT, MED, FUR, ELEC.',
  `category_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama kategori barang. Contoh: Peralatan Teknologi Informasi.',
  `description_category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi kategori barang. Contoh: Digunakan untuk komputer dan perangkat IT.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif kategori. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-02 10:48:14.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data. Contoh: superadmin.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui. Contoh: 2026-10-02 10:48:14.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data. Contoh: superadmin.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_category_product`),
  UNIQUE KEY `uk_category_code` (`category_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master kategori barang atau kelompok aset.';

-- Dumping data for table simaset.master_category_product: ~5 rows (approximately)
INSERT INTO `master_category_product` (`idmaster_category_product`, `category_code`, `category_name`, `description_category`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'IT', 'Peralatan Teknologi Informasi', 'Komputer, laptop, printer, server, jaringan dan perangkat IT lainnya.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'MED', 'Peralatan Medis', 'Peralatan medis dan elektromedik.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'FUR', 'Furniture', 'Meja, kursi, lemari dan furniture lainnya.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 'ELEC', 'Peralatan Elektronik', 'Peralatan elektronik selain perangkat IT dan medis.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(5, 'BUILD', 'Peralatan Gedung', 'Peralatan pendukung gedung seperti AC dan peralatan sarana prasarana.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_condition
CREATE TABLE IF NOT EXISTS `master_condition` (
  `idmaster_condition` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key kondisi aset.',
  `condition_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode kondisi. Contoh: GOOD, MINOR_DAMAGE, MAJOR_DAMAGE.',
  `condition_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama kondisi. Contoh: Baik, Rusak Ringan, Rusak Berat.',
  `description_condition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi kondisi aset.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif kondisi. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_condition`),
  UNIQUE KEY `uk_condition_code` (`condition_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master kondisi fisik atau operasional aset.';

-- Dumping data for table simaset.master_condition: ~3 rows (approximately)
INSERT INTO `master_condition` (`idmaster_condition`, `condition_code`, `condition_name`, `description_condition`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'GOOD', 'Baik', 'Aset dalam kondisi baik dan dapat digunakan.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'MINOR_DAMAGE', 'Rusak Ringan', 'Aset mengalami kerusakan ringan tetapi masih dapat digunakan atau diperbaiki.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'MAJOR_DAMAGE', 'Rusak Berat', 'Aset mengalami kerusakan berat dan membutuhkan tindakan khusus.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_funding_source
CREATE TABLE IF NOT EXISTS `master_funding_source` (
  `idmaster_funding_source` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key sumber dana.',
  `funding_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode sumber dana. Contoh: APBD, BLUD, DAK.',
  `funding_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama sumber dana. Contoh: BLUD.',
  `description_funding` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi sumber dana.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif sumber dana. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_funding_source`),
  UNIQUE KEY `uk_funding_code` (`funding_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master sumber dana perolehan aset.';

-- Dumping data for table simaset.master_funding_source: ~5 rows (approximately)
INSERT INTO `master_funding_source` (`idmaster_funding_source`, `funding_code`, `funding_name`, `description_funding`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'APBD', 'APBD', 'Anggaran Pendapatan dan Belanja Daerah.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'BLUD', 'BLUD', 'Badan Layanan Umum Daerah.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'DAK', 'DAK', 'Dana Alokasi Khusus.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 'DONATION', 'Hibah', 'Dana atau barang yang diperoleh melalui hibah.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(5, 'OTHER', 'Lainnya', 'Sumber dana lainnya.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_kib
CREATE TABLE IF NOT EXISTS `master_kib` (
  `idmaster_kib` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key master KIB. Contoh: 1 untuk KIB A.',
  `kib_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode KIB. Contoh: A, B, C, D, E, F.',
  `kib_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama KIB. Contoh: Peralatan dan Mesin.',
  `description_kib` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi KIB. Contoh: KIB B digunakan untuk peralatan dan mesin.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif master KIB. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-02 10:48:14.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data. Contoh: superadmin.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui. Contoh: 2026-10-02 10:48:14.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data. Contoh: superadmin.',
  `status` int DEFAULT '1' COMMENT 'Status data secara umum. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_kib`),
  UNIQUE KEY `uk_kib_code` (`kib_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master Klasifikasi Inventaris Barang Milik Daerah berdasarkan KIB.';

-- Dumping data for table simaset.master_kib: ~6 rows (approximately)
INSERT INTO `master_kib` (`idmaster_kib`, `kib_code`, `kib_name`, `description_kib`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'A', 'Tanah', 'Tanah', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'B', 'Peralatan dan Mesin', 'Peralatan dan mesin', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'C', 'Gedung dan Bangunan', 'Gedung dan bangunan', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 'D', 'Jalan, Irigasi dan Jaringan', 'Jalan, irigasi dan jaringan', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(5, 'E', 'Aset Tetap Lainnya', 'Aset tetap lainnya', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(6, 'F', 'Konstruksi Dalam Pengerjaan', 'Konstruksi dalam pengerjaan', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_product
CREATE TABLE IF NOT EXISTS `master_product` (
  `idmaster_product` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key barang. Contoh: 1 = Patient Monitor.',
  `product_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode barang internal. Contoh: MED-MON-001.',
  `product_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama barang. Contoh: Patient Monitor.',
  `idmaster_category_product` bigint unsigned NOT NULL COMMENT 'Relasi ke kategori barang. Contoh: kategori MED untuk Patient Monitor.',
  `idmaster_kib` bigint unsigned NOT NULL COMMENT 'Relasi ke KIB default barang. Contoh: KIB B untuk Patient Monitor.',
  `service_type` enum('SERVICE','NON_SERVICE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SERVICE' COMMENT 'Jenis penggunaan barang. SERVICE = mendukung pelayanan pasien, NON_SERVICE = tidak langsung mendukung pelayanan.',
  `brand` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Merek barang. Contoh: Mindray.',
  `model` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Model atau tipe barang. Contoh: PM-60.',
  `unit_of_measure` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Satuan barang. Contoh: UNIT, SET, PCS.',
  `description_product` text COLLATE utf8mb4_unicode_ci COMMENT 'Deskripsi barang. Contoh: Patient Monitor untuk monitoring tanda vital pasien.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif barang. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-02 10:48:14.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data. Contoh: superadmin.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui. Contoh: 2026-10-02 10:48:14.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data. Contoh: superadmin.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_product`),
  UNIQUE KEY `uk_product_code` (`product_code`),
  KEY `idx_category` (`idmaster_category_product`) USING BTREE,
  KEY `idx_kib` (`idmaster_kib`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_product_category` FOREIGN KEY (`idmaster_category_product`) REFERENCES `master_category_product` (`idmaster_category_product`),
  CONSTRAINT `fk_product_kib` FOREIGN KEY (`idmaster_kib`) REFERENCES `master_kib` (`idmaster_kib`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master jenis barang yang dapat memiliki satu atau banyak aset fisik.';

-- Dumping data for table simaset.master_product: ~5 rows (approximately)
INSERT INTO `master_product` (`idmaster_product`, `product_code`, `product_name`, `idmaster_category_product`, `idmaster_kib`, `service_type`, `brand`, `model`, `unit_of_measure`, `description_product`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'IT-CMP-001', 'PC Desktop Core i5', 1, 2, 'NON_SERVICE', 'Lenovo', 'ThinkCentre', 'UNIT', 'Komputer desktop untuk kebutuhan administrasi.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'IT-LAP-001', 'Laptop', 1, 2, 'NON_SERVICE', 'Lenovo', 'ThinkPad', 'UNIT', 'Laptop untuk kebutuhan operasional rumah sakit.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'MED-MON-001', 'Patient Monitor', 2, 2, 'SERVICE', 'Mindray', 'PM-60', 'UNIT', 'Patient Monitor untuk monitoring tanda vital pasien.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 'MED-ECG-001', 'ECG 12 Channel', 2, 2, 'SERVICE', 'GE', 'MAC 2000', 'UNIT', 'Electrocardiograph 12 channel.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(5, 'FUR-KRS-001', 'Kursi Tunggu', 3, 2, 'SERVICE', NULL, NULL, 'PCS', 'Kursi untuk ruang tunggu pasien.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(6, 'BUILD-AC-001', 'AC Split 2 PK', 5, 2, 'SERVICE', 'Daikin', '2 PK', 'UNIT', 'AC split untuk ruangan pelayanan rumah sakit.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_room
CREATE TABLE IF NOT EXISTS `master_room` (
  `idmaster_room` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key ruangan. Contoh: 1 = Ruangan Melati.',
  `idmaster_building` bigint unsigned NOT NULL COMMENT 'Gedung tempat ruangan berada. Contoh: Gedung Rawat Inap.',
  `idmaster_unit` bigint unsigned NOT NULL COMMENT 'Unit yang menggunakan atau bertanggung jawab atas ruangan. Contoh: Instalasi Rawat Inap.',
  `room_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode ruangan. Contoh: RI-MELATI.',
  `room_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama ruangan. Contoh: Melati.',
  `floor_number` int DEFAULT NULL COMMENT 'Nomor lantai ruangan. Contoh: 2.',
  `room_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Jenis ruangan. Contoh: Rawat Inap, Poli, Workshop.',
  `description_room` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi ruangan.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif ruangan. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-02 10:48:14.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data. Contoh: superadmin.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui. Contoh: 2026-10-02 10:48:14.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data. Contoh: superadmin.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_room`),
  UNIQUE KEY `uk_room_code` (`room_code`),
  KEY `idx_building` (`idmaster_building`) USING BTREE,
  KEY `idx_unit` (`idmaster_unit`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_room_building` FOREIGN KEY (`idmaster_building`) REFERENCES `master_building` (`idmaster_building`),
  CONSTRAINT `fk_room_unit` FOREIGN KEY (`idmaster_unit`) REFERENCES `master_unit` (`idmaster_unit`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master ruangan berdasarkan gedung dan unit.';

-- Dumping data for table simaset.master_room: ~9 rows (approximately)
INSERT INTO `master_room` (`idmaster_room`, `idmaster_building`, `idmaster_unit`, `room_code`, `room_name`, `floor_number`, `room_type`, `description_room`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 1, 'RI-MELATI', 'Melati', 1, 'RAWAT_INAP', 'Ruang Rawat Inap Melati.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 1, 1, 'RI-ANGGREK', 'Anggrek', 1, 'RAWAT_INAP', 'Ruang Rawat Inap Anggrek.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 1, 1, 'RI-TULIP', 'Tulip', 2, 'RAWAT_INAP', 'Ruang Rawat Inap Tulip.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 2, 2, 'RJ-POLI-UMUM', 'Poli Umum', 1, 'POLI', 'Ruang Poli Umum.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(5, 2, 2, 'RJ-POLI-ANAK', 'Poli Anak', 1, 'POLI', 'Ruang Poli Anak.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(6, 3, 5, 'ATEM-WORKSHOP', 'Workshop ATEM', 1, 'WORKSHOP', 'Workshop Alat Teknik Elektromedik.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(7, 3, 4, 'IT-ROOM', 'Ruang IT', 1, 'OFFICE', 'Ruang Teknologi Informasi.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(8, 3, 6, 'IPS-WORKSHOP', 'Workshop IPS', 1, 'WORKSHOP', 'Workshop Instalasi Pemeliharaan Sarana.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(9, 4, 3, 'RM-ROOM', 'Rekam Medis', 1, 'OFFICE', 'Ruangan Rekam Medis.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_technical_team
CREATE TABLE IF NOT EXISTS `master_technical_team` (
  `idmaster_technical_team` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key tim teknis.',
  `team_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode tim teknis. Contoh: IT, ATEM, IPS.',
  `team_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama tim teknis. Contoh: Teknologi Informasi.',
  `team_scope` text COLLATE utf8mb4_unicode_ci COMMENT 'Ruang lingkup pekerjaan tim. Contoh: komputer, jaringan dan printer.',
  `idmaster_unit` bigint unsigned DEFAULT NULL COMMENT 'Unit yang menaungi tim teknis. Contoh: Unit IT.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif tim. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_technical_team`),
  UNIQUE KEY `uk_team_code` (`team_code`),
  KEY `idx_unit` (`idmaster_unit`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `fk_technical_team_unit` FOREIGN KEY (`idmaster_unit`) REFERENCES `master_unit` (`idmaster_unit`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master tim teknis yang menangani pemeliharaan dan pemeriksaan kerusakan aset.';

-- Dumping data for table simaset.master_technical_team: ~3 rows (approximately)
INSERT INTO `master_technical_team` (`idmaster_technical_team`, `team_code`, `team_name`, `team_scope`, `idmaster_unit`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'IT', 'Teknologi Informasi', 'Komputer, laptop, server, jaringan, printer dan perangkat teknologi informasi.', 4, 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'ATEM', 'Alat Teknik Elektromedik', 'Alat kesehatan, peralatan elektromedik dan perangkat medis.', 5, 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'IPS', 'Instalasi Pemeliharaan Sarana', 'Gedung, listrik, AC, plumbing dan sarana prasarana.', 6, 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_unit
CREATE TABLE IF NOT EXISTS `master_unit` (
  `idmaster_unit` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key unit. Contoh: 1 = Instalasi Rawat Inap.',
  `unit_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode unit. Contoh: RI, RJ, IT, ATEM, IPS.',
  `unit_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama unit. Contoh: Instalasi Rawat Inap.',
  `unit_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Jenis unit. Contoh: Pelayanan, Penunjang, Administrasi.',
  `description_unit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Deskripsi unit. Contoh: Unit yang menangani pelayanan rawat inap.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif unit. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat. Contoh: 2026-10-02 10:48:14.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data. Contoh: superadmin.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui. Contoh: 2026-10-02 10:48:14.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data. Contoh: superadmin.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_unit`),
  UNIQUE KEY `uk_unit_code` (`unit_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master unit atau instalasi pengguna/pengelola aset.';

-- Dumping data for table simaset.master_unit: ~7 rows (approximately)
INSERT INTO `master_unit` (`idmaster_unit`, `unit_code`, `unit_name`, `unit_type`, `description_unit`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'RI', 'Instalasi Rawat Inap', 'PELAYANAN', 'Unit pelayanan rawat inap.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'RJ', 'Instalasi Rawat Jalan', 'PELAYANAN', 'Unit pelayanan rawat jalan.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'RM', 'Rekam Medis', 'PENUNJANG', 'Unit pengelola rekam medis.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(4, 'IT', 'Teknologi Informasi', 'PENUNJANG', 'Unit pengelola teknologi informasi.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(5, 'ATEM', 'Alat Teknik Elektromedik', 'PENUNJANG', 'Unit teknis peralatan elektromedik.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(6, 'IPS', 'Instalasi Pemeliharaan Sarana', 'PENUNJANG', 'Unit pemeliharaan sarana dan prasarana.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(7, 'LAB', 'Laboratorium', 'PELAYANAN', 'Unit pelayanan laboratorium.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.master_vendor
CREATE TABLE IF NOT EXISTS `master_vendor` (
  `idmaster_vendor` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key vendor.',
  `vendor_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode vendor. Contoh: VEN-001.',
  `vendor_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama vendor. Contoh: PT Medika Sejahtera.',
  `vendor_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Jenis vendor. Contoh: Medical, IT, Building.',
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Alamat vendor.',
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nomor telepon vendor.',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email vendor.',
  `contact_person` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nama kontak vendor. Contoh: Budi.',
  `description_vendor` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Keterangan vendor.',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT 'Status aktif vendor. 1 = aktif, 0 = tidak aktif.',
  `created` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu data dibuat.',
  `createdby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username pembuat data.',
  `updated` datetime DEFAULT NULL COMMENT 'Tanggal dan waktu terakhir data diperbarui.',
  `updatedby` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username terakhir yang memperbarui data.',
  `status` int DEFAULT '1' COMMENT 'Status data. 1 = aktif, 0 = nonaktif.',
  PRIMARY KEY (`idmaster_vendor`),
  UNIQUE KEY `uk_vendor_code` (`vendor_code`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master vendor yang terkait dengan pengadaan atau pemeliharaan aset.';

-- Dumping data for table simaset.master_vendor: ~2 rows (approximately)
INSERT INTO `master_vendor` (`idmaster_vendor`, `vendor_code`, `vendor_name`, `vendor_type`, `address`, `phone`, `email`, `contact_person`, `description_vendor`, `is_active`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 'VEN-001', 'PT Medika Sejahtera', 'MEDICAL', 'Surabaya', '031-123456', 'info@medikasejahtera.co.id', 'Budi Santoso', 'Vendor alat kesehatan.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(2, 'VEN-002', 'PT Solusi Teknologi Nusantara', 'IT', 'Surabaya', '031-234567', 'info@solusiteknologi.co.id', 'Andi', 'Vendor perangkat teknologi informasi.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1),
	(3, 'VEN-003', 'CV Sarana Hospital', 'BUILDING', 'Mojokerto', '0321-345678', 'info@saranahospital.co.id', 'Rudi', 'Vendor sarana dan prasarana rumah sakit.', 1, '2026-10-02 10:48:14', 'superadmin', '2026-10-02 10:48:14', 'superadmin', 1);

-- Dumping structure for table simaset.role
CREATE TABLE IF NOT EXISTS `role` (
  `idrole` int NOT NULL AUTO_INCREMENT,
  `parent` int DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `createdby` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `updatedby` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`idrole`),
  UNIQUE KEY `uk_role_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table simaset.role: ~2 rows (approximately)
INSERT INTO `role` (`idrole`, `parent`, `name`, `title`, `description`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 0, 'superadmin', 'Super Admin', 'Akses penuh ke seluruh menu.', '2026-10-19 11:59:16', 'superadmin', '2026-10-19 11:59:21', 'superadmin', 1),
	(2, 0, 'administrator', 'Administrator', 'Akses penuh ke seluruh menu.', '2026-10-19 11:59:17', 'superadmin', '2026-10-19 11:59:21', 'superadmin', 1);

-- Dumping structure for table simaset.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `idrole` int DEFAULT NULL,
  `nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `createdby` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `updatedby` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_email` (`email`),
  KEY `idx_users_idrole` (`idrole`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`idrole`) REFERENCES `role` (`idrole`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table simaset.users: ~2 rows (approximately)
INSERT INTO `users` (`id`, `idrole`, `nama`, `email`, `password`, `created`, `createdby`, `updated`, `updatedby`, `status`) VALUES
	(1, 1, 'Super Admin', 'superall@gmail.com', '$2b$10$hkdBpIBGNBLHYhCbF9ffm.JXWQBJ5maOCSg/RFcbvkpqRWkAbFwRy', '2026-10-19 03:27:03', 'superadmin', '2026-10-19 11:58:59', 'superadmin', 1),
	(2, 2, 'Administrator', 'administrator@gmail.com', '$2b$10$hkdBpIBGNBLHYhCbF9ffm.JXWQBJ5maOCSg/RFcbvkpqRWkAbFwRy', '2026-10-10 08:00:00', 'superadmin', '2026-10-19 11:59:05', 'superadmin', 1);

-- Dumping structure for table simaset.user_access
CREATE TABLE IF NOT EXISTS `user_access` (
  `iduser_access` int NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `menu_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `access` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`iduser_access`),
  UNIQUE KEY `uk_user_access_menu` (`user_id`,`menu_name`),
  CONSTRAINT `fk_user_access_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table simaset.user_access: ~0 rows (approximately)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
