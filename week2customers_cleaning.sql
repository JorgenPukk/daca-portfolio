-- Loo customers_test ja kontrolli ridade arvu.
CREATE TABLE customers_test AS SELECT * FROM customers;
SELECT COUNT(*) AS ridade_arv FROM customers_test;

--Leia duplikaadid
SELECT email, COUNT(*) AS koopiate_arv
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--Samm 3. Leia puuduvad nimed
SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '') AS null_perenimi
FROM customers_test;

--Samm 4. Kontrolli linnade nimekujusid — kas on ebajärjekindlusi?
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city
ORDER BY city;

--Samm 5. Kontrolli kontaktandmeid — puuduvad telefoninumbrid ja e-mailid:
SELECT
    COUNT(*) FILTER (WHERE phone IS NULL OR phone = '') AS null_telefon,
    COUNT(*) FILTER (WHERE email IS NULL OR email = '') AS null_email
FROM customers_test;

SELECT city, COUNT(*) FROM customers_test
GROUP BY city HAVING COUNT(*) > 1;
--Ühtlusta linnanimed INITCAP + TRIM abil
UPDATE customers_test
SET city = INITCAP(TRIM(city))
WHERE city != INITCAP(TRIM(city));

-- Kontrolli tulemust
SELECT city, COUNT(*) AS arv
FROM customers
GROUP BY city ORDER BY city;

-- Standardiseeri e-mailid väiketähtedeks
UPDATE customers_test
SET email = LOWER(TRIM(email))
WHERE email != LOWER(TRIM(email));


SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city ORDER BY city;

-- Näide: standardiseeri telefoninumbrid
SELECT phone,
    CASE
        WHEN phone LIKE '+372%' THEN phone
        WHEN phone LIKE '372%' THEN '+' || phone
        WHEN LENGTH(phone) = 7 THEN '+372' || phone
        ELSE phone
    END AS standardne_telefon
FROM customers_test
WHERE phone IS NOT NULL;
LIMIT 10;