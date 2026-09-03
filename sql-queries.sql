-- ====================================================================
-- Учебный проект: SQL-запросы для Support Engineer
-- Практика выполнена на SQLiteOnline (https://sqliteonline.com/)
-- Цель: Отработать навыки работы с базами данных для диагностики 
-- проблем пользователей, заказов и системных ошибок.
-- ====================================================================

-- ШАГ 1: Создание тестовой базы данных
-- Я создал две таблицы: users (пользователи) и orders (заказы)
-- и заполнил их тестовыми данными для практики.

-- Таблица пользователей
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT,
    status TEXT,
    created_at TEXT
);

INSERT INTO users VALUES (1, 'Иван Иванов', 'ivan@example.com', 'active', '2026-01-15');
INSERT INTO users VALUES (2, 'Мария Петрова', 'maria@example.com', 'active', '2026-02-20');
INSERT INTO users VALUES (3, 'Алексей Сидоров', 'alexey@example.com', 'blocked', '2026-03-10');
INSERT INTO users VALUES (4, 'Ольга Смирнова', 'olga@example.com', 'active', '2026-04-05');

-- Таблица заказов
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    amount REAL,
    status TEXT,
    error_message TEXT,
    created_at TEXT
);

INSERT INTO orders VALUES (101, 1, 1500.00, 'completed', NULL, '2026-09-01');
INSERT INTO orders VALUES (102, 2, 2300.50, 'failed', 'Payment declined', '2026-09-02');
INSERT INTO orders VALUES (103, 1, 890.00, 'completed', NULL, '2026-09-02');
INSERT INTO orders VALUES (104, 3, 5000.00, 'failed', 'User blocked', '2026-09-03');
INSERT INTO orders VALUES (105, 4, 1200.00, 'pending', NULL, '2026-09-03');

-- ====================================================================
-- ШАГ 2: Выполнение практических запросов
-- ====================================================================

-- ЗАПРОС 1: Поиск пользователя по email
-- Задача: Пользователь жалуется, что не может войти. Нужно найти его в базе.
SELECT id, name, email, status, created_at 
FROM users 
WHERE email = 'ivan@example.com';
-- Результат: нашёл Ивана Иванова (id=1, статус active)

-- ЗАПРОС 2: Проверка последних заказов пользователя
-- Задача: Пользователь говорит "мой заказ не прошёл". Проверяем его историю.
SELECT o.id, o.status, o.amount, o.created_at 
FROM orders o
WHERE o.user_id = 1
ORDER BY o.created_at DESC
LIMIT 10;
-- Результат: увидел 2 completed заказа Ивана на 1500 и 890 рублей

-- ЗАПРОС 3: Поиск заказов с ошибками (статус 'failed')
-- Задача: Разобрать массовую жалобу на сбои оплаты за сегодня.
SELECT id, user_id, amount, error_message, created_at 
FROM orders 
WHERE status = 'failed' 
ORDER BY created_at DESC;
-- Результат: нашёл 2 failed-заказа (Мария - Payment declined, Алексей - User blocked)

-- ЗАПРОС 4: Подсчёт ошибок по типам (агрегация)
-- Задача: Понять, какая ошибка встречается чаще всего.
SELECT error_message, COUNT(*) as error_count 
FROM orders 
WHERE status = 'failed'
GROUP BY error_message
ORDER BY error_count DESC;
-- Результат: увидел распределение ошибок по типам

-- ЗАПРОС 5: Поиск дубликатов email
-- Задача: Найти технические сбои, из-за которых создались дубликаты аккаунтов.
SELECT email, COUNT(*) as duplicate_count 
FROM users 
GROUP BY email 
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- Результат: дубликатов не найдено (все email уникальны)

-- ====================================================================
-- ЧЕМУ Я НАУЧИЛСЯ:
-- 1. Использовать WHERE для фильтрации данных по конкретному пользователю или дате.
-- 2. Применять ORDER BY и LIMIT для сортировки и ограничения результатов.
-- 3. Использовать GROUP BY и COUNT для анализа массовых инцидентов.
-- 4. Применять HAVING для фильтрации после группировки.
-- 5. Понимать, как с помощью SQL можно быстро проверить гипотезу 
--    ("проблема у одного пользователя или массовая?").
-- ====================================================================

-- ПОЧЕМУ ЭТО ВАЖНО ДЛЯ SUPPORT ENGINEER:
-- При обращении пользователя инженер поддержки должен:
-- 1. Найти пользователя в базе по email или ID
-- 2. Проверить его историю действий (заказы, логины, платежи)
-- 3. Определить, проблема индивидуальная или массовая
-- 4. Передать разработчикам конкретные данные, а не "всё сломалось"
-- Эти навыки я отработал в данном проекте на SQLiteOnline.

-- ССЫЛКИ ДЛЯ ИЗУЧЕНИЯ:
-- SQLiteOnline: https://sqliteonline.com/
-- SQL Tutorial: https://www.w3schools.com/sql/
-- SQL Practice: https://sql-ex.ru/
