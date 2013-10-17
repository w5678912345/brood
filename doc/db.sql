#sudo ln -s /usr/local/mysql-5.5.25-osx10.6-x86_64/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib

-- select count(DISTINCT role_id) as online_count from notes where api_name = 'online';


-- select count(id) - (select count(DISTINCT role_id) as online_count from notes where api_name = 'online' and created_at between  '2013-09-01' and '2013-09-10' ) from roles;


-- select count(id) as all, (count(id) - (select count(DISTINCT role_id) as online_count from notes where api_name = 'online' and created_at between  '2013-09-26' and '2013-09-30' ) ) as   from roles;


select accnout from roles where  into outfile '/tmp/data.txt'

select account,password from roles  where close = 1 and close_hours = 120000 into outfile '/tmp/roles_close_12w.txt';


select count(id) - (select count(DISTINCT role_id) as online_count from notes where api_name = 'online' and created_at between  '2013-09-26' and '2013-09-30' ) as un_count,count(id) all_count from roles;


select count(id),date(created_at) from roles group by date(created_at);


# 重庆1区   AnswerVerifyCode count
select  count(n.id) from notes n INNER JOIN roles   r on n.role_id = r.id  where n.api_name = 'AnswerVerifyCode' and  r.server = '重庆1区' and date(n.created_at) > '2013-09-19'




 select DISTINCT server from roles

update roles set server = '上海测试区'  where id in (5226, 5285, 4329, 4034, 5246, 4735, 4892, 4992, 4754, 5292, 5147, 4728, 5028, 5240, 3761, 3790, 4294, 5010, 4077, 4907, 5012, 4307, 4889, 4938, 4932, 4729, 4546, 4550, 4564, 4567, 4574, 4575, 4303, 4540, 4062, 3758, 3784, 5242, 3794, 5241, 3799, 3807, 5188, 4016, 5038, 4049, 4046, 4054, 5244, 3816, 4543, 5245, 4985, 4986, 5122, 4996, 5189, 4894, 4773, 4968, 4283, 4056, 4061, 4045, 3776, 4083, 4776, 4047, 5007, 4064, 4931, 4733, 4865, 5192, 3792, 3793, 4531, 5101, 3800, 4051, 4069, 4309, 5011, 4079, 4902, 3798, 4718, 5247, 4272, 4306, 5167, 5170, 4910, 5148, 3823, 4759, 4544, 4013, 3824, 5270, 4558, 4030, 5121, 5126, 3760, 3806, 4888, 4300, 5248, 5239, 5229, 5267, 4925, 4273, 3827, 4562, 4911, 5031, 5266, 4763, 4780, 4287, 4908, 5165, 4038, 4037, 4319, 5161, 4886, 4870, 5141, 4027, 5268, 4742, 4269, 4719, 4906, 5164, 5151, 4313, 4552, 4311, 4551, 4528, 4052, 3778, 4310, 4566, 4274, 5288);


update roles set server = '上海测试区' 


update roles set ip_range = null ,ip_range2 = null where server in('贵州1区','华北2区','湖南1区','广西1区','上海1区')



select count(*) ,server from roles group by server;


#select 

select count(DISTINCT role_id) as role_id ,SUBSTRING_INDEX(ip,'.',2) as id_range from notes where api_name = 'online' and ip <> 'localhost' and created_at between  '2013-10-01' and '2013-10-08' group by id_range;


select count(role_id) as role_id from notes where api_name = 'online' and created_at between  '2013-10-01' and '2013-10-08' group by  role_id #SUBSTRING_INDEX(ip,'.',2)


select SUBSTRING_INDEX(ip,'.',2) as ip_range ,count(DISTINCT role_id) as ip_use_count from notes where api_name = 'online' and created_at between  '2013-10-01' and '2013-10-08' group by SUBSTRING_INDEX(ip,'.',2);



select role_id  from notes  where  api_name = 'online' and created_at between '2013-10-01' and '2013-10-08' group by role_id   HAVING COUNT(SUBSTRING_INDEX(ip,'.',2) ) =2; 

