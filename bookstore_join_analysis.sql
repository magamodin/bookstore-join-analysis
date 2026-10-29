-- =====================================================================
-- Layihə : Kitab mağazası bazası: SQL praktikası və JOIN təhlili
-- Müəllif: Məmmədov Məhəmməd
-- Platforma: Microsoft SQL Server (T-SQL)
-- Mövzular: DDL/DML, NULL emalı, CASE, tarix funksiyaları, GROUP BY / HAVING,
--           INNER / LEFT / RIGHT / FULL / CROSS JOIN, anti-join
-- Qeyd   : Books cədvəli ilə başlayır, sonra Publishers, Stores, Sales əlavə olunur.
-- =====================================================================

--1--
-- Sual: Books cədvəlini yarat.
CREATE TABLE Books (
    BookId      INT PRIMARY KEY IDENTITY(1, 1),
    Title       NVARCHAR(150) NOT NULL,
    Author      NVARCHAR(100) NOT NULL,
    Genre       NVARCHAR(50),
    Price       DECIMAL(8, 2),
    Pages       INT,
    PublishYear INT,
    Stock       INT,
    Barcode     NVARCHAR(30)
)

--2--
-- Sual: Books cədvəlinə Publisher sütunu əlavə et.
ALTER TABLE Books ADD Publisher NVARCHAR(100)

--3--
-- Sual: Title sütununu nvarchar(200) et.
ALTER TABLE Books ALTER COLUMN Title NVARCHAR(200)

--4--
-- Sual: Barcode sütununu sil.
ALTER TABLE Books DROP COLUMN Barcode

--5--
-- Sual: Books cədvəlinə 10 kitab əlavə et.
INSERT INTO Books (Title, Author, Genre, Price, Pages, PublishYear, Stock, Publisher)
VALUES
    (N'Əli və Nino', N'Qurban Səid', N'Roman', 12.50, 320, 1937, 15, N'Şərq-Qərb'),
    (N'Dədə Qorqud', N'Xalq dastanı', N'Dastan', 9.90, 180, 1988, 0, NULL),
    (N'Kiçik Şahzadə', N'Antuan de Sent-Ekzüperi', N'Nağıl', 8.00, 96, 1943, 40, N'Qanun'),
    (N'Səfillər', N'Viktor Hüqo', N'Roman', 18.00, 1200, 1862, 5, N'Qanun'),
    (N'Min bir gecə', N'Xalq nağılları', N'Nağıl', 14.00, NULL, NULL, 7, NULL),
    (N'Python əsasları', N'Əli Məmmədov', N'Texnologiya', 25.00, 410, 2021, 22, N'TechPress'),
    (N'SQL dərsliyi', N'Leyla Əliyeva', N'Texnologiya', 22.50, 350, 2023, 18, N'TechPress'),
    (N'Məlumat təhlili', N'Rauf Quliyev', N'Texnologiya', 30.00, 500, 2024, 0, NULL),
    (N'Şərq nağılları', N'Xalq nağılları', N'Nağıl', NULL, 0, 1995, 12, N'Çıraq'),
    (N'Test kitab', N'Test müəllif', NULL, 1.00, 1, 2000, 1, NULL)

--6--
-- Sual: Bütün kitabları göstər.
SELECT *
FROM Books

--7--
-- Sual: Kitab və müəllif adlarını 'Kitab' və 'Müəllif' adları ilə göstər.
SELECT
    Title Kitab,
    Author Müəllif
FROM Books

--8--
-- Sual: Fərqli janrları göstər.
SELECT DISTINCT Genre
FROM Books

--9--
-- Sual: Fərqli müəllifləri göstər.
SELECT DISTINCT Author
FROM Books

--10--
-- Sual: Hər kitabın stok dəyərini (qiymət x stok) göstər.
SELECT
    Title BookName,
    Price * Stock StockValue
FROM Books

--11--
-- Sual: Qiyməti 20-dən böyük kitabları göstər.
SELECT
    Title,
    Price
FROM Books
WHERE Price > 20

--12--
-- Sual: 1950-dən əvvəl nəşr olunmuş kitabları göstər.
SELECT
    Title,
    PublishYear
FROM Books
WHERE PublishYear < 1950

