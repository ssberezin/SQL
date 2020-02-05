---из pw_4.txt

--1. Создать представление, что позволяет получить информацию о книгах, тираж которых более 3000, и их авторах.
create view view_pw_4_1 (Author, BookName, Circulation)
as
select a.AuthorName+' '+a.AuthorSurName as 'Author',b.BookName, b.Сirculation
from [Author]a join [Books]b on a.Id=b.AuthorId
where b.Сirculation>50000
go

select * from view_pw_4_1
go

--2. Создать представление всех книг и их тематик в отсортированом виде.

create view view_pw_4_2 (BookName, JanreName)
as
select b.BookName, j.JanreName
from [Books]b join [Janre]j on b.JanreId=j.Id
Group by j.JanreName, b.BookName
go

select * from view_pw_4_2
order by 2, 1
go

--3. Создать представление, которое будет отображать информацию о книгах, которые имели тираж 
--более 10 экземпляров с опцией проверки на модификацию и вставте новые данные.

create view view_pw_4_3_1 (JanreId, AuthorId,BookName, Сirculation, PageCount, DateOfPubl, Price,IsPublish)
as
select JanreId, AuthorId,BookName, Сirculation, PageCount, DateOfPubl, Price,IsPublish
from [Books]b 
where b.Сirculation>50000
with check option
go

select * from view_pw_4_3_1
go

insert into view_pw_4_3_1 (JanreId, AuthorId,BookName, Сirculation, PageCount, DateOfPubl, Price,IsPublish)
values
(3,3,'The one', 60000,350,'2018.7.11',21.9,'No');

