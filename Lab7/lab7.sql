--вычисление и возврат значения агрегатной функции
--процедура и функция возврата количества вепршин в заданном графе

CREATE OR REPLACE PROCEDURE get_count_vertex_in_graph(IN graph_id_param INT, OUT count_vertex INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COALESCE(count(vertex_id), 0) INTO count_vertex
    FROM vertex
    WHERE vertex.graph_id = graph_id_param;
END;
$$;


    call get_count_vertex_in_graph(5, NULL); 
    



CREATE OR REPLACE FUNCTION get_count_vertex_in_graph1(graph_id_param INT)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    count_v INTEGER;
BEGIN
    SELECT COALESCE(count(vertex_id), 0) INTO count_v
    FROM vertex
    WHERE vertex.graph_id = graph_id_param;

    RETURN count_v;
END;
$$;
select get_count_vertex_in_graph1(2); 

/* Процедура каскадного удаления. вершина->ребра 
удаление вершины, а также с ней свзязанные ребра

*/

CREATE OR REPLACE PROCEDURE del_vertex(IN vertex_id_param INT)
LANGUAGE plpgsql
AS $$
BEGIN
    delete from edge 
	where edge.vertex_id_from=vertex_id_param or edge.vertex_id_to=vertex_id_param;
	delete from vertex
	where vertex.vertex_id=vertex_id_param;
END;
$$;

DO $$ 
BEGIN 
    call del_vertex(44); 
END $$;

/*Процедура удаления с очисткой справочника 
удалеине вершины, и если она была единственной, то удаляется и граф 
INSERT INTO graph
VALUES
(3,'graph_3',1);
INSERT INTO vertex
VALUES 
(33,'стоп VRTX2',2,5,1,3);
INSERT INTO graph_user_roots
values (3,1,1);
*/
CREATE OR REPLACE PROCEDURE del_vertex_and_graph(IN vertex_id_param INT)
LANGUAGE plpgsql
AS $$
DECLARE
	graph_of_vertex integer;
BEGIN
	select vertex.graph_id into graph_of_vertex from vertex 
	where vertex.vertex_id=vertex_id_param;
	delete from vertex
	where vertex.vertex_id=vertex_id_param;
	if not exists (select * from vertex where vertex.graph_id=graph_of_vertex)
	then
	begin 
		delete from graph_user_roots where graph_id=graph_of_vertex;
		delete from graph where graph_id=graph_of_vertex;		
    end;
	end if;
END;
$$;

DO $$ 
BEGIN 
    call del_vertex_and_graph(44); 
END $$;


/*Процедура вставки с пополнением справочника


*/

CREATE OR REPLACE PROCEDURE insert_graph_and_user(IN 
												  graph_id_param INT,
												  graph_name_param varchar(30),
												  user_id_param int)
LANGUAGE plpgsql
AS $$
DECLARE
	new_user_id integer;
	
BEGIN
	if not exists(select from "user" where user_id = user_id_param)
	then 
	begin
		new_user_id :=(select COALESCE (max( user_id)+1, 0) from "user");
		insert into "user" values (new_user_id,'New USER_'||new_user_id::varchar);
	end;
	else
		set new_user_id=user_id_param;
	end if;
	insert into graph values (graph_id_param,graph_name_param,new_user_id);
END;
$$;

DO $$ 
BEGIN 
    call insert_graph_and_user(6,'New graph',4); 
END $$;

/*Формирование статистики во временной таблице*/
/* 
!!!!!!!!
удалить все что уже есть перед запуском
drop table stat_table;
DROP FUNCTION IF EXISTS graphs_statistic3();
*/
CREATE OR REPLACE function graphs_statistic3()
RETURNS table(stat_id int,
        graph_ids INT,
        count_vertexs INT,
        avg_count_vertexs DOUBLE PRECISION,
        diff_count_vrtxs DOUBLE PRECISION )
LANGUAGE plpgsql
AS $$
BEGIN
CREATE TEMPORARY TABLE stat_table (
    stat_id SERIAL PRIMARY KEY,
	graph_id int,
	count_vertexes int,
	avg_count_vertexes double  PRECISION default 0,
	diff_count_vrtx double  PRECISION default 0
);

insert into stat_table(graph_id,count_vertexes) 
select graph.graph_id,coalesce(count(vertex_id),0) as count_vertex 
from vertex full join graph on graph.graph_id=vertex.graph_id 
group by graph.graph_id;



update stat_table set avg_count_vertexes = 
(select avg(count_vertexes) from stat_table);

update stat_table set diff_count_vrtx=count_vertexes-avg_count_vertexes;


return query select * from stat_table;
drop table stat_table;

END;
$$;
drop table stat_table;
DROP FUNCTION IF EXISTS graphs_statistic3();
select * from graphs_statistic3(); 