--13--
-- Sual: BookId=10 olan kitabı sil.
DELETE FROM Books
WHERE BookId = 10

--14--
-- Sual: 'SQL dərsliyi' kitabının qiymətini 24 et.
UPDATE Books
SET Price = 24
WHERE Title = N'SQL dərsliyi'

--15--
-- Sual: 'Məlumat təhlili' kitabının stokunu 25 et.
UPDATE Books
SET Stock = 25
WHERE Title = N'Məlumat təhlili'

--16--
-- Sual: Adı S hərfi ilə başlayan kitabları tap.
SELECT *
FROM Books
WHERE Title LIKE N'S%'

--17--
-- Sual: Müəllifinin adında 'Əli' olan kitabları tap.
SELECT *
FROM Books
WHERE Author LIKE N'%Əli%'

--18--
-- Sual: Adının ikinci hərfi 'ə' olan kitabları tap.
SELECT *
FROM Books
WHERE Title LIKE N'_ə%'

--19--
-- Sual: Naşiri olmayan kitabları tap.
SELECT Title
FROM Books
WHERE Publisher IS NULL

--20--
-- Sual: Qiyməti olmayan kitabları tap.
SELECT Title
FROM Books
WHERE Price IS NULL

--21--
-- Sual: Naşiri olmayan kitablar üçün 'Naməlum' göstər.
SELECT
    Title,
    ISNULL(Publisher, N'Naməlum') Publisher
FROM Books

--22--
-- Sual: Qiyməti NULL olan kitablar üçün 0 göstər.
SELECT
    Title,
    ISNULL(Price, 0) Price
FROM Books

--23--
-- Sual: Stoku 0 olan kitablar üçün NULL göstər (NULLIF).
SELECT
    Title,
    NULLIF(Stock, 0) Stock
FROM Books

--24--
-- Sual: Hər kitabın bir səhifəsinin qiymətini hesabla (səhifə 0 və ya NULL olanda xəta verməsin).
SELECT ROUND(CAST(ISNULL(Price / NULLIF(Pages, 0), 0) AS DECIMAL(10, 3)), 3) PagePrice
FROM Books

SELECT *
FROM Books

--25--
-- Sual: 15% endirimdən sonra qiyməti 10-dan az olan kitabları tap.
SELECT Title
FROM Books
WHERE Price * 0.85 < 10

--26--
-- Sual: Ümumi dəyəri (qiymət x stok) 300-dən çox olan kitabları tap.
SELECT
    Title,
    Price * Stock ÜmumiDeyer
FROM Books
WHERE Price * Stock > 300

--27--
-- Sual: Qiyməti (NULL=0 qəbul etməklə) 20-dən az olan kitabları göstər.
SELECT
    Title,
    ISNULL(Price, 0) Price
FROM Books
WHERE ISNULL(Price, 0) < 20

--28--
-- Sual: Səhifə sayı məlum və 0-dan fərqli olan kitabların sayını tap.
SELECT COUNT(Pages) Sayı
FROM Books
WHERE Pages != 0

--29--
-- Sual: Bütün qiymətləri 10% artır, qiyməti olmayanlara 10 yaz.
UPDATE Books
SET Price = ISNULL(Price * 1.1, 10)

--30--
-- Sual: Language sütunu əlavə et (default AZ), Texnologiya kitablarını EN et.
ALTER TABLE Books ADD Language NVARCHAR(20) NOT NULL DEFAULT (N'AZ')

UPDATE Books
SET Language = N'EN'
WHERE Genre = N'Texnologiya'

SELECT *
FROM Books

--31--
-- Sual: Kitabları müəllifə görə, sonra qiymətə görə azalan sırala.
-- update Books set Pages= isnull(Pages,0)  -- sonrakı tapşırıqlar (47, 48, 52, 55) NULL səhifələrə ehtiyac duyduğu üçün söndürülüb

SELECT
    Author,
    Price
FROM Books
ORDER BY Author, Price DESC

--32--
-- Sual: Kitabları qiymətə görə azalan sırala.
SELECT
    Title,
    Price
FROM Books
ORDER BY Price DESC

--33--
-- Sual: Kitabları janra, sonra qiymətə görə artan sırala.
SELECT
    Title,
    Genre,
    Price
