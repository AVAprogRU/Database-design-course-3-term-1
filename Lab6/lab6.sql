/*Графы, ширина которых не превышает 300 пикселей. Ширина графа в пикселях
  Ответ:graph_1
*/

select graph.graph_name,graph.graph_id,max(vertex.coordinate_x+vertex.vertex_width/2)- 
min(vertex.coordinate_x-vertex.vertex_width/2) from vertex
join graph on vertex.graph_id=graph.graph_id
group by graph.graph_id
having max(vertex.coordinate_x+vertex.vertex_width/2)- 
min(vertex.coordinate_x-vertex.vertex_width/2)<=300




/*Ж 
Вершины, у которых нет входящих ребер от вершины со словом «выход»
Ответ:11,12,13,22,23
*/


						
/*Ж except*/						
select vertex.vertex_id from vertex
except
select vrtx.vertex_id from vertex as vrtx
join edge on vrtx.vertex_id=edge.vertex_id_to
join vertex as vrtx2 on edge.vertex_id_from=vrtx2.vertex_id
where vrtx2.vertex_name like '%выход%'
						
/*Ж not in*/
select vertex.vertex_id from vertex
where vertex.vertex_id not in( 
select vertex.vertex_id from vertex 
join edge on vertex.vertex_id=edge.vertex_id_to
join vertex as vrtx2 on edge.vertex_id_from=vrtx2.vertex_id
where vrtx2.vertex_name like '%выход%')
						
/*Ж left  join*/
select vertex.vertex_id from vertex
left join
(select vrtx.vertex_id from vertex as vrtx
	join edge on vrtx.vertex_id=edge.vertex_id_to
	join vertex as vrtx2 on edge.vertex_id_from=vrtx2.vertex_id
	where vrtx2.vertex_name like '%выход%'
)as vertex2 
on vertex.vertex_id=vertex2.vertex_id
where vertex2.vertex_id is NULL

/*д. авторы графов, графы которых может редактировать 
     наибольшее число пользователей
	 Ответ:USER_1
*/

--временные результаты запроса.
with max_roots_tab as
(select graph_id,count(user_id) as count_users from graph_user_roots
			where graph_user_roots.roots=3
			group by graph_user_roots.graph_id
)
		
select "user".user_name from "user"
join graph on "user".user_id=graph.user_id
join max_roots_tab 
on graph.graph_id=max_roots_tab.graph_id
where count_users = (select max(count_users) from max_roots_tab)



with max_roots_tab as
(select graph_id,count(user_id) as count_roots from graph_user_roots
			where graph_user_roots.roots=3
			group by graph_user_roots.graph_id
)
		
select "user".user_name from "user"
join graph on "user".user_id=graph.user_id
join max_roots_tab 
on graph.graph_id=max_roots_tab.graph_id
where count_roots >= all(select (count_roots) from max_roots_tab)

	
	
/*Вершины, для которых есть исходящие ребра, 
ведущие ко всем остальным вершинам еѐ графа*/


SELECT vertex_id_from
FROM edge join vertex as vrtx on edge.vertex_id_from=vrtx.vertex_id
where vertex_id_to<>vertex_id_from
GROUP BY vertex_id_from,graph_id
HAVING  COUNT(DISTINCT vertex_id_to) = (select count(vertex_id)-1 
									   as count_vrtx_in_graph
 		from vertex as vrtx2
 		where vrtx.graph_id=vrtx2.graph_id )




Select * from vertex  
join graph on graph.graph_id=vertex.graph_id
where not exists(
select * from vertex as vrtx2
where graph.graph_id=vrtx2.graph_id and vertex.vertex_id<>vrtx2.vertex_id

and  not exists(
select * from edge
where edge.vertex_id_from=vertex.vertex_id 
ANd edge.vertex_id_to=vrtx2.vertex_id ))
