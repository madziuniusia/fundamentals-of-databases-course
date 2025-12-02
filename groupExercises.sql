-- ex 1.1 Dla każdego zamówienia podaj jego wartość. Posortuj wynik wg wartości zamówień (w malejęcej kolejności)
select OrderID, round(sum(UnitPrice * Quantity * (1-Discount)), 2) as TotalValue from [Order Details] group by OrderID order by TotalValue desc;

-- ex 1.2 Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało tylko pierwszych 10 wierszy
select top 10 OrderID, round(sum(UnitPrice * Quantity * (1-Discount)), 2) as TotalValue from [Order Details] group by OrderID order by TotalValue desc;

-- ex 1.3 Podaj  nr zamówienia oraz wartość  zamówienia, dla zamówień, dla których łączna liczba zamawianych jednostek produktów jest większa niż 250
select OrderID, round(sum(UnitPrice * Quantity * (1-Discount)), 2) as TotalValue from [Order Details] group by OrderID having sum(Quantity) > 250;

-- ex 1.4 Podaj liczbę zamówionych jednostek produktów dla produktów, dla których productid jest mniejszy niż 3
select sum(Quantity) as order_sum from [Order Details] where ProductID < 3 group by OrderID;

---
-- ex 2.1 Ilu jest dorosłych czytelników
select count(adult.member_no) from adult;

-- ex 2.2 Ile jest dzieci zapisanych do biblioteki
select count(*) from juvenile

-- ex 2.3 Ilu z dorosłych czytelników mieszka w Kaliforni (CA)
select count(*) from adult where state like 'CA'

-- ex 2.4 Dla każdego dorosłego czytelnika podaj liczbę jego dzieci.
select adult_member_no, count(*) as 'Children' from juvenile group by adult_member_no;

-- ex 2.5 Dla każdego dorosłego czytelnika podaj liczbę jego dzieci urodzonych przed 1998r
select adult_member_no, count(*) as 'Children' from juvenile where year(birth_date) = 1998 group by adult_member_no;

---
-- ex 3.1 Dla każdego czytelnika podaj liczbę zarezerwowanych przez niego książek
select member_no, count(member_no) from reservation group by member_no;

-- ex 3.2 Dla każdego czytelnika podaj liczbę wypożyczonych przez niego książek
select member_no, count(*) from loanhist group by member_no;

-- ex 3.3 Dla każdego czytelnika podaj liczbę książek zwróconych przez niego w 2001r.
select member_no, count(*) from loanhist where year(out_date) = 2001 group by member_no;

-- ex 3.4 Dla każdego czytelnika podaj sumę kar jakie zapłacił w 2001r
select member_no, sum(fine_paid) from loanhist where year(out_date) = 2001 group by member_no;

-- ex 3.5 Ile książek wypożyczono w maju 2001
select count(*) from loanhist where year(out_date) = 2001 and month(out_date) = 5;

-- ex 3.6 Na jak długo średnio były wypożyczane książki w maju 2001
select  AVG(CAST(DATEDIFF(dd, out_date, in_date) AS float)) from loanhist where year(out_date) = 2001 and month(out_date) = 5;

---

-- ex 4.1 Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień w 1997r
select EmployeeID, count(EmployeeID) from Orders where year(OrderDate) = 1997 group by EmployeeID

-- ex 4.2 Dla każdego pracownika podaj ilu klientów (różnych klientów) obsługiwał ten pracownik w 1997r
-- select distinct EmployeeID, CustomerID from Orders where year(OrderDate) = 1997 order by EmployeeID, CustomerID
select EmployeeID, count(distinct CustomerID) from Orders where year(OrderDate) = 1997 group by EmployeeID

-- ex 4.3 Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" dla przewożonych przez niego zamówień
select ShipVia, sum(Freight) AS TotalFreight from Orders group by ShipVia order by ShipVia

-- ex 4.4 Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" przewożonych przez niego zamówień w latach od 1996 do 1997
select ShipVia, sum(Freight) AS TotalFreight from Orders where year(ShippedDate) between 1996 and 1997 group by ShipVia order by ShipVia

-- ex 5.1 Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z podziałem na lata
select EmployeeID, year(OrderDate) as year, count(EmployeeID) as totalOrders from Orders group by EmployeeID, year(OrderDate) order by EmployeeID, year(OrderDate)

-- ex 5.2 Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z podziałem na lata i miesiące.
select EmployeeID, year(OrderDate) as year, month(OrderDate) as month, count(EmployeeID) as totalOrders from Orders group by EmployeeID, year(OrderDate), month(OrderDate) order by EmployeeID, year(OrderDate), month(OrderDate)