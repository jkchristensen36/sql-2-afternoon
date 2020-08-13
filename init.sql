-- PRACTICE JOINS

-- #1
SELECT *
FROM invoice i
JOIN invoice_line il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;

-- #2
SELECT i.invoice_date, c.first_name, c.last_name
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;

-- #3
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;

-- #4
SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id 

-- #5
SELECT pt.track_id
FROM playlist_track pt
JOIN playlist pl ON pl.playlist_id = pt.playlist_id
WHERE pl.name = 'Music';

-- #6
SELECT tr.name
FROM track tr
JOIN playlist_track pt ON pt.track_id = tr.track_id
WHERE pt.playlist_id = 5;

-- #7
SELECT tr.name, pl.name
FROM track tr
JOIN playlist_track pt ON tr.track_id = pt.track_id
JOIN playlist pl ON pt.playlist_id = pl.playlist_id;

-- #8
SELECT tr.name, al.title
FROM track tr
JOIN album al ON tr.album_id = al.album_id
JOIN genre g ON g.genre_id = tr.genre_id
WHERE g.name = 'Alternative & Punk';


-- PRACTICE NESTED QUERIES

-- #1
SELECT *
FROM invoice i
WHERE invoice_id IN (
  SELECT invoice_id 
  FROM invoice_line 
  WHERE unit_price > 0.99
);

-- #2
SELECT *
FROM playlist_track
WHERE playlist_id IN (
	SELECT playlist_id
  FROM playlist
  WHERE name = 'Music';
);

-- #3
SELECT name
FROM track
WHERE track_id IN (
	SELECT track_id
  FROM playlist_track
  WHERE playlist_id = 5
);

-- #4
SELECT *
FROM track
WHERE genre_id IN (
	SELECT genre_id
  FROM genre
  WHERE name = 'Comedy'
);

-- #5
SELECT *
FROM track
WHERE album_id IN (
	SELECT album_id
  FROM album
  WHERE title = 'Fireball'
);

-- #6
SELECT *
FROM track
WHERE album_id IN (
	SELECT album_id
  FROM album
  WHERE artist_id IN (
  	SELECT artist_id
    FROM artist
    WHERE name = 'Queen'
  )
);


-- PRACTICE UPDATING ROWS

-- #1
UPDATE customer
SET fax = null
WHERE fax IS NOT null;

-- #2
UPDATE customer
SET company = 'Self'
WHERE company = null;

-- #3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

-- #4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

-- #5
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = (
	SELECT genre_id
  FROM genre
  WHERE name = 'Metal'
)
AND composer IS null;


-- GROUP BY

-- #1
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;

-- #2
SELECT COUNT(*), g.name
FROM genre g
JOIN track t ON t.genre_id = g.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

-- #3
SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY ar.name;


-- USE DISTINCT

-- #1
SELECT DISTINCT composer
FROM track;

-- #2
SELECT DISTINCT billing_postal_code
FROM invoice;

-- #3
SELECT DISTINCT company
FROM customer;


-- DELETE ROWS

-- #1
DELETE
FROM practice_delete
WHERE type = 'bronze';

-- #2
DELETE
FROM practice_delete
WHERE type = 'silver';

-- #3
DELETE
FROM practice_delete
WHERE value = 150;


-- eCOMMERCE SOLUTION (NO HINTS)

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(60),
    email VARCHAR(40)
);

INSERT INTO users (
    name,
    email
)
VALUES
('Chuck', 'chuck@yes.yes'),
('Betty', 'betty@yes.yes'),
('Clarence', 'clarence@yes.yes');

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(60),
    price INTEGER
);

INSERT INTO products (
    name,
    price
)
VALUES
('Water Gun', 12),
('Water Balloon', 65),
('Water Torpedo', 2);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id)
);

INSERT INTO orders (
    product_id
)
VALUES
(3),
(2),
(1);

-- RUN QUERIES AGAINST YOUR DATA
-- GET ALL PRODUCTS FOR THE FIRST ORDER
SELECT * 
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.id = 1;

-- GET ALL ORDERS
SELECT *
FROM orders o
JOIN products p ON o.product_id = p.product_id

-- GET THE TOTAL COST OF AN ORDER (SUM THE PRICE OF ALL PRODUCTS ON AN ORDER)
SELECT SUM(p.price)
FROM products p
JOIN orders o ON o.product_id = p.product_id
WHERE o.id = 3;

-- ADD A FOREIGN KEY REFERENCE FROM ORDERS TO USERS
ALTER TABLE users
ADD COLUMN id INTEGER REFERENCES orders(id);

-- UPDATE THE ORDERS TABLE TO LINK A USER TO EACH ORDER
UPDATE orders


-- RUN QUERIES AGAINST YOUR DATA
-- GET ALL ORDERS FOR A USER


-- GET HOW MANY ORDERS EACH USER HAS