
# tianyi 机器饱和度查询
select computer_id,sum(if(api_name='account_start',hours,0)) / sum(if(api_name='computer_start',hours,0)) as tt
	from notes where date(created_at) = '2014-03-24' and computer_id > 0 group by computer_id  order by tt asc limit 10;


# bolt 最近2-3天没有调度的号

select count(roles.id),SUBSTRING_INDEX(roles.server,'|',1) as g_server from roles inner join accounts on roles.account = accounts.no 
	where accounts.bind_computer_id > 0 and date(roles.updated_at) < '2014-03-21' and role_index = 0 and level =45 group by g_server;

select roles.id,roles.updated_at from roles inner join accounts on roles.account = accounts.no 
	where accounts.bind_computer_id > 0 and date(roles.updated_at) < '2014-03-21' and role_index = 0 and level =45 and roles.server like '网通五区%';