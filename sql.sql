-- Dumping structure for table server.salon
CREATE TABLE IF NOT EXISTS `salon` (
  `imevozila` mediumtext DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `cena` int(11) DEFAULT NULL,
  `stanje` int(11) DEFAULT NULL,
  `slika` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table server.salon: ~2 rows (approximately)
/*!40000 ALTER TABLE `salon` DISABLE KEYS */;
INSERT INTO `salon` (`imevozila`, `model`, `cena`, `stanje`, `slika`) VALUES
	('Sultan', 'sultan', 150000, 10, 'https://cdn.discordapp.com/attachments/885475573604954145/1047194092771225703/unknown.png'),
	('Sanchez', 'sanchez', 50000, 0, NULL);
/*!40000 ALTER TABLE `salon` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
