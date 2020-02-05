--
create database bookshops
go
use bookshops
go
--
create default dch as 'no data'
go
create type myStr from nvarchar(50) not null
go
create type picS from varchar(256) not null
go
create table Themes(
	ID_THEME int primary key identity,
	NameTheme myStr,
)
go
insert into themes values
('Базы данных'),
('Интернет'), 
('Hardware'),
('Операционные системы') ,
('Сети') ,
('Программирование') ,
('Программное обеспечение') ,
('Прочее') ,
('Цифровая обработка сигналов')
go
create table Country
(
	ID_COUNTRY int primary key identity,
	NameCountry myStr
)
go
insert into Country values('USA'),('Германия'),('СНГ'),('Финляндия'),('Великобритания')
go
create table Authors(
	ID_AUTHOR int primary key identity,
	FirstName  myStr,
	LastName  myStr,
	ID_COUNTRY int not null,
	foreign key (ID_COUNTRY) references Country(ID_COUNTRY)
	on delete cascade
	on update cascade
)
go
insert into Authors values
( 'Бек', 'Кент', 1 ),
( 'Савин', 'Роман', 1 ),
( 'Шкритек' , 'Пауль', 2 ),
( 'Циммерман','Филипп', 3 ),
( 'А.И.','Кубин', 3 ),
( 'Торвальдс','Линус', 4 ),
( 'ДеМарко', 'Том', 1),
( 'Хэррис', 'Сара Л', 5),
( 'Паундстоун','Уильям', 1),
( 'Йордан', 'Эдвард', 1),
( 'Фаулер','Мартин', 1),
( 'Kaspersky','Kris', 1),
( 'Макконнелл','Стив', 1)
go
create table Shops
(
	ID_SHOP int primary key identity,
	NameShop myStr,
	ID_COUNTRY int not null,
	foreign key (ID_COUNTRY) references Country(ID_COUNTRY)
	on delete cascade
	on update cascade
)
go
insert into Shops values
( 'us books', 1 ),
( 'deutch books', 2 ),
( 'суничка', 3 ),
( 'you ', 4 ),
( 'great reading', 1 ),
( 'big great reading', 5 )
go
create table Books(
	ID_BOOK int primary key identity,
	NameBook myStr,
	ID_THEME int not null,
	foreign key (ID_THEME) references Themes(ID_THEME)
	on delete cascade
	on update cascade,
	ID_AUTHOR int not null,
	foreign key (ID_AUTHOR) references Authors(ID_AUTHOR)
	on delete cascade
	on update cascade,
	Price money not null,
	DrawingOfBook pics,
	DateOfPublish date not null,
	Pages int not null
)
go
insert into Books values
( 'Экстрим программирование',6, 1 , 451.20,	'no pic',  '2018-02-05', 6 ),
( 'tестирование dot com',6, 2 , 270.20,	'no pic',  '2007-01-01', 2 ),
( 'Справочник по звуковой схемотехнике', 9, 3 , 150.65,	'no pic',  '1991-01-01', 125 ),
( 'Введение в криптографию (ЛП)',8, 4 , 51.20,	'no pic',  '1991-01-01', 18 ),
( '1000 и 1 секрет BIOS ',3, 5 , 120.65,	'no pic',  '2007-01-01', 98 ),
( 'Just for Fun', 4, 6 , 320.65,	'no pic',  '2001-01-01', 135 ),
( 'Deadline. Роман об управлении проектами', 6, 7 , 170.00,	'no pic',  '2006-01-01', 61 ),
( 'Цифровая схемотехника и архитектура компьютера', 3, 8 , 150.00,	'no pic',  '2012-01-01', 61 ),
( 'Как сдвинуть гору Фудзи?', 8, 9, 250.00,	'no pic',  '2004-01-01', 206),
( 'Путь камикадзе [Смертельный марш]?', 6, 10, 236.00,	'no pic',  '2003-01-01', 41),
( 'Рефакторинг', 6, 11, 232.00,	'no pic',  '2003-01-01', 135),
( 'Тонкости дизассемблирования', 6, 12, 182.00,	'no pic',  '2012-01-01', 195),
( 'Совершенный код', 6, 13, 182.00,	'no pic',  '2005-01-01', 195)

go
create table Sales(
	ID_SALE int primary key identity,
	ID_BOOK int not null,
	NameBook myStr,
	foreign key (ID_BOOK) references Books(ID_BOOK)
	on delete no action
	on update no action,
	DateOfSale date not null,
	Price money not null,
	Quantity int not null,
	ID_SHOP int not null,
	foreign key (ID_SHOP) references Shops(ID_SHOP)
	on delete no action
	on update no action
)
go
insert into Sales values
( 11 , (select NameBook from books where id_book = 11 ), '2018-07-10',(select price from books where id_book = 11), 1 ,6),
( 2 , (select NameBook from books where id_book = 2 ), '2018-07-10',(select price from books where id_book = 2) , 1 ,1),
( 4 , (select NameBook from books where id_book = 4 ), '2018-07-10',(select price from books where id_book = 4), 1 ,2),
( 13 , (select NameBook from books where id_book = 13 ), '2018-07-10',(select price from books where id_book = 13),1 ,6),
( 1 , (select NameBook from books where id_book = 1 ), '2018-07-10', (select price from books where id_book = 1) , 1 ,1),
( 7 , (select NameBook from books where id_book = 7 ), '2018-07-10',(select price from books where id_book = 7), 1 ,4),
( 8 , (select NameBook from books where id_book = 8 ), '2018-07-10',(select price from books where id_book = 8), 1 ,4),
( 9 , (select NameBook from books where id_book = 9 ), '2018-07-10',(select price from books where id_book = 9), 1 ,5),
( 5 , (select NameBook from books where id_book = 5 ), '2018-07-10',(select price from books where id_book = 5), 1 ,3),
( 10 , (select NameBook from books where id_book = 10 ), '2018-07-10',(select price from books where id_book = 10),1 ,5),
( 6 , (select NameBook from books where id_book = 6 ), '2018-07-10',(select price from books where id_book = 6), 1 ,3),
( 3 , (select NameBook from books where id_book = 3 ), '2018-07-10',(select price from books where id_book = 3), 1 ,2),

( 12 , (select NameBook from books where id_book = 12 ), '2018-07-10',(select price from books where id_book = 12),1 ,6)
go
select * from authors 
select * from books 
select * from country
select * from sales
select * from shops
select * from themes
go
