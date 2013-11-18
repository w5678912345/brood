



# select DISTINCT

# select  

select DISTINCT notes.role_id as 'bslock_role_id' from notes where date(created_at) = '2013-10-15' and api_name = 'bslock';


update roles set locked = 0 where server ='江苏1区' and locked = 1;



select account,password,server from roles where close = 1 and close_hours = 120000 into outfile  '/tmp/12w.txt';



LOAD DATA INFILE '/tmp/roles_gdx.txt' INTO TABLE roles FIELDS TERMINATED BY '|' (account,password,role_index,server,level,vit_power,gold);




LOAD DATA INFILE '/tmp/11_17_150_roles.txt' INTO TABLE roles FIELDS TERMINATED BY '----' (account,password);


delete from comroles where role_id in (select id from roles where server = '上海测试区');

