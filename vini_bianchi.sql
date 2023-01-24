-- new table 
select * 
into bianchi 
from vini_tan;

select * from bianchi;

--------------------------------------------------------------------------------------------------------------------------------
-- data cleaning
--------------------------------------------------------------------------------------------------------------------------------

-- annata

select annata, count(*)
from bianchi
group by annata
order by count(*) desc;

-- null and NV removal
delete from bianchi
where annata isnull or annata = 'NV' or annata = '';

-- numeric conversion
alter table bianchi
alter annata type numeric using annata::numeric;
--------------------------------------------------------------------------------------------------------------------------------

-- denominazione

-- lowercase conversion
update bianchi
set denominazione = lower(denominazione);


select denominazione, count(*)
from bianchi
group by denominazione
order by count(*) desc;

-- null removal 
delete from bianchi 
where denominazione isnull;

-- place removal
update bianchi
set denominazione = split_part(denominazione, ' ', -1);

-- wrong denomination removal
delete from bianchi 
where denominazione not in('doc', 'igt', 'docg', 'igp', 'dop');
--------------------------------------------------------------------------------------------------------------------------------

-- vitigni

-- lowercase conversion
update bianchi
set vitigni = lower(vitigni);


select vitigni, count(*)
from bianchi
group by vitigni
order by count(*) desc;

-- Selection of the first grape variety (example: white and gray pinot = pinot)
update bianchi
set vitigni = split_part(vitigni, ' ', 1);

-- commas removal
update bianchi
set vitigni = replace(vitigni, ',', '');

-- null removal 
delete from bianchi 
where vitigni isnull;

-- Grape varieties grouping over the 20th position by frequency
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

-- alcol

-- % symbol removal
update bianchi
set alcol = replace(alcol, '%', '');


select alcol, count(*)
from bianchi
group by alcol
order by count(*) desc;

-- null removal 
delete from bianchi 
where alcol = '';

-- numeric conversion
alter table bianchi
alter alcol type numeric using alcol::numeric; 

-- mean to replace null
update bianchi
set alcol = (select avg(alcol) from bianchi)
where alcol isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- allergeni

select allergeni, count(*)
from bianchi
group by allergeni
order by count(*) desc;

-- column removal
alter table bianchi
drop allergeni;
--------------------------------------------------------------------------------------------------------------------------------

-- consumo_ideale

select consumo_ideale, count(*)
from bianchi
group by consumo_ideale
order by count(*) desc;

-- wrong data replacement
update bianchi
set consumo_ideale = null
where consumo_ideale like '%20224%' or consumo_ideale like '%2''24%';

-- null removal 
delete from bianchi 
where consumo_ideale = '' or consumo_ideale isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- temperatura_servizio

select temperatura_servizio, count(*)
from bianchi
group by temperatura_servizio
order by count(*) desc;

-- °C symbol removal
update bianchi
set temperatura_servizio = replace(temperatura_servizio, '°C', '');

-- null removal 
delete from bianchi 
where temperatura_servizio = '';

-- mean replacement
update bianchi
set temperatura_servizio = (
	(cast(split_part(temperatura_servizio, '/', 1) as numeric)) + (cast(split_part(temperatura_servizio, '/', 2) as numeric))/2);

-- rounding
update bianchi
set temperatura_servizio = round(cast(temperatura_servizio as numeric), 0);

-- numeric conversion
alter table bianchi
alter temperatura_servizio type numeric using temperatura_servizio::numeric;

-- mean to replace null
update bianchi
set temperatura_servizio = (select round(avg(temperatura_servizio), 0) from bianchi)
where temperatura_servizio isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- abbinamenti

select abbinamenti, count(*)
from bianchi
group by abbinamenti
order by count(*) desc;

-- Selecting the first match without category
update bianchi
set abbinamenti = split_part(abbinamenti, ' ', 1);

-- lowercase conversion
update bianchi
set abbinamenti = lower(abbinamenti);

-- grouping specific pairings
update bianchi
set abbinamenti = 'altri'
where abbinamenti not in('antipasti', 'primi', 'secondi');

-- mode to replace null
update bianchi
set abbinamenti = 'antipasti'
where abbinamenti isnull;
--------------------------------------------------------------------------------------------------------------------------------

-- prezzo

-- € symbol removal
update bianchi
set prezzo = replace(prezzo, ' €', '');

-- replacing , with .
update bianchi
set prezzo = replace(prezzo, ',', '.');

-- numeric conversion
alter table bianchi
alter prezzo type numeric using prezzo::numeric;


--------------------------------------------------------------------------------------------------------------------------------

select * from bianchi;