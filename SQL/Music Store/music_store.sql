
-- 1. Who is the senior most employee based on job title?

select concat(trim(e.first_name),' ',trim(e.last_name)) as full_name , e.title  
from employee e 
where e.reports_to is null;

-- 2. Which countries have the most Invoices?

select i.billing_country , count(i.billing_country) as billing_count from invoice i 
group by i.billing_country 
order by billing_count desc
limit 1;

-- 3. What are top 3 values of total invoice?

select i.total from invoice i 
order by i.total desc
limit 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music 
--    Festival in the city we made the most money. Write a query that returns one city that 
--    has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select i.billing_city , sum(i.total) as city_total from invoice i
group by i.billing_city
order by city_total desc
limit 1;

-- 5. Who is the best customer? The customer who has spent the most money will be 
--    declared the best customer. Write a query that returns the person who has spent the most money

select concat(trim(c.first_name),' ',trim(c.last_name)) as customer_name, sum(i.total) customer_total from invoice i
join customer c on c.customer_id = i.customer_id 
group by c.customer_id 
order by customer_total desc
limit 1;

-- 6. Write query to return the email, first name, last name, & Genre of all Rock Music 
--    listeners. Return your list ordered alphabetically by email starting with A

select distinct c.email, trim(c.first_name) as first_name ,c.last_name as last_name from customer c 
join invoice i on i.customer_id = c.customer_id 
join invoice_line il on il.invoice_id = i.invoice_id 
join track t on t.track_id = il.track_id 
join genre g on g.genre_id = t.genre_id
where g.name ilike 'rock'
order by c.email;

-- 7. Let's invite the artists who have written the most rock music in our dataset. Write a 
--	  query that returns the Artist name and total track count of the top 10 rock bands

select a2."name", count(a2.artist_id) as total_track from track t 
join album a on a.album_id = t.album_id 
join artist a2 on a2.artist_id = a.artist_id 
join genre g on g.genre_id = t.genre_id 
where g.name ilike 'rock'
group by a2.artist_id
order by total_track desc
limit 10;

-- 8. Return all the track names that have a song length longer than the average song length. 
--    Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select t."name" , t.milliseconds from track t
where t.milliseconds > (select avg(tt.milliseconds) from track tt)
order by t.milliseconds desc;

-- 9. Find how much amount spent by each customer on artists? Write a query to return
--	  customer name, artist name and total spent

select concat(trim(c.first_name),' ',trim(c.last_name)) as customer_name , a2."name" as artist_name, sum(i.total) as total_spent from invoice i
join customer c on c.customer_id = i.customer_id 
join invoice_line il on il.invoice_id = i.invoice_id 
join track t on t.track_id = il.track_id 
join album a on t.album_id = a.album_id 
join artist a2 on a2.artist_id = a.artist_id
group by c.customer_id , a2.artist_id
order by customer_name , total_spent desc;


-- 10 Write a query that determines the customer that has spent the most on music for each 
--    country. Write a query that returns the country along with the top customer and how
--	  much they spent. For countries where the top amount spent is shared, provide all 
--    customers who spent this amount

select billing_country , customer_name , money_spent from ( select 
i.billing_country , 
sum(i.total) as money_spent,
concat(trim(c.first_name),' ',trim(c.last_name)) as customer_name , 
dense_rank() over(partition by i.billing_country order by sum(i.total) desc) as customer_rank
from invoice i
join customer c on i.customer_id = c.customer_id 
group by i.billing_country , c.customer_id
order by i.billing_country ) tab
where customer_rank = 1;


-- 11 Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amount

select billing_country , genre_name from
(select i.billing_country ,
g.name as genre_name,
dense_rank() over(partition by i.billing_country order by count(g.name) desc) as country_genre_rank
from invoice i 
join invoice_line il on il.invoice_id  = i.invoice_id
join track t on il.track_id = t.track_id 
join genre g on g.genre_id = t.genre_id
group by i.billing_country , g.name) st;
where country_genre_rank = 1;