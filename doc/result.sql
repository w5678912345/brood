SELECT COUNT(DISTINCT role_id) as role_count,ip_range_count  from (SELECT  role_id,COUNT(DISTINCT ip_range)  as ip_range_count from ( SELECT role_id,SUBSTRING_INDEX(ip,'.',2)  as ip_range from notes where api_name = 'online' and created_at between '2013-09-28' and '2013-10-08'  ) as tab  GROUP BY role_id ) as tab2 GROUP BY ip_range_count;





+------------+----------------+
| role_count | ip_range_count |
+------------+----------------+
|       3144 |              1 |
|       8877 |              2 |
|       4627 |              3 |
|       1031 |              4 |
|          3 |              5 |
+------------+----------------+


SELECT COUNT(DISTINCT role_id) as role_count,ip_range_count  from (SELECT  role_id,COUNT(DISTINCT ip_range)  as ip_range_count from ( SELECT role_id,SUBSTRING_INDEX(ip,'.',2)  as ip_range from notes where api_name = 'bslock' and created_at between '2013-09-28' and '2013-10-08'  ) as tab  GROUP BY role_id ) as tab2 GROUP BY ip_range_count;


+------------+----------------+
| role_count | ip_range_count |
+------------+----------------+
|       7162 |              1 |
|        165 |              2 |
+------------+----------------+



