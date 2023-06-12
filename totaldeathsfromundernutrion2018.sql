-- determing the total number of deaths from undernutrtion per million citizens
-- in 2018 (the most recent year in the data)

select u.country,
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
where u.year = '2018' and d.code is not null;
