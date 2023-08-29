create table y_konyv as select * from konyvtar.konyv;

alter table y_konyv add constraint yk_pk primary key (konyv_azon);

grant select, references on y_konyv to u_nnnn, aniko;

select *
from u_egxyop.y_konyv;

create table y_vmi
(azon number(5),
konyv_azon number(10),
constraint yv_fk foreign key (konyv_azon) references u_egxyop.y_konyv (konyv_azon));

grant insert (konyv_azon, cim, ar) on y_konyv to u_ic56f2, aniko;

insert into u_ic56f2.y_konyv(konyv_azon, cim, ar)
values (123, 'Feny?fa', 1000);

select * from y_konyv;
commit;

select * from y_konyv;

revoke insert, select on y_konyv from u_ic56f2, aniko;
revoke insert on y_konyv from u_ic56f2;

drop table y_vmi;
revoke references on y_konyv from u_ic56f2;

select *
from user_tab_privs;

select *
from user_sys_privs;

select *
from user_role_privs;

select * from dict where table_name like '%ROLE%';

SELECT * from role_sys_privs;

select * from y_konyv;

alter table y_konyv add constraint yk_pk primary key (konyv_azon);

alter table y_konyv drop constraint yk_pk;

alter table y_konyv add constraint yk_pk primary key (konyv_azon);

alter table y_konyv drop primary key;

alter table y_konyv add constraint yk_ch check (isbn is not null);
/*uq, fk, ch, pk*/

delete y_konyv where isbn is null;

alter table y_konyv add constraint yk_ch check (isbn is not null);

alter table y_konyv rename constraint yk_ch to yk_ch2;

rename y_konyv to y_konyv2;

rename y_konyv2 to y_konyv;

alter table y_konyv add (szin varchar2(10));

alter table y_konyv modify szin varchar2(30);

alter table y_konyv rename column szin to szin2;

alter table y_konyv drop column szin2;


/*Hozzon l?tre n?zetet, amely megmutatja, hogy egy aut?nak h?ny tulajdonosa van, 
mikor v?s?rol?k meg utolj?ra. A lista legyen rendsz?m szerint rendezett.*/
create view v_atu as 
select au.azon, rendszam, count(atu.tulaj_azon) db, max(vasarlas_ideje) mvi
from szerelo.sz_auto au left outer join
szerelo.sz_auto_tulajdonosa atu
on au.azon=atu.auto_azon
group by au.azon, rendszam;

/*Hozzon l?tre n?zetet, amely megmutatja, hogy az egyes dolgoz?knak ki a f?n?ke*/
create view v_fonok6 as
select beosztott.employee_id dolg_azon, beosztott.first_name||' '||beosztott.last_name dolg_nev,
fonok.employee_id fonok_azon, fonok.first_name||' '||fonok.last_name fonok_nev
from hr.employees beosztott left outer join
hr.employees fonok
on beosztott.manager_id=fonok.employee_id;

/*Hozzon l?tre n?zetet, amely megmutatja, hogy az egyes szerel?k jelenlegi munkahely?t (muhely)?
Minden szerel?t list?zzon.*/
create view v_d as
select sz.azon szerelo_azon, sz.nev szerelo_nev,
szm.azon muhely_azon, szm.nev muhely_nev
from szerelo.sz_szerelo sz left outer join szerelo.sz_dolgozik d
on sz.azon=d.szerelo_azon
left outer join szerelo.sz_szerelomuhely szm 
on d.muhely_azon=szm.azon
where d.munkaviszony_vege is null;

/*Sz?nenk?nt melyik a legdr?g?bb aut??*/
select *
from szerelo.sz_auto
where (nvl(szin,'null'), elso_vasarlasi_ar) in (select nvl(szin,'null'), max(elso_vasarlasi_ar)
                                    from szerelo.sz_auto
                                    group by szin);
                                    
select *
from szerelo.sz_auto au inner join (select szin, max(elso_vasarlasi_ar) meva
                                    from szerelo.sz_auto
                                    group by szin) bs
on (au.szin=bs.szin or au.szin is null and bs.szin is null)
and au. elso_vasarlasi_ar=bs.meva;

/*Az egyes aut?knak (rendszam) mennyi az utols? fel?rt?kel?si ?rt?ke?*/
select rendszam ,au.azon, ertek
from szerelo.sz_auto au left outer join 
(select *
 from szerelo.sz_autofelertekeles
 where (auto_azon, datum) in (select auto_azon, max(datum)
                             from szerelo.sz_autofelertekeles
                             group by auto_azon)) bs
on au.azon=bs.auto_azon;


















