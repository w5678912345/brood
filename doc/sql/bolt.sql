

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


select count(id) , server,date(created_at) from notes where api_name = 'discardforyears' group by date(created_at),server;



select count(DISTINCT account) from notes where api_name ='account_start' and hour(created_at) >= 11 and hour(created_at) <= 17;

# 10 - 21

select count(DISTINCT account) from 
(select account,hour(created_at) as h from notes where api_name = 'account_start') as t1
where h >= 10 and h <= 21 and(account not in(select account from notes where api_name ='account_start' and hour(created_at) < 10 and hour(created_at)>21 ));



select count(DISTINCT account) from notes where api_name ='account_start';

select count(DISTINCT account) from notes where api_name ='account_start' and hour(created_at) >= 18 and hour(created_at) <= 20;



select account from 
(select account,hour(created_at) as h from notes where api_name = 'account_start') as t1 
where account not in(select account  from notes where api_name = 'account_start' and hour(created_at) <18 or hour(created_at) >21);

select count(DISTINCT account) from accounts 
 left join (select account,hour(created_at) as h from notes where api_name ='account_start') as tmp
  on accounts.no  = tmp.account
where status = 'discardforyears' and h < 18 or h > 21;






select no from accounts where status = 'discardforyears' and no not in(
	select DISTINCT account from notes where api_name = 'account_start' and hour(created_at) < 18 or hour(created_at) > 21
);


select DISTINCT account from notes where api_name = 'account_start' and hour(created_at) < 18 or hour(created_at) > 21;

select count(DISTINCT account)  from notes where api_name = 'account_start' and hour(created_at) <18 or hour(created_at) >21;



and account not in(select account from notes where api_name = 'account_start' where hour(created_at) < 10 or hour(created_at) > 21)


select count(DISTINCT account) from notes where api_name = 'account_start' and account not in (select account from notes where hour(created_at) < 11 or hour(created_at) > 17);


#and h not in(0,1,2,3,4,5,6,7,8,9,10,18,19,20,21,22,23);



select hour(created_at),account from notes where api_name ='account_start';


select count(DISTINCT account) from notes where api_name = 'account_start'
 and (hour(notes.created_at) < 18 or hour(notes.created_at) > 21);


select count(DISTINCT account),hour(created_at) from notes where api_name ='account_start' group by hour(created_at);



select count(DISTINCT account) from notes where api_name = 'account_start'
 and (hour(notes.created_at) < 18 or hour(notes.created_at) > 21);



select count(DISTINCT notes.account) from accounts left join notes on accounts.no = notes.account
where  notes.api_name = 'account_start'
and (hour(notes.created_at) < 18 or hour(notes.created_at) > 21);




select count(DISTINCT accounts.no) from accounts left join notes on accounts.no = notes.account
where status = 'normal' 
and notes.api_name = 'account_start'
and hour(notes.created_at) < 18 and hour(notes.created_at) > 21;


select count(DISTINCT accounts.no) from accounts left join notes on accounts.no = notes.account
where status = 'normal' 
and notes.api_name = 'account_start'
and (hour(notes.created_at) < 15 or hour(notes.created_at) > 21);



select count(DISTINCT account) from notes 
 where api_name = 'account_start' and (hour(notes.created_at) < 18 or hour(notes.created_at) > 21);


# 11 - 17
# 

select hour(created_at),account from notes

select DISTINCT account from notes where api_name ='account_start' 
and hour(created_at) in(1,0)
and hour(created_at) not in(11,13);


#update accounts set server = '电信八区' where bind_computer_id = 104;


 select account from notes where api_name = 'account_start'  group by account having min(hour(created_at)) >= 20  and max(hour(created_at)) <= 21;



select  count(DISTINCT no) from accounts 
right join (select account from notes where api_name = 'account_start'   
	group by account having min(hour(created_at)) >= 10  
	and max(hour(created_at)) < 23
	and min(hour(stopped_at)) >= 10 
	and max(hour(stopped_at)) < 23
	and max(hours) < 10
	and min(hours) > 1
	) as tmp
on accounts.no = tmp.account
where accounts.status = 'discardforyears' ;

# 12-12
select  count(DISTINCT no) from accounts 
right join (select account from notes where api_name = 'account_start'   
	group by account having min(hour(created_at)) >= 2
	and max(hour(created_at)) < 15
	and min(hour(stopped_at)) >= 2 
	and max(hour(stopped_at)) < 15
	and max(hours) < 10
	) as tmp
on accounts.no = tmp.account
where accounts.status = 'discardforyears' ;



select  DISTINCT no from accounts 
right join (select account from notes where api_name = 'account_start'   
	group by account having min(hour(created_at)) >= 10  
	and max(hour(created_at)) < 23
	and min(hour(stopped_at)) >= 10 
	and max(hour(stopped_at)) < 23
	and max(hours) < 10
	) as tmp
on accounts.no = tmp.account
where accounts.status = 'discardforyears' ;


select  DISTINCT  no from accounts 
right join (select account from notes where api_name = 'account_start'   
	group by account having min(hour(created_at)) >= 0  and max(hour(created_at)) < 15 and max(hours) < 10) as tmp
on accounts.no = tmp.account
where accounts.status = 'discardforyears';





select count(no )



select  account,max(hour(created_at)) as max_h,min(hour(created_at)) as min_h from 
(select account,hours,created_at,stopped_at from notes where api_name ='account_start') as t1 group by account limit 3;


select count(DISTINCT no)  from accounts 
right join (select account from notes where api_name = 'account_start'  
	group by account having min(hour(created_at)) >= 0  and max(hour(created_at)) < 24) as tmp
on accounts.no = tmp.account
where accounts.status = 'discardforyears';

# 
select count(DISTINCT no)  from accounts 
right join (select account from notes where api_name = 'account_start' and date(created_at) = date(stopped_at) 
	group by account having min(hour(created_at)) >= 10  and max(hour(created_at)) < 23 and min(hour(stopped_at)) >= 10 and max(hour(stopped_at)) < 23)  as tmp
on accounts.no = tmp.account
where accounts.status = 'discardforyears' ;






select count(DISTINCT account) from notes where api_name ='account_start' and date(created_at) != date(stopped_at);


#and date(created_at) = date(stopped_at) 


#select 


