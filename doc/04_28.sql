

select count(id) as cc, account from notes where api_name='discardfordays' group by account having cc =3;

