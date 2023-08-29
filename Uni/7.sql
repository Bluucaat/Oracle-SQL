create table y_hallgato
(neptun char(6),
nev varchar2(30) /*constraint yh_nn_nev */not null,
szul_dat date,
cim varchar2(50),
unipass_kartya_szam char(16),
cipomeret number(2),
constraint yh_pk primary key (neptun),
constraint yh_uq_uksz unique (unipass_kartya_szam),
constraint yh_ch_cm check (cipomeret>5));

insert into y_hallgato(neptun, nev, szul_dat, unipass_kartya_szam, cipomeret)
values ('aaa111','Anna', to_date('2005.01.01', 'yyyy.mm.dd'), 'a1',38);

/*insert into y_hallgato(neptun, nev,  unipass_kartya_szam, cipomeret)
values ('aaa111','Bela', 'b1',40);*/

/*insert into y_hallgato(neptun, nev,  unipass_kartya_szam, cipomeret)
values ('bbb111','Bela', 'a1',40);*/

/*insert into y_hallgato(neptun, nev,  unipass_kartya_szam, cipomeret)
values ('bbb111','Bela', 'b1',1);*/

insert into y_hallgato(neptun, nev,  unipass_kartya_szam, cipomeret)
values ('bbb111','Bela', 'b1',null);

/*insert into y_hallgato(neptun, nev)
values ('ccc111',null);*/
 
insert into y_hallgato(neptun, nev)
values ('ccc111','Cili');

commit;

create table y_tantargy
(kod char(8),
nev varchar2(30) constraint yt_nn_n not NULL,
kredit number(2),
constraint yt_pk primary key (kod));

create table y_hallgatja
(neptun char(6),
targykod char(8),
constraint yhg_pk primary key (neptun, targykod),
constraint yhg_fk_h foreign key (neptun) references y_hallgato(neptun),
constraint yhg_fk_t foreign key (targykod) references y_tantargy(kod));

drop table y_tantargy;

drop table y_tantargy purge;

INSERT INTO y_tantargy (kod,nev,kredit) 
VALUES ('inbp0211', 'Adatbr. lab', 3);

INSERT INTO y_tantargy (kod,nev,kredit) 
VALUES ('inbp0210', 'Adatbr. ea', 3);

INSERT INTO y_tantargy (kod,nev,kredit) 
VALUES ('inbp0221', 'prog1', 6);

commit;

insert into y_hallgatja(neptun, targykod)
values ('aaa111','inbp0211');
insert into y_hallgatja(neptun, targykod)
values ('aaa111','inbp0210');
insert into y_hallgatja(neptun, targykod)
values ('bbb111','inbp0210');

commit;

select *
from y_hallgato h full outer join y_hallgatja hg on h.neptun=hg.neptun
full outer join y_tantargy t on hg.targykod=t.kod;

update y_hallgato
set cim='Db',
cipomeret=39
where neptun='aaa111';

select *
from y_hallgato;

insert into y_hallgato(neptun, nev)
values ('ddd111', 'denes');

select *
from y_hallgato;
commit;

delete y_hallgato
where neptun='ddd111';
commit;

select *
from y_hallgato;

insert into y_hallgato(neptun, nev)
values ('ddd111', 'denes');

insert into y_hallgato(neptun, nev)
values ('eee111', 'elek');

select *
from y_hallgato;

rollback;

select *
from y_hallgato;

insert into y_hallgato(neptun, nev)
values ('ddd111', 'denes');

insert into y_hallgato(neptun, nev)
values ('eee111', 'elek');

select *
from y_hallgato;

savepoint sp1;

insert into y_hallgato(neptun, nev)
values ('fff111', 'ferenc');

insert into y_hallgato(neptun, nev)
values ('ggg111', 'geza');

select *
from y_hallgato;

rollback to sp1;

select *
from y_hallgato;

rollback;

select *
from y_hallgato;

create table y_szamok
(sz number(5));

insert into y_szamok(sz) values (1);
insert into y_szamok(sz) values (5);
insert into y_szamok(sz) values (7);
commit;

select * from y_szamok;

delete y_szamok;

rollback;
select * from y_szamok;

truncate table y_szamok;
-- rollback;  --:)
select * from y_szamok;

create sequence seq_y;

select seq_y.nextval from dual;
select seq_y.currval from dual;

drop sequence seq_y;
create sequence seq_y;


create synonym bela for konyvtar.konyv;

select * from bela;

drop synonym bela;

create view v_sf_konyv as 
select *
from konyvtar.konyv where tema='sci-fi';

select * from v_sf_konyv;

select *
from dict;/*dictionary*/

select * from user_tables;
select * from user_views;
select * from user_synonyms;
select * from user_sequences;
select * from user_tab_cols;
select * from user_constraints;
select * from user_users;

select * from all_users;
select * from all_tables;
select * from all_constraints;

/*select * from dba_tables;
select * from dba_tables where owner like 'U\_%' escape '\';

select * from v$session;
select * from v$process;
select * from v$sql;*/

select * from v$version;



























































 