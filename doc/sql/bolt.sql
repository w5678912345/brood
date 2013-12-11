

update roles set status = 'disable_for_tmp' where role_index !=0 and status = 'normal'; and online = 0;


select count(n.id),count(DISTINCT r.id) from roles r inner join notes n on n.role_id = n.role_id where r.is_agent = 1 and n.api_name='role_start' and date(n.created_at) >= '2013-12-06';


select count(DISTINCT role_id) from notes where role_id in(select id from roles where is_agent=1) and date(created_at) >= '2013-12-06';



select sum(gold),SUBSTRING_INDEX(server,'|',1) as game_server from roles where server is not null group by game_server;


select count(DISTINCT accounts.id) from accounts inner join notes on accounts.no = notes.account where notes.api_name='discardforyears'  having min(date(notes.created_at)) = '2013-12-09';



select count(DISTINCT role_id) from notes where api_name = 'account_start' having min(notes.created_at) > '2013-12-01';


select count(accounts.id) from accounts left join notes on accounts.no = notes.account where status = 'discardforyears';

select count(DISTINCT account),date(created_at) from notes where api_name = 'account_start' group by date(notes.created_at) having min(notes.created_at) > '2013-12-01';



select count(account) from 
(select account,min(date(created_at)) m from notes where api_name = 'account_start' group by account) as tmp where m = '2013-12-09';

#
select count(DISTINCT accounts.no),tmp.m from accounts inner join
(select account,min(date(created_at)) m from notes where api_name = 'account_start' group by account) as tmp on accounts.no = tmp.account
where accounts.status = 'discardforyears' and  tmp.m > '2013-12-01' group by tmp.m;


#
select count(DISTINCT accounts.no),tmp.m from accounts inner join
(select account,min(date(created_at)) m from notes where api_name = 'account_start' group by account) as tmp on accounts.no = tmp.account
where accounts.status != 'locked' and  tmp.m > '2013-12-01' group by tmp.m;


select count(account) from 
(select account,min(date(created_at)) m from notes where api_name = 'account_start' group by account) as tmp where m = '2013-12-09';






