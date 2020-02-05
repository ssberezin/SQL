/*T-Sql - Одно
из основных назначений языка T-SQL – позволить раз-
работчикам баз данных с легкостью создавать запросы,
возвращая при этом данные множеством способов*/

 /*ряд расширений языка T-SQL:
1. Операторы BEGIN..END, которые ограничивают несколь-
ко операторов определенного блока.
2. Переменные, которые служат для сохранения произ-
вольных данных. Для того, чтобы создать перемен-
ную, нужно ее задекларировать:
 */

 -- ***** Создание *******
 declare @var_1 varchar(25);

 -- ***** Груповое создание ******
 declare @var_2 varchar(10),@var_3 int;

 -- ***** Создание и инициализация *******
 declare @var_4 int = 78;

 -- ***** Груповое cоздание и инициализация ********
 declare @var_5 varchar(25) = 'Hello World',
		@var_6 datetime = '28/05/2018';

-- ********* Инициализация *********
set @var_1 = 'I am a teacher';
select @var_2 = 'Gosha', @var_3 = 37;


-- ******** переменные табличного типа ***********
-- создаем переменную табличного типа
declare @ProductTable table(id int not null, ProductName varchar(255));
-- заполняем переменную данными
insert @ProductTable select Products.ProductID, Products.ProductName from Products; 
-- выводим на экран данные с переменной типа таблицы
select id, ProductName from @ProductTable order by 1;
 
 -- ******** Вывод : ***********
 --select
 select 'Значение переменной @var_4 = '+convert(varchar,@var_4);
 select '@var_1 = '+@var_1+' '+
 ', @var_2 = '+@var_2+', @var3 = '+convert(varchar,@var_3)+
 ', @var_5 = '+@var_5+', @var_6 = '+convert(varchar,@var_6)

 -- print - нельзя использовать оператор конкатенации
 declare @msg varchar(max) = '@var_1 = '+@var_1+' '+
 ', @var_2 = '+@var_2+', @var3 = '+convert(varchar,@var_3)+
 ', @var_5 = '+@var_5+', @var_6 = '+convert(varchar,@var_6);

print @msg;
print @msg +' - error';
go

-- ******** Условный оператор if.else ***********
if(datename(dw, GetDate())) = 'Monday'
	print 'Сегодня понедельник';
else 
	print 'Сегодня не понедельник';

-- ********* select в условных операторах ************
--	определим среднюю цену продуктов и, если полученная цена будет больше
--  50 грн., тогда выведем соответствующее сообщение:
if(select avg(UnitPrice) from Products) > 50
	begin 
		print 'Существуют продукты, средняя цена которых больше 50 грн' 
	end
else 
	begin 
		print 'Не существуют продукты, средняя цена которых больше 50 грн' 
	end
go

if(select avg(UnitPrice) from Products) > 50
	begin 
		print 'Существуют продукты, средняя цена которых больше 50 грн' 
	end
else 
	begin 
		print 'Не существуют продукты, средняя цена которых больше 50 грн' 
	end
go

/*выведем всю информацию про каждый
продукт, цена которого находится в промежутке
от 10 до 20:*/
if exists(select * from Products where Products.UnitPrice between 10 and 30)
	begin 
		select 'Информация про продукты'
		select * from Products where Products.UnitPrice between 10 and 30
		return
	end
go


-- ********** Оператор ветвления CASE ************
/*Примечание! В SQL Server CASE является функцией, а не
командой. В связи с этим CASE может использоваться
только как часть оператора SELECT или UPDATE, в от-
личие от оператора IF, который работает самостоятельно.*/

select 'Product', 'Category';

select 'Product' = 'snickers', 'Category' = 'Chocklet';

select 'Product' = Products.ProductName, 'Category' = Categories.CategoryName
from Products, Categories where Products.CategoryID = Categories.CategoryID;

/* Простая форма*/
/*Напишем запрос, который будет выводить на
экран название продуктов и их категорию в расширен-
ном виде*/
select 'Product Name' = Products.ProductName,
'Category' = case Categories.CategoryName
	when 'Beverages' then 'This is Beverage Category'
	when 'Condiments' then 'This is Condiments Category'
	else 'This is other Category'
	end
from Products, Categories 
where Products.CategoryID = Categories.CategoryID;	

/*
С поиском. В этой форме CASE можно указать ус-
ловное выражение при каждой инструкции
WHEN.
*/					 
/*Запрос, в котором нужно проверить цену продукта.
В результирующий запрос возвращается значе-
ние, соответствующее первой условии true. 
реализовать 2 условия в конструкции when*/
select 'Product title' = Products.ProductName,
'Price' = case
	when Products.UnitPrice<30 then 'Product cheaper than 30'
	when Products.UnitPrice between 30 and 60 then 'Price ranges between 30 and 60'
	else 'Product more expensive than 60'
	end
from Products;

-- ********* Проверка на NULL, функции coalesce **********
-- с оператором case
select 'Costomer Name' = Customers.ContactName,
'Region' = case
	when Customers.Region is not null then 'Region is not null'
	else 'Region is null'
	end
from Customers;

-- с использованием функции coalesce
select 'Costomer Name' = Customers.ContactName,
'Region' = coalesce(Customers.Region + ' not null', 'Region is null')
from Customers;


-- ************** Оператор case может вернуть NULL,  Nullif ***************
--нам необходимо вы-
--вести на экран названия продуктов и их остатки. Если значение
--остатка равно нулю, тогда выводим NULL.
-- с оператором case
select 'Books' = ProductName,
 'Pressrun' = case
 when UnitsInStock = 0 then NULL
 else UnitsInStock
 end
from Products;

-- с использованием функции nullif
select 'Books' = ProductName,
 'Pressrun' = NULLIF(UnitsInStock,0)
from Products;

/*подсчитаем сколько продуктов имеют значение
остатка (не ноль).*/
select 'Number of product whith not zero stock' =
count(nullif(UnitsInStock,0)) 
from Products;

-- ************ Оператор безусловного перехода GOTO **************
label1: PRINT 'Действие выполняется'
GOTO label
PRINT 'Действие не выполняется'
label: PRINT 'После выполнения'

-- зацыкливание error
label1: PRINT 'Действие выполняется'
GOTO label2
PRINT 'Действие не выполняется'
label2: PRINT 'После выполнения'
goto label1

-- *********** циклы WHILE (break, continue, END) ***********
-- создаем переменную
declare @i int;
set @i = 1;
-- запускаем цикл
-- до пяти
while @i<10
begin
	print @i
	set @i = @i + 1	
	if @i> 5
		break
end;
-- не четные
set @i = 1;
while @i<10
begin
	if @i % 2 != 0
		print @i
	set @i = @i + 1	
end;

-- обсчитаем среднюю цену всех продуктов. Если она
-- меньше 35 грн., то все цены повысить на 10% до тех пор,
-- пока средняя цена не станет больше 35 грн.
select avg(UnitPrice) from Products;
while (select avg(UnitPrice) from Products)<35
begin
	update Products set UnitPrice = UnitPrice*1.1
end;
select avg(UnitPrice) from Products;

-- **************** Общие табличные выражения (виртуальными представлениями) ***************

