--перед вставкой, проверка существует ли добавляемая вершина и граф 
CREATE OR REPLACE FUNCTION before_insert_vertex()
RETURNS TRIGGER AS $$
BEGIN
  if not exists(select * from graph where graph.graph_id=NEW.graph_id) then
  	RAISE EXCEPTION 'Граф с id % не существует', NEW.graph_id;
  elseif exists(select * from vertex where vertex.vertex_id=NEW.vertex_id)then
  	RAISE EXCEPTION 'вершина с id % уже существует', NEW.vertex_id;
  end if;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER before_insert_vertex_trigger
BEFORE INSERT ON vertex
FOR EACH ROW
EXECUTE FUNCTION before_insert_vertex();

-------------------------------
CREATE TABLE log_vertex (
  log_id SERIAL PRIMARY KEY,
  event_type VARCHAR(10) NOT NULL,
  vertex_id INT NOT NULL,
  old_vertex_name VARCHAR(50),
  new_vertex_name VARCHAR(50),
  event_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION after_insert_vertex()
RETURNS TRIGGER AS $$
BEGIN
  insert into log_vertex(event_type, vertex_id, new_vertex_name, event_timestamp)
  values('INSERT', NEW.vertex_id, NEW.vertex_name, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER after_insert_vertex_trigger
AFTER INSERT ON vertex
FOR EACH ROW
EXECUTE FUNCTION after_insert_vertex();


-------------------------------


CREATE OR REPLACE FUNCTION before_update_vertex()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.vertex_width < 0  THEN
    RAISE EXCEPTION 'Некорректные значения для ширины вершины.';
  END IF;
  if exists(select * from vertex where vertex.vertex_id=NEW.vertex_id and NEW.vertex_id<>OLD.vertex_id)then
  	RAISE EXCEPTION 'вершина с id % уже существует', NEW.vertex_id;
  end if;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE or replace TRIGGER before_update_vertex_trigger
BEFORE UPDATE ON vertex
FOR EACH ROW
EXECUTE FUNCTION before_update_vertex();

-------------------------------

CREATE OR REPLACE FUNCTION after_update_vertex()
RETURNS TRIGGER AS $$
BEGIN
  insert into log_vertex(event_type, vertex_id, old_vertex_name,new_vertex_name, event_timestamp)
  values('UPDATE', NEW.vertex_id, OLD.vertex_name, NEW.vertex_name, NOW());
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER after_update_vertex_trigger
AFTER UPDATE ON vertex
FOR EACH ROW
EXECUTE FUNCTION after_update_vertex();

---------------------------------


CREATE OR REPLACE FUNCTION before_delete_vertex()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT * FROM vertex 
			 join edge on edge.vertex_id_from=vertex.vertex_id 
			 			OR edge.vertex_id_to=vertex.vertex_id
			 WHERE vertex.vertex_id = OLD.vertex_id) THEN
    delete from edge where edge.vertex_id_from = OLD.vertex_id 
							OR edge.vertex_id_to = OLD.vertex_id;
	RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER before_delete_vertex_trigger
BEFORE DELETE ON vertex
FOR EACH ROW
EXECUTE FUNCTION before_delete_vertex();
drop trigger before_delete_vertex_trigger on vertex

CREATE OR REPLACE FUNCTION after_delete_vertex()
RETURNS TRIGGER AS $$
BEGIN
  insert into log_vertex(event_type, vertex_id, old_vertex_name, event_timestamp)
  values('DELETE', OLD.vertex_id, OLD.vertex_name, NOW());
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER after_delete_vertex_trigger
AFTER DELETE ON vertex
FOR EACH ROW
EXECUTE FUNCTION after_delete_vertex();