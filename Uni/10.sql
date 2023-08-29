/*T?r?lje azot az aut?kat, amelyeket nem szereltek ?s nincs fel?rt?kel?s?k*/
create table y_auto as select * from szerelo.sz_auto;

delete--select *
from y_auto ---
where azon not in (select auto_azon from szerelo.sz_szereles)
and azon not in (select auto_azon from szerelo.sz_autofelertekeles);
rollback;

/*T?r?lje azokat a fel?rtkel?seket, amelyek piros Fiat aut?khoz tartoznak ?s 
fel?rt?k?l?si ?rt?k?k t?bb, mint 1m*/
create table y_autofelertekeles as select * from szerelo.sz_autofelertekeles;
delete--select *
from y_autofelertekeles
where auto_azon in (select azon from szerelo.sz_auto
                   where szin='piros'
                   and tipus_azon in (select azon from szerelo.sz_autotipus
                                      where marka='Fiat'))
and ertek>1000000;                                      
rollback;

/*T?r?lje azokat a tulajdonl?sokat, amelyben nem debreceni tulajdonos olyan aut?t birtokol,
amelyet 3-n?l t?bbsz?r szereltek.*/
create table y_auto_tulajdonosa as select * from szerelo.sz_auto_tulajdonosa;
delete--select *
from y_auto_tulajdonosa
where tulaj_azon in (select azon from szerelo.sz_tulajdonos
                     where cim not like 'Debrecen, %')
and auto_azon in (select auto_azon
                 from szerelo.sz_szereles
                 group by auto_azon
                 having count(szereles_kezdete)>3);

rollback;                 
/*T?r?lje azokat a tulajdonl?sokat, amelyben nem debreceni tulajdonos olyan aut?t birtokol,
amelyet 2-n?l kevesebbszer szereltek.*/

delete--select *
from y_auto_tulajdonosa
where tulaj_azon in (select azon from szerelo.sz_tulajdonos
                     where cim not like 'Debrecen, %')
and auto_azon in (select au.azon
                 from szerelo.sz_auto au left outer join szerelo.sz_szereles sz
                 on au.azon=sz.auto_azon
                 group by au.azon
                 having count(szereles_kezdete)<2);
rollback;                 

/*T?r?lje azokat a szerel?seket, amelyeket olyan aut?n v?geztek, amelyhez 
l?tezik legal?bb 1db 2m-n?l nagyobb fel?rt?kel?s
?s olyan m?helyben szerelt?k, amelynek a f?n?ke Bek? Antal.*/

create table y_szereles as select * from szerelo.sz_szereles;
delete--select * 
from y_szereles
where auto_azon in (select auto_azon from szerelo.sz_autofelertekeles af
                    where ertek>2000000)
and muhely_azon in (select azon from szerelo.sz_szerelomuhely
                   where vezeto_azon in (select azon 
                                         from szerelo.sz_szerelo
                                         where nev='Bek? Antal'));
rollback;                                         

/*T?r?lje azokat a szerel?seket, amelyek eset?n a munkav?gz?s ?ra t?bb, 
mint az aut? els? v?s?rl?si ?r?nak a 10%-a.*/
delete--select *
from y_szereles sz
where munkavegzes_ara>(select elso_vasarlasi_ar*0.1
                      from szerelo.sz_auto au
                      where sz.auto_azon=au.azon);
rollback;

/*T?r?lje azokat a fel?rt?kel?seket, amelyek ?rt?ke t?bb, mint az aut? els? v?s?rl?si ?r?nak a 90%-a*/
delete--select *
from y_autofelertekeles af
where ertek>(select elso_vasarlasi_ar*0.9
             from szerelo.sz_auto au
             where af.auto_azon=au.azon);
rollback;             

/*M?dos?tsa a szerel?s t?bl?t, a piros, fekete vagy k?k Fiat aut?k eset?n 
 a le nem z?rt szerel?sek ?ra legyen az aut? els? v?s?rl?si ?r?nak az 1%-a,
 z?rja le a szerel?st a mai d?tummal, de csak azokra a szerel?sekre, amelyeket 
 Bek? T?ni ?s Fia Kft.-n?l v?geztek.*/
 update y_szereles sz
 set szereles_vege=sysdate,
 munkavegzes_ara=(select elso_vasarlasi_ar*0.01 from szerelo.sz_auto au where sz.auto_azon=au.azon)
 where auto_azon in (select azon from szerelo.sz_auto
                   where szin in ('piros', 'fekete', 'k?k')
                   and tipus_azon in (select azon from szerelo.sz_autotipus
                                      where marka='Fiat'))
and muhely_azon in (select azon 
                    from szerelo.sz_szerelomuhely
                    where nev='Bek? T?ni ?s Fia Kft.');
rollback;                    

/*M?dos?tsa a dolgozik t?bl?t. A legfiatalabb szerel? munkaviszonyait 
z?rja le a mai d?tummal (mert p?ly?t v?lt)*/
create table y_dolgozik as select * from szerelo.sz_dolgozik;
update y_dolgozik
set munkaviszony_vege=sysdate
where szerelo_azon in (select azon from szerelo.sz_szerelo
                       order by szul_dat desc nulls last
                       fetch first row with ties);
rollback;                       

/*M?dos?tsa az aut?fel?rt?kel?s t?bl?t, n?velje meg a fel?rt?kel?si ?rt?ket 
az aut? els? v?s?rl?si ?r?nak az 1%-?val azon aut?k eset?n,
amelyek pirosak, Fiat m?rk?j?ak 
?s 2-n?l kevesebb tulajdonsuk van. */
update y_autofelertekeles af
set ertek=ertek+(select elso_vasarlasi_ar*0.01
                 from szerelo.sz_auto au
                 where af.auto_azon=au.azon)
where auto_azon in (select au.azon
                 from szerelo.sz_auto au left outer join 
                 szerelo.sz_auto_tulajdonosa atu
                 on au.azon=atu.auto_azon
                 where szin = 'piros'
                   and tipus_azon in (select azon from szerelo.sz_autotipus
                                      where marka='Fiat')
                 group by au.azon
                 having count(tulaj_azon)<2);
rollback;                 









