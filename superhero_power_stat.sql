use superhero_power_stat;

CREATE TABLE characters (
    id 				int NOT NULL auto_increment,
    alias			varchar(50),
    name 			varchar(50),
    gender			varchar(6),
    race 			varchar(20),
    side			varchar(8), -- alignment = side
    universe		varchar(20),
    intelligence	tinyint(3),
    strength		tinyint(3),
    speed			tinyint(3),
    durability		tinyint(3),
    power			tinyint(3),
    combat			tinyint(3),
    overall			float,
    primary key(id)
);

select * from characters;

-- CLEANING: Created a function to change the character's overall rating. Loaded the wrong overall rating.
DELIMITER //
create function overall(intelligence	tinyint(3),
						strength		tinyint(3),
						speed			tinyint(3),
						durability		tinyint(3),
						power			tinyint(3),
						combat			tinyint(3))
	returns  float
	DETERMINISTIC
BEGIN
    
	declare stats float;
	declare overall float;
    declare new_overall float;
    
    set stats = intelligence + strength + speed + durability + power + combat;
	set overall = stats/600;
    set new_overall = overall * 100;
    
	return  round(new_overall, 2);
    
END; //
DELIMITER ;

-- Testing the function to see if the overall function produced the correct overall rating
select alias, overall(intelligence, strength, speed, durability, power, combat) as overall
from characters;

-- CLEANING: Updated the overall rating to have the correct rating for each character
update characters
set overall = overall(intelligence, strength, speed, durability, power, combat);


-- Find the number of characters in each univers
select universe, count(*) AS character_count from characters
group by universe;


-- Find the average overall for each universe, then round it up
select universe, round(avg(overall)) AS average_overall from characters
group by universe;


-- Find the Top 10 overall characters in the database
select alias, universe, overall from characters
order by overall desc
limit 10;


-- Find the Top 5 overall characters in the DC Comics' Universe
select alias, overall from characters
where universe = 'DC Comics'
order by overall desc
limit 5;


-- Find the Top 5 overall characters in the Marvel Comics' Universe
select alias, overall from characters
where universe = 'Marvel Comics'
order by overall desc
limit 5;

-- Find the characters that are human and are both intelligent and are good combatants in the DC Comics' Universe
select alias, intelligence, combat, overall from characters
where universe = 'DC Comics'
and race = 'Human'
and intelligence >= 70
and combat >= 70
order by overall desc
limit 10;

-- Out of all the Batmans in the DC Comics' Universe, who is the best overall Batman
select name, overall from characters
where universe = 'DC Comics'
and alias like 'Batman%'
order by overall desc;

-- Out of all the Flashes in the DC Comics' Universe, who is the best overall Flashes
select name, overall from characters
where universe = 'DC Comics'
and alias like 'Flash%'
order by overall desc;

-- Find the most dangerous villain in the database
select alias, universe, overall from characters
where side = 'Villain'
order by overall desc
limit 1;