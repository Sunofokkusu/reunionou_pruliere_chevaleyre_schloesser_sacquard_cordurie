DROP TABLE IF EXISTS `events`;
CREATE TABLE `events`(
    `id` UUID NOT NULL UNIQUE,
    `id_creator` UUID NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `adress` VARCHAR(255) NOT NULL,
    `description` TEXT ,
    `date` DATETIME NOT NULL,
    `lat` FLOAT NOT NULL,
    `long` FLOAT NOT NULL,
    `token` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;