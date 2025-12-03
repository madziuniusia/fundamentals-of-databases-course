-- ex 0.1 Napisz polecenie zwracające jako wynik nazwy klientów, którzy złożyli zamówienia po 01 marca 1998 (baza northwind)
select distinct C.CompanyName from Orders
inner join dbo.Customers C on C.CustomerID = Orders.CustomerID
where orderdate > '1998-03-01'

-- ex 0.2 Napisz polecenie zwracające wszystkich klientów z datami zamówień (baza northwind).
select C.companyname, C.customerid, Orders.OrderDate from Orders
left outer join dbo.Customers C on Orders.CustomerID = C.CustomerID

-- ex 0.3 Napisz polecenie zwracające klientów, którzy nigdy nie złożyli zamówienia (baza northwind).
select companyname, customers.customerid, orderdate
from customers
     left outer join orders
                    on customers.customerid = orders.customerid
where OrderID is null

-- ex 0.4 Napisz polecenie zwracające listę produktów zamawianych w dniu 1996-07-08
select distinct productname
from orders as O
     inner join [order details] as OD
                on O.orderid = OD.orderid
     inner join products as P
                on OD.productid = P.productid
where orderdate = '1996-07-08'

---

-- ex 1.1 Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
select Products.ProductName, Products.UnitPrice, S.CompanyName, S.Address, S.City, S.Country from Products
inner join dbo.Suppliers S on S.SupplierID = Products.SupplierID
where UnitPrice between 20 and 30

-- ex 1.2 Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
select Products.ProductName, Products.UnitsInStock from Products
inner join dbo.Suppliers S on S.SupplierID = Products.SupplierID
where S.CompanyName = 'Tokyo Traders'

-- ex 1.3 Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe
select distinct Customers.CompanyName, Customers.Address, Customers.City, Customers.Country
from Customers
         left join dbo.Orders O on Customers.CustomerID = O.CustomerID and year(o.OrderDate) = 1997
where O.OrderID is null

SELECT c.CustomerID, c.CompanyName, c.Address
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT DISTINCT o.CustomerID
                           FROM Orders o
                           WHERE YEAR(o.OrderDate) = 1997);

select Customers.CustomerID, CompanyName, Address, City, Region, PostalCode, Country
from Orders
         right join Customers
                    on Orders.CustomerID = Customers.CustomerID and year(OrderDate) = 1997
where OrderID is null

-- ex 1.4 Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie  ma w magazynie.
select distinct CompanyName, Phone
from Suppliers
         left join dbo.Products P on Suppliers.SupplierID = P.SupplierID
where P.UnitsInStock = 0

SELECT DISTINCT s.CompanyName, s.Phone
FROM Suppliers s
         JOIN Products p ON s.SupplierID = p.SupplierID
WHERE p.UnitsInStock = 0;

SELECT s.CompanyName, s.Phone
FROM Products AS p
         INNER JOIN Suppliers AS s
                    ON p.SupplierID = s.SupplierID
WHERE UnitsInStock = 0

-- ex 1.5 Wybierz zamówienia złożone w marcu 1997. Dla każdego takiego zamówienia wyświetl jego numer, datę złożenia zamówienia oraz nazwę i numer telefonu klienta
SELECT o.OrderID, o.OrderDate, c.CompanyName AS CustomerName, c.Phone
FROM Orders o
         JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 1997
  AND MONTH(o.OrderDate) = 3;

---

-- ex 2.1 Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
select m.firstname, m.lastname, juvenile.birth_date
from juvenile
         inner join dbo.member m on m.member_no = juvenile.member_no

-- ex 2.2 Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
select distinct title.title
from loan
         inner join title on loan.title_no = title.title_no

-- ex 2.3 Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao Teh King’.  Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką zapłacono karę
select l.due_date, l.in_date, DATEDIFF(DAY, l.due_date, l.in_date) AS Delay, l.fine_assessed, l.fine_paid
from loanhist as l
         inner join title as t on l.title_no = t.title_no and t.title = 'Tao Teh King'
where datediff(DAY, l.due_date, l.in_date) > 0

SELECT l.due_date, l.in_date, DATEDIFF(DAY, l.due_date, l.in_date) AS Delay,l.fine_assessed, l.fine_paid
FROM loanhist AS l
         INNER JOIN title AS t
                    ON l.title_no = t.title_no