FROM Books
ORDER BY Genre, Price ASC

--34--
-- Sual: Kitabları səhifə sayına görə artan sırala.
SELECT
    Title,
    Pages
FROM Books
ORDER BY Pages ASC

--35--
-- Sual: Dili kiçik hərflərlə göstər.
SELECT
    Title,
    LOWER(Language)
FROM Books

--36--
-- Sual: TechPress naşirinin kitablarını böyük hərflərlə göstər.
SELECT
    UPPER(Title) t,
    UPPER(Publisher) p
FROM Books
WHERE Publisher = N'TechPress'

--37--
-- Sual: Naşir adındakı '-' işarəsini boşluqla əvəz et.
SELECT
    Title,
    REPLACE(Publisher, '-', ' ')
FROM Books

--38--
-- Sual: Hər kitab adının ilk 3 hərfini göstər.
SELECT
    Title,
    LEFT(Title, 3)
FROM Books

--39--
-- Sual: Səhifə sayının 300-dən fərqinin mütləq qiymətini göstər.
SELECT ABS(Pages - 300)
FROM Books

--40--
-- Sual: Books cədvəlinə ArrivalDate sütunu əlavə et.
ALTER TABLE Books ADD ArrivalDate DATE

--41--
-- Sual: ArrivalDate sütununu doldur (sonrakı tarix tapşırıqları üçün məlumat lazımdır).
-- Qeyd: bu tapşırıqda kod yox idi, sonrakı tarix sorğuları (42-44, 49) boş nəticə verirdi. Aşağıdakı tarixlər nümunə kimi əlavə olundu.
UPDATE Books
SET ArrivalDate =
    CASE BookId
        WHEN 1 THEN '2025-11-15'
        WHEN 2 THEN '2025-12-20'
        WHEN 3 THEN '2026-02-10'
        WHEN 4 THEN '2025-10-05'
        WHEN 5 THEN '2026-01-25'
        WHEN 6 THEN '2026-04-12'
        WHEN 7 THEN '2026-05-02'
        WHEN 8 THEN '2026-05-20'
        WHEN 9 THEN '2026-03-01'
    END

--42--
-- Sual: Hər kitab üçün 2026-06-01 tarixinə qədər neçə gün keçdiyini tap.
SELECT DATEDIFF(DAY, ArrivalDate, '2026-06-01') DayCount
FROM Books

--43--
-- Sual: Hər kitab üçün ArrivalDate + 90 gün = ExpireDate hesabla.
SELECT
    Title,
    ArrivalDate,
    DATEADD(DAY, 90, ArrivalDate) ExpireDate
FROM Books

--44--
-- Sual: 2026-06-01-ə qədər 120 gündən çox keçmiş kitabları azalan sırada göstər.
SELECT
    Title,
    DATEDIFF(DAY, ArrivalDate, '2026-06-01') Date
FROM Books
WHERE DATEDIFF(DAY, ArrivalDate, '2026-06-01') > 120
ORDER BY DATEDIFF(DAY, ArrivalDate, '2026-06-01') DESC

--45--
-- Sual: Qiymətə görə qrupla: Ucuz (<15), Orta (<25), Baha.
SELECT
    Title,
    CASE
        WHEN Price < 15 THEN N'Ucuz'
        WHEN Price < 25 THEN N'Orta'
        ELSE N'Baha'
    END AS PriceGroup
FROM Books

--46--
-- Sual: Stoka görə qrupla: Bitib (0), Azdır (<10), Kifayətdir.
SELECT
    Title,
    CASE
        WHEN Stock = 0 THEN N'Bitib'
        WHEN Stock < 10 THEN N'Azdır'
        ELSE N'Kifayətdir'
    END AS StockStatus
FROM Books

--47--
-- Sual: Səhifəyə görə qrupla: Məlum deyil, Nazik (<200), Orta (200-500), Qalın.
SELECT
    Title,
    CASE
        WHEN Pages IS NULL THEN N'Məlum deyil'
        WHEN Pages < 200 THEN N'Nazik'
        WHEN Pages BETWEEN 200 AND 500 THEN N'Orta'
        ELSE N'Qalın'
    END AS Size
FROM Books

