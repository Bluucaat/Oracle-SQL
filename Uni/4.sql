--Az IT és Sales nevû részlegek dolgozóit listázzuk.
select employee_id, first_name, last_name
from hr.employees emp inner join hr.departments dept
on emp.department_id=dept.department_id
where department_name in ('IT', 'Sales');

select employee_id, first_name, last_name
from hr.employees
where department_id in (select department_id
                       from hr.departments
                       where department_name in ('IT', 'Sales'));

select employee_id, first_name, last_name
from hr.employees emp inner join (select department_id
                              from hr.departments
                              where department_name in ('IT', 'Sales')) d
on emp.department_id=d.department_id;    

--Listázza azokat a részlegeket, amelyeken nincs dolgozó.
select *
from hr.departments 
where department_id not in (select department_id from hr.employees where department_id is not null);

--Melyik dolgozó keresi a legtöbbet?
select *
from hr.employees
where salary=(select max(salary) from hr.employees);

--Kik azok a dolgozók, akik átlag felett keresnek?
select *
from hr.employees
where salary>(select avg(salary) from hr.employees);

--Mely részlegnek nincs dolgozója.
select *
from hr.departments dept
where not exists (select 1
                  from hr.employees emp
                  where dept.department_id=emp.department_id);
                  
--Kik azok a dolgozók, akik több fizetést kapnak, mint összes IT részlegen dolgozó fizetése.
select *
from hr.employees
where salary>all(select salary from hr.employees
                where department_id in (select department_id 
                                        from hr.departments  
                                        where department_name='IT'));

select *
from hr.employees
where salary>(select max(salary) from hr.employees
                where department_id in (select department_id 
                                        from hr.departments  
                                        where department_name='IT'));
                                        
--Kik azok a dolgozók, akik több fizetést kapnak, mint valamely IT részlegen dolgozó fizetése. 
select *
from hr.employees
where salary>any(select salary from hr.employees
                where department_id in (select department_id 
                                        from hr.departments  
                                        where department_name='IT'));
                                        
select *
from hr.employees
where salary>(select min(salary) from hr.employees
                where department_id in (select department_id 
                                        from hr.departments  
                                        where department_name='IT'));
                                        
select vezeteknev, keresztnev
from konyvtar.szerzo
union
select vezeteknev, keresztnev
from konyvtar.tag;

select vezeteknev, keresztnev, 'alma'
from konyvtar.szerzo
intersect
select vezeteknev, keresztnev
from konyvtar.tag;
                   

select vezeteknev, keresztnev
from konyvtar.szerzo
intersect
select vezeteknev, szuletesi_datum
from konyvtar.tag;
                                        
select vezeteknev, keresztnev
from konyvtar.szerzo
intersect
select vezeteknev, to_char(szuletesi_datum,'yyyymmdd')
from konyvtar.tag;

select vezeteknev, keresztnev
from konyvtar.szerzo
intersect
select 'Jókai', 'Mór'
from konyvtar.tag;


select keresztnev
from konyvtar.szerzo
intersect
select keresztnev
from konyvtar.tag;

select keresztnev
from konyvtar.szerzo
minus
select keresztnev
from konyvtar.tag;

select keresztnev
from konyvtar.szerzo
union all
select keresztnev
from konyvtar.tag;

--Keressük azokat a keresztneveket, akik valamely tag nevében és valamely szerzõ nevében szerepelnek.
select keresztnev
from konyvtar.szerzo
intersect
select keresztnev
from konyvtar.tag;

select distinct sz.keresztnev
from konyvtar.szerzo sz inner join konyvtar.tag t
on sz.keresztnev=t.keresztnev;

--Keressük azokat a keresztneveket, akik valamely tag nevében szerepelnek, 
--de nem szereplenek egyik szerzõ nevében sem.

select keresztnev
from konyvtar.tag
minus
select keresztnev
from konyvtar.szerzo;

select distinct keresztnev
from konyvtar.tag
where keresztnev not in (select keresztnev from konyvtar.szerzo);

