-- Find the crime scene report(s) that is a murder that occured on January 15, 2018 at SQL City
select * from crime_scene_report
where type = 'murder' and date = 20180115 and city = 'SQL City';

-- Find the first witness that lives on the last house on "Northwestern Dr"
select * from person
where address_street_name = 'Northwestern Dr'
order by address_number DESC
LIMIT 1;

-- Find the second witness who's name in Annabel and lives somewhere on "Franklin Ave"
select * from person
where address_street_name = 'Franklin Ave' and name like '%Annabel%';   

-- Get Morty's transcript from his interview
select name, transcript from interview as i
left join person as p on i.person_id = p.id
where address_street_name = 'Northwestern Dr'
order by address_number DESC
LIMIT 1;

-- Get Annabel's transcript from her interview
select name, transcript from interview as i
left join person as p on i.person_id = p.id
where p.address_street_name = 'Franklin Ave' and p.name like '%Annabel%';

-- Find the male gym member(s) with a gold membership status and a membership number beginning with '48Z'
select * from get_fit_now_member
where membership_status = 'gold' and id like '48Z%';

-- Find out out which gym member has a car plate that includes 'H42W'; This will find who committed the murder
select
	p.name as name,
	dl.plate_number as plate_number
from get_fit_now_member as gfnm
left join person as p on p.id = gfnm.person_id
left join drivers_license as dl on p.license_id = dl.id
where gfnm.membership_status = 'gold' 
	and gfnm.id like '48Z%'
	and dl.plate_number like '%H42W%';
    
-- Find the murderer's transcript from their interview
select name, transcript from interview as i
left join person as p on i.person_id = p.id
where p.name like 'Jeremy Bowers';

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

