/*
1. Функцию, которая возвращает среднее арифметическое цен всех книг, проданных до указанной даты.
*/

create function AvPrBookBeforDate(@day datetime)
returns money 
as
begin
	declare @avPrice money
	set @avPrice =(	
	Select AVG(b.Price)
	From sale.sales S join book.Books B on S.ID_BOOK = B.ID_BOOK
	 where s.DateOfSale<@day);
		
	return @avPrice
end
go

select dbo.AvPrBookBeforDate('2019-01-02') as 'AVG Price'
go

/*
2. Функцию, которая возвращает самую дорогую книгу издательства указанной тематики.
*/


create function mostExpBookbyThem (@theme nvarchar(50))
 returns table
 as return(

Select b.NameBook, b.PRICE
from book.Books as b 
where b.PRICE=(
select   max(b.PRICE) as 'Price'
from book.Books as b join sale.Sales as s 
on s.ID_BOOK = b.ID_BOOK
join book.Themes as t on b.ID_THEME=T.ID_THEME
where t.NameTheme=@theme));
go

select * from mostExpBookbyThem('Programming');
go

/*
3. Функцию, которая по ID магазина возвращает информацию о нем 
(ID, название, местоположение, средняя стоимость продаж за последний
 год книг вашего издательства) в табличном виде.
*/

create function shopInfo (@Id int )
 returns table
 as return(
select sh.ID_SHOP as'ID',sh.NameShop as 'Shop name' , avg(s.Price) as 'Average price',
		 c.NameCountry as 'Location'
from book.Books  b join sale.Sales S on b.ID_BOOK=s.ID_BOOK
join sale.Shops sh on s.ID_SHOP=sh.ID_SHOP
join global.Country c on sh.ID_COUNTRY=c.ID_COUNTRY
where sh.ID_SHOP=@Id
group by sh.ID_SHOP,sh.NameShop, c.NameCountry
);
go

select * from shopInfo(1);
go


/*
4. Функцию, которая возвращает количество магазинов, которые не продали ни 
одной книги издательства.
*/

create function nullShop()
returns int
as
begin
	declare @count int
	
	declare @tmpTable table (NameShop nvarchar(30), SalesCount int )	
	insert @tmpTable 
	select sh.NameShop as 'Shop name' , count (s.DateOfSale) as 'Salese count'
	from book.Books  b join sale.Sales S on b.ID_BOOK=s.ID_BOOK
	join sale.Shops sh on s.ID_SHOP=sh.ID_SHOP
	group by sh.NameShop

	set @count =(	
	Select tt.SalesCount
	From @tmpTable tt
	 where tt.SalesCount=0)
		if @count=NULL
			set @count=0;
		--print @count
		return @count
end
go



select dbo.nullShop() as 'Count of NULLShops' 
go


/*
5. Функцию, которая возвращает минимальный из трех параметров.
*/

create function Minimum(@a int, @b int, @c int )
returns int
as
begin
 declare @min int
	if @a<=@b and @a<=@c
		set @min= @a;
	else
		if @b<=@a and @b<=@c
		set @min= @b;
	else
		--if @c>=@a and @c>=@b
		set @min= @c;	
	return @min;
end
go

select dbo.Minimum(1,2,3) as 'Minimum'
go


/*
6. Многооператорную функцию, которая возвращает количество проданных 
книг по каждой из тематик и в разрезе каждого магазина.
*/




create function BookCountJanreInShop()
returns @tmpTable table (ShopName varchar(30) not null, BookCount int not null, NameTheme varchar(30) not null)
as
begin
	
	insert @tmpTable 
	select sh.NameShop as 'Shop name' , count(s.DateOfSale) as 'Count of sales',
		 t.NameTheme as 'Janre'		 
	from book.Books  b join sale.Sales S on b.ID_BOOK=s.ID_BOOK
	join sale.Shops sh on s.ID_SHOP=sh.ID_SHOP
	join book.Themes t on t.ID_THEME=b.ID_THEME
	group by t.NameTheme, sh.NameShop
	return
end
go

select * from BookCountJanreInShop();
go


/*
7. Функцию, которая возвращает список книг, которые соответствуют
 набору критериев (имя и фамилия автора, тематика), и отсортированы по фамилии автора 
 в указанном в 4-м параметре направлении.
*/

create view ViewFor  (FirstName, LastName, NameBook, ThemeName)
as
Select A.FirstName, A.LastName, B.NameBook, t.NameTheme
from book.Books  b join book.Authors A on b.ID_AUTHOR=A.ID_AUTHOR	
	join book.Themes t on t.ID_THEME=b.ID_THEME
go

create function BooksBy (@Name nvarchar(30), @SurName nvarchar(30),
 @janreName nvarchar(100) , @sort int)
 returns @tmpTable table (FirstName varchar(30) not null,LastName varchar(30) not null,
						NameBook varchar(50) not null, ThemeName varchar(50) not null)
as
begin

if @sort=0
	begin
	insert @tmpTable
	 select * from ViewFor 
	 where FirstName=@Name and LastName=@SurName and ThemeName=@janreName	 
	 order by FirstName
	end
else	
	begin
	 insert @tmpTable
	 select * from ViewFor 
	 where FirstName=@Name and LastName=@SurName and ThemeName=@janreName	 
	 order by FirstName desc
	end
	return
end
go
		
select * from BooksBy('Wallace','Wang','Programming',0);
go





