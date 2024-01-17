CREATE TABLE "user" (
	user_id INT NOT NULL PRIMARY KEY,
	user_name VARCHAR(50)NOT NULL
);
CREATE TABLE graph(
	graph_id INT NOT NULL PRIMARY KEY,
	user_name VARCHAR(50)NOT NULL,
	user_id INT NOT NULL,
	CONSTRAINT fk_gr_author FOREIGN KEY (user_id) REFERENCES "user"(user_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);
CREATE TABLE graph_user_roots(
	graph_id INT NOT NULL ,
	user_id INT NOT NULL ,
	PRIMARY KEY(user_id,graph_id),
	CONSTRAINT fk_user_roots FOREIGN KEY (user_id) REFERENCES "user"(user_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT fk_graph_roots FOREIGN KEY (graph_id) REFERENCES graph(graph_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);
CREATE TABLE vertex(
	vertex_id INT NOT NULL PRIMARY KEY,
	vertex_name VARCHAR(30)NOT NULL,
	coordinate_y INT NOT NULL,
	coordinate_x INT NOT NULL,
	vertex_width INT NOT NULL,
	graph_id INT NOT NULL,
	CONSTRAINT fk_graph_in_vertex FOREIGN KEY (graph_id) REFERENCES graph(graph_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE	
);
CREATE TABLE edge(
	edge_id INT NOT NULL PRIMARY KEY,
	vertex_id_from INT NOT NULL,
	vertex_id_to INT NOT NULL,
	CONSTRAINT fk_vertexfrom_in_edge FOREIGN KEY (vertex_id_from) REFERENCES vertex(vertex_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT fk_vertexto_in_edge FOREIGN KEY (vertex_id_to) REFERENCES vertex(vertex_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);