SELECT
    Title,
    Pages
FROM Books

--48--
-- Sual: Səhifə sayı NULL olan kitabları siyahının sonuna sal.
SELECT
    Pages,
    CASE
        WHEN Pages IS NULL THEN 1
        ELSE 0
    END
FROM Books
ORDER BY CASE WHEN Pages IS NULL THEN 1 ELSE 0 END, Pages

--48.1--
-- Sual: Eyni sual: NULL səhifələri sona salmağın başqa yazılışı (CASE ilə ORDER BY).
SELECT
    Title,
    Pages
FROM Books
ORDER BY CASE WHEN Pages IS NULL THEN 1 ELSE 0 END, Pages ASC

--48.2--
-- Sual: Eyni sual: NULL əvəzinə ən böyük dəyər + 1 qoymaqla sıralama.
SELECT
    Title,
    Pages
FROM Books
ORDER BY ISNULL(Pages, (SELECT MAX(Pages) + 1 FROM Books)), Pages ASC

--49--
-- Sual: 2026-06-01-ə qədər 150 gündən çox keçmişləri 'Köhnə', qalanını 'Yeni' göstər.
SELECT
    Title,
    DATEDIFF(DAY, ArrivalDate, '2026-06-01') DayCount,
    CASE
        WHEN DATEDIFF(DAY, ArrivalDate, '2026-06-01') > 150 THEN N'Köhnə'
        ELSE N'Yeni'
    END AS Status
FROM Books
ORDER BY DATEDIFF(DAY, ArrivalDate, '2026-06-01') DESC

--50--
-- Sual: Stoku 20-dən çox olan kitablara 10% endirim et, stoku 5 və az olanların qiymətinə 2 əlavə et.
UPDATE Books
SET Price =
    CASE
        WHEN Stock > 20 THEN Price * 0.9
        WHEN Stock <= 5 THEN Price + 2
        ELSE Price
    END

--51--
-- Sual: Cəmi kitab sayını tap.
SELECT CəmiKitabSayı = COUNT(Title)
FROM Books

--52--
-- Sual: Səhifə sayı məlum olan kitabların sayını tap.
SELECT COUNT(Pages) SəhifəSayiMəlum
FROM Books

--53--
-- Sual: Ən baha və ən ucuz kitabın qiymətini tap.
SELECT
    MAX(Price) AS EnBaha,
    MIN(Price) AS EnUcuz
FROM Books

--54--
-- Sual: Cəmi stoku tap.
SELECT SUM(Stock) KitabSayıStok
FROM Books

--55--
-- Sual: Orta səhifə sayını tap (NULL-ların nəticəyə təsirini 4 üsulla göstər).
SELECT
    AVG(Pages) OrtalamaSehifeSay,
    AVG(ISNULL(Pages, 0)) OrtalamaSehifeSay1,
    SUM(Pages) / COUNT(Pages),
    SUM(ISNULL(Pages, 0)) / COUNT(ISNULL(Pages, 0))
FROM Books

--56--
-- Sual: Fərqli naşirlərin sayını tap.
SELECT COUNT(DISTINCT Publisher) FerqliNasir
FROM Books

--57--
-- Sual: Texnologiya janrında kitab sayını və orta qiyməti tap.
SELECT
    KitabSayi = COUNT(Title),
    OrtaQiymet = AVG(Price)
FROM Books
WHERE Genre = N'Texnologiya'

--58--
-- Sual: Hər janrda neçə kitab olduğunu göstər.
SELECT
    Genre Janr,
    COUNT(Title) KitabSay
FROM Books
GROUP BY Genre

--59--
-- Sual: Hər janrda ən baha və ən ucuz kitabın qiymətini göstər.
SELECT
    Genre Janr,
    MAX(Price) EnBahaKitab,
    MIN(Price) EnUcuzKitab
FROM Books
GROUP BY Genre

--60--
-- Sual: Hər janr üzrə cəmi stoku göstər.
SELECT
    Genre Janr,
    SUM(Stock) StokSay
FROM Books
GROUP BY Genre

--61--
-- Sual: Hər naşirin kitab sayını göstər (NULL naşirlər bir qrup olur).
SELECT
    Publisher Naşir,
    COUNT(Title) KitabSay
