-- comparing the top five from both tables by columns in overweight_and_diet table.

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

select o.country,
	   round(o.high_systolic_blood_pressure::numeric/(p.population::numeric/1000000),1)
	   		as high_systolic_blood_pressure,
	   round(o.diet_high_in_sodium::numeric/(p.population::numeric/1000000),1) 
	   		as diet_high_in_sodium,
	   round(o.alcohol_use::numeric/(p.population::numeric/1000000),1) 
	   		as alcohol_use,
	   round(o.high_fasting_plasma_glucose::numeric/(p.population::numeric/1000000),1)
	        as high_fasting_plasma_glucose,
	   round(o.high_body_mass_index::numeric/(p.population::numeric/1000000),1) 
	   		as high_body_mass_index
from overweight_and_diet o join population p
	 on o.country = p.country and o.year = p.year
where
	 o.year = '2018' and o.country in (select country from cte) or 
     o.year = '2018' and o.country in (select country from cte2);
	 


