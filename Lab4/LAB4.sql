INSERT INTO "user" 
VALUES
(1,'USER_1'),
(2,'USER_2');
INSERT INTO graph
VALUES
(1,'graph_1',1),
(2,'graph_1',2);
INSERT INTO vertex
VALUES 
(11,'VRTX1',2,5,1,1),
(12,'стоп VRTX2',3,3,1,1),
(21,'VRTX1',2,6,1,2),
(22,'стоп VRTX2',2,5,1,2),
(13,'VRTX4',4,4,1,1),
(24,'выход',3,310,1,2),
(5,'WILL_UPDATE',9,9,9,2);
INSERT INTO edge
VALUES 
(11,11,12),
(22,24,24),
(23,24,21),
(12,11,13),
(13,12,13),
(21,21,22);
INSERT INTO graph_user_roots
VALUES 
(1,1,3),
(1,2,1),
(2,1,3),
(2,2,3);