FROM Books
GROUP BY Publisher

--NULL olanlari bir quruplasdirdi

--62--
-- Sual: Hər dil üzrə kitab sayını və stoku göstər.
SELECT
    Language Dil,
    COUNT(Title) KitabSay,
    SUM(Stock) StokSay
FROM Books
GROUP BY Language

--63--
-- Sual: Janr və naşir üzrə kitab sayını göstər.
SELECT
    Genre Janr,
    Publisher Naşir,
    COUNT(Title) KitabSay
FROM Books
GROUP BY Genre, Publisher

--64--
-- Sual: Qiyməti 12-dən çox olan kitabların janr üzrə sayını göstər.
SELECT
    Genre Janr,
    COUNT(Title) KitabSay
FROM Books
WHERE Price > 12
GROUP BY Genre

--65--
-- Sual: Naşir üzrə kitab sayını və səhifəsi məlum olanların sayını göstər.
SELECT
    Publisher Naşir,
    COUNT(Title) KitabSay,
    COUNT(Pages) SəhifəSayi
FROM Books
GROUP BY Publisher

--66--
-- Sual: Ən azı 3 kitabı olan janrları göstər.
SELECT
    Genre Janr,
    COUNT(Title) KitabSay
FROM Books
GROUP BY Genre
HAVING COUNT(Title) >= 3

--67--
-- Sual: Orta qiyməti 20-dən yüksək olan janrları göstər.
SELECT
    Genre,
    AVG(Price) OrtaQiymet
FROM Books
GROUP BY Genre
HAVING AVG(Price) > 20

--68--
-- Sual: Cəmi stoku 50-dən çox olan janrları göstər.
SELECT
    Genre,
    SUM(Stock) ÜmumiStok
FROM Books
GROUP BY Genre
HAVING SUM(Stock) > 50

--69--
-- Sual: Qiyməti 10-dan çox olan kitablar üzrə, ən azı 2 kitabı olan janrları göstər.
SELECT
    Genre,
    COUNT(title) KitabSay
FROM Books
WHERE Price > 10
GROUP BY Genre
HAVING COUNT(title) >= 2

--70--
-- Sual: Ən azı 2 kitabı olan naşirləri göstər.
SELECT
    Publisher Naşir,
    COUNT(Title) KitabSay
FROM Books
GROUP BY Publisher
HAVING COUNT(Title) >= 2

--71--
-- Sual: Ən baha və ən ucuz qiymət fərqi 5-dən çox olan janrları göstər.
SELECT
    Genre,
    MAX(Price) - MIN(Price) Spread
FROM Books
GROUP BY Genre
HAVING MAX(Price) - MIN(Price) > 5

--72--
-- Sual: Ümumi dəyəri (qiymət x stok) 500-dən çox olan janrları göstər.
SELECT
    Genre,
    SUM(Price * Stock) TotalValue
FROM Books
GROUP BY Genre
HAVING SUM(Price * Stock) > 500

--73--
-- Sual: Janr üzrə kitab sayını azalan sırada, bərabər olanları janr adına görə göstər.
SELECT
    Genre Janr,
    COUNT(Title) KitabSay
FROM Books
GROUP BY Genre
ORDER BY KitabSay DESC, Janr

--74.1--
-- Sual: Naməlum naşirlərin sayı: SUM(CASE ...) ilə.
SELECT SUM(CASE WHEN Publisher IS NULL THEN 1 ELSE 0 END) AS NamelumNaşir
FROM Books

--74.2--
-- Sual: Naməlum naşirlərin sayı: COUNT(CASE ...) ilə.
SELECT COUNT(CASE WHEN Publisher IS NULL THEN 0 END) AS NamelumNaşir
FROM Books

--74.3--
-- Sual: Naməlum naşirlərin sayı: COUNT(*) - COUNT(Publisher) ilə.
SELECT COUNT(*) - COUNT(Publisher) NamelumNaşir
FROM Books

--75--
-- Sual: Publishers cədvəlini yarat.
CREATE TABLE Publishers (
    PublisherId INT IDENTITY PRIMARY KEY,
    Name        NVARCHAR(100) NOT NULL,
    Country     NVARCHAR(50),
    FoundedYear INT
)

