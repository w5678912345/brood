
#  test_tianyi 等级大于50 的账号
select count(accounts.id) from accounts left join roles on accounts.no = roles.account
 where accounts.server ='上海1区' and accounts.status != 'discardforyears' and roles.level >= 50;


 select accounts.no,accounts.password,accounts.server,accounts.status
 from accounts left join roles on accounts.no = roles.account
 where accounts.server ='上海1区' and accounts.status != 'discardforyears' and roles.level >= 50
 into outfile '/tmp/sh1q_level_egt_50.txt' FIELDS TERMINATED BY '|';


 LOAD DATA INFILE '/tmp/202_new.txt' IGNORE INTO TABLE accounts FIELDS TERMINATED BY '|' (no,password,server,status);

