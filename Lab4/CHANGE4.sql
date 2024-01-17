INSERT INTO "user"
VALUES (4,'NICKNAME');

UPDATE "user"
SET user_name='CHANGED_NAME'
WHERE user_name='NICKNAME';

DELETE FROM "user"
WHERE user_name='NICKNAME';
SELECT * FROM "user"