--76--
-- Sual: Publishers cədvəlinə məlumat əlavə et.
INSERT INTO Publishers (Name, Country, FoundedYear)
VALUES
    (N'Şərq-Qərb', N'Azərbaycan', 1998),
    (N'Qanun', N'Azərbaycan', 1992),
    (N'TechPress', N'ABŞ', 2005),
    (N'Çıraq', N'Azərbaycan', NULL),
    (N'Penguin', N'Britaniya', 1935);

--77--
-- Sual: Stores cədvəlini yarat.
CREATE TABLE Stores (
    StoreId   INT IDENTITY(1, 1) PRIMARY KEY,
    StoreName NVARCHAR(100) NOT NULL,
    City      NVARCHAR(50)
)

SELECT *
FROM Stores

--78--
-- Sual: Stores cədvəlinə məlumat əlavə et.
INSERT INTO Stores (StoreName, City)
VALUES
    (N'Mərkəz', N'Bakı'),
    (N'Gənclik', N'Bakı'),
    (N'Sumqayıt filialı', N'Sumqayıt'),
    (N'Gəncə filialı', N'Gəncə');

--79--
-- Sual: Sales cədvəlini yarat (Books və Stores ilə FOREIGN KEY).
CREATE TABLE Sales (
    SaleId   INT IDENTITY(1, 1) PRIMARY KEY,
    BookId   INT,
    StoreId  INT,
    Quantity INT NOT NULL,
    SaleDate DATE,
    CONSTRAINT fk_Books FOREIGN KEY (BookId) REFERENCES Books (BookId),
    CONSTRAINT fk_Stores FOREIGN KEY (StoreId) REFERENCES Stores (StoreId)
)

--80--
-- Sual: Sales cədvəlinə məlumat əlavə et.
INSERT INTO Sales (BookId, StoreId, Quantity, SaleDate)
VALUES
    (1, 1, 2, '2026-04-02'),
    (1, 2, 1, '2026-04-15'),
    (3, 1, 3, '2026-04-20'),
    (4, 3, 1, '2026-05-03'),
    (6, 1, 4, '2026-05-10'),
    (6, 2, 2, '2026-05-21'),
    (7, 1, 5, '2026-05-22'),
    (7, 3, 1, '2026-05-30'),
    (8, 2, 2, '2026-05-30'),
    (9, 1, 1, '2026-03-01'),
    (3, 2, 2, '2026-06-02'),
    (6, 3, 3, '2026-06-05');

--Qeyd--
SELECT *
FROM Books  --Kitablar

SELECT *
FROM Publishers  --Naşirlər

SELECT *
FROM Stores  --Mağazalar

SELECT *
FROM Sales  --Satışlar

--81--
-- Sual: Hər kitabın adını və naşirinin ölkəsini göstər (INNER JOIN).
SELECT
    b.Title KitabAd,
    p.Country Ölkə
FROM Publishers p
INNER JOIN Books b
    ON p.Name = b.Publisher

--82--
-- Sual: Satılan kitabın adını, miqdarını və satış tarixini göstər.
SELECT
    b.Title KitabAd,
    s.Quantity SatılanMiqdar,
    s.SaleDate SatişTarixi
FROM Sales s
INNER JOIN Books b
    ON s.BookId = b.BookId

--83--
-- Sual: Kitabın adını, mağazanın adını və satılan miqdarı göstər.
SELECT
    b.Title KitabAd,
    st.StoreName MağazaAd,
    s.Quantity SatılanMiqdar
FROM Sales s
INNER JOIN Books b
    ON s.BookId = b.BookId
INNER JOIN Stores st
    ON s.StoreId = st.StoreId

--84--
-- Sual: Miqdarı 2-dən çox olan satışları azalan sırada göstər.
SELECT
    b.Title KitabAd,
    st.StoreName MağazaAd,
    s.Quantity SatılanMiqdar
FROM Sales s
INNER JOIN Books b
    ON s.BookId = b.BookId
INNER JOIN Stores st
    ON s.StoreId = st.StoreId
WHERE s.Quantity > 2
ORDER BY SatılanMiqdar DESC, KitabAd

