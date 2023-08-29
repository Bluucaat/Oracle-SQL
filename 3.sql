select count(*), count(konyv_azon), count(3), count(ar),
min(ar),max(ar), min(cim), max(cim),
sum(ar), avg(ar)
from konyvtar.konyv;

select avg(ar),
sum(ar)/count(*), sum(ar)/count(ar)
from konyvtar.konyv;

/*A horror t?m?j? k?nyveknek mennyi az ?tlag?ra?*/
select avg(ar)
from konyvtar.konyv
where tema='horror';

select tema, ar, konyv_azon, cim
from konyvtar.konyv
order by tema;

select tema, count(*), min(ar), max(ar), sum(ar), avg(ar)
from konyvtar.konyv
group by tema;

/*List?zza azokat a t?m?kat, amelyeknek az ?tlag?ra t?bb, mint 1500.*/
select tema, avg(ar)
from konyvtar.konyv
group by tema
having avg(ar)>1500;

/*Melyek azok a besorol?sok, amelyekhez 5-n?l t?bb tag tartozik?*/
select besorolas, count(*)
from konyvtar.tag
group by besorolas
having count(*)>5;

/*Az egyes k?nyvekhez (konyv_azon) h?ny p?ld?ny tartozik?*/
select konyv_azon, count(*)
from konyvtar.konyvtari_konyv
group by konyv_azon;

/*Az egyes k?nyvekhez (cim, tema) h?ny p?ld?ny tartozik?*/
select ko.konyv_azon, cim, count(kk.leltari_szam), tema
from konyvtar.konyv ko left outer join
konyvtar.konyvtari_konyv kk
on kk.konyv_azon=ko.konyv_azon
group by cim, ko.konyv_azon, tema;

/*Az egyes szerz?k h?ny k?nyvet ?rtak?*/
select sz.szerzo_azon, vezeteknev||' '||keresztnev, count(ksz.konyv_azon)
from konyvtar.szerzo sz left outer join
konyvtar.konyvszerzo ksz
on sz.szerzo_azon=ksz.szerzo_azon
group by sz.szerzo_azon, vezeteknev, keresztnev;

/*Mely k?nyvnek van 3-n?l t?bb szerz?je?*/
select ko.konyv_azon, cim , count(szerzo_azon)
from konyvtar.konyv ko inner join konyvtar.konyvszerzo ksz
on ko.konyv_azon=ksz.konyv_azon
group by ko.konyv_azon, cim 
having count(szerzo_azon)>3;

/*Mely k?nyvek?rt adtak 3-n?l t?bb szerz?nek 500000-t?l nagyobb honor?riumot?
A list?t rendezze c?m szerint cs?kken?en*/
select ko.konyv_azon, cim , count(szerzo_azon)
from konyvtar.konyv ko inner join konyvtar.konyvszerzo ksz
on ko.konyv_azon=ksz.konyv_azon
where honorarium>500000
group by ko.konyv_azon, cim 
having count(szerzo_azon)>3
order by cim desc;

/*List?zza ki azokat a h?napokat, amelyekben 3-n?l t?bb tag sz?letett.
Rendezze a list?t*/
select to_char(szuletesi_datum, 'mm'), count(*)
from konyvtar.tag
group by to_char(szuletesi_datum, 'mm')
having count(*)>3
order by to_char(szuletesi_datum, 'mm');

select to_char(szuletesi_datum, 'month'), count(*)
from konyvtar.tag
group by to_char(szuletesi_datum, 'month'), to_char(szuletesi_datum, 'mm')
having count(*)>3
order by to_char(szuletesi_datum, 'mm');

/*List?zza ki azokat a tagokat, akiknek 
nev?ben pontosan kett? 'e' bet? van (mindegy, hogy kicsi vagy nagy).*/
select vezeteknev||' '||keresztnev
from konyvtar.tag
where lower(vezeteknev||' '||keresztnev) like '%e%e%'
and lower(vezeteknev||' '||keresztnev) not like '%e%e%e%';

/*List?zza ki azokat a p?ld?nyokat(leltari_szam, konyv_azon), 
amelyek ?rt?ke nagyobb, mint a hozz?juk tartoz? k?nyv ?r?nak a 99%-a.*/
select *
from konyvtar.konyvtari_konyv kk inner join
konyvtar.konyv ko
on kk.konyv_azon=ko.konyv_azon and ertek>ar*0.99;

/*Mennyi az az ?sszoldalsz?m, amely ahhoz a t?m?hoz tartozik, amelyhez a legt?bb ?sszoldalsz?m tartozik?*/
select max(sum(oldalszam))
from konyvtar.konyv
group by tema;

select * from hr.employees;
/*Ki David	Austin f?n?ke?*/

select fonok.first_name, fonok.last_name
from hr.employees da inner join hr.employees fonok
on da.manager_id=fonok.employee_id
where da.first_name='David'
and da.last_name='Austin';

/*Kik azok szerz?k, akik a k?nyv?r?s?rt kapott honor?riumukat 
a k?nyv ?r?hoz hasonl?tva  az ar?ny t?bb, mint 150? List?zza a szerz? nev?t ?s a k?nyv c?m?t, 
illetve az ?rat, a honor?riumot, a kett? ar?ny?t.
A lista legyen az ar?ny szerint rendezett.*/
select cim, ko.konyv_azon, vezeteknev, keresztnev, ar, honorarium, honorarium/ar
from konyvtar.konyv ko inner join 
konyvtar.konyvszerzo ksz on ksz.konyv_azon=ko.konyv_azon
inner join konyvtar.szerzo sz on sz.szerzo_azon=ksz.szerzo_azon
where honorarium/ar>150;













