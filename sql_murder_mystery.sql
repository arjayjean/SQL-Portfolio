-- Find the crime scene report(s) that is a murder and occured on January 15, 2018 at SQL City
-- This should provide data on the murder we are looking for
select * from crime_scene_report
where type = 'murder' and date = 20180115 and city = 'SQL City';

-- The crime scene report says that there were 2 witnesses:
-- Find the first witness that lives on the last house on "Northwestern Dr"
select * from person
where address_street_name = 'Northwestern Dr'
order by address_number DESC
LIMIT 1;

-- Find the second witness who's name is Annabel and lives somewhere on "Franklin Ave"
select * from person
where address_street_name = 'Franklin Ave' and name like '%Annabel%';   

-- Get Morty's (first witness) transcript from his interview
-- His transcript will tell us more about what we should look for next
select name, transcript from interview as i
left join person as p on i.person_id = p.id
where address_street_name = 'Northwestern Dr'
order by address_number DESC
LIMIT 1;

-- Get Annabel's transcript from her interview
-- Her transcript will tell us more about what we should look for next
select name, transcript from interview as i
left join person as p on i.person_id = p.id
where p.address_street_name = 'Franklin Ave' and p.name like '%Annabel%';

-- According to the 2 witnesses, they said it was:
	-- a male gym member with a gold gym membership status (membership number beginning with '48Z')
	-- and his car has a car plate that includes 'H42W'
-- This will find who committed the murder
select
	p.name as name,
    gfnm.membership_status as get_fit_now_membership_status,
    gfnm.person_id as get_fit_now_gym_id,
	dl.plate_number as plate_number
from get_fit_now_member as gfnm
left join person as p on p.id = gfnm.person_id
left join drivers_license as dl on p.license_id = dl.id
where gfnm.membership_status = 'gold' 
	and gfnm.id like '48Z%'
	and dl.plate_number like '%H42W%';
    
-- With the murderer found, we need to know why he did it
-- Find the murderer's transcript from their interview
select name, transcript from interview as i
left join person as p on i.person_id = p.id
where p.name like 'Jeremy Bowers';

-- Based on the murderer's transcript, he says that he was hired by:
	-- a female who has red hair, stands between 65" (5'5) and 67" (5'7),
	-- drives a Tesla Model S and attended the SQL Symphony Concert 3 times in December 2017
-- Find out who hired the murderer
with attendance as (select person_id, count(*) as attendance_total from facebook_event_checkin
	where event_name = 'SQL Symphony Concert'
		and date like '2017%'
	group by person_id)
select
	p.name as name,
	a.attendance_total as attendance_total,
	dl.gender as gender,
	dl.height as height,
	dl.hair_color as hair_color,
	dl.car_make as car_make,
	dl.car_model as car_model
from attendance as a
left join person as p on a.person_id = p.id
left join drivers_license as dl on p.license_id = dl.id
where a.attendance_total = 3
	and dl.gender = 'female'
	and dl.height between 65 and 67
	and dl.hair_color = 'red'
	and dl.car_make = 'Tesla'
	and dl.car_model = 'Model S';