--85--
-- Sual: Hər mağaza üzrə cəmi satış miqdarını və satış sayını göstər.
SELECT
    st.StoreName,
    SUM(s.Quantity) TotalQty,
    COUNT(s.SaleId) SaleCount
FROM Sales s
INNER JOIN Stores st
    ON s.StoreId = st.StoreId
GROUP BY st.StoreName

--86--
-- Sual: Janr üzrə cəmi satış miqdarını göstər, yalnız 5 və yuxarı olanları.
SELECT
    b.Genre,
    SUM(s.Quantity) TotalQty
FROM Sales s
INNER JOIN Books b
    ON s.BookId = b.BookId
GROUP BY b.Genre
HAVING SUM(s.Quantity) >= 5
ORDER BY TotalQty DESC

--87--
-- Sual: Naşir üzrə gəliri (qiymət x miqdar) göstər, azalan sırada.
SELECT *
FROM Books

SELECT
    b.Publisher,
    SUM(b.Price * s.Quantity) Revenue
FROM Sales s
INNER JOIN Books b
    ON s.BookId = b.BookId
GROUP BY b.Publisher
ORDER BY Revenue DESC

--88--
-- Sual: Hər kitabın adını və naşirinin ölkəsini göstər (naşiri olmayan kitablar da görünsün, LEFT JOIN).
SELECT
    b.Title,
    p.Country
FROM Books b
LEFT JOIN Publishers p
    ON b.Publisher = p.Name

--89--
-- Sual: Hər kitabın satış sayını göstər (satılmayanlar da).
SELECT
    b.Title,
    ISNULL(COUNT(s.Quantity), 0) SaleCount
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
GROUP BY b.Title

--90--
-- Sual: Hər kitabın cəmi satış miqdarını göstər (satılmayanlar 0 ilə).
SELECT
    b.Title,
    ISNULL(SUM(s.Quantity), 0) TotalQty
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
GROUP BY b.Title

--91--
-- Sual: Hər kitabı və satış tarixini göstər; 2026-05-15-dən sonrakı satışlar üçün ON və WHERE fərqini göstər.
SELECT
    b.Title,
    s.SaleDate
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId

SELECT
    b.Title,
    s.SaleDate
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
WHERE s.SaleDate > '2026-05-15'

SELECT
    b.Title,
    s.SaleDate
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
        AND s.SaleDate > '2026-05-15'

SELECT
    b.Title,
    ISNULL(COUNT(s.SaleId), 0) SalesCount
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
        AND s.SaleDate > '2026-05-15'
GROUP BY b.Title

--92--
-- Sual: 2026-05-15-dən sonrakı satışların sayını kitab üzrə göstər (WHERE ilə: satışsız kitablar itir).
SELECT
    b.Title,
    ISNULL(COUNT(s.SaleId), 0) SalesCount
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
WHERE s.SaleDate > '2026-05-15'
GROUP BY b.Title

--93--
-- Sual: Hər mağazanın satış sayını göstər (satışsız mağaza da görünsün).
SELECT
    st.StoreName,
    ISNULL(COUNT(s.SaleId), 0) SaleCount
FROM Stores st
LEFT JOIN Sales s
    ON st.StoreId = s.StoreId
GROUP BY st.StoreName
ORDER BY SaleCount DESC

--94--
-- Sual: Hər naşiri və onun kitablarını göstər (RIGHT JOIN).
SELECT
    p.Name,
    b.Title
FROM Books b
RIGHT JOIN Publishers p
    ON b.Publisher = p.Name

--95--
-- Sual: Hər naşirin kitab sayını göstər (kitabı olmayan 0 ilə).
SELECT
    p.Name,
    ISNULL(COUNT(b.Title), 0) BookCount
FROM Books b
RIGHT JOIN Publishers p
    ON b.Publisher = p.Name
GROUP BY p.Name

--96--
-- Sual: Hər mağazanın cəmi satış miqdarını göstər (RIGHT JOIN).
SELECT
    st.StoreName,
    ISNULL(SUM(s.Quantity), 0) TotalQty
FROM Sales s
RIGHT JOIN Stores st
    ON s.StoreId = st.StoreId
GROUP BY st.StoreName
ORDER BY TotalQty DESC

