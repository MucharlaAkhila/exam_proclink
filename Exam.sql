--Schemas

CREATE TABLE artists (
    artist_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    birth_year INT NOT NULL
);

CREATE TABLE artworks (
    artwork_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    artist_id INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    artwork_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

INSERT INTO artists (artist_id, name, country, birth_year) VALUES
(1, 'Vincent van Gogh', 'Netherlands', 1853),
(2, 'Pablo Picasso', 'Spain', 1881),
(3, 'Leonardo da Vinci', 'Italy', 1452),
(4, 'Claude Monet', 'France', 1840),
(5, 'Salvador Dalí', 'Spain', 1904);

INSERT INTO artworks (artwork_id, title, artist_id, genre, price) VALUES
(1, 'Starry Night', 1, 'Post-Impressionism', 1000000.00),
(2, 'Guernica', 2, 'Cubism', 2000000.00),
(3, 'Mona Lisa', 3, 'Renaissance', 3000000.00),
(4, 'Water Lilies', 4, 'Impressionism', 500000.00),
(5, 'The Persistence of Memory', 5, 'Surrealism', 1500000.00);

INSERT INTO artworks (artwork_id, title, artist_id, genre, price) VALUES
(6, 'XYZ', 1,  'Cubism', 1000000.00)

INSERT INTO artworks (artwork_id, title, artist_id, genre, price) VALUES
(7, 'Abc', 2, 'Cubism', 1000000.00)

INSERT INTO sales (sale_id, artwork_id, sale_date, quantity, total_amount) VALUES
(1, 1, '2024-01-15', 1, 1000000.00),
(2, 2, '2024-02-10', 1, 2000000.00),
(3, 3, '2024-03-05', 1, 3000000.00),
(4, 4, '2024-04-20', 2, 1000000.00);


-- Section 1: 1 mark each

--1. Write a query to display the artist names in uppercase.

select UPPER (name) as Artists_name from artists

--2. Write a query to find the top 2 highest-priced artworks and the total quantity sold for each.

select TOP(2)  a.artwork_id,price,rank() over(order by price desc) as Rank , sum(quantity) as Quantity_sold from artworks a
join sales s on a.artwork_id = s.artwork_id
group by a.artwork_id,price


--3. Write a query to find the total amount of sales for the artwork 'Mona Lisa'.

Select sum(total_amount) from sales s
right join artworks a on s.artwork_id = a.artwork_id
group by a.artwork_id,Title
Having Title = 'Mona Lisa'

--4. Write a query to extract the year from the sale date of 'Guernica'.

select datepart(year,sale_date) as year from sales s
join artworks a on s.artwork_id = a.artwork_id
where Title = 'Guernica'

--### Section 2: 2 marks each

--5. Write a query to find the artworks that have the highest sale total for each genre.

 select  TOP(1) a.artwork_id,sum(total_amount),rank() over(partition by genre order by sum(total_amount) desc ) from sales s
 join artworks a on s.artwork_id = a.artwork_id
 group by a.artwork_id,genre

--6. Write a query to rank artists by their total sales amount and display the top 3 artists.

select TOP(3) ar.artist_id, sum(total_amount) as total_sales,dense_rank() over(order by sum(total_amount) desc) as Rank from sales s
join artworks a on s.artwork_id = a.artwork_id
join artists ar on a.artist_id =ar.artist_id
Group by ar.artist_id


--7. Write a query to display artists who have artworks in multiple genres.

Select a.artist_id ,name from artists a
join artworks ar on a.artist_id = ar.artist_id
group by a.artist_id,name
having count( Distinct Genre) > 1

--8. Write a query to find the average price of artworks for each artist.

Select a.artist_id ,name,avg(price) as Avg_price from artists a
join artworks ar on a.artist_id = ar.artist_id
group by a.artist_id,name

--9. Write a query to create a non-clustered index on the `sales` table to improve query performance for queries filtering by `artwork_id`.

Create NONClustered Index IX_Sales
ON sales(Gender DESC, Salary ASC)  -

--10. Write a query to find the artists who have sold more artworks than the average number of artworks sold per artist.

select a.artist_id,sum(quantity) from sales s
join artworks a on s.artwork_id = a.artwork_id
join artists ar on a.artist_id =ar.artist_id
group by a.artist_id
having sum(quantity) > (select avg(quantity) from sales s)


--11. Write a query to find the artists who have created artworks in both 'Cubism' and 'Surrealism' genres.

select name from artists a
join artworks ar on a.artist_id = ar.artist_id
where Genre = 'Cubism'
INTERSECT 
select name from artists a
join artworks ar on a.artist_id = ar.artist_id
where Genre = 'Surrealism'

--12. Write a query to display artists whose birth year is earlier than the average birth year of artists from their country.





--13. Write a query to find the artworks that have been sold in both January and February 2024.

select ar.artwork_id,Format(sale_date,'MM yyyy') as sale_date from artists a
join artworks ar on a.artist_id = ar.artist_id
join sales s on ar.artwork_id = s.artwork_id
where Format(sale_date,'MM yyyy') = '01 2024'
INTERSECT 
select ar.artwork_id,Format(sale_date,'MM yyyy') as sale_date from artists a
join artworks ar on a.artist_id = ar.artist_id
join sales s on ar.artwork_id = s.artwork_id
where Format(sale_date,'MM yyyy') = '02 2024'


--14. Write a query to calculate the price of 'Starry Night' plus 10% tax.

select (price*1.1) as TotalPriceWithTax from sales s
join artworks a on a.artwork_id = s.artwork_id
where title ='Starry Night'

--15. Write a query to display the artists whose average artwork price is higher than every artwork price in the 'Renaissance' genre.

select name from artists a
join artworks ar on a.artist_id = ar.artist_id
join sales s on ar.artwork_id = s.artwork_id
group by name
having avg(price) > All(select price from artworks
						where Genre = 'Renaissance' )


--### Section 3: 3 Marks Questions

--16. Write a query to find artworks that have a higher price than the average price of artworks by the same artist.

select artwork_id from artworks o
where price > (select avg(price) from artworks i
				group by artist_id
				having o.artist_id =i.artist_id)

--17. Write a query to find the average price of artworks for each artist and only include artists whose average artwork price is higher than the overall average artwork price.

select a.artist_id,avg(price) from artists a
join artworks ar on a.artist_id = ar.artist_id
group by a.artist_id 
having avg(price) > (select avg(price) from artworks)

--18. Write a query to create a view that shows artists who have created artworks in multiple genres.

Go
create view vwArtistsInMultipleGenres
AS
Select a.artist_id ,name from artists a
join artworks ar on a.artist_id = ar.artist_id
group by a.artist_id,name
having count( Distinct Genre) > 1
Go

select * from vwArtistsInMultipleGenres

--### Section 4: 4 Marks Questions

--19. Write a query to convert the artists and their artworks into JSON format.


select 
 a.artist_id as 'Artists.id',
 name as 'Artists.name',
 country as 'Artists.country',
 birth_year as 'Artists.birt_year',
 artwork_id as ' artwork.id ',
Title as ' artwork.Title',
Genre as ' artwork.genre',
price as 'artwork.price'
from artists a
join artworks ar on a.artist_id = ar.artist_id
for json path ,Root ('Artists')


--20. Write a query to export the artists and their artworks into XML format.

select 
 a.artist_id as [Artists/id],
 name as [Artists/name],
 country as [Artists/country],
 birth_year as [Artists/birt_year],
 artwork_id as [artwork/id ],
Title as [artwork/Title],
Genre as [artwork/genre],
price as [artwork/price]
from artists a
join artworks ar on a.artist_id = ar.artist_id
for xml path ('Artists'),Root 

--### Section 5: 5 Marks Questions

--21. Create a trigger to log changes to the `artworks` table into an `artworks_log` table, capturing the `artwork_id`, `title`, and a change description.

CREATE TABLE artworks_log(
    artwork_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    change_description nvarchar(50)
);


Go
alter trigger ChangeInArtWorks
on artworks
After Insert
As
Begin 
    if update (price)
    Insert into Artworks_log 
    select artwork_id,title,'update in artworks'
	from inserted
End
go

Update artworks
set price ='200000.00'
where artwork_id = 6

select * from artworks
select * from Artworks_log 


--22. Create a scalar function to calculate the average sales amount for artworks in a given genre and write a query to use this function for 'Impressionism'.

Go
create function salesOfGenre(@Genre nvarchar(20))
returns decimal(18,2)
AS
begin
Return (
		select avg(total_amount) as Avg_sales from sales s
		join artworks ar on s.artwork_id = ar.artwork_id
		group by genre
		having genre = @Genre
		);
end 
Go

select * from salesOfGenre('Impressionism')

--23. Create a stored procedure to add a new sale and update the total sales for the artwork. Ensure the quantity is positive, and use transactions to maintain data integrity.

go 
Create Procedure addSales
	@sale_id INT ,
    @artwork_id INT ,
	@sale_date DATE ,
    @quantity INT ,
    @total_amount DECIMAL(10, 2) 
as
Begin
  BEGIN TRANSACTION ;
  BEGIN TRY
    IF not (@quantity > 0)
	THROW 60000, 'quantity is negative', 1 ;
    insert into sales values
	(@sale_id ,@artwork_id ,@sale_date,@quantity ,@total_amount)
	select sum(total_amount) from sales s
	join artworks ar on ar.artwork_id = s.artwork_id
	group by ar.artwork_id
    COMMIT TRANSACTION ;
  END TRY 
  BEGIN CATCH
    Rollback Transaction;
    print Concat('Error number is: ',Error_number()); 
	print Concat('Error message is: ',Error_message()); 
	print Concat('Error state is: ',Error_state()); 
  END CATCH 
end
Go

EXEC addSales  @sale_id = 8 ,@artwork_id =2,@sale_date ='2024-05-20',@quantity =1 ,@total_amount = '200000.00';


--24. Create a multi-statement table-valued function (MTVF) to return the total quantity sold for each genre and use it in a query to display the results.

select sum(quantity) as total_Quantity from sales s
join artworks a on a.artwork_id = s.artwork_id
group by Genre

Go
create function total_Quantity ()
returns @total_Quantity Table (genre nvarchar(20) , Quantity int)
as
begin
		select Genre,sum(quantity) as total_Quantity from sales s
		join artworks a on a.artwork_id = s.artwork_id
		group by Genre
		return;
end



--25. Write a query to create an NTILE distribution of artists based on their total sales, divided into 4 tiles.

select name,sum(total_amount),rank() over (order by sum(total_amount) desc)  as sales_amount,NTILE(4) OVER (ORDER BY sum(total_amount) desc) as Group_Number from sales s
join artworks ar on s.artwork_id = ar.artwork_id
join artists a on ar.artist_id = a.artist_id
Group by a.artist_id,name


--### Normalization (5 Marks)

--26. **Question:**
--    Given the denormalized table `ecommerce_data` with sample data:

--| id  | customer_name | customer_email      | product_name | product_category | product_price | order_date | order_quantity | order_total_amount |
--| --- | ------------- | ------------------- | ------------ | ---------------- | ------------- | ---------- | -------------- | ------------------ |
--| 1   | Alice Johnson | alice@example.com   | Laptop       | Electronics      | 1200.00       | 2023-01-10 | 1              | 1200.00            |
--| 2   | Bob Smith     | bob@example.com     | Smartphone   | Electronics      | 800.00        | 2023-01-15 | 2              | 1600.00            |
--| 3   | Alice Johnson | alice@example.com   | Headphones   | Accessories      | 150.00        | 2023-01-20 | 2              | 300.00             |
--| 4   | Charlie Brown | charlie@example.com | Desk Chair   | Furniture        | 200.00        | 2023-02-10 | 1              | 200.00             |


--Normalize this table into 3NF (Third Normal Form). Specify all primary keys, foreign key constraints, unique constraints, not null constraints, and check constraints.

create table customers(
 cust_id int primary key identity (1,1) ,
 customer_name nvarchar (30) NOT NULL,
 customer_email nvarchar(40)NOT NULL unique
);

create table Products(
 prod_id int primary key identity (1,1),
 product_name nvarchar (30) NOT NULL,
 product_category nvarchar(40) NOT NULL,
 product_price decimal(10,2) NOT NULL
);

create table orders(
 order_id int primary key identity (1,1),
 order_date date NOT NULL, 
 order_quantity int NOT NULL,
 order_total_amount  decimal(10,2) NOT NULL
);

create table injuction (
id int primary key identity (1,1),
cust_id int,
 prod_id int ,
  order_id int , 
  FOREIGN KEY (cust_id) REFERENCES customers(cust_id),
  FOREIGN KEY ( prod_id) REFERENCES Products( prod_id),
  FOREIGN KEY (order_id ) REFERENCES orders(  order_id )
)
--### ER Diagram (5 Marks)

--27. Using the normalized tables from Question 26, create an ER diagram. Include the entities, relationships, primary keys, foreign keys, unique constraints, not null constraints, and check constraints. Indicate the associations using proper ER diagram notation.