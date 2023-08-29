/*List?zza azokat az aut?kat, amelyek k?k vagy piros vagy fekete sz?n?ek, nincs megadva a tipusuk, 
?s 2010 ?s 2020 k?z?tt adt?k el el?sz?r. A lista legyen rendezett, sz?n, azon bel?l 
els? v?s?rl?s id?pontja szerint cs?kken?en.*/

select szin, rendszam, to_char(elso_vasarlas_idopontja,'yyyy.mm.dd hh24:mi:ss')
from szerelo.sz_auto
where szin in ('k?k','piros','fekete')
and tipus_azon is null
and extract (year from  elso_vasarlas_idopontja) between 2010 and 2020
order by szin, elso_vasarlas_idopontja desc;

/*Melyek azok a sz?nek, amelyekhez 3-n?l t?bb aut? tartozik?*/
select szin, count(*)
from szerelo.sz_auto
group by szin
having count(*)>3;

/*Az egyes t?pusokhoz h?ny aut? tartozik? (csak az a t?pus kell, amihez van aut?) (tipus_azon)*/
select count(*), tipus_azon
from szerelo.sz_auto
group by tipus_azon;

/*Az egyes t?pusokhoz h?ny aut? tartozik? tipus_nev*/
select ati.megnevezes, ati.azon, count(au.azon)
from szerelo.sz_auto au full outer join szerelo.sz_autotipus ati
on au.tipus_azon=ati.azon
group by ati.megnevezes, ati.azon;

/*Az egyes aut?kat h?nyszor szerelt?k? (rendsz?m)*/
select au.rendszam, count(sz.szereles_kezdete)
from szerelo.sz_auto au left outer join szerelo.sz_szereles sz 
on au.azon=sz.auto_azon
group by au.rendszam;

/*List?zza a szerel?seket, amelyek eseet?n k?k vagy piros vagy fekete sz?n? aut?t
A F?ktelen?l Bt.-ben szereltek az elm?lt 1000 napban.
Lista legyen rendsz?m, azon bel?l szerel?s kezdete szerint rendezett.*/
select rendszam, szin, to_char(szereles_kezdete,'yyyy.mm.dd hh24:mi:ss')
from szerelo.sz_auto au inner join szerelo.sz_szereles sz
on au.azon=sz.auto_azon inner join szerelo.sz_szerelomuhely szm
on sz.muhely_azon=szm.azon
where szin in ('k?k','piros','fekete')
and szm.nev='F?ktelen?l Bt.'
and sysdate-szereles_kezdete<1000
order by rendszam, szereles_kezdete;

/*Mely aut?kat nem szerelt?k?*/
select *
from szerelo.sz_auto
where azon not in (select auto_azon from szerelo.sz_szereles);

/*Mely aut?knak t?bb az els? v?s?rl?si ?ra, mint a piros aut? ?tlagos els? v?s?rl?si ?ra?*/

select *
from szerelo.sz_auto
where elso_vasarlasi_ar>(select avg(elso_vasarlasi_ar) from szerelo.sz_auto
                        where szin='piros');
                        
/*Ki a legid?sebb szerel??*/

select nev
from szerelo.sz_szerelo
order by szul_dat
fetch first row with ties;

/*Melyik aut?t ?rt?kelt?k fel utolj?ra?*/
select rendszam
from szerelo.sz_auto au inner join
szerelo.sz_autofelertekeles af
on au.azon=af.auto_azon
order by datum desc
fetch first row with ties;

/*Az egyes aut?m?rk?knak az ?tlagos szerel?si k?lt?ge (minden aut?m?rka)*/
select am.nev, avg(munkavegzes_ara)
from szerelo.sz_automarka am full outer join szerelo.sz_autotipus ati 
on am.nev=ati.marka full outer join szerelo.sz_auto au
on ati.azon=au.tipus_azon left outer join szerelo.sz_szereles sz
on au.azon=sz.auto_azon
group by am.nev;

/*Az egyes aut?kat (rendsz?m) mikor v?s?rolt?k meg utolj?ra?*/
select rendszam, to_char(max(vasarlas_ideje),'yyyy.mm.dd hh24:mi:ss')
from szerelo.sz_auto au left outer join
szerelo.sz_auto_tulajdonosa atu
on au.azon=atu.auto_azon
group by rendszam;

/*Az egyes aut?kat (rendsz?m) ki v?s?rolta meg utolj?ra?*/
select rendszam, tu.nev, tu.azon
from szerelo.sz_auto au left outer join szerelo.sz_auto_tulajdonosa atu
on au.azon=atu.auto_azon left outer join szerelo.sz_tulajdonos tu
on atu.tulaj_azon=tu.azon
where (auto_azon, vasarlas_ideje) in (select auto_azon, max(vasarlas_ideje)
                                      from szerelo.sz_auto_tulajdonosa
                                      group by auto_azon)
or auto_azon is null
order by rendszam;

/*Az egyes aut?knak (rendsz?m) mennyi volt az utols? fel?rt?kel?se?*/
select rendszam, ertek
from szerelo.sz_autofelertekeles af right outer join szerelo.sz_auto au 
on au.azon=af.auto_azon
where (auto_azon, datum) in (select auto_azon, max(datum)
                             from szerelo.sz_autofelertekeles
                             group by auto_azon)
or af.auto_azon is null
order by rendszam;















