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




 select DISTINCT server from roles

update roles set server = '上海测试区' 
  where id in (5226, 5285, 4329, 4034, 5246, 4735, 4892, 4992, 4754, 5292, 5147, 4728, 5028, 5240, 3761, 3790, 4294, 5010, 4077, 4907, 5012, 4307, 4889, 4938, 4932, 4729, 4546, 4550, 4564, 4567, 4574, 4575, 4303, 4540, 4062, 3758, 3784, 5242, 3794, 5241, 3799, 3807, 5188, 4016, 5038, 4049, 4046, 4054, 5244, 3816, 4543, 5245, 4985, 4986, 5122, 4996, 5189, 4894, 4773, 4968, 4283, 4056, 4061, 4045, 3776, 4083, 4776, 4047, 5007, 4064, 4931, 4733, 4865, 5192, 3792, 3793, 4531, 5101, 3800, 4051, 4069, 4309, 5011, 4079, 4902, 3798, 4718, 5247, 4272, 4306, 5167, 5170, 4910, 5148, 3823, 4759, 4544, 4013, 3824, 5270, 4558, 4030, 5121, 5126, 3760, 3806, 4888, 4300, 5248, 5239, 5229, 5267, 4925, 4273, 3827, 4562, 4911, 5031, 5266, 4763, 4780, 4287, 4908, 5165, 4038, 4037, 4319, 5161, 4886, 4870, 5141, 4027, 5268, 4742, 4269, 4719, 4906, 5164, 5151, 4313, 4552, 4311, 4551, 4528, 4052, 3778, 4310, 4566, 4274, 5288);


update roles set server = '上海测试区' 