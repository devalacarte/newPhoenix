CREATE TABLE IF NOT EXISTS `pve_reports` (
  `KillerName` char(50) DEFAULT NULL,
  `KillerGuid` int(10) DEFAULT NULL,
  `KillerAccount` int(10) DEFAULT NULL,
  `ItemEntry` int(10) DEFAULT NULL,
  `ItemGuid` int(10) DEFAULT NULL,
  `KilledName` char(50) DEFAULT NULL,
  `KilledGuid` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `character_gm_rights` (
  `guid` int(10) DEFAULT NULL,
  `accountId` int(10) DEFAULT NULL,
  `comment` char(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
