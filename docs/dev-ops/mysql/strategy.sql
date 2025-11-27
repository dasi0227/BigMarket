USE big_market;

DROP TABLE IF EXISTS award;
CREATE TABLE award (
    id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '自增id',
    award_id     BIGINT UNIQUE NOT NULL UNIQUE COMMENT '奖品id',
    award_name   VARCHAR(32)   NOT NULL COMMENT '奖品名称',
    award_config VARCHAR(32)   NULL COMMENT '奖品配置',
    award_desc   VARCHAR(256)  NOT NULL COMMENT '奖品描述',
    create_time  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT ='奖品表';
INSERT INTO award (award_id, award_name, award_config, award_desc)
VALUES (2001, '测试奖品2001-随机积分', '1,100', '测试描述2001'),
       (2002, '测试奖品2002-2元优惠券', NULL, '测试描述2002'),
       (2003, '测试奖品2003-IPhone17', NULL, '测试描述2003');

DROP TABLE IF EXISTS strategy;
CREATE TABLE strategy (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '自增id',
    strategy_id   BIGINT UNIQUE NOT NULL UNIQUE COMMENT '策略id',
    strategy_desc VARCHAR(256)  NOT NULL COMMENT '策略描述',
    rule_models   VARCHAR(256)  NULL     COMMENT '规则列表',
    create_time   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT ='策略表';
INSERT INTO strategy (strategy_id, strategy_desc, rule_models)
VALUES (1001, '测试策略1001', 'rule_blacklist,rule_weight');

DROP TABLE IF EXISTS strategy_rule;
CREATE TABLE strategy_rule (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '自增id',
    strategy_id BIGINT          NOT NULL COMMENT '抽奖策略id',
    rule_desc   VARCHAR(256)    NOT NULL COMMENT '规则描述',
    rule_model  VARCHAR(32)     NOT NULL COMMENT '规则名',
    rule_value  VARCHAR(512)    NOT NULL COMMENT '规则值',
    create_time DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uq_strategy_id_rule_model (strategy_id, rule_model)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT ='策略规则表';
INSERT INTO strategy_rule (strategy_id, rule_model, rule_value, rule_desc)
VALUES (1001, 'rule_blacklist', '100:dasi', '黑名单：dasi'),
       (1001, 'rule_weight', '4000:2001,2002 5000:2002,2003', '权重：4000 和 5000');

DROP TABLE IF EXISTS strategy_award;
CREATE TABLE strategy_award (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '自增id',
    strategy_id   BIGINT         NOT NULL COMMENT '抽奖策略id',
    award_id      INT            NOT NULL COMMENT '抽奖奖品id',
    tree_id       VARCHAR(32)    NULL COMMENT '规则树id',
    award_title   VARCHAR(32)    NOT NULL COMMENT '抽奖奖品标题',
    award_total   INT            NOT NULL DEFAULT 0 COMMENT '奖品库存总量',
    award_surplus INT            NOT NULL DEFAULT 0 COMMENT '奖品库存余量',
    award_rate    DECIMAL(10, 6) NOT NULL DEFAULT 0 COMMENT '奖品中奖概率',
    create_time   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uq_strategy_id_award_id (strategy_id, award_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT ='策略奖品表';
INSERT INTO strategy_award (strategy_id, award_id, tree_id, award_title, award_total, award_surplus, award_rate)
VALUES (1001, 2001, 'tree_test','测试：策略1001奖品2001', 15, 15, 0.1500),
       (1001, 2002, 'tree_test','测试：策略1001奖品2002', 80, 80, 0.8000),
       (1001, 2003, 'tree_test','测试：策略1001奖品2003', 5, 5, 0.0500);

DROP TABLE IF EXISTS rule_tree;
CREATE TABLE rule_tree (
    id          BIGINT UNSIGNED    NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增id',
    tree_id     VARCHAR(32) UNIQUE NOT NULL COMMENT '规则树id',
    tree_name   VARCHAR(32)        NOT NULL COMMENT '规则树名称',
    tree_desc   VARCHAR(256)       NOT NULL COMMENT '规则树描述',
    tree_root   VARCHAR(32)        NOT NULL COMMENT '根节点规则',
    create_time DATETIME           NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT ='规则树表';
INSERT INTO rule_tree (tree_id, tree_name, tree_desc, tree_root)
VALUES ('tree_test', '测试规则树tree_test', '测试规则树描述tree_test', 'rule_lock');

DROP TABLE IF EXISTS rule_node;
CREATE TABLE rule_node (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增id',
    tree_id     VARCHAR(32)     NOT NULL COMMENT '规则树id',
    rule_desc   VARCHAR(256)    NOT NULL COMMENT '规则树节点描述',
    rule_model  VARCHAR(32)     NOT NULL COMMENT '规则树节点模型',
    rule_value  VARCHAR(512)    NULL DEFAULT NULL COMMENT '规则树节点值',
    create_time DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT ='规则树节点表';
INSERT INTO rule_node (tree_id, rule_model, rule_desc, rule_value)
VALUES ('tree_test', 'rule_lock', '达到一定次数解锁', '3'),
       ('tree_test', 'rule_luck', '幸运奖品', '2001'),
       ('tree_test', 'rule_stock', '库存扣减', NULL);

DROP TABLE IF EXISTS rule_edge;
CREATE TABLE rule_edge (
    id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '自增id',
    tree_id           VARCHAR(32)     NOT NULL COMMENT '规则树id',
    rule_node_from    VARCHAR(32)     NOT NULL COMMENT '规则边起点',
    rule_node_to      VARCHAR(32)     NOT NULL COMMENT '规则边终点',
    rule_check_type   VARCHAR(32)     NOT NULL COMMENT '规则检查类型',
    rule_check_result VARCHAR(32)     NOT NULL COMMENT '规则检查结果',
    create_time       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT ='规则树边表';
INSERT INTO rule_edge (tree_id, rule_node_from, rule_node_to, rule_check_type, rule_check_result)
VALUES ('tree_test', 'rule_lock', 'rule_stock', 'EQUAL', 'PERMIT'),
       ('tree_test', 'rule_lock', 'rule_luck', 'EQUAL', 'CAPTURE'),
       ('tree_test', 'rule_stock', 'rule_luck', 'EQUAL', 'PERMIT');
