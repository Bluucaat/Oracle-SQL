select ar/oldalszam, round(ar/oldalszam), trunc(ar/oldalszam)
from konyvtar.konyv;

select ar/oldalszam, round(ar/oldalszam, 2), trunc(ar/oldalszam, 2)
from konyvtar.konyv;

select ar, round(ar, -2), trunc(ar, -2)
from konyvtar.konyv;

select chr(65), ascii('A')
from dual;

select concat(vezeteknev, keresztnev), vezeteknev|| ' '|| keresztnev
from konyvtar.szerzo;

select initcap(cim), cim
from konyvtar.konyv;

select upper(cim), lower(cim)
from konyvtar.konyv;

select cim, substr(cim, 4, 10), length(cim), length( substr(cim, 4, 10))
from konyvtar.konyv;

select cim, replace(lower(cim), 'ny', '****')
from konyvtar.konyv;

select cim, instr(lower(cim), 'ny')
from konyvtar.konyv;

select cim, substr(cim, 6, instr(cim, ',')-6) varos
from konyvtar.tag;

select ar, nvl(ar, 1000000), nvl(to_char(ar), 'nincs')
from konyvtar.konyv;

select *
from konyvtar.konyv
where ar='5980';

select *
from konyvtar.konyv
where to_char(ar)='5980';

select *
from konyvtar.konyv
where ar=to_number('5980');

select *
from konyvtar.konyv
where ar=5980;

select tema, decode(tema, 'horror', 'h', 'krimi', 'k', 'mesek?nyv', 'm','?')
from konyvtar.konyv;

select tema, decode(tema, 'horror', 'h', 'krimi', 'k', 'mesek?nyv', 'm',tema)
from konyvtar.konyv;

select user 
from dual;

select sysdate 
from dual;

select to_char(sysdate, 'yyyy.mm.dd hh24:mi:ss') 
from dual;

select to_char(sysdate, 'hh24:mi:ss dd.mm.yyyy ') 
from dual;

select to_char(sysdate, 'yyyymmddhh24miss') 
from dual;

select to_char(sysdate, 'yyyy/mm*dd.hh24;mi- ss') 
from dual;

select to_char(sysdate, 'yyyy.mm.dd') 
from dual;

select to_char(sysdate, 'year /syyyy') 
from dual;

select to_char(sysdate, 'mon Mon MON month Month MONTH') 
from dual;

select to_char(sysdate, 'w ww') 
from dual;

select to_char(sysdate, 'd dd ddd') 
from dual;

select to_char(sysdate, 'dy Dy DY day Day DAY') 
from dual;

select to_char(sysdate, 'hh24 hh am ') 
from dual;

select to_char(sysdate+1, 'yyyy.mm.dd hh24:mi:ss') 
from dual;

select to_char(sysdate+1/24, 'yyyy.mm.dd hh24:mi:ss') 
from dual;

select to_char(sysdate+3/24, 'yyyy.mm.dd hh24:mi:ss hh am') 
from dual;

select to_char(sysdate, 'sssss') 
from dual;

select to_char(megrendeles_datuma, 'yyyy.mm.dd hh24:mi:ss')
from hajo.s_megrendeles;

select to_date('2000.01.01 10:34:20', 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(to_date('2000.01.01', 'yyyy.mm.dd'), 'day')
from dual;

select to_char(sysdate+1, 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(sysdate+1/24, 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(sysdate+1/24/60, 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(sysdate-1, 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(sysdate+7, 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(add_months(sysdate,1), 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(add_months(sysdate,12), 'yyyy.mm.dd hh24:mi:ss')
from dual;

select sysdate-to_date('2000.01.01 03:11:25', 'yyyy.mm.dd hh24:mi:ss')
from dual;

select (sysdate-to_date('2000.01.01 03:11:25', 'yyyy.mm.dd hh24:mi:ss'))/7
from dual;

select months_between(sysdate, to_date('2000.01.01 03:11:25', 'yyyy.mm.dd hh24:mi:ss'))
from dual;

select months_between(sysdate, to_date('2000.01.01 03:11:25', 'yyyy.mm.dd hh24:mi:ss'))/12
from dual;

select to_char(last_day(sysdate), 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(last_day(add_months(sysdate, -3*12)), 'yyyy.mm.dd hh24:mi:ss')
from dual;

select extract (year from sysdate), extract (month from sysdate), extract (day from sysdate)
from dual;

select to_char(sysdate+1/24, 'yyyy.mm.dd hh24:mi:ss'),
to_char(round(sysdate+1/24), 'yyyy.mm.dd hh24:mi:ss'),
to_char(trunc(sysdate+1/24), 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(sysdate+1/24, 'yyyy.mm.dd hh24:mi:ss'),
to_char(round(sysdate+1/24, 'mm'), 'yyyy.mm.dd hh24:mi:ss'),
to_char(trunc(sysdate+1/24, 'mm'), 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(sysdate+1/24, 'yyyy.mm.dd hh24:mi:ss'),
to_char(round(sysdate+1/24, 'yyyy'), 'yyyy.mm.dd hh24:mi:ss'),
to_char(trunc(sysdate+1/24, 'yyyy'), 'yyyy.mm.dd hh24:mi:ss')
from dual;

select to_char(sysdate+80/24/60, 'yyyy.mm.dd hh24:mi:ss'),
to_char(round(sysdate+80/24/60, 'hh24'), 'yyyy.mm.dd hh24:mi:ss'),
to_char(trunc(sysdate+80/24/60, 'hh24'), 'yyyy.mm.dd hh24:mi:ss')
from dual;

List?zza ki a 50 ?vesn?l id?sebb szerz?k nev?t, sz?let?si d?tum?t ?s ?letkor?t.
A lista legyen ?letkor szerint cs?kken?en rendezett.;

select vezeteknev||' '||keresztnev, to_char(szuletesi_datum, 'yyyy.mm.dd hh24:mi:ss'),
months_between(sysdate, szuletesi_datum)/12 eletkor
from konyvtar.szerzo
where months_between(sysdate, szuletesi_datum)/12>50
order by eletkor desc;

List?zza azokat szerz?ket, akik janu?rban, febru?rban vagy m?rciusban sz?lettek, 
?s a nev?kben szerepel legal?bb 2 a bet? (mindegy, hogy kicsi vagy nagy).
A lista legyen sz?let?si h?nap, azon bel?l n?v szerint rendezett.;

select vezeteknev||' '||keresztnev nev, 
to_char(szuletesi_datum,'yyyy.mm.dd')
from konyvtar.szerzo
where extract( month from szuletesi_datum) in (1,2,3)
--and to_char(szuletesi_datum,'mm') in ('01','02','03')
and lower(vezeteknev||' '||keresztnev) like '%a%a%'
order by extract( month from szuletesi_datum), nev;



