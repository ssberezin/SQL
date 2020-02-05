--*********************************
--******** Явные транзакции********
--*********************************

begin transaction
--1
select ProductName from Products;
--2
insert into Categories values('Mocho', 'This is Mocho category',NULL);
--3
update Categories set Picture = 'images/logo.png' where CategoryName = 'Mocho';

select Categories.CategoryName from Categories;
-- подтверждаем выполнение транзакции.
commit transaction
--rollback transaction

--*************************************
--********** Точка сохранения *********
--*************************************
begin transaction
--1
select Categories.CategoryName, Picture from Categories;
-- Первая точка сохранения
save transaction pt1;
--2
insert into Categories values('Mocho', 'This is Mocho category',NULL);
-- Вторая точка сохранения
save transaction pt2;
--3
update Categories set CategoryName = 'Mocho' where CategoryName = 'Mocho';
select Categories.CategoryName, Picture from Categories;
-- Отменить выполнение транзакции до точки pt2 (до update)
rollback transaction pt2;

--**************************
--********* @@eror *********
--**************************
begin transaction 
--1
select CategoryName from Categories;
save transaction pt1
--2
insert into Categories values('MochoMucho', 'This is Mocho category',NULL);
save transaction pt2;
--3
update Categories set CategoryName = 'MochoMucho2' where CategoryName = 'MochoMucho';
-- Выбор действия в зависимости от текущего состояния ошибки
if(@@error>=1 and @@error <=10)
begin
	print 'Значение ошибки 1...10'
	rollback transaction pt2
end
else if(@@error>10)
begin
	rollback transaction
end
else
	commit transaction

--**************************************
--******* Хранимые процедуры ***********
--**************************************
-- Просмотрим список категорий и количество продустов
create procedure sp_categories
as
select Categories.CategoryName, count(Products.ProductID)
from Categories,Products
where Products.CategoryID = Categories.CategoryID
group by Categories.CategoryName;
go
execute sp_categories;

-- Параметр "Число" или Группа процедур
create procedure sp_grCategory;1
as
select * from Products;
go

create procedure sp_grCategory;2
as
select Categories.CategoryName,count(Products.ProductName) as "Count Product"
from Categories, Products
where Categories.CategoryID = Products.CategoryID
group by Categories.CategoryName;
go

execute sp_grCategory;1
execute sp_grCategory;2
execute sp_grCategory; -- Также выполняет первую процедуру из группы


--******************************
--***** Удаление процедуры *****
--******************************
drop procedure sp_grCategory;

--*************************************************
--******** Передача параметров в процедуру ********
--***********************r**************************
create procedure sp_suma
@a int, @b int, @res int output
as
set @res = @a + @b
go

-- Обьявляем прерменную, котороя содержит результат
declare @sum int;

-- явная передача параметров
execute sp_suma @a = 5, @b = 25, @res = @sum output;
print @sum;

-- передача параметров по позиции
execute sp_suma 5, 39,@sum output;
print @sum;

--************************
--******** return ********
--************************
create procedure sp_summa2 @a int, @b int
as
declare @res int
set @res = @a + @b
return @res
go

-- Вызов:
-- Объявляем переменную, которая будет содержать результат
declare @summ int;
 -- явная передача параметров
 execute @summ = sp_summa2 @a = 5, @b = 25;
 print @summ;
 -- передача параметров по позиции
 execute @summ = sp_summa2 5, 67
 print @summ;
 

-- Пример:  сотрудник, который живет в London.
create procedure sp_listEmploeeyFromLondon @firstName varchar(25) output, @lastName varchar(25) output
as
select @firstName = Employees.FirstName, @lastName = Employees.LastName
from Employees
where Employees.City = 'London'
go 


declare @name varchar(25), @surname varchar(25)
execute sp_listEmploeeyFromLondon @name output, @surname output;
select 'Emploeey from London', @name +' '+@surname;

--*******************************************
--******** Информация о процедуре ***********
--*******************************************
exec sp_helptext sp_listEmploeeyFromLondon;

--*******************************************
--******** Информация о зависимостях ***********
--*******************************************
exec sp_depends sp_listEmploeeyFromLondon;


--********************************************
--*********** Пример для вставки *************
--********************************************
create proc sp_addCategory @cName varchar(25), @cDesc varchar(255), @cPic image
as 
insert into Categories values(@cName, @cDesc,@cPic);

--drop proc sp_addCategory;

declare @Name varchar(25) = 'Bingo', @Desc varchar(25) = 'This is a Bingo', @Pic image = null;
execute sp_addCategory 'Bingo', 'This is a Bingo',null;


--*****************************************************
--************* Необезательные параметры **************
--*****************************************************
alter proc sp_addCategory @cName varchar(25), @cDesc varchar(255), @cPic image = null
as 
insert into Categories values(@cName, @cDesc,@cPic);

--drop proc sp_addCategory;

declare @Name varchar(25) = 'Bingo', @Desc varchar(25) = 'This is a Bingo', @Pic image = null;
execute sp_addCategory 'Bingo', 'This is a Bingo';

