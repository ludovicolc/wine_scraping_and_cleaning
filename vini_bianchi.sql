-- creazione tabella 
select * 
into bianchi 
from vini_tan;

select * from bianchi;

--------------------------------------------------------------------------------------------------------------------------------
-- pulizia dati
--------------------------------------------------------------------------------------------------------------------------------

-- colonna annata

select annata, count(*)
from bianchi
group by annata
order by count(*) desc;

-- rimozione null e NV
delete from bianchi
where annata isnull or annata = 'NV' or annata = '';

-- conversione in numeric
alter table bianchi
alter annata type numeric using annata::numeric;
--------------------------------------------------------------------------------------------------------------------------------

-- colonna denominazione

-- conversione in minuscolo
update bianchi
set denominazione = lower(denominazione);


select denominazione, count(*)
from bianchi
group by denominazione
order by count(*) desc;

-- rimozione null 
delete from bianchi 
where denominazione isnull;

-- rimozione luogo
update bianchi
set denominazione = split_part(denominazione, ' ', -1);

-- rimozione denominazioni errate
delete from bianchi 
where denominazione not in('doc', 'igt', 'docg', 'igp', 'dop');
--------------------------------------------------------------------------------------------------------------------------------

-- colonna vitigni

-- conversione in minuscolo
update bianchi
set vitigni = lower(vitigni);


select vitigni, count(*)
from bianchi
group by vitigni
order by count(*) desc;

-- selezione del primo vitigno (vitigo con % più elevata ed esclusa categoria interna, es. pinot bianco e grigio riuniti in pinot)
update bianchi
set vitigni = split_part(vitigni, ' ', 1);

-- rimozione virgole
update bianchi
set vitigni = replace(vitigni, ',', '');

-- rimozione null 
delete from bianchi 
where vitigni isnull;

-- raggruppamento vitigni oltre la 20° posizione per frequenza
with cte_vitigni as(
	select vitigni, count(*)
	from bianchi
	group by vitigni
	order by count(*) desc
	limit 20
)

update bianchi
set vitigni = 'altri'
where vitigni not in(select vitigni from cte_vitigni);
--------------------------------------------------------------------------------------------------------------------------------

-- colonna alcol

-- rimozione simbolo %
update bianchi
set alcol = replace(alcol, '%', '');


select alcol, count(*)
from bianchi
group by alcol
order by count(*) desc;

-- rimozione null 
delete from bianchi 
where alcol = '';

-- conversione in numeric
alter table bianchi
alter alcol type numeric using alcol::numeric; 

-- utilizzo media per rimpiazzare null
update bianchi
set alcol = (select avg(alcol) from bianchi)
where alcol isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- colonna allergeni

select allergeni, count(*)
from bianchi
group by allergeni
order by count(*) desc;

-- rimozione colonna inutile
alter table bianchi
drop allergeni;
--------------------------------------------------------------------------------------------------------------------------------

-- colonna consumo_ideale

select consumo_ideale, count(*)
from bianchi
group by consumo_ideale
order by count(*) desc;

-- sostituzione dati errati
update bianchi
set consumo_ideale = null
where consumo_ideale like '%20224%' or consumo_ideale like '%2''24%';

-- rimozione null 
delete from bianchi 
where consumo_ideale = '' or consumo_ideale isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- colonna temperatura_servizio

select temperatura_servizio, count(*)
from bianchi
group by temperatura_servizio
order by count(*) desc;

-- rimozione simbolo °C
update bianchi
set temperatura_servizio = replace(temperatura_servizio, '°C', '');

-- rimozione null 
delete from bianchi 
where temperatura_servizio = '';

-- sostituzione con media degli stessi (es. 8/10 diventa 9)
update bianchi
set temperatura_servizio = (
	(cast(split_part(temperatura_servizio, '/', 1) as numeric)) + (cast(split_part(temperatura_servizio, '/', 2) as numeric))/2);

-- arrotondamento
update bianchi
set temperatura_servizio = round(cast(temperatura_servizio as numeric), 0);

-- conversione in numeric
alter table bianchi
alter temperatura_servizio type numeric using temperatura_servizio::numeric;

-- utilizzo media per rimpiazzare null
update bianchi
set temperatura_servizio = (select round(avg(temperatura_servizio), 0) from bianchi)
where temperatura_servizio isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- colonna abbinamenti

select abbinamenti, count(*)
from bianchi
group by abbinamenti
order by count(*) desc;

-- selezione del primo abbinamento senza categoria
update bianchi
set abbinamenti = split_part(abbinamenti, ' ', 1);

-- conversione in minuscolo
update bianchi
set abbinamenti = lower(abbinamenti);

-- raggruppamento abbianmenti specifici
update bianchi
set abbinamenti = 'altri'
where abbinamenti not in('antipasti', 'primi', 'secondi');

-- utilizzo moda per rimpiazzare null
update bianchi
set abbinamenti = 'antipasti'
where abbinamenti isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- colonna prezzo

-- rimozione simbolo €
update bianchi
set prezzo = replace(prezzo, ' €', '');

-- sostituzione virgola con punto
update bianchi
set prezzo = replace(prezzo, ',', '.');

-- conversione in numeric
alter table bianchi
alter prezzo type numeric using prezzo::numeric;


--------------------------------------------------------------------------------------------------------------------------------

select * from bianchi;