--Listázza az összes különbözõ évszámot a tagok és a szerzõ születési dátumából.
select to_char(szuletesi_datum, 'yyyy') sz
from konyvtar.tag
minus
select to_char(szuletesi_datum, 'yyyy')
from konyvtar.szerzo
order by sz;

--Listázza az összes helységnevet a szerelõ sémából.
select cim, instr(cim, ','), substr(cim, 1, instr(cim, ',')-1)
from szerelo.sz_szerelo;

select substr(cim, 1, instr(cim, ',')-1)
from szerelo.sz_szerelo
union 
select substr(cim, 1, instr(cim, ',')-1)
from szerelo.sz_szerelomuhely
union
select substr(cim, 1, instr(cim, ',')-1)
from szerelo.sz_tulajdonos;

--Listázza ki az elsõ 10 legnagyobb keresetû dolgozót (hr)
select employee_id, first_name, last_name, salary, rownum
from hr.employees
order by salary desc nulls last;

select employee_id, first_name, last_name, salary, rownum
from hr.employees;

select employee_id, first_name, last_name, salary, rownum
from (select employee_id, first_name, last_name, salary
      from hr.employees
      order by salary desc nulls last)
where rownum<11;

select employee_id, first_name, last_name, salary, rownum
from (select employee_id, first_name, last_name, salary
      from hr.employees
      order by salary desc nulls last)
where rownum<2;

/*select *
from (select *
      from konyvtar.konyv
      order by ar desc nulls last)
where rownum<2;*/

select *
from konyvtar.konyv
where ar=(select max(ar) from konyvtar.konyv);

select *
from konyvtar.konyv
order by ar desc nulls last
fetch first row with ties;

select *
from konyvtar.konyv
order by ar desc nulls last
fetch first row only;

select *
from konyvtar.konyv
order by ar desc nulls last
fetch first 8 rows with ties;

--Egy lista második 10 eleme
select *
from konyvtar.konyv
order by ar desc nulls last
offset 10 rows fetch next 10 rows with ties;

--Egy lista elsõ 10%-a:
select *
from konyvtar.konyv
order by ar desc nulls last
fetch first 10 percent rows with ties;

--Listázza a 10 legidõsebb szerzõ nevét.
select vezeteknev, keresztnev, szerzo_azon, to_char(szuletesi_datum,'yyyy.mm.dd hh24:mi:ss')
from konyvtar.szerzo
order by szuletesi_datum
fetch first 10 rows with ties;

--Kik (tagnév) és milyen könyvet (cim, ltsz, ka) kölcsönztek az utolsó 5 kölcsönzésben?
select vezeteknev, keresztnev, olvasojegyszam, kk.leltari_szam, ko.konyv_azon, ko.cim,
to_char(kolcsonzesi_datum, 'yyyy.mm.dd hh24:mi:ss')
from konyvtar.tag t inner join 
    (select *
     from konyvtar.kolcsonzes
     order by kolcsonzesi_datum desc nulls last
     fetch first 5 rows with ties) k
on t.olvasojegyszam=k.tag_azon
inner join konyvtar.konyvtari_konyv kk
on k.leltari_szam=kk.leltari_szam
inner join konyvtar.konyv ko
on kk.konyv_azon=ko.konyv_azon;

-- Listázza az utolsó 5 felértékelés idõpontját, értékét és a benne szereplõ autó rendszámát.
select rendszam, ertek, to_char(datum, 'yyyy.mm.dd hh24:mi:ss')
from szerelo.sz_autofelertekeles af inner join szerelo.sz_auto au
on af.auto_azon=au.azon
order by datum desc nulls last
fetch first 5 rows with ties;

--Írja ki a legnagyobb havi fizetéssel rendelkezõ szerelõ nevét. 
select nev
from szerelo.sz_szerelo
where azon in (select szerelo_azon
              from szerelo.sz_dolgozik
              order by havi_fizetes desc nulls last
              fetch first row with ties);








                  