--97--
-- Sual: Kitabları və naşirləri FULL OUTER JOIN ilə birləşdir.
SELECT
    b.Title,
    p.Name
FROM Books b
FULL OUTER JOIN Publishers p
    ON b.Publisher = p.Name

--98--
-- Sual: Kitab üzrə cəmi satış miqdarını FULL OUTER JOIN ilə göstər.
SELECT
    b.Title,
    SUM(s.Quantity) TotalQty
FROM Books b
FULL OUTER JOIN Sales s
    ON b.BookId = s.BookId
GROUP BY b.Title

--99--
-- Sual: Uyğunsuz sətirləri tap: satılmamış kitablar və kitabı olmayan satışlar.
SELECT
    b.Title,
    s.SaleId
FROM Books b
FULL OUTER JOIN Sales s
    ON b.BookId = s.BookId
WHERE b.BookId IS NULL
    OR s.BookId IS NULL

--100--
-- Sual: Janr üzrə satış sayını göstər (naməlum janr 'Naməlum' kimi).
SELECT
    ISNULL(b.Genre, N'Naməlum') Genre,
    COUNT(s.SaleId) SalesCount
FROM Books b
FULL OUTER JOIN Sales s
    ON b.BookId = s.BookId
GROUP BY ISNULL(b.Genre, N'Naməlum')

--101--
-- Sual: Hər kitabı hər mağaza ilə cütləşdir (CROSS JOIN).
SELECT
    b.Title,
    s.StoreName
FROM Books b
CROSS JOIN Stores s

--102--
-- Sual: Texnologiya kitabları ilə Bakıdakı mağazaları cütləşdir.
SELECT
    b.Title,
    s.StoreName
FROM Books b
CROSS JOIN Stores s
WHERE b.Genre = N'Texnologiya'
    AND s.City = N'Bakı'
ORDER BY s.StoreName, b.Title

--103--
-- Sual: Kitab x mağaza cütlərini və şəhərlər üzrə cüt sayını göstər.
SELECT
    b.Title,
    s.StoreName,
    s.City
FROM Books b
CROSS JOIN Stores s

SELECT
    s.City,
    COUNT(*) PairCount
FROM Books b
CROSS JOIN Stores s
GROUP BY s.City

--104--
-- Sual: Texnologiya kitablarından hansı mağazada heç satılmayıb?

SELECT
    b.Title,
    st.StoreName,
    s.SaleId
FROM Books b
CROSS JOIN Stores st
LEFT JOIN Sales s
    ON b.BookId = s.BookId
        AND st.StoreId = s.StoreId
WHERE b.Genre = N'Texnologiya'
    AND s.SaleId IS NULL
ORDER BY b.Title, st.StoreName

--105--
-- Sual: Heç satılmamış kitabları tap.
SELECT b.Title
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
WHERE s.BookId IS NULL

--106--
-- Sual: Heç kitabı olmayan naşirləri tap.
SELECT p.Name
FROM Publishers p
LEFT JOIN Books b
    ON p.Name = b.Publisher
WHERE b.Publisher IS NULL

--107--
-- Sual: Heç satışı olmayan mağazaları tap.
SELECT st.StoreName
FROM Stores st
LEFT JOIN Sales s
    ON st.StoreId = s.StoreId
WHERE s.StoreId IS NULL

--108--
-- Sual: Kitabı olmayan satışları tap.
SELECT s.SaleId
FROM Sales s
LEFT JOIN Books b
    ON s.BookId = b.BookId
WHERE b.BookId IS NULL

--109--
-- Sual: Satılmamış kitabların adını və naşirinin ölkəsini göstər.
SELECT
    b.Title,
    p.Country
FROM Books b
INNER JOIN Publishers p
    ON b.Publisher = p.Name
LEFT JOIN Sales s
    ON b.BookId = s.BookId
WHERE s.SaleId IS NULL
ORDER BY b.Title

--110--
-- Sual: Satılmamış kitabların sayını janr üzrə göstər, azalan sırada.
SELECT
    b.Genre,
    COUNT(b.BookId) BookCount
FROM Books b
LEFT JOIN Sales s
    ON b.BookId = s.BookId
WHERE s.SaleId IS NULL
GROUP BY b.Genre
ORDER BY BookCount DESC
