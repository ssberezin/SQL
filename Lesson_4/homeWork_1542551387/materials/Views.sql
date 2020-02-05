/*
View
Представление (view) – это объект БД, который имеет внешний
вид таблицы, но в отличие от нее не имеет своих собствен-
ных данных.

create view [схема.] название_представления [(поле [,...n])]
as
< оператор select>
[with check option]



WITH CHECK OPTION – создает модифицированное пред-
ставление, в котором существует возможность за-
претить выполнение операций INSERT или DELETE,
если при этом нарушается условие, заданное в кон-
струкции WHERE.
*/

/*1 пример*/
-- запрос на получение информацию о продуктах,
-- количество которорых более 20,
-- и их поставщиках.
create view Product_View1 (NameProduct, SupplierCompany, CountInStock)
as
select Products.ProductName, Suppliers.CompanyName, Products.UnitsInStock
from Products,Suppliers
where Products.SupplierID = Suppliers.SupplierID and
Products.UnitsInStock > 20;

select * from Product_View1; 


/*
Различают следующие типы представлений:

1. Обычные представления на основе объединений – это пред-
ставление на выборку данных.

2. Модифицированные (обновляемые) преставления – это представ-
ления, которые поддерживают модификацию данных

*/

/*Пример 2*/
/*Данные в отсортированом виде*/
select * from Product_View1 order by 1;

create view Sorting_View2
as
select Products.ProductName, Categories.CategoryName, Products.UnitPrice
from Products, Categories
where Products.CategoryID = Categories.CategoryID
order by 1; /**************** Ошибка ***********************/

/*С применением параметра top*/
create view Sorting_View2
as
select top 1000 Products.ProductName, Categories.CategoryName, Products.UnitPrice
from Products, Categories
where Products.CategoryID = Categories.CategoryID
order by 1;

select * from Sorting_View2;

/*Ограничения*/
/*1.Хранимые процедуры*/
create view sp_View3
as
exec sp_helpdb;

/*2. select into*/
create view into_View4
as
select * into new_table from Products;

/*3. при изменении
данных представления меняются данные базовых
таблиц;*/

/*4. представление не может ссылаться больше, чем на
1024 поля*/

/*5. UNION и UNION ALL недопустимы при форми-
ровании представлений*/

/**************************************/
/************ Изменения представления *************/
alter view Product_View1 (NameProduct, SupplierCompany, CountInStock)
as
select Products.ProductName, Suppliers.CompanyName, Products.UnitsInStock
from Products,Suppliers
where Products.SupplierID = Suppliers.SupplierID and
Products.UnitsInStock < 20;

select * from Product_View1; 


/*Удаление представления*/
drop view Product_View1;


/**************************************/
/************ Обновляемые представления *************/
/*К таким представлениям можно применять команды
INSERT, UPDATE и DELETE. сайт metanit*/ 
create view Product_View2 (NameProduct, Price, Storcks)
as
select Products.ProductName, Products.UnitPrice, Products.UnitsInStock
from Products
where
Products.UnitsInStock < 20 with check option;

/*представление при следующем
обращении введенных данных показывать не будет, по-
скольку они не соответствуют критерию отбора данных */
insert into Product_View2 (NameProduct, Price, Storcks)
values ('Microsoft SQL Server', 230,50);

/* Коректный запрос на вставку поскольку количество отвечает учловию*/
insert into Product_View2 (NameProduct, Price, Storcks)
values ('Microsoft SQL Server', 230,15);

/*проверяем...*/
select * from Product_View2;

/* Как вы думаете куда на самом деле добавился новый продукт? */
select * from Products;

