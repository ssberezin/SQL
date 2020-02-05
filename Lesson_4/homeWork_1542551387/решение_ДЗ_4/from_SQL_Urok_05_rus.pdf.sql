--Задания из SQL_Urok_05_rus.pdf.txt 

--1. С помощью оператора COMPUTE BY написать запрос, который выводит названия 
--магазинов и суммарное количество заказанных магазином книг.

select sh.ShopName, sum(sh.BookCount)
from  [Shop] sh 
group by sh.ShopName

--2. С помощью оператора COMPUTE вывести данные о том,
-- сколько получило издательство от продажи книг за последний год.


select sh.ShopName, sum(sh.BookCount*s.Price) as '$'
from  [Shop] sh join [Sales]s on sh.SalesId = s.Id
group by sh.ShopName



--3. С помощью операторов CUBE и ROLLUP написать два запроса, которые будут
-- отображать информацию о среднем количестве продажи книг  магазинами
--  Великобритании и Канады в промежутке 01/01/2008 по 01/09/2008.
--   Показать среднее количество продаж, как по каждой стране, 
--   так и по отдельному магазину.

select sh.ShopName , c.CountryName, avg(s.SaleCount) as 'Sale books'
from [Sales]s join [Shop] sh on sh.SalesId = s.Id
join [Country] c on sh.CountryId=c.Id
where c.CountryName in ('Украина', 'Грузия') 
and s.DateOfSal between '2017-01-01' and '2018-12-01'
group by sh.ShopName , c.CountryName
with rollup;

--4. Используя оператор GROUPING SET написать запрос, который выведет 
--максимальный тираж книг за весь период работы издательства в разрезе 
--авторов и годов выпуска книг.

select b.BookName as 'Книга', a.AuthorSurName+' '+a.AuthorName as 'Автор', 
max (b.Сirculation) as 'Тираж', b.DateOfPubl as 'Дата издания'
from [Author]a join [Books]b on a.Id=b.AuthorId
group by grouping sets (b.BookName,a.AuthorSurName+' '+a.AuthorName ,  b.DateOfPubl)


--5. Используя оператор PIVOT создать сводную таблицу, 
--отражающую минимальные цены продажи книг отдельными магазинами за последний год.

--способ для нормальных людей
select min(b.Price) as 'Минимальная цена', sh.ShopName as 'Магазин'
from [Books]b join [Sales]s on b.Id=s.BooksId 
join [Shop]sh on  sh.SalesId = s.Id
group by sh.ShopName

---способ для извращенцев
select [min], [Звезда], [Книжный клуб семейного досуга], [Колумб],
 [Либрусек], [Плимут]
 From (select 'Minumum price' as 'min',b.Price, sh.ShopName 
from [Books]b join [Sales]s on b.Id=s.BooksId 
join [Shop]sh on  sh.SalesId = s.Id ) tmp
pivot
(min (Price) for Shopname in ([Звезда], [Книжный клуб семейного досуга], [Колумб],
 [Либрусек], [Плимут]))pvt;

 --6. Используя оператор PIVOT, создать двухуровневую сводную таблицу,
  --которая отражает данные о количестве выпуска издательством книг всех
  -- тематик на протяжении трех выбранных лет. Отсортировать данные по тематикам.
  select x.Year, [4] as 'Фэнтези',
		 [3]as 'Альтернативная история',
		 [2]as 'Боевая фантастика',
		 [1]as 'Найчная фантастика'
  from (
  select JanreName, b.Сirculation, year(b.DateOfPubl) as Year
  from [Janre]j join [Books]b on j.Id=b.JanreId
  where year(b.DateOfPubl) between '2017' and '2018'
  )tmp
  pivot	
  (sum(Сirculation) for JanreName in ([1],[2],[3],[4])
  ) as x
  order by x.Year;



  