WHERE t.title = 'Tao Teh King'
  AND DATEDIFF(DAY, l.due_date, l.in_date) > 0

-- ex 2.4 Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych przez osobę o nazwisku: Stephen A. Graff
select reservation.isbn
from reservation
         inner join dbo.member m
                    on reservation.member_no = m.member_no and m.firstname = 'Stephen' and m.lastname = 'Graff' and
                       m.middleinitial = 'A'

SELECT r.isbn
FROM reservation AS r
         INNER JOIN member AS m
                    ON r.member_no = m.member_no
WHERE m.firstname = 'Stephen'
  AND m.lastname = 'Graff'

---

-- ex 3.1 Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, interesują nas tylko produkty z kategorii ‘Meat/Poultry’
select p.ProductName, p.UnitPrice, s.Address + ', ' + s.PostalCode + ' ' + s.City + ', ' + s.Country as Address
from Products as P
         inner join dbo.Categories C on C.CategoryID = P.CategoryID and C.CategoryName = 'Meat/Poultry'
         inner join dbo.Suppliers S on S.SupplierID = P.SupplierID
where P.UnitPrice between 20 and 30

SELECT p.ProductName, p.UnitPrice, s.Address + ', ' + s.PostalCode + ' ' + s.City + ', ' + s.Country as Address
FROM Products AS p
         INNER JOIN Suppliers AS s
                    ON p.SupplierID = s.SupplierID
         INNER JOIN Categories AS c
                    ON p.CategoryID = c.CategoryID
WHERE p.UnitPrice BETWEEN 20 AND 30
  AND c.CategoryName = 'Meat/Poultry'

-- ex 3.2 Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu podaj nazwę dostawcy.
select ProductName, UnitPrice, S.CompanyName
from Products
         inner join Categories on Products.CategoryID = Categories.CategoryID
         inner join dbo.Suppliers S on Products.SupplierID = S.SupplierID
where CategoryName = 'Confections'

-- ex 3.3 Dla każdego klienta podaj liczbę złożonych przez niego zamówień. Zbiór wynikowy powinien zawierać nazwę klienta, oraz liczbę zamówień
select C.CompanyName, count(O.OrderID) as totalOrders
from Orders as O
         inner join dbo.Customers C on C.CustomerID = O.CustomerID
group by C.CompanyName

-- ex 3.4 Dla każdego klienta podaj liczbę złożonych przez niego zamówień w marcu 1997r
select C.CompanyName, count(O.OrderID) as totalOrders
from Orders as O
         inner join dbo.Customers C on C.CustomerID = O.CustomerID
where year(O.OrderDate) = 1997
  and month(O.OrderDate) = 3
group by C.CompanyName

---

-- ex 4.1 Który ze spedytorów był najaktywniejszy w 1997 roku, podaj nazwę tego spedytora
select top 1 S.CompanyName, count(OrderDate) as 'Total Orders in 1997'
from Orders
inner join dbo.Shippers S on S.ShipperID = Orders.ShipVia
where year(OrderDate) = 1997
group by S.CompanyName
order by count(OrderDate) desc

-- ex 4.2 Dla każdego zamówienia podaj wartość zamówionych produktów. Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta oraz wartość zamówionych produktów
select Orders.OrderID, Orders.OrderDate, C.CompanyName, round(sum(OD.UnitPrice * OD.Quantity * (1-OD.Discount)), 2) as total  from Orders
inner join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
inner join dbo.Customers C on C.CustomerID = Orders.CustomerID
group by Orders.OrderID, Orders.OrderDate, C.CompanyName

-- ex 4.3 Dla każdego zamówienia podaj jego pełną wartość (wliczając opłatę za przesyłkę). Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta oraz pełną wartość zamówienia
select Orders.OrderID, Orders.OrderDate, C.CompanyName, round(sum(OD.UnitPrice * OD.Quantity * (1-OD.Discount) + Orders.Freight), 2) as total  from Orders
inner join dbo.[Order Details] OD on Orders.OrderID = OD.OrderID
inner join dbo.Customers C on C.CustomerID = Orders.CustomerID
group by Orders.OrderID, Orders.OrderDate, C.CompanyName

