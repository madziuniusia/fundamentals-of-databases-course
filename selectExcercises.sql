-- ex 1.1 - Napisz polecenie select  za pomocą którego uzyskasz identyfikator/numer tytułu oraz tytuł książki
select title_no, title from title;
-- ex 1.2 - Napisz polecenie, które wybiera tytuł o numerze/identyfikatorze 10
select title from title where title_no = 10;
-- ex 1.3 - Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu)  i autora dla wszystkich książek, których autorem jest Charles Dickens lub Jane Austen
select title_no, author from title where author in ('Charles Dickens', 'Jane Austen');

---

-- ex 2.1 - Napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich  książek, których tytuły zawierających słowo 'adventure'
select title_no, title from title where title Like '%adventure%';
-- ex 2.2 - Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę dla wszystkich książek, ktore zostały zwrócone w listopadzie 2001
select * from loanhist;
select member_no, fine_assessed from loanhist where YEAR(in_date) = 2001 and MONTH(in_date) = 11 and fine_assessed is not null;
-- ex 2.3 - Napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy adult.
select distinct city, state from adult;
-- ex 2.4 - Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w porządku alfabetycznym.
select title from title order by title asc;

-- ex 3.1 - wybiera numer członka biblioteki (member_no), isbn książki (isbn) i wartość naliczonej kary (fine_assessed) z tablicy loanhist
-- dla wszystkich wypożyczeń/zwrotów, dla których naliczono karę (wartość nie NULL w kolumnie fine_assessed)
-- stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny fine_assessed, stwórz alias double_fine
-- stwórz kolumnę o nazwie diff, zawierającą różnicę wartości w kolumnach double_fine i fine_assessed
-- wybierz wiersze dla których wartość w kolumnie diff jest większa niż 3
select member_no, isbn, fine_assessed, fine_assessed * 2 as double_fine, abs(fine_assessed * 2 - fine_assessed) as diff from loanhist
where fine_assessed is not null and (fine_assessed * 2 - fine_assessed) > 3;

-- ex 4.1 - Napisz polecenie, które
-- generuje pojedynczą kolumnę, która zawiera kolumny: firstname (imię członka biblioteki), middleinitial (inicjał drugiego imienia) i lastname (nazwisko) z tablicy member dla wszystkich członków biblioteki, którzy nazywają się Anderson
-- nazwij tak powstałą kolumnę email_name (użyj aliasu email_name dla kolumny)
-- zmodyfikuj polecenie, tak by zwróciło 'listę proponowanych loginów e-mail'  utworzonych przez połączenie imienia członka biblioteki, z inicjałem drugiego imienia i pierwszymi dwoma literami nazwiska (wszystko małymi małymi literami).
-- wykorzystaj funkcję SUBSTRING do uzyskania części kolumny znakowej oraz LOWER do zwrócenia wyniku małymi literami.
-- wykorzystaj operator (+) do połączenia napisów.
select lower(firstname + middleinitial + substring(lastname, 1, 2)) as email_name from member where lastname = 'Anderson';
select member_no, firstname, lastname, lower(firstname + middleinitial + substring(replace(lastname, ' ', '-'), 1, 2)) + cast(member_no as varchar(16)) as email_name from member where lastname = 'Anderson';

-- ex 5.1 - Napisz polecenie, które wybiera title i title_no z tablicy title.
-- wynikiem powinna być pojedyncza kolumna o formacie jak w przykładzie poniżej:
-- The title is: Poems, title number 7
-- czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o wyrażenie, które łączy 4 elementy:
-- stała znakowa ‘The title is:’
-- wartość kolumny  title
-- stała znakowa ‘title number’
-- wartość kolumny title_no
select 'The title is: ' + title + ' title number ' + cast(title_no as varchar(16)) as 'title' from title;
