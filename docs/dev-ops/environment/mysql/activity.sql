/* ============================
主库 big_market
============================ */
USE big_market;

/* 活动表 */
DROP TABLE IF EXISTS activity;
CREATE TABLE `activity` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `activity_id` BIGINT NOT NULL,
    `activity_name` VARCHAR(64) NOT NULL,
    `activity_desc` VARCHAR(128) NOT NULL,
    `begin_date_time` DATETIME NOT NULL,
    `end_date_time` DATETIME NOT NULL,
    `stock_count` INT NOT NULL,
    `stock_count_surplus` INT NOT NULL,
    `activity_count_id` BIGINT NOT NULL,
    `strategy_id` BIGINT NOT NULL,
    `state` VARCHAR(8) NOT NULL,
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_activity_id` (`activity_id`),
    KEY `idx_begin_date_time` (`begin_date_time`),
    KEY `idx_end_date_time` (`end_date_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动表';
INSERT INTO activity (activity_id, activity_name, activity_desc, begin_date_time, end_date_time, stock_count, stock_count_surplus, activity_count_id, strategy_id, state)
VALUES
    (1001, '测试活动', '测试活动描述', '2025-11-25 00:00:00', '2025-12-25 00:00:00', 100, 100, 1001, 100001, 'enable');

/* 活动次数配置 */
DROP TABLE IF EXISTS activity_count;
CREATE TABLE `activity_count` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `activity_count_id` BIGINT NOT NULL,
    `total_count` INT NOT NULL,
    `day_count` INT NOT NULL,
    `month_count` INT NOT NULL,
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_activity_count_id` (`activity_count_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动次数配置表';

/* 订单（主库版） */
DROP TABLE IF EXISTS activity_order;
CREATE TABLE `activity_order` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` VARCHAR(32) NOT NULL,
    `activity_id` BIGINT NOT NULL,
    `activity_name` VARCHAR(64) NOT NULL,
    `strategy_id` BIGINT NOT NULL,
    `order_id` VARCHAR(12) NOT NULL,
    `order_time` DATETIME NOT NULL,
    `state` VARCHAR(8) NOT NULL,
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_order_id` (`order_id`),
    KEY `idx_user_id_activity_id` (`user_id`, `activity_id`, `state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动订单（主库）';

/* 活动账户（主库版） */
DROP TABLE IF EXISTS activity_account;
CREATE TABLE `activity_account` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` VARCHAR(32) NOT NULL,
    `activity_id` BIGINT NOT NULL,
    `total_count` INT NOT NULL,
    `total_count_surplus` INT NOT NULL,
    `day_count` INT NOT NULL,
    `day_count_surplus` INT NOT NULL,
    `month_count` INT NOT NULL,
    `month_count_surplus` INT NOT NULL,
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_user_id_activity_id` (`user_id`,`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动账户表';

/* 流水（主库版） */
DROP TABLE IF EXISTS activity_flow;
CREATE TABLE `activity_flow` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` VARCHAR(32) NOT NULL,
    `activity_id` BIGINT NOT NULL,
    `total_count` INT NOT NULL,
    `day_count` INT NOT NULL,
    `month_count` INT NOT NULL,
    `flow_id` VARCHAR(32) NOT NULL,
    `flow_channel` VARCHAR(12) NOT NULL DEFAULT 'activity',
    `biz_id` VARCHAR(12) NOT NULL,
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_flow_id` (`flow_id`),
    UNIQUE KEY `uq_biz_id` (`biz_id`),
    KEY `idx_user_id_activity_id` (`user_id`,`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动流水表';


/* ============================
分库 big_market_01
============================ */
DROP DATABASE IF EXISTS big_market_01;
CREATE DATABASE big_market_01 DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
USE big_market_01;

/* 四个订单分表 */
CREATE TABLE activity_order_000 LIKE big_market.activity_order;
CREATE TABLE activity_order_001 LIKE big_market.activity_order;
CREATE TABLE activity_order_002 LIKE big_market.activity_order;
CREATE TABLE activity_order_003 LIKE big_market.activity_order;

/* 四个流水分表 */
CREATE TABLE activity_flow_000 LIKE big_market.activity_flow;
CREATE TABLE activity_flow_001 LIKE big_market.activity_flow;
CREATE TABLE activity_flow_002 LIKE big_market.activity_flow;
CREATE TABLE activity_flow_003 LIKE big_market.activity_flow;

/* 账户不分表（每库一张） */
CREATE TABLE activity_account LIKE big_market.activity_account;


/* ============================
分库 big_market_02
============================ */
DROP DATABASE IF EXISTS big_market_02;
CREATE DATABASE big_market_02 DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
USE big_market_02;

/* 四个订单分表 */
CREATE TABLE activity_order_000 LIKE big_market.activity_order;
CREATE TABLE activity_order_001 LIKE big_market.activity_order;
CREATE TABLE activity_order_002 LIKE big_market.activity_order;
CREATE TABLE activity_order_003 LIKE big_market.activity_order;

/* 四个流水分表 */
CREATE TABLE activity_flow_000 LIKE big_market.activity_flow;
CREATE TABLE activity_flow_001 LIKE big_market.activity_flow;
CREATE TABLE activity_flow_002 LIKE big_market.activity_flow;
CREATE TABLE activity_flow_003 LIKE big_market.activity_flow;

/* 账户不分表 */
CREATE TABLE activity_account LIKE big_market.activity_account;