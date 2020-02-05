---задание из pw_3.txt


--1. Для представления данных авторов (Имя, Фамилия) и количестова книг которые авторы написали

create view view_1 (Author, BookCount)
as
select a.AuthorName+' ' + a.AuthorSurName as 'Author', count(b.Id) as 'BookCount'
from [Author]a join [Books] b on a.Id=b.AuthorId
group by a.AuthorName+' ' + a.AuthorSurName
go

select * from view_1
go
--2. Количество книг каждой тематики

create view view_2 (BookCount, JanreName)
as
select count(b.Id) as 'BookCount', j.JanreName
from [Books] b join [Janre]j on b.JanreId = j.Id
group by j.JanreName
go

select * from view_2
go

--3. Количество проданных книг

create view view_3 (BookCountSale)
as
select sum(s.SaleCount) as 'BookCountSale'
from [Sales] s
go

select * from view_3
go


--4. Среднее количество страниц книг каждой тематики

create view view_4 (AveragePage, JanreName)
as
select avg(b.PageCount) as 'AveragePage', j.JanreName
from [Janre] j join [Books]b on j.Id=b.JanreId
group by j.JanreName
go

select * from view_4
go
