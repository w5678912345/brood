-- select count(DISTINCT role_id) as online_count from notes where api_name = 'online';


-- select count(id) - (select count(DISTINCT role_id) as online_count from notes where api_name = 'online' and created_at between  '2013-09-01' and '2013-09-10' ) from roles;


-- select count(id) as all, (count(id) - (select count(DISTINCT role_id) as online_count from notes where api_name = 'online' and created_at between  '2013-09-26' and '2013-09-30' ) ) as   from roles;




select count(id) - (select count(DISTINCT role_id) as online_count from notes where api_name = 'online' and created_at between  '2013-09-26' and '2013-09-30' ) as un_count,count(id) all_count from roles;


select count(id),date(created_at) from roles group by date(created_at);





+-----------+------------------+
| count(id) | date(created_at) |
+-----------+------------------+
|       500 | 2013-07-11       |
|         7 | 2013-07-30       |
|      1240 | 2013-07-31       |
|       320 | 2013-08-01       |
|      1037 | 2013-08-02       |
|      1009 | 2013-08-04       |
|      2012 | 2013-08-07       |
|      3886 | 2013-08-15       |
|      1178 | 2013-08-24       |
|       526 | 2013-09-02       |
|       833 | 2013-09-04       |
|      1557 | 2013-09-09       |
|       723 | 2013-09-11       |
|       608 | 2013-09-12       |
|       625 | 2013-09-14       |
|       919 | 2013-09-17       |
|       534 | 2013-09-21       |
|       407 | 2013-09-23       |
|       313 | 2013-09-26       |
+-----------+------------------+




