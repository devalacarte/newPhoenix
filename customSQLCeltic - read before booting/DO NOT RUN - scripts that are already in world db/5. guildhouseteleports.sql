-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server versie:                5.5.28 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Versie:              8.0.0.4396
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Structuur van  tabel worlddk.guildhouses wordt geschreven
DROP TABLE IF EXISTS `guildhouses`;
CREATE TABLE IF NOT EXISTS `guildhouses` (
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `guildId` bigint(20) NOT NULL DEFAULT '0',
  `x` double NOT NULL,
  `y` double NOT NULL,
  `z` double NOT NULL,
  `map` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumpen data van tabel worlddk.guildhouses: 11 rows
/*!40000 ALTER TABLE `guildhouses` DISABLE KEYS */;
INSERT INTO `guildhouses` (`id`, `guildId`, `x`, `y`, `z`, `map`, `comment`) VALUES
	(1, 1885, 16222, 16266, 14.2, 1, 'Phoenix Staff'),
	(2, 2284, 4664.617188, -4448.211914, 1106.204346, 1, 'Sry Baby I\'m On Cooldown'),
	(3, 2570, 4441.695801, -4343.533203, 1054.394165, 1, 'BangBros'),
	(4, 2332, 4792.285156, -4267.123535, 1053.313843, 1, 'AoD Code Red'),
	(5, 1718, 4501.53227, -4667.985352, 1145.849854, 1, 'Apocalypse'),
	(6, 2513, 4815.356934, -4757.008301, 1169.549072, 1, 'Time For Plan B'),
	(7, 795, 4498.958008, -4045.785156, 1168.350708, 1, 'Will Kill For Cheese'),
	(8, 2359, 5037.613281, -4241.950684, 1238.906494, 1, 'We make our rules'),
	(9, 2002, 5099.126465, -4555.067383, 1194.254883, 1, 'Kamikaze'),
	(10, 1942, 5247.26, -5001.6, 1209.4, 1, 'La Costa Nostra'),
	(11, 2555, 4585.98877, -4296.396973, 1222.457764, 1, 'Killing Squad Instinct');
/*!40000 ALTER TABLE `guildhouses` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
