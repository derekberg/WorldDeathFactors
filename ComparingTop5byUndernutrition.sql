-- comparing the top five from both tables by columns in undernutrtion table.

with cte as (select u.country,
	  round((u.diet_low_in_whole_grains +
	   u.diet_low_in_fruits +
	   u.low_birth_weight +
	   u.child_wasting +
	   u.diet_low_in_nuts_and_seeds +
	   u.diet_low_in_vegetables +
	   u.low_bone_mineral_density +
	   u.vitamin_a_deficiency +
	   u.child_stunting +
	   u.iron_deficiency)::numeric/(p.population::numeric/1000000),1) as deaths_per_million
from undernutrition u join deathfactors d
	 on u.country = d.country and u.year = d.year
	 join population p
	 on p.country = u.country and p.year = u.year
where u.year = '2018' and d.code is not null
order by 2 DESC 
limit 5),

cte2 as (select o.country,
	  round((o.high_systolic_blood_pressure +
	   o.diet_high_in_sodium +
	   o.alcohol_use +
	   o.high_fasting_plasma_glucose +
	   o.high_body_mass_index)::numeric/(p.population::numeric/1000000),1) as deaths_per_million
from overweight_and_diet o join deathfactors d
	 on o.country = d.country and o.year = d.year
	 join population p
	 on p.country = o.country and p.year = o.year
where o.year = '2018' and d.code is not null
order by 2 DESC
limit 5)

select u.country,
	   round(u.diet_low_in_whole_grains::numeric/(p.population::numeric/100000), 1) as diet_low_in_whole_grains,
	   round(u.diet_low_in_fruits::numeric/(p.population::numeric/100000), 1) as diet_low_in_fruits,
	   round(u.low_birth_weight::numeric/(p.population::numeric/100000), 1) as low_birth_weight,
	   round(u.child_wasting::numeric/(p.population::numeric/100000), 1) as child_wasting,
	   round(u.diet_low_in_nuts_and_seeds::numeric/(p.population::numeric/100000), 1) as diet_low_in_nuts_and_seeds,
	   round(u.diet_low_in_vegetables::numeric/(p.population::numeric/100000), 1) as diet_low_in_vegetables,
	   round(u.low_bone_mineral_density::numeric/(p.population::numeric/100000), 1) as low_bone_mineral_density,
	   round(u.vitamin_a_deficiency::numeric/(p.population::numeric/100000), 1) as vitamim_a_deficiency,
	   round(u.child_stunting::numeric/(p.population::numeric/100000), 1) as child_stunting,
	   round(u.iron_deficiency::numeric/(p.population::numeric/100000), 1) as iron_deficiency
from undernutrition u join population p
	 on u.country = p.country and u.year = p.year
where
	 u.year = '2018' and u.country in (select country from cte) or 
     u.year = '2018' and u.country in (select country from cte2);
