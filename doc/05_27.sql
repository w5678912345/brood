


select count(n2.id) as cc, n2.account from notes as n1
  inner join notes as n2 on n1.account = n2.account 
  where n1.api_name = 'discardforyears' and date(n1.created_at) = '2014-05-26' 
  and  n2.api_name = 'account_start' and n2.success = 1 and date(n2.created_at) >= '2014-05-22' 
  group by n2.account order by cc



select count(accounts.id) from accounts inner join roles on accounts.no = roles.account
 where date(accounts.updated_at) < '2014-05-24' and bind_computer_id > 0 and roles.level = 45;



