

----1----
SELECT b.BookName as 'Название книги', a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор' 
FROM
Books b, Author a
WHERE b.AuthorId = a.Id and a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName in (SELECT  Top 3
a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор'
FROM
Books b, Author a
WHERE b.AuthorId = a.Id
Group by  a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName
ORDER BY RAND()
)
order by 'Автор' 



---2----
SELECT b.BookName as 'Название книги', b.PageCount as 'Количество страниц' 
FROM Books b
where b.PageCount>500 and b.PageCount<650
order by b.PageCount 

----3----
SELECT b.BookName as 'Название книги' 
FROM Books b
where b.BookName like '%[АС]%';

---4----
SELECT B.BookName as 'Название книги', J.JanreName as 'Жанр', B.Сirculation as 'Тираж'
FROM BOOKS B, JANRE J
WHERE j.Id = b.JanreId and J.JanreName != 'Фэнтези' and b.Сirculation>=100000


----5----
SELECT B.BookName as 'Название книги' , b.DateOfPubl as 'Дата издания', b.Price as 'Цена, $'
FROM Books B
where  YEAR(GETDATE())-year(b.DateOfPubl)<=0 and b.Price <30


---6---
SELECT B.BookName as 'Название книги'
FROM Books B
WHERE B.BookName LIKE 'Я [^танкист]%'

----7----
SELECT B.BookName as 'Название книги', J.JanreName as 'Жанр',  b.Price/b.PageCount as 'Цена',
 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор' 
FROM [Books] B 
JOIN [Janre] J ON j.Id = b.JanreId
JOIN [Author] A ON a.Id = b.AuthorId
WHERE b.Price/b.PageCount<0.06

---8---
SELECT B.BookName as 'Название книги'
From Books b
WHERE b.bookname like '% % % %';

---9---

SELECT B.BookName as 'Название книги',   b.Price as 'Цена для диллеров, $', 
 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор' , s.DateOfsal as 'Дата продажи'
FROM [Sales] S
join [Books] B on b.Id = s.BooksId
join [Author] A  on b.AuthorId=a.Id
Where  s.DateOfSal>'01/01/2018'

 ----10--- 
 Select  B.BookName as 'Название книги', j.JanreName as 'Жанр', 
 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор' , 
 b.Price as 'Цена для диллеров, $', sum (s.SaleCount) as 'Количество продаж',
  sh.ShopName as 'Название магазина', c.CountryName as 'Страна'
 From [Books] b
 join [Janre] j on b.JanreId = j.Id
 join [Author] a on a.Id = b.AuthorId
 join [Sales] s on b.Id = s.BooksId
 join [Shop] sh on sh.SalesId=s.Id
 join [Country] c on c.Id=sh.CountryId
 Where j.JanreName!='Фэнтези' and c.CountryName!='Украина' and c.CountryName!='Россия'
  Group by B.BookName , j.JanreName , a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName ,
   b.Price,   sh.ShopName, c.CountryName




 ----11-----
  SELECT COUNT(a.id) as 'Количество авторов'
into TmpAuthor
from [Author] a;

SELECT * 
from [TmpAuthor] a

---12--

select AVG(s.Price) as AvPrice
into #TmpLocalTable
from [Sales] s;

----13---

SELECT j.JanreName as 'Жанр',  avg(b.PageCount) as 'Среднее число страниц'
FROM [Janre] J
join [Books] b on b.JanreId= j.Id
Group by j.JanreName;

---14---
Select top 3 a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор',
sum(b.Id) as 'Количество книг', sum(b.PageCount) 'Сумма страниц'
From [Books] b
join [Author] a on b.AuthorId= a.Id
Group by a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName

-----15---
Select b.BookName as 'Название книги', max(b.PageCount) as 'Наибольшее количество странитц'
From [Janre]j
join [Books] b on b.JanreId = j.Id
where j.JanreName='Фэнтези'
Group by b.BookName;


----16---- неработает

Select a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор', 
b.BookName as 'Название книги', b.DateOfPubl as 'Дата издания'
--into ##GlobTable_16
From [Author] a
join [Books] b on b.AuthorId = a.Id
where b.DateOfPubl in (

)
Group by a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName , b.BookName,b.DateOfPubl

---тут получаем ток мин дату публикации и авторов,без названия книги
select min(b.DateOfPubl),a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор'

From [Author] a
join [Books] b on b.AuthorId = a.Id
group by a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName 


---17----

select  avg(b.PageCount) as 'Среднее кол-во стр по тематике', j.JanreName as 'Жанр'
from [Janre] j
join [Books] b on b.JanreId= j.Id
group by j.JanreName
having avg(b.PageCount)>400;

-----18----

select  sum(b.PageCount) as 'Сумма страниц', j.JanreName as 'Жанр'
from [Janre] j
join [Books] b on b.JanreId= j.Id
where j.JanreName in('Фэнтези','Боевая фантастика')
group by j.JanreName
having sum(b.PageCount)>300;


---19---
select sum (s.SaleCount) as BookSalCount , s.DateOfSal as DateSale, sh.ShopName as Shop
into #TMPTab_19
from [Sales]s
join [Shop] sh on sh.SalesId = s.Id
where s.DateOfSal>'01/10/2018'
group by s.DateOfSal, sh.ShopName;

select sum (tmp.BookSalCount) as 'Ко-во проданных книг', tmp.Shop as 'Магазин'
from [#TMPTab_19]tmp
group by tmp.Shop;
 
 -----20----

  Select  sh.ShopName as 'Название магазина',  B.BookName as 'Название книги', 
  j.JanreName as 'Жанр',  a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Автор' , 
 sum(s.Price) as 'Выручка, $', sum (s.SaleCount) as 'Количество продаж',
   c.CountryName as 'Страна'
 From [Books] b
 join [Janre] j on b.JanreId = j.Id
 join [Author] a on a.Id = b.AuthorId
 join [Sales] s on b.Id = s.BooksId
 join [Shop] sh on sh.SalesId=s.Id
 join [Country] c on c.Id=sh.CountryId

  Group by sh.ShopName,B.BookName , j.JanreName , a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName ,
       c.CountryName;


----запрос 1 ------ дз №3 -----------------------------------------------------------------------------------------------
Select sum(s.SaleCount) as 'SumSalesCount', b.BookName as 'Book name' 
into #TMPTab_1
from [Author] a 
join[books]	b on a.Id = b.AuthorId
join [sales] s on b.Id=s.BooksId and a.AuthorCountry = 'США'
 Group by b.bookname
 select max (tmp.SumSalesCount)
from [#TMPTab_1]tmp

Select sum(s.SaleCount) as 'CountSaleBooks', a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName as 'Author', 
b.BookName as 'BookName', a.AuthorCountry as 'AuthorCountry'
into #TMPTab_2
from [Author] a 
join[books]	b on a.Id = b.AuthorId
join [sales] s on b.Id=s.BooksId and a.AuthorCountry!='США'
Group by  a.AuthorName+' '+a.AuthorSecName +' '+a.AuthorSurName ,b.BookName, a.AuthorCountry;

select tmp2.CountSaleBooks as 'Количество проданых книг', tmp2.Author as 'Автор', tmp2.Bookname as 'Название книги',
tmp2.AuthorCountry as 'Страна автора'
from [#TMPtab_2]tmp2
where tmp2.CountSaleBooks>(select max (tmp.SumSalesCount)from [#TMPTab_1]tmp)


 
