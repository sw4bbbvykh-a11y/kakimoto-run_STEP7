-- 設問1：すべてのユーザー情報を取得するSQL
SELECT * FROM users;

-- 設問2：2024年に作成されたユーザーを取得するSQL
SELECT * FROM users WHERE created_at LIKE '2024%';

-- 設問3：30歳未満かつ女性のユーザーを取得するSQL
SELECT * FROM users WHERE age < 30 AND gender = 'female';

-- 設問4：全商品の一覧（商品名と価格）を取得するSQL
SELECT product_name, price FROM products;

-- 設問5：ordersとusersを結合し、ユーザー名と注文日を取得するSQL
SELECT users.name, orders.order_date FROM orders JOIN users ON orders.user_id = users.id;

-- 設問6：order_itemsとproductsを結合し、各明細ごとに商品名と数量、単価、金額（単価✕数量）を取得するSQL
SELECT products.product_name, order_items.quantity, products.price, (products.price * order_items.quantity) AS amount FROM order_items JOIN products ON order_items.product_id = products.id;

-- 設問7：ユーザーごとの注文件数を取得するSQL
SELECT users.name, COUNT(orders.id) AS order_count FROM users LEFT JOIN orders ON users.id = orders.user_id GROUP BY users.id, users.name;

-- 設問8：各ユーザーの総入金額（明細の合計）を取得するSQL
SELECT users.name, SUM(products.price * order_items.quantity) AS total_amount FROM users LEFT JOIN orders ON users.id = orders.user_id LEFT JOIN order_items ON orders.id = order_items.order_id LEFT JOIN products ON order_items.product_id = products.id GROUP BY users.id, users.name;

-- 設問9：最も注文金額が高かったユーザーの名前と金額を取得するSQL
SELECT users.name, SUM(products.price * order_items.quantity) AS total_amount FROM users JOIN orders ON users.id = orders.user_id JOIN order_items ON orders.id = order_items.order_id JOIN products ON order_items.product_id = products.id GROUP BY users.id, users.name ORDER BY total_amount DESC LIMIT 1;

-- 設問10：各商品が何回注文されたか（order_itemsの合計数量）を取得するSQL
SELECT products.product_name, SUM(order_items.quantity) AS total_quantity FROM products LEFT JOIN order_items ON products.id = order_items.product_id GROUP BY products.id, products.product_name;

-- 設問11：注文が1回もないユーザーを取得するSQL
SELECT users.* FROM users LEFT JOIN orders ON users.id = orders.user_id WHERE orders.id IS NULL;

-- 設問12：1回の注文で2種類以上の商品を購入した注文のIDを取得するSQL
SELECT order_id FROM order_items GROUP BY order_id HAVING COUNT(DISTINCT product_id) >= 2;

-- 設問13：「テレビ」という商品を注文したすべてのユーザー名を取得するSQL
SELECT DISTINCT users.name FROM users JOIN orders ON users.id = orders.user_id JOIN order_items ON orders.id = order_items.order_id JOIN products ON order_items.product_id = products.id WHERE products.product_name = 'テレビ';

-- 設問14：明細ごとの注文日・ユーザー名・商品名・数量・合計金額を一覧で取得するSQL
SELECT orders.order_date, users.name, products.product_name, order_items.quantity, (products.price * order_items.quantity) AS total_price FROM order_items JOIN orders ON order_items.order_id = orders.id JOIN users ON orders.user_id = users.id JOIN products ON order_items.product_id = products.id;

-- 設問15：最も多く購入された商品（数量ベース）の商品名を取得するSQL
SELECT products.product_name FROM order_items JOIN products ON order_items.product_id = products.id GROUP BY products.id, products.product_name ORDER BY SUM(order_items.quantity) DESC LIMIT 1;

-- 設問16：各月の注文件数を取得するSQL（order_dateの年月を使う）
SELECT SUBSTRING(order_date, 1, 7) AS order_month, COUNT(*) AS order_count FROM orders GROUP BY order_month;

-- 設問17：注文のない商品を取得するSQL
SELECT products.* FROM products LEFT JOIN order_items ON products.id = order_items.product_id WHERE order_items.product_id IS NULL;

-- 設問18：order_items.product_id にインデックスを追加するSQL
ALTER TABLE order_items ADD INDEX idx_product_id (product_id);

-- 設問19：ユーザーごとの平均注文金額を取得するSQL
SELECT users.name, AVG(order_totals.order_amount) AS avg_order_amount FROM users JOIN (SELECT orders.id, orders.user_id, SUM(products.price * order_items.quantity) AS order_amount FROM orders JOIN order_items ON orders.id = order_items.order_id JOIN products ON order_items.product_id = products.id GROUP BY orders.id, orders.user_id) AS order_totals ON users.id = order_totals.user_id GROUP BY users.id, users.name;

-- 設問20：各ユーザーの最新注文日のみを取得するSQL
SELECT users.name, MAX(orders.order_date) AS latest_order_date FROM users LEFT JOIN orders ON users.id = orders.user_id GROUP BY users.id, users.name;

-- 設問21：新規ユーザー「中村（25歳・女性・2025-06-01作成）」をusersテーブルに追加するSQL
INSERT INTO users (name, age, gender, created_at) VALUES ('中村', 25, 'female', '2025-06-01');

-- 設問22：商品「エアコン（価格：60000円）」をproductsテーブルに追加するSQL
INSERT INTO products (product_name, price) VALUES ('エアコン', 60000);

-- 設問23：ユーザーIDが1の人が2025-06-10に行った新しい注文（orders）を追加するSQL（注文IDは10）
INSERT INTO orders (id, user_id, order_date) VALUES (10, 1, '2025-06-10');

-- 設問24：上記の注文（注文ID：10）に対して、「エアコン（商品ID：6）」を1つ購入したことを表すorder_itemsを追加するSQL
INSERT INTO order_items (id, order_id, product_id, quantity) VALUES (DEFAULT, 10, 6, 1);

-- 設問25：ユーザー「田中美咲」の年齢を23歳から24歳に更新するSQL
UPDATE users SET age = 24 WHERE name = '田中美咲';

-- 設問26：全ての商品価格を10%値上げするSQL
UPDATE products SET price = price * 1.1;

-- 設問27：2024年5月以前（5月1日より前）に行われた注文のorder_dateをすべて「2024-05-01」に統一するSQL
UPDATE orders SET order_date = '2024-05-01' WHERE order_date < '2024-05-01';

-- 設問28：ユーザー名が「高橋健一」のレコードをusersテーブルから削除するSQL
DELETE FROM users WHERE name = '高橋健一';

-- 設問29：注文IDが5の明細（order_items）をすべて削除するSQL
DELETE FROM order_items WHERE order_id = 5;

-- 設問30：一度も注文されたことのない商品をproductsテーブルから削除するSQL
DELETE FROM products WHERE id NOT IN (SELECT product_id FROM (SELECT product_id FROM order_items) AS tmp);