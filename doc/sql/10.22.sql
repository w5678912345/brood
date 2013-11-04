#

# select count()

# 备份数据库 表 的部分数据 (insert sql)
#mysqldump -t -uroot -p brood_remote roles --where="id>4000 limit 3" > /home/suxu/roles1.sql


select count(id) from roles where server = '广东1区' or server = '广西1区';



mysqldump -t -uroot -p brood_production roles --complete-insert=false --where="id != 5300 and (server = '广东1区' or server = '广西1区')" > /tmp/gd_gx.sql


mysql -u root -p brood_production  --skip-column-names id </tmp/t.sql;

 --skip-column-names
 --skip-column-names

select * from roles where id > 5630 into outfile '/tmp/t1' fields-terminated-by=',';




select * from roles where id > 5630 into outfile '/tmp/data.txt' --fields-terminated-by=’,’;

 select *  into outfile '/tmp/rolw_tab' fields-terminated-by=',' from roles where id > 5630 ;



 SELECT account,password,role_index,server,level,vit_power,gold FROM roles where server = '广东1区' or server = '广西1区' INTO OUTFILE '/tmp/gd_gx_roles.txt' FIELDS TERMINATED BY '|';


 LOAD DATA INFILE '/tmp/roles_gdx.txt' INTO TABLE roles FIELDS TERMINATED BY '|' (account,password,role_index,server,level,vit_power,gold);

LOAD DATA INFILE '/tmp/roles4.txt' INTO TABLE roles (account,password,role_index,server,level,vit_power,gold) TERMINATED BY '|';


update roles set server = '广东1区' where server = '广东1区s';

LOAD DATA INFILE '/tmp/2000.txt' INTO TABLE roles FIELDS TERMINATED BY '----' (account,password);


