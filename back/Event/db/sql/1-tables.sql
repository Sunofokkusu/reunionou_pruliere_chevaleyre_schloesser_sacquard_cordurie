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
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `participant`;
CREATE TABLE `participant`(
    `id` UUID NOT NULL UNIQUE,
    `id_event` UUID NOT NULL,
    `id_user` UUID DEFAULT NULL,
    `name` VARCHAR(255) NOT NULL,
    `status` INT NOT NULL DEFAULT 0,
    `message` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`(
    `id` UUID NOT NULL UNIQUE,
    `id_event` UUID NOT NULL,
    `id_user` UUID DEFAULT NULL,
    `name` VARCHAR(255) NOT NULL,
    `comment` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;