SELECT vertex_id,vertex_name
FROM vertex
WHERE  vertex_name LIKE '%_стоп%';

select distinct graph_id
from vertex
right join edge on edge.vertex_id_from=vertex.vertex_id
where edge.vertex_id_from=edge.vertex_id_to
;
select vertex_id
from vertex
left join edge on vertex.vertex_id=edge.vertex_id_from
where edge.vertex_id_from is NULL
;
