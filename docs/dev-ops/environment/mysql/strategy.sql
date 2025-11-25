DROP TABLE IF EXISTS strategy;
CREATE TABLE strategy (
    id BIGINT AUTO_INCREMENT COMMENT '自增ID',
    strategy_id BIGINT NOT NULL UNIQUE COMMENT '抽奖策略ID',
    strategy_desc VARCHAR(256) COMMENT '抽奖策略描述',
    rule_models VARCHAR(512) COMMENT '抽奖策略模型',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='抽奖策略表';
INSERT INTO strategy (strategy_id, strategy_desc, rule_models)
VALUES
    (1001, '测试策略', 'rule_blacklist,rule_weight');

DROP TABLE IF EXISTS strategy_rule;
CREATE TABLE strategy_rule (
    id BIGINT AUTO_INCREMENT COMMENT '自增ID',
    strategy_id BIGINT NOT NULL COMMENT '抽奖策略ID',
    rule_desc VARCHAR(256) COMMENT '规则描述',
    rule_model VARCHAR(128) NOT NULL COMMENT '规则模型',
    rule_value VARCHAR(256) COMMENT '规则值',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_strategy_id (strategy_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='抽奖策略规则表';
INSERT INTO strategy_rule (strategy_id, rule_model, rule_value, rule_desc)
VALUES
    (1001, 'rule_blacklist', '100:dasi', '黑名单：dasi'),
    (1001, 'rule_weight', '4000:2001,2002 5000:2002,2003', '权重：4000 和 5000');

DROP TABLE IF EXISTS strategy_award;
CREATE TABLE strategy_award (
    id BIGINT AUTO_INCREMENT COMMENT '自增ID',
    strategy_id BIGINT NOT NULL COMMENT '抽奖策略ID',
    award_id INT NOT NULL COMMENT '抽奖奖品ID',
    award_title VARCHAR(256) COMMENT '抽奖奖品标题',
    award_total INT NOT NULL DEFAULT 0 COMMENT '奖品库存总量',
    award_surplus INT NOT NULL DEFAULT 0 COMMENT '奖品库存余量',
    award_rate DECIMAL(10,6) NOT NULL DEFAULT 0 COMMENT '奖品中奖概率',
    tree_id VARCHAR(64) COMMENT '规则树ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_strategy_id (strategy_id),
    KEY idx_award_id (award_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='抽奖策略奖品表';
INSERT INTO strategy_award
(strategy_id, award_id, award_title, award_total, award_surplus, award_rate, tree_id)
VALUES
    (1001, 2001, '测试策略奖品2001', 15, 15, 0.1500, 'tree_test'),
    (1001, 2002, '测试策略奖品2002', 80, 80, 0.8000, 'tree_test'),
    (1001, 2003, '测试策略奖品2003', 5, 5, 0.0500, 'tree_test');

DROP TABLE IF EXISTS award;
CREATE TABLE award (
    id INT AUTO_INCREMENT COMMENT '自增ID',
    award_id INT NOT NULL UNIQUE COMMENT '抽奖奖品ID',
    award_name VARCHAR(128) COMMENT '奖品名称',
    award_config VARCHAR(128) COMMENT '奖品配置',
    award_desc VARCHAR(255) COMMENT '奖品描述',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='奖品表';
INSERT INTO award (award_id, award_name, award_config, award_desc)
VALUES
    (2001, '测试奖品-随机积分', '1,100', '测试描述'),
    (2002, '测试奖品-2元优惠券', NULL, '测试描述'),
    (2003, '测试奖品-IPhone17', NULL, '测试描述');

DROP TABLE IF EXISTS rule_tree;
CREATE TABLE `rule_tree` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
    `tree_id` varchar(64) NOT NULL COMMENT '规则树业务ID',
    `tree_name` varchar(128) DEFAULT NULL COMMENT '规则树名称',
    `tree_desc` varchar(255) DEFAULT NULL COMMENT '规则树描述',
    `tree_root` varchar(64) NOT NULL COMMENT '规则树根节点的规则模型',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `tree_id` (`tree_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='规则树表';
INSERT INTO rule_tree (tree_id, tree_name, tree_desc, tree_root)
VALUES
    ('tree_test', '测试规则树', '测试规则树', 'rule_lock');

DROP TABLE IF EXISTS rule_node;
CREATE TABLE `rule_node` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
    `tree_id` varchar(64) NOT NULL COMMENT '规则树ID',
    `rule_model` varchar(64) NOT NULL COMMENT '规则模型',
    `rule_desc` varchar(255) DEFAULT NULL COMMENT '规则描述',
    `rule_value` varchar(255) DEFAULT NULL COMMENT '规则值',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='规则树节点表';
INSERT INTO rule_node (tree_id, rule_model, rule_desc, rule_value)
VALUES
    ('tree_test', 'rule_lock', '达到一定次数解锁', '3'),
    ('tree_test', 'rule_luck', '幸运奖品', '2001'),
    ('tree_test', 'rule_stock', '库存扣减', NULL);

DROP TABLE IF EXISTS rule_edge;
CREATE TABLE `rule_edge` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
    `tree_id` varchar(64) NOT NULL COMMENT '规则树ID',
    `rule_node_from` varchar(64) NOT NULL COMMENT '规则边起点',
    `rule_node_to` varchar(64) NOT NULL COMMENT '规则边终点',
    `rule_check_type` varchar(32) NOT NULL COMMENT '规则检查类型',
    `rule_check_result` varchar(32) NOT NULL COMMENT '规则检查结果',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='规则树边表';
INSERT INTO rule_edge (tree_id, rule_node_from, rule_node_to, rule_check_type, rule_check_result)
VALUES
    ('tree_test', 'rule_lock', 'rule_stock', 'EQUAL', 'PERMIT'),
    ('tree_test', 'rule_lock', 'rule_luck', 'EQUAL', 'CAPTURE'),
    ('tree_test', 'rule_stock', 'rule_luck', 'EQUAL', 'PERMIT');
