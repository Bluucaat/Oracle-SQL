SQL: Structured Query Language
- ddl: data definition language: create, alter, drop, truncate
- dml: data manipulation language: insert, update, delete, merge
  - ql: query language: select 
- dcl:data control language:
   - tranzakci?kezel?s: commit, rollback, savepoint;
   - jogosults?gkezel?s: grant, revoke;
   
select *
from konyvtar.konyv;

select cim, ar, oldalszam
from konyvtar.konyv;

select cim, ar/oldalszam, ar*10, 5*5
from konyvtar.konyv;

select cim, ar/oldalszam ar_per_oldalszam, ar*10 as tizszeres_ar, 5*5
from konyvtar.konyv;


select  5*5, sin(0), cos(0), power(3,4)
from dual;

select *
from dual;

select *
from konyvtar.konyv
order by tema, kiado, cim;

select *
from konyvtar.konyv
order by cim;

select *
from konyvtar.konyv
order by tema asc, kiado desc, cim desc;

select *
from konyvtar.konyv
order by tema nulls first, ar;

select *
from konyvtar.konyv
order by tema desc nulls last, ar;

select *
from konyvtar.konyv
where tema='horror'
order by cim;

select *
from konyvtar.konyv
where tema!='horror'
order by cim;

select *
from konyvtar.konyv
where tema<>'horror'
order by cim;

select *
from konyvtar.konyv
where ar<=5000
order by cim;

select *
from konyvtar.konyv
where ar<5000
order by cim;

select *
from konyvtar.konyv
where ar<=5000
order by cim;

select *
from konyvtar.konyv
where ar>5000
order by cim;

select *
from konyvtar.konyv
where cim>'Elef?nt'
order by cim;

select *
from konyvtar.konyv
where ar>=2000 and tema='krimi'
order by cim;

select *
from konyvtar.konyv
where ar>=2000 or tema='krimi'
order by cim;

select *
from konyvtar.konyv
where not(ar>=2000 or tema='krimi')
order by cim;

select *
from konyvtar.konyv
where ar>=2000 and ar<=5000
order by ar;

select *
from konyvtar.konyv
where ar between 2090 and 4741
order by ar;

select *
from konyvtar.konyv
where ar not between 2090 and 4741
order by ar;

select *
from konyvtar.konyv
where ar is null
order by ar;

select *
from konyvtar.konyv
where ar is not null
order by ar;


select *
from konyvtar.konyv
where tema='horror' or tema='sci-fi' or tema='mesek?nyv'
order by tema, cim;

select *
from konyvtar.konyv
where tema in ('horror', 'sci-fi', 'mesek?nyv')
order by tema, cim;

select *
from konyvtar.konyv
where tema not in ('horror', 'sci-fi', 'mesek?nyv')
order by tema, cim;

select *
from konyvtar.konyv
where tema not in ('horror', 'sci-fi', 'mesek?nyv') or tema is null
order by tema, cim;

select *
from konyvtar.konyv
where cim='Nap?leon';

select *
from konyvtar.konyv
where cim like 'A%';

select *
from konyvtar.konyv
where cim like '_a%';

select *
from konyvtar.konyv
where cim not like '_a%';

select cim, upper(cim), lower(cim)
from konyvtar.konyv
where lower(cim) like '%a%';

--comment egysoros
/*
t?bb soros comment
*/

Keress?k azokat a n?i tagokat, akiknek a besorol?sa gyerek, nyugd?jas vagy di?k.
A lista legyen besorol?s, azon bel?l n?v szerint cs?kken?en rendezett. 

select besorolas, vezeteknev||' '|| keresztnev nev, nem
from konyvtar.tag
where nem='n' and besorolas in ('gyerek', 'nyugd?jas','di?k')
order by besorolas, nev desc;

select besorolas, concat(concat(vezeteknev, ' '), keresztnev) nev, nem
from konyvtar.tag
where nem='n' and besorolas in ('gyerek', 'nyugd?jas','di?k')
order by besorolas, nev desc;

List?zza a debreceni tagok nev?t ?s c?m?t!
select *
from konyvtar.tag
where cim like '____ Debrecen, %';




