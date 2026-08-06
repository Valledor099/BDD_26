use classicmodels;

DELETE FROM payments;
SELECT * FROM payments;

SHOW MASTER STATUS;

SHOW BINLOG EVENTS in 'binlog.000293' LIMIT 10;

use mysql;
SELECT * FROM performance_schema.error_log
ORDER BY LOGGED DESC
LIMIT 20;


SHOW TABLES FROM performance_schema LIKE '%error%';
