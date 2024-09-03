--Q1. Who is the Senior most employee based on job title?

select * from employee

ORDER BY levels DESC
limit 1

--Q2. Which Countries have the most invoices?

select COUNT(*) as c, billing_country
from invoice
group by billing_country
ORDER BY c DESC
limit 2

--Q3. What are top 3 values of total invoice?
select * from invoice
oRDER BY total DESC
limit 3

--Q4. Which City has the best Customer?
--we would like to throw a Promotional Music Festival in the city we made the most money.
--Write a query that returns one city that has the highest sum of invoice totals.
--Return both the city name & sum of all invoice totals

select SUM(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc

--Q5. who is the best customer? The customer who has spent the most money will be declared the best customer.
--write a query that returns the person who has spent the most money.
Select customer.customer_id, customer.first_name, customer.last_name, Sum(invoice.total) as total
from Customer
JOIN invoice 
ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC

select * from track
--Q6. Write query to return the email, first_name, last_name & Genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email starting with A.
Select DISTINCT first_name, last_name, email 
from customer AS c
JOIN invoice ON c.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
 WHERE genre.name LIKE 'Rock'

 ORDER by email;

 --Q7. Let's invite the artists who have written the most rock music in our dataset.
 --Write a query that returns the artist name and total track count of the top 10 rock bands.

select * from track
 select artist.name, artist.artist_id, COUNT(artist.artist_id) AS number_of_songs 
 from artist
 JOIN album ON album.artist_id = artist.artist_id
 JOIN track ON track.album_id = album.album_id
 JOIN genre ON genre.genre_id = track.genre_id
 where genre.name LIKE 'Rock'
 GROUP BY artist.artist_id
 Order by number_of_songs DESC
 LIMIT 10;

 --Q8. Return all the track names that have a song length longer than the average song length.
 --Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

 select name , milliseconds
 from track
 WHERE milliseconds >( 
 	Select AVG(milliseconds) as avg_song_length
	 from track)
	 ORDER BY milliseconds DESC;

--Q9. Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent.

WITH best_selling_artist as (
	Select artist.artist_id as artist_id, artist.name as artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) 
	from invoice_line
	JOIN track on track.track_id = invoice_line.track_id
	JOIN album on album.album_id = track.album_id
	JOIN artist on artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 3
)

SELECT customer.customer_id, customer.first_name, customer.last_name, bsa.artist_name,
SUM(invoice_line.unit_price*invoice_line.quantity) AS amount_spent
FROM invoice 
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id =  track.album_id
JOIN best_selling_artist AS bsa ON bsa.artist_id = album.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC; 

--Q10. We want to find out the most popular music Genre for each country.
--We determine the most popular genre as the genre as the genre with the highest amount of purchases.
--Write a query that returns each country along with the top Genre.
-- For countries where the maximum number of purchases is shared return all Genres.




