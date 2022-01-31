use assignment;
select * from airbnb_calendar;
desc airbnb_calendar;

select min(date), max(date) from airbnb_calendar;

select count(*) from airbnb_calendar having count(*)>1;
create table airbnb_calendar1(
listing_ID varchar(10),
    Date date,
    available char,
    price float
);
insert into airbnb_calendar1 select distinct * from airbnb_calendar;
truncate table airbnb_calendar;
insert into airbnb_calendar select * from airbnb_calendar1;
drop table airbnb_calendar1;

create table availability(
listing_id varchar(10),
available_days int,
unavailable_days int,
available_fraction float
);
insert into availability select listing_id, 
(select count(available) from airbnb_calendar where available='t'), 
(select count(available) from airbnb_calendar where available='f' ), 
(select count(available)/(select count(available) from airbnb_calendar) from airbnb_calendar where available='t') 
from airbnb_calendar group by listing_id;
select * from availability;

select count(*) from airbnb_calendar having (select count(available) * 100.0 / (select count(available) from airbnb_calendar) from airbnb_calendar where available='t')>0.50; 
select count(*) from airbnb_calendar  having (select count(available) * 100.0 / (select count(available) from airbnb_calendar) from airbnb_calendar where available='t')>0.75; 

create table aggregate(
listing_id varchar(10),
max_price float,
min_price float,
avg_price float
);
insert into aggregate select listing_id, max(price), min(price), avg(price) from airbnb_calendar group by listing_id;
select * from aggregate;

select listing_id, price from airbnb_calendar group by listing_id,price having avg(price)>500;

truncate table airbnb_calendar;
drop table availability, aggregate;