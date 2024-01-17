CREATE TABLE dop_vertex_table (
	vertex_id INT NOT NULL ,
	vertex_name VARCHAR(30)NOT NULL,
	coordinate_y INT NOT NULL,
	coordinate_x INT NOT NULL,
	vertex_width INT NOT NULL,
	graph_id INT NOT NULL
);
INSERT INTO dop_vertex_table
VALUES
(23,'VRTX стоп',1,1,3,2),
(5,'WILL_UPDATE',1,1,3,2);
SELECT * FROM dop_vertex_table;
SELECT * FROM vertex;
MERGE INTO vertex AS v
USING dop_vertex_table AS dpv
ON v.vertex_id=dpv.vertex_id
WHEN NOT MATCHED THEN
	INSERT 
	VALUES(vertex_id ,vertex_name,coordinate_y,coordinate_x,vertex_width,graph_id)
WHEN MATCHED THEN UPDATE
	SET coordinate_y=dpv.coordinate_y,coordinate_x= dpv.coordinate_x,
	vertex_width = dpv. vertex_width,
	graph_id= dpv. vertex_width
;

