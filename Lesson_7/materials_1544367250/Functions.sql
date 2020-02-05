-- 1
alter function DayOfWeek(@day datetime)
returns nvarchar(15)
as
begin
	declare @wday nvarchar(15)
	if(datename(dw, @day) = 'понедельник')
		set @wday = 'Monday'
	else if(datename(dw, @day) = 'пятница')
		set @wday = 'Friday'
	else
		set @wday = 'Other day'
	return @wday
end
go

select dbo.DayOfWeek(getdate()) as 'День недели'
go
select datename(dw, getdate())
go


------------------------------------------------------------------------------------------




-- 2
create function countShops()
returns table
as
return (
select b.NameBook as 'Book Title', count(sh.id_Shop) as 'Number of Shops'
from book.Books as b, sale.Sales as s, sale.Shops as sh 
where s.ID_BOOK = b.ID_BOOK and s.ID_SHOP = sh.ID_SHOP
group by b.NameBook
);
go

select * from countShops();
go

-- 3
create function bestShops()
returns @tableBestShops table (ShopName varchar(30) not null, BookCount int not null)
as
begin
	declare @tmpTable table (id_book int not null, bookNumber int not null)
	
	insert @tmpTable select b.id_book , count (s.id_shop) as 'Number Of Shops'
	from book.Books b, sale.Sales s
	where b.ID_BOOK = s.ID_BOOK
	group by b.ID_BOOK

	insert @tableBestShops 
	select sh.NameShop, 'Number Of Books' = max(tt.bookNumber)
	from @tmpTable as tt, sale.Sales s, sale.Shops sh
	where tt.id_book = s.ID_BOOK and
	s.ID_SHOP = sh.ID_SHOP
	group by sh.NameShop
	return
end
go

select * from bestShops();
go


---------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Список пользовательских функций
select * from sys.sql_modules;

-- Список параметров
select * from sys.parameters;