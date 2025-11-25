CREATE TABLE `raffle_activity` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    `activity_id` BIGINT NOT NULL COMMENT '活动ID',
    `activity_name` VARCHAR(64) NOT NULL COMMENT '活动名称',
    `activity_desc` VARCHAR(128) NOT NULL COMMENT '活动描述',
    `begin_date_time` DATETIME NOT NULL COMMENT '开始时间',
    `end_date_time` DATETIME NOT NULL COMMENT '结束时间',
    `stock_count` INT NOT NULL COMMENT '库存总量',
    `stock_count_surplus` INT NOT NULL COMMENT '剩余库存',
    `activity_count_id` BIGINT NOT NULL COMMENT '活动参与次数配置',
    `strategy_id` BIGINT NOT NULL COMMENT '抽奖策略ID',
    `state` VARCHAR(8) NOT NULL COMMENT '活动状态',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uq_activity_id` (`activity_id`),
    KEY `idx_begin_date_time` (`begin_date_time`),
    KEY `idx_end_date_time` (`end_date_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动表';

CREATE TABLE `raffle_activity_count` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    `activity_count_id` BIGINT NOT NULL COMMENT '活动次数编号',
    `total_count` INT NOT NULL COMMENT '总次数',
    `day_count` INT NOT NULL COMMENT '日次数',
    `month_count` INT NOT NULL COMMENT '月次数',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uq_activity_count_id` (`activity_count_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动次数配置表';

CREATE TABLE `raffle_activity_order` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    `user_id` VARCHAR(32) NOT NULL COMMENT '用户ID',
    `activity_id` BIGINT NOT NULL COMMENT '活动ID',
    `activity_name` VARCHAR(64) NOT NULL COMMENT '活动名称',
    `strategy_id` BIGINT NOT NULL COMMENT '抽奖策略ID',
    `order_id` VARCHAR(12) NOT NULL COMMENT '订单ID',
    `order_time` DATETIME NOT NULL COMMENT '下单时间',
    `state` VARCHAR(8) NOT NULL COMMENT '订单状态（not_used、used、expire）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uq_order_id` (`order_id`),
    KEY `idx_user_id_activity_id` (`user_id`, `activity_id`, `state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动单';


CREATE TABLE `raffle_activity_account` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    `user_id` VARCHAR(32) NOT NULL COMMENT '用户ID',
    `activity_id` BIGINT NOT NULL COMMENT '活动ID',
    `total_count` INT NOT NULL COMMENT '总次数',
    `total_count_surplus` INT NOT NULL COMMENT '总次数-剩余',
    `day_count` INT NOT NULL COMMENT '日次数',
    `day_count_surplus` INT NOT NULL COMMENT '日次数-剩余',
    `month_count` INT NOT NULL COMMENT '月次数',
    `month_count_surplus` INT NOT NULL COMMENT '月次数-剩余',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uq_user_id_activity_id` (`user_id`,`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动账户表';


CREATE TABLE `raffle_activity_account_flow` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    `user_id` VARCHAR(32) NOT NULL COMMENT '用户ID',
    `activity_id` BIGINT NOT NULL COMMENT '活动ID',
    `total_count` INT NOT NULL COMMENT '总次数',
    `day_count` INT NOT NULL COMMENT '日次数',
    `month_count` INT NOT NULL COMMENT '月次数',
    `flow_id` VARCHAR(32) NOT NULL COMMENT '流水ID - 生成的唯一ID',
    `flow_channel` VARCHAR(12) NOT NULL DEFAULT 'activity' COMMENT '流水渠道（activity-活动领取、sale-购买、redeem-兑换、free-免费赠送）',
    `biz_id` VARCHAR(12) NOT NULL COMMENT '业务ID（外部透传，活动ID、订单ID）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uq_flow_id` (`flow_id`),
    UNIQUE KEY `uq_biz_id` (`biz_id`),
KEY `idx_user_id_activity_id` (`user_id`,`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='抽奖活动账户流水表';