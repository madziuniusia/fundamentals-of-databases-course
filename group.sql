select top 5 orderid, productid, quantity  from [order details] order by quantity desc;
select top 5 with ties orderid, productid, quantity from [order details] order by quantity desc;

-- ex 1.1 Podaj liczbę produktów o cenach mniejszych niż 10 lub większych niż 20
select count(ProductName) as liczba_produktow from Products where UnitPrice < 10 or UnitPrice > 20;

-- ex 1.2 Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20
select max(UnitPrice) from Products where UnitPrice < 20;

-- ex 1.3 Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o produktach sprzedawanych w butelkach (‘bottle’)
select max(UnitPrice) as maksimum, min(UnitPrice) as minimum, avg(UnitPrice) as srednia from Products where QuantityPerUnit like '%bottle%'

-- ex 1.4 Wypisz informację o wszystkich produktach o cenie powyżej średniej
select ProductName, UnitPrice from Products where UnitPrice > (select avg(UnitPrice) from Products);

-- ex 1.5 Podaj sumę/wartość zamówienia o numerze 10250
select  cast(sum(UnitPrice * (1-Discount) * Quantity) as decimal(10, 2)) as 'suma zamówienia' from [Order Details] where OrderID = 10250;

---
-- ex 2.1 Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, max(UnitPrice) as MaxPrice from [Order Details] group by OrderID;

-- ex 2.2 Posortuj zamówienia wg maksymalnej ceny produktu
select OrderID, max(UnitPrice) as MaxPrice from [Order Details] group by OrderID order by max(UnitPrice) DESC;

-- ex 2.3 Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, min(UnitPrice) as minimum, max(UnitPrice) as maksimum from [Order Details] group by OrderID;

-- ex 2.4 Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
select ShipVia, count(*) from Orders group by ShipVia;

-- ex 2.5 Który ze spedytorów był najaktywniejszy w 1997 roku
select top 1 ShipVia, count(*) as liczba_zamowien from Orders where year(ShippedDate) = 1997 group by ShipVia order by liczba_zamowien desc;
select top 1 ShipVia from Orders where year(ShippedDate) = 1997 group by ShipVia order by count(*) desc;

-- ex 3.1 Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
select OrderID from [Order Details] group by OrderID having count(*) > 5;

-- ex 3.2 Wyświetl  klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień (wyniki posortuj malejąco
-- wg  łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
select CustomerID from Orders where year(OrderDate) = 1998 group by CustomerID having count(*) > 8 order by sum(Freight) desc ;