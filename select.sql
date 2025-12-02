-- 1.1 Wybierz nazwy i adresy wszystkich klientów
select LastName, FirstName, Address from Employees

-- 1.2 Wybierz nazwiska i numery telefonów pracowników
select LastName, HomePhone from Employees

-- 1.3 Wybierz nazwy i ceny produktów
select ProductName, UnitPrice from Products

-- 1.4 Pokaż wszystkie kategorie produktów (nazwy i opisy)
select CategoryName, Description from Categories

-- 1.5 Pokaż nazwy i adresy stron www dostawców
select CompanyName, HomePage from Suppliers

---

-- 2.1 Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
select CompanyName, Address from Customers where City = 'London';

-- 2.2 Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii
select CompanyName, Address from Customers where Country = 'Spain' or Country = 'France';

-- 2.3 Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
select ProductName, UnitPrice from Products where UnitPrice between 20.00 and 30.00;

-- 2.4 Wybierz nazwy i ceny produktów z kategorii 'Meat/Poultry'
select ProductName, UnitPrice from Products join Categories on Products.CategoryID = Categories.CategoryID where CategoryName = 'Meat/Poultry';
SELECT ProductName, UnitPrice FROM Products WHERE CategoryID = 6; --- mega gówno

-- 2.5 Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
select ProductName, UnitsInStock from Products join Suppliers on Products.SupplierID = Suppliers.SupplierID where CompanyName = 'Tokyo Traders';

-- 6. Wybierz nazwy produktów których nie ma w magazynie
select ProductName from Products where UnitsInStock = 0;

---

-- 3.1 Szukamy informacji o produktach sprzedawanych w butelkach (‘bottle’)
select * from Products where QuantityPerUnit like '%bottle%';

-- 3.2 Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę z zakresu od B do L
select Title from Employees where LastName like '[B-L]%';

-- 3.3 Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę  B lub L
select Title from Employees where LastName like '[BL]%';

-- 3.4 Znajdź nazwy kategorii, które w opisie zawierają przecinek
select CategoryName from Categories where Description like '%,%';

-- 3.5 Znajdź  klientów, którzy w swojej nazwie mają w którymś miejscu słowo 'Store'
select ContactName from Customers where CompanyName like '%Store%';

---

-- 4.1 Szukamy informacji o produktach o cenach mniejszych niż 10 lub większych niż 20
select * from Products where UnitPrice < 10 or UnitPrice > 20;

-- 4.2 Wybierz zamówienia złożone w 1997 roku
-- select * from Orders where OrderDate between '1997-01-01' and '1997-12-31';
select * from Orders where YEAR(OrderDate) = 1997;

-- 4.3 Wybierz zamówienia złożone w latach: 1997 do 1998
-- select * from Orders where OrderDate between '1997-01-01' and '1998-12-31';
select * from Orders where YEAR(OrderDate) between 1997 and 1998;

-- 5.1 Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer klienta dla wszystkich
-- niezrealizowanych jeszcze zleceń, dla których krajem odbiorcy jest Argentyna
select OrderID, OrderDate, EmployeeID from Orders where ShippedDate is null and ShipCountry = 'Argentina';

---

-- 6.1 Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj  według kraju, w ramach danego kraju nazwy firm posortuj alfabetycznie
select CompanyName, Country from Customers order by Country ASC;

-- 6.2 Wybierz nazwy i  kraje wszystkich klientów mających siedziby we Francji lub w Hiszpanii,
-- wyniki posortuj  według kraju, w ramach danego kraju nazwy firm posortuj alfabetycznie
select CompanyName, Country from Customers
where Country in ('Spain', 'France')
order by Country, CompanyName;

-- 6.3 Wybierz zamówienia złożone w 1997 r. Wynik po sortuj malejąco wg numeru miesiąca, a w ramach danego miesiąca rosnąco według ceny za przesyłkę
select * from Orders
where YEAR(OrderDate) = 1997
order by MONTH(OrderDate) DESC, Freight ASC;

---

-- 7.1 Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 10250
select  UnitPrice * Quantity * (1 - Discount) as TotalValue from [Order Details] where OrderID = 10250;

-- 7.2 Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą kolumnę zawierającą nr telefonu i nr faksu w formacie
-- (numer telefonu i faksu mają być oddzielone przecinkiem)
select Phone + ',' + Fax as PhoneAndFax from Suppliers;