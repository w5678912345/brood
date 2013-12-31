

select count(account), vc from (
select count(id) as vc, account from notes 
 where server = '上海1区' and api_name = 'answer_verify_code'
 and date(created_at) > '2013-12-25' group by account having count(id) > 35;
 ) as t1 group by vc



select count(account), vc from (
select count(id) as vc, account from notes 
 where server = '上海1区' and api_name = 'exception'
 and date(created_at) > '2013-12-25' group by account having count(id) > 20;
 ) as t1 group by vc;