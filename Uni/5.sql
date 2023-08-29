--List?zza, hogy az utols? 5 k?lcs?nz?sben melyik k?nyvet(cim) ki k?lcs?nzte (nev).
select kv.konyv_azon, kv.cim, t.olvasojegyszam, 
t.vezeteknev, t.keresztnev, to_char(kcs.kolcsonzesi_datum, 'yyyy.mm.dd hh24:mi:ss')
from konyvtar.tag t inner join
konyvtar.kolcsonzes kcs 
on t.olvasojegyszam=kcs.tag_azon
inner join konyvtar.konyvtari_konyv kk
on kcs.leltari_szam=kk.leltari_szam
inner join konyvtar.konyv kv
on kk.konyv_azon=kv.konyv_azon
order by kcs.kolcsonzesi_datum desc nulls last
fetch first 5 rows with ties;

--Melyik tag k?lcs?n?zte a legt?bb k?nyvet?
select vezeteknev, keresztnev, t.olvasojegyszam, count(ko.leltari_szam) db
from konyvtar.tag t left outer join
konyvtar.kolcsonzes ko
on t.olvasojegyszam=ko.tag_azon
group by vezeteknev, keresztnev, t.olvasojegyszam
order by db desc 
fetch first row with ties;


select vezeteknev, keresztnev, t.olvasojegyszam, count(ko.leltari_szam) db
from konyvtar.tag t left outer join
konyvtar.kolcsonzes ko
on t.olvasojegyszam=ko.tag_azon
group by vezeteknev, keresztnev, t.olvasojegyszam
having count(ko.leltari_szam)=(select max(count(ko.leltari_szam))
                               from konyvtar.tag t left outer join
                               konyvtar.kolcsonzes ko
                               on t.olvasojegyszam=ko.tag_azon
                               group by vezeteknev, keresztnev, t.olvasojegyszam);
                               
--Olyan tulajdonl?sokat keres?nk, amelyben fekete piros vagy k?k sz?n? aut?k 
--Debreceni tulajdonos az elm?lt 2 ?vben v?s?rolt. (tulajn?v, rendszam, vasarlas_ideje)
select *
from szerelo.sz_auto au inner join szerelo.sz_auto_tulajdonosa atu 
on au.azon=atu.auto_azon inner join szerelo.sz_tulajdonos t
on t.azon=atu.tulaj_azon
where szin in ('piros', 'k?k', 'fekete')
and t.cim like 'Debrecen,%'
and months_between(sysdate, vasarlas_ideje)/12<2;

--A piros aut?k k?z?l melyik a legdr?g?bb? (elso_vasarlasi_ar)
select *
from szerelo.sz_auto
where szin='piros'
order by elso_vasarlasi_ar desc nulls last
fetch first row with ties;

select *
from szerelo.sz_auto
where szin='piros'
and elso_vasarlasi_ar=(select max(elso_vasarlasi_ar) 
                      from szerelo.sz_auto
                      where szin='piros');

--Melyek azok a m?rk?k, amelyekhez 3-n?l t?bb t?pus tartozik.
select marka, count(azon)
from szerelo.sz_autotipus
group by marka
having count(azon)>3;

--Melyek azok a m?rk?k, amelyekhez 3-n?l kevesebb t?pus tartozik.
select am.nev, count(azon)
from szerelo.sz_autotipus ati right outer join szerelo.sz_automarka am
on ati.marka=am.nev
group by am.nev
having count(azon)<3;

--Melyek azok az aut?k, amelyeknek az els? v?s?rl?si ?ra kevesebb, 
--mint a k?k aut?k ?tlagos els? v?s?rl?si ?ra
select *
from szerelo.sz_auto
where elso_vasarlasi_ar<(select avg(elso_vasarlasi_ar) 
                         from szerelo.sz_auto
                         where szin='k?k');
                         
--List?zza azokat az ?v-h?nap p?rosokat, amelyekben 2-n?l t?bb aut?t adtak el?sz?r.                         
select to_char(elso_vasarlas_idopontja, 'yyyy.mm'), count(azon)
from szerelo.sz_auto
group by to_char(elso_vasarlas_idopontja, 'yyyy.mm')
having count(azon)>2;

--Melyek azok a szerel?sek, amelyek 3 napn?l r?videbb ideig tartottak?
--Melyik m?helyben, melyik aut?n
--Ha a szerel?s nem ?rt v?get, akkor a mai d?tumhoz hasonl?tsuk.
--A lista legyen m?helyn?v, azon bel?l rendsz?m szerint cs?kken?en rendezett.
select rendszam, szm.nev
from szerelo.sz_auto au inner join szerelo.sz_szereles sz on au.azon=sz.auto_azon
inner join szerelo.sz_szerelomuhely szm on sz.muhely_azon=szm.azon
where nvl(szereles_vege, sysdate)-szereles_kezdete<3
order by szm.nev, rendszam;

--Melyik aut?t nem szerelt?k?
select * from szerelo.sz_auto
where azon not in (select auto_azon from szerelo.sz_szereles);

--Kik azok a tulajdonosok, akiknek a nev?ben pontosan k?t 'a' bet? szerepel
--?s a c?m?ben szerepel a debrecen sz?, 
--mindegy, hogy kicsi vagy
--?s a vezet?k neve 4 karakter hossz?
-- a lista legyen v?ros, azon bel?l n?v szerint rendezett.

select nev, substr(cim, 1, instr(cim,',')-1) varos, cim
from szerelo.sz_tulajdonos
where lower(nev) like '%a%a%' and lower(nev) not like '%a%a%a%'
and nev like '____ %' and
lower(cim) like '%debrecen%'
order by varos, nev;

--V?rosonk?nt h?ny tulajdonos van?
select substr(cim, 1, instr(cim,',')-1) varos, count(*)
from szerelo.sz_tulajdonos
group by substr(cim, 1, instr(cim,',')-1);











