USE big_market;

INSERT INTO activity (activity_id, activity_name, activity_desc, begin_time, end_time, activity_count_id, strategy_id, state)
VALUES
    (1001, '测试活动', '测试活动描述', '2025-11-25 00:00:00', '2025-12-25 00:00:00', 1001, 100001, 'enable');

INSERT INTO activity_count (activity_count_id, total_count, day_count, month_count)
VALUES
    (1001, 5, 1, 2);

INSERT INTO activity_sku (sku, activity_id, activity_count_id, stock_amount, stock_surplus)
VALUES
    (2001, 1001, 1001, 100, 100);
