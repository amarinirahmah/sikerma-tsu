-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Apr 2025 pada 13.33
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sikerma`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `daftar_kerja_sama`
--

CREATE TABLE `daftar_kerja_sama` (
  `id_kerja_sama` int(11) NOT NULL,
  `nama_mitra` varchar(100) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_berakhir` date NOT NULL,
  `status` enum('aktif','nonaktif') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `daftar_notifikasi`
--

CREATE TABLE `daftar_notifikasi` (
  `id_notifikasi` int(11) NOT NULL,
  `notifikasi` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `daftar_progres`
--

CREATE TABLE `daftar_progres` (
  `id_progres` int(11) NOT NULL,
  `nama_mitra` varchar(100) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_berakhir` date NOT NULL,
  `status` enum('aktif','nonaktif') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_progres`
--

CREATE TABLE `detail_progres` (
  `id_detail` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `aktivitas` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `mitra`
--

CREATE TABLE `mitra` (
  `id_mitra` int(11) NOT NULL,
  `nama_mitra` varchar(100) NOT NULL,
  `alamat` text NOT NULL,
  `kontak` varchar(20) NOT NULL,
  `status` enum('aktif','nonaktif') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `unit`
--

CREATE TABLE `unit` (
  `id_unit` int(11) NOT NULL,
  `id_mitra` int(11) NOT NULL,
  `nama_unit` varchar(100) NOT NULL,
  `jenis_unit` varchar(50) NOT NULL,
  `status` enum('aktif','nonaktif') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `upload_mou`
--

CREATE TABLE `upload_mou` (
  `nomor_mou` int(11) NOT NULL,
  `nama_mitra` varchar(100) NOT NULL,
  `judul` varchar(250) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_berakhir` date NOT NULL,
  `upload_file` varchar(255) NOT NULL,
  `tujuan` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `upload_pks`
--

CREATE TABLE `upload_pks` (
  `nomor_pks` int(11) NOT NULL,
  `nomor_mou` int(11) NOT NULL,
  `judul` varchar(250) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_berakhir` date NOT NULL,
  `nama_unit` varchar(50) NOT NULL,
  `uoload_file` varchar(255) NOT NULL,
  `tujuan` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` enum('admin','pimpinan') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `daftar_kerja_sama`
--
ALTER TABLE `daftar_kerja_sama`
  ADD PRIMARY KEY (`id_kerja_sama`);

--
-- Indeks untuk tabel `daftar_notifikasi`
--
ALTER TABLE `daftar_notifikasi`
  ADD PRIMARY KEY (`id_notifikasi`);

--
-- Indeks untuk tabel `daftar_progres`
--
ALTER TABLE `daftar_progres`
  ADD PRIMARY KEY (`id_progres`);

--
-- Indeks untuk tabel `detail_progres`
--
ALTER TABLE `detail_progres`
  ADD PRIMARY KEY (`id_detail`);

--
-- Indeks untuk tabel `mitra`
--
ALTER TABLE `mitra`
  ADD PRIMARY KEY (`id_mitra`);

--
-- Indeks untuk tabel `unit`
--
ALTER TABLE `unit`
  ADD PRIMARY KEY (`id_unit`),
  ADD KEY `id_mitra` (`id_mitra`);

--
-- Indeks untuk tabel `upload_mou`
--
ALTER TABLE `upload_mou`
  ADD PRIMARY KEY (`nomor_mou`);

--
-- Indeks untuk tabel `upload_pks`
--
ALTER TABLE `upload_pks`
  ADD PRIMARY KEY (`nomor_pks`),
  ADD KEY `nomor_mou` (`nomor_mou`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `unit`
--
ALTER TABLE `unit`
  ADD CONSTRAINT `unit_ibfk_1` FOREIGN KEY (`id_mitra`) REFERENCES `mitra` (`id_mitra`);

--
-- Ketidakleluasaan untuk tabel `upload_pks`
--
ALTER TABLE `upload_pks`
  ADD CONSTRAINT `upload_pks_ibfk_1` FOREIGN KEY (`nomor_mou`) REFERENCES `upload_mou` (`nomor_mou`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
