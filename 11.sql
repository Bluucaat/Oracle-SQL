/*Az 50 ?vesn?l fiatalabb szerel?ket sz?rja a saj?t szerel? t?bl?jaba a szerel? s?ma 
szerel? t?bl?j?b?l.*/
create table y_szerelo as select * from szerelo.sz_szerelo where 0=1;

insert into y_szerelo(azon,nev,cim, telefon,szul_dat,adoszam)
select azon,nev,cim,telefon,szul_dat,adoszam
from szerelo.sz_szerelo
where months_between(sysdate, szul_dat)/12<50;
rollback;

/*A piros aut?kat fel?rt?kelik a mai nap. 
A fel?rt?kel?s ?rt?ke legyen az aut? els? v?s?rl?si ?r?nak a 90%-a.*/
insert into y_autofelertekeles(ertek, auto_azon, datum)
select elso_vasarlasi_ar*0.9, azon, sysdate
from szerelo.sz_auto
where szin='piros';
rollback;


/*Azokat az aut?kat, amelyekhez 3-n?l t?bb szerel?s tartozik, 
fel?rt?kelik a mai nappal. Az ?j ?rt?k legyen az aut? els? v?s?rl?si ?ra cs?kkentve 
az aut? ?ssz munkav?gz?si ?r?nak a 50%?val.*/

/*select azon, sysdate
from szerelo.sz_auto
where azon in (select auto_azon
              from szerelo.sz_szereles
              group by auto_azon
              having count(*)>3);*/
            
insert into y_autofelertekeles(auto_azon, ertek, datum)              
select azon, elso_vasarlasi_ar-sum(munkavegzes_ara)*0.5, sysdate
from szerelo.sz_auto au inner join szerelo.sz_szereles sz
on au.azon=sz.auto_azon
group by azon, elso_vasarlasi_ar
having count(*)>3;
rollback;

/*A piros Fiatokat ma elkezdik szerelni a F?ktelen?l Bt.-ben Vegye fel a szerel?s t?bl?ba a sort.*/
select au.azon
from szerelo.sz_auto au
where szin='piros'
and tipus_azon in (select azon from szerelo.sz_autotipus where marka='Fiat');

select m.azon
from szerelo.sz_szerelomuhely m
where nev='F?ktelen?l Bt.';

insert into y_szereles(auto_azon, muhely_azon, szereles_kezdete)
select au.azon, m.azon, sysdate
from szerelo.sz_auto au, szerelo.sz_szerelomuhely m
where szin='piros'
and tipus_azon in (select azon from szerelo.sz_autotipus where marka='Fiat')
and nev='F?ktelen?l Bt.';
commit;

/*Az Andornakt?ly?n lak? tulajdonos megv?s?rolja ma az APZ rendsz?m kezdet? aut?t. Vegye fel a sort 
az auto_tulajdonosa t?bl?ba.*/
select tu.azon
from szerelo.sz_tulajdonos tu
where cim like 'Andornakt?lya, %';

select au.azon
from szerelo.sz_auto au
where rendszam like 'APZ%';

insert into y_auto_tulajdonosa (auto_azon, tulaj_azon, vasarlas_ideje)
select au.azon, tu.azon, sysdate
from szerelo.sz_auto au, szerelo.sz_tulajdonos tu
where rendszam like 'APZ%'
and cim like 'Andornakt?lya, %';
rollback;

insert into y_auto_tulajdonosa (auto_azon, tulaj_azon, vasarlas_ideje)
select tulaj_azon, auto_azon, sysdate
from (select tu.azon tulaj_azon
from szerelo.sz_tulajdonos tu
where cim like 'Andornakt?lya, %'),

(select au.azon auto_azon
from szerelo.sz_auto au
where rendszam like 'APZ%');

/*A legfiatalabb szerel? ma elkezd dolgozni abban a m?helyben 
ahol a legt?bb szerel?st v?gezt?k eddig. Vegye sort a dolgozik t?bl?ba.*/
insert into y_dolgozik(szerelo_azon, muhely_azon, munkaviszony_kezdete)
select szerelo_azon, muhely_azon, sysdate
from (
select azon szerelo_azon
from szerelo.sz_szerelo
order by szul_dat desc nulls last
fetch first row with ties),

(select m.azon muhely_azon
from szerelo.sz_szerelomuhely m left outer join
szerelo.sz_szereles sz
on m.azon=sz.muhely_azon
group by m.azon
order by  count(sz.szereles_kezdete) desc
fetch first row with ties);
rollback;

/*List?zza az els? 5 legnagyobb aut?fel?rt?kel?s ?rt?ke, ?s rendsz?ma*/
select ertek, rendszam
from szerelo.sz_auto inner join szerelo.sz_autofelertekeles
on azon=auto_azon
order by ertek desc nulls last
fetch first 5 row with ties;

/*List?zza a m?sodik 5 legnagyobb aut?fel?rt?kel?s ?rt?k?t, ?s rendsz?m?t*/
select ertek, rendszam
from szerelo.sz_auto inner join szerelo.sz_autofelertekeles
on azon=auto_azon
order by ertek desc nulls last
offset 5 rows fetch next 5 row with ties;

/*Hozzon l?tre n?zetet, amely megmutatja, hogy az egyes aut?kat h?nyszor szerelt?k
?s h?nyszor ?rt?kelt?k fel. Az aut?nak a rendsz?m?t ?s azon-j?t is list?zza.*/
create view vy1 as
select au.azon auto_azon, rendszam, nvl(szereles_db, 0) szereles_db,
nvl(felertekeles_db, 0) felertekeles_db
from szerelo.sz_auto au left outer join

(select auto_azon, count(szereles_kezdete) szereles_db
from szerelo.sz_szereles
group by auto_azon) sz
on au.azon=sz.auto_azon

left outer join 

(select auto_azon, count(datum) felertekeles_db
from szerelo.sz_autofelertekeles
group by auto_azon) fe
on au.azon=fe.auto_azon;

/*N?velje meg a munkav?gz?s ?r?t 10%-kal azon lez?rt szerel?sek eset?n ahol piros Fiat szerelt?k, 
?s amelyeket a Bek? Antal ?ltal vezetett m?helyben v?geztek. */
update y_szereles
set munkavegzes_ara=munkavegzes_ara*1.1
where auto_azon in (select azon from szerelo.sz_auto
                    where szin='piros'
                    and tipus_azon in (select azon from szerelo.sz_autotipus where marka='Fiat'))
and muhely_azon in (select azon from szerelo.sz_szerelomuhely
                    where vezeto_azon =(select azon from szerelo.sz_szerelo
                                       where nev='Bek? Antal'));
                                       
rollback;                                       







