select *
from hr.employees, hr.departments;

select *
from hr.employees emp, hr.departments dept
where emp.department_id=dept.department_id;

select *
from hr.employees emp inner join hr.departments dept on emp.department_id=dept.department_id;


select *
from hr.employees emp inner join hr.departments dept using (department_id);

select *
from hr.employees natural join hr.jobs;


select *
from hr.employees emp natural join hr.departments;

select *
from hr.employees emp inner join hr.departments dept on emp.department_id=dept.department_id;

select *
from hr.employees emp left outer join hr.departments dept on emp.department_id=dept.department_id;

select *
from hr.departments;

select distinct dept.department_id, department_name
from hr.employees emp inner join hr.departments dept on emp.department_id=dept.department_id;

select *
from hr.employees emp right outer join hr.departments dept on emp.department_id=dept.department_id;

select *
from hr.employees emp full outer join hr.departments dept on emp.department_id=dept.department_id;

select *
from hr.employees emp, hr.departments dept
where emp.department_id=dept.department_id(+);
/*List?zza ki az ?sszes dolgoz?t ?s a munkak?r?k nev?t. 
A lista legyen munkak?r, azon bel?l n?v szerint rendezett.*/

select jo.job_id, job_title, first_name, last_name, employee_id
from hr.employees emp left outer join hr.jobs jo
on emp.job_id=jo.job_id
order by job_title, first_name, last_name;

/*List?zza ki a Toyota m?rk?j? aut?k rendsz?m?t ?s t?pus?t.*/
select ati.megnevezes, rendszam
from szerelo.sz_autotipus ati inner join
szerelo.sz_auto au
on ati.azon=au.tipus_azon
where marka='Toyota';

/*A F?ktelen?l Bt. nev? m?helynek ki a f?n?ke?*/
select sz.nev, sz.azon
from szerelo.sz_szerelomuhely szm inner join 
szerelo.sz_szerelo sz on szm.vezeto_azon=sz.azon
where szm.nev='F?ktelen?l Bt.';

/*Bik?s Alex mely m?helyekben dolgozott (dolgozik) valaha?*/
select szm.azon, szm.nev
from szerelo.sz_szerelo sz inner join
szerelo.sz_dolgozik d on sz.azon=d.szerelo_azon
inner join szerelo.sz_szerelomuhely szm
on d.muhely_azon=szm.azon
where sz.nev='Bik?s Alex';

/*Mely aut?kat szerelt?k a F?ktelen?l Bt. nev? m?helyben*/
select au.azon, au.rendszam
from szerelo.sz_szerelomuhely m inner join szerelo.sz_szereles sz
on m.azon=sz.muhely_azon
inner join szerelo.sz_auto au on au.azon=sz.auto_azon
where m.nev='F?ktelen?l Bt.';

/*List?zza ki a piros aut?kat, ?s ha volt fel?rt?kel?s?k, akkor tegye mell?j?k az ?rt?ket.*/
select au.azon, szin, rendszam, ertek, to_char(datum,'yyyy.mm.dd hh24:mi:ss')
from szerelo.sz_auto au left outer join szerelo.sz_autofelertekeles fe
on fe.auto_azon=au.azon
where szin='piros';

/*List?zza ki az ?sssze piros,k?k vagy fekete aut?t, ?s ha van szerel?se, akkor
azon szerel?seit (m?hely n?vvel), 
amely az elm?lt 2 ?vben t?rt?nt (szerel?s_kezdete). 
?rja ki, hogy a szerel?s milyen hossz? volt (ha m?g nem ?rt v?get, akkor mai d?tumhoz viszony?tsa) 
A lista legyen a m?hely neve, azon bel?l a szerel?s kezdete szerint cs?kken?en rendezve. */

select au.azon, au. rendszam, szin, m.azon, m.nev,
to_char(szereles_kezdete, 'yyyy.mm.dd hh24:mi:ss'),
to_char(szereles_vege, 'yyyy.mm.dd hh24:mi:ss'),
nvl(szereles_vege, sysdate)-szereles_kezdete
from szerelo.sz_auto au left outer join szerelo.sz_szereles sz
on au.azon=sz.auto_azon
left outer join szerelo.sz_szerelomuhely m
on sz.muhely_azon=m.azon
where szin in ('piros','k?k', 'fekete')
and (months_between (sysdate,szereles_kezdete)/12<2 or szereles_kezdete is null)
order by m.nev, szereles_kezdete desc;









