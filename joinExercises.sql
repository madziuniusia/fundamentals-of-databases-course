-- ex 1.1 Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta.
select Orders.OrderID, C.CompanyName, sum(OD.Quantity) as totalQuantity
from Orders
         inner join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
         inner join dbo.Customers C on C.CustomerID = Orders.CustomerID
group by Orders.OrderID, C.CompanyName;

-- ex 1.2 Dla każdego zamówienia podaj łączną wartość zamówionych produktów (wartość zamówienia bez opłaty za przesyłkę) oraz nazwę klienta.
select Orders.OrderID, C.CompanyName, CAST(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) as money) as total
from Orders
         inner join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
         left join dbo.Customers C on C.CustomerID = Orders.CustomerID
group by Orders.OrderID, C.CompanyName

-- ex 1.3 Dla każdego zamówienia podaj łączną wartość tego zamówienia (wartość zamówienia wraz z opłatą za przesyłkę) oraz nazwę klienta.
select Orders.OrderID, C.CompanyName, CAST(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount) + Orders.Freight) as money) as total
from Orders
         inner join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
         left join dbo.Customers C on C.CustomerID = Orders.CustomerID
group by Orders.OrderID, C.CompanyName
-- ex 1.4 Zmodyfikuj poprzednie przykłady tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówień
select Orders.OrderID,
       C.CompanyName,
       E.FirstName,
       E.LastName,
       CAST(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount) + Orders.Freight) as money) as total
from Orders
         inner join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
         left join dbo.Customers C on C.CustomerID = Orders.CustomerID
         left join dbo.Employees E on Orders.EmployeeID = E.EmployeeID
group by Orders.OrderID, C.CompanyName, E.FirstName, E.LastName

---

-- ex 2.1 Podaj nazwy przewoźników, którzy w marcu 1998 przewozili produkty z kategorii 'Meat/Poultry'
SELECT Shippers.CompanyName FROM Shippers
JOIN dbo.Orders O on Shippers.ShipperID = O.ShipVia AND O.ShippedDate BETWEEN '1998-03-01' AND '1998-03-31'
JOIN dbo.[Order Details] OD on O.OrderID = OD.OrderID
JOIN dbo.Products P on OD.ProductID = P.ProductID
JOIN dbo.Categories C on P.CategoryID = C.CategoryID AND C.CategoryName LIKE 'Meat/Poultry'
GROUP BY Shippers.CompanyName

select distinct S.CompanyName from Orders
         join dbo.Shippers S on S.ShipperID = Orders.ShipVia
         join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
         join dbo.Products P on P.ProductID = OD.ProductID
         join dbo.Categories C on C.CategoryID = P.CategoryID and C.CategoryName = 'Meat/Poultry'
where year(Orders.ShippedDate) = 1998 and month(Orders.ShippedDate) = 3

-- ex 2.2 Podaj nazwy przewoźników, którzy w marcu 1997r nie przewozili produktów z kategorii 'Meat/Poultry'
select S.CompanyName
from Shippers as S
where S.ShipperID not in (select distinct S.ShipperID
                          from Orders
                                   join dbo.Shippers S on S.ShipperID = Orders.ShipVia
                                   join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
                                   join dbo.Products P on P.ProductID = OD.ProductID
                                   join dbo.Categories C
                                        on C.CategoryID = P.CategoryID and C.CategoryName = 'Meat/Poultry'
                          where year(Orders.ShippedDate) = 1997
                            and month(Orders.ShippedDate) = 3)


-- ex 2.3 Dla każdego przewoźnika podaj wartość produktów z kategorii 'Meat/Poultry' które ten przewoźnik przewiózł w marcu 1997
select S.CompanyName, SUM(OD.Quantity * OD.UnitPrice) total from Orders
         join dbo.Shippers S on S.ShipperID = Orders.ShipVia
         join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
         join dbo.Products P on P.ProductID = OD.ProductID
         join dbo.Categories C on C.CategoryID = P.CategoryID and C.CategoryName = 'Meat/Poultry'
where year(Orders.ShippedDate) = 1997 and month(Orders.ShippedDate) = 3
group by S.CompanyName

SELECT Shippers.CompanyName, SUM(OD.Quantity * OD.UnitPrice) "Łączna wartość" FROM Shippers
JOIN dbo.Orders O on Shippers.ShipperID = O.ShipVia AND O.ShippedDate BETWEEN '1997-03-01' AND '1997-03-31'
JOIN dbo.[Order Details] OD on O.OrderID = OD.OrderID
JOIN dbo.Products P on OD.ProductID = P.ProductID
JOIN dbo.Categories C on P.CategoryID = C.CategoryID AND C.CategoryName LIKE 'Meat/Poultry'
GROUP BY Shippers.CompanyName

---

-- ex 3.1 Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów z tej kategorii.
select C.CategoryName, sum(isnull(OD.Quantity, 0))
from Categories as C
         left join dbo.Products P on C.CategoryID = P.CategoryID
         left join dbo.[Order Details] OD on P.ProductID = OD.ProductID
group by C.CategoryName

-- ex 3.2 Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych w 1997r jednostek towarów z tej kategorii.
select C.CategoryName, sum(isnull(OD.Quantity, 0))
from Categories as C
         left join dbo.Products P on C.CategoryID = P.CategoryID
         left join dbo.[Order Details] OD on P.ProductID = OD.ProductID
         left join dbo.Orders O on O.OrderID = OD.OrderID
where year(O.OrderDate) = 1997
group by C.CategoryName

select C.CategoryName, SUM(IIF(O.OrderID IS NULL, 0, OD.Quantity))
from Categories as C
         left join dbo.Products P on C.CategoryID = P.CategoryID
         left join dbo.[Order Details] OD on P.ProductID = OD.ProductID
         left join dbo.Orders O on O.OrderID = OD.OrderID AND year(O.OrderDate) = 1997
group by C.CategoryName

-- ex 3.3 Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych towarów z tej kategorii.
select C.CategoryName, round(sum(OD.UnitPrice * OD.Quantity * (1-OD.Discount)), 2)
from Categories as C
         left join dbo.Products P on C.CategoryID = P.CategoryID
         left join dbo.[Order Details] OD on P.ProductID = OD.ProductID
group by C.CategoryName

---

-- ex 4.1 Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r

-- ex 4.2 Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika
-- ex 4.3 Dla każdego przewoźnika podaj łączną wartość "opłat za przesyłkę" przewożonych przez niego zamówień od '1998-05-03' do '1998-05-29'
-- ex 4.4 Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika w maju 1996
-- ex 4.5 Który z pracowników obsłużył największą liczbę zamówień w 1996r, podaj imię i nazwisko takiego pracownika
-- ex 4.6 Który z pracowników był najaktywniejszy (obsłużył zamówienia o największej wartości) w 1996r, podaj imię i nazwisko takiego pracownika

---

-- ex 5.1  Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika
-- Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych
-- b) którzy nie mają podwładnych

-- ex 5.2 Napisz polecenie, które wyświetla klientów z Francji którzy w 1998r złożyli więcej niż dwa zamówienia oraz klientów z Niemiec którzy w 1997r złożyli więcej niż trzy zamówienia