-- ex 4.4 Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections’
select C.CompanyName, C.Phone
from Customers as C
where C.CustomerID in (select O.CustomerID
                           from Customers as C
                                    join dbo.Orders O on C.CustomerID = O.CustomerID
                                     join dbo.[Order Details] OD on O.OrderID = OD.OrderID
                                     join dbo.Products P on P.ProductID = OD.ProductID
                                     join dbo.Categories C2 on C2.CategoryID = P.CategoryID
                           where C2.CategoryName like 'Confections')

-- ex 4.5 Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii ‘Confections’
select cu.CompanyName, cu.Phone
from Customers as cu
where cu.CustomerID not in (select c.CustomerID
                            from Customers as c
                                     join orders as o on o.CustomerID = c.CustomerID
                                     join [Order Details] as od on o.OrderID = od.OrderID
                                     join Products as p on p.ProductID = od.ProductID
                                     join Categories as cat on cat.CategoryID = p.CategoryID
                            where cat.CategoryName like 'Confections')
order by cu.CompanyName

-- ex 4.6 Wybierz nazwy i numery telefonów klientów, którzy w 1997r nie kupowali produktów z kategorii ‘Confections’
select cu.CompanyName, cu.Phone
from Customers as cu
where cu.CustomerID not in (select c.CustomerID
                            from Customers as c
                                     join orders as o on o.CustomerID = c.CustomerID and year(O.OrderDate) = 1997
                                     join [Order Details] as od on o.OrderID = od.OrderID
                                     join Products as p on p.ProductID = od.ProductID
                                     join Categories as cat on cat.CategoryID = p.CategoryID
                            where cat.CategoryName like 'Confections')
order by cu.CompanyName

---

-- ex 5.1 Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres zamieszkania dziecka.
select m.firstname, m.lastname, j.birth_date, a.street, a.city
from juvenile as j
         inner join dbo.member m on j.member_no = m.member_no
         inner join dbo.adult a on a.member_no = j.adult_member_no

-- ex 5.2 Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania dziecka oraz imię i nazwisko rodzica.
select m.firstname, m.lastname, j.birth_date, a.street, a.city, m2.firstname, m2.lastname
from juvenile as j
         inner join dbo.member m on j.member_no = m.member_no
         inner join dbo.adult a on a.member_no = j.adult_member_no
         inner join dbo.member m2 on m2.member_no = j.adult_member_no

---

-- ex 6.1 Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza northwind)
select e.FirstName + ' ' + e.LastName as employee_name, sub.FirstName + ' ' + sub.LastName as subordinate_name
from Employees as e
         join Employees as sub
              on sub.ReportsTo = e.EmployeeID

-- ex 6.2 Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych (baza northwind)
select e.FirstName + ' ' + e.LastName as employee_name
from Employees as e
         left join Employees as sub
                         on e.EmployeeID = sub.ReportsTo
where sub.ReportsTo is null

-- ex 6.3 Napisz polecenie, które wyświetla pracowników, którzy mają podwładnych (baza northwind)
select distinct e.FirstName + ' ' + e.LastName as employee_name
from Employees as e
         join Employees as sub
              on sub.ReportsTo = e.EmployeeID

---

-- ex 7.1 Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają  więcej niż dwoje dzieci zapisanych do biblioteki
select m.firstname,
       m.lastname,
       m.member_no,
       a.state,
       count(*) as Liczba_dzieci
from member as m
         join adult as a
              on a.member_no = m.member_no
         join juvenile as j
              on m.member_no = j.adult_member_no
where a.state = 'AZ'
group by m.firstname, m.lastname, m.member_no, a.state
having count(*) > 2

-- ex 7.2 Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają  więcej niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni (CA) i mają więcej niż troje dzieci zapisanych do biblioteki
select m.firstname, m.lastname, a.state, count(*) from member as m
inner join dbo.adult a on m.member_no = a.member_no
inner join dbo.juvenile j on m.member_no = j.adult_member_no
where a.state = 'AZ'
group by m.firstname, m.lastname, a.state having count(*) > 2
union
select m.firstname, m.lastname, a.state, count(*) from member as m
inner join dbo.adult a on m.member_no = a.member_no
inner join dbo.juvenile j on m.member_no = j.adult_member_no
where a.state = 'CA'
group by m.firstname, m.lastname, a.state having count(*) > 3