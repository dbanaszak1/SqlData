
---DODAWANIE AUTA---
CREATE OR ALTER PROCEDURE usp_dodaj_oferte
(
	@vin VARCHAR(64),
	@rok INT,
	@przebieg INT,
	@skrzynia VARCHAR(128),
	@kraj VARCHAR(128),
	@id_silnika  INT,
	@id_model INT, 
	@dealer_nazwa VARCHAR(128)    
)
AS
BEGIN

--Sprawdzanie czy dany samochod jest w bazie--
    IF EXISTS (SELECT 1 FROM Samochod WHERE VIN=@vin)
    BEGIN 
        RAISERROR('Samochod o takim vinie juz istnieje w bazie',11,1);
        RETURN;
    END;

--Sprawdzanie czy taki model istnieje w bazie--
    IF @id_model NOT IN (SELECT id FROM Model)
    BEGIN 
        RAISERROR('Nie ma takiego modelu',11,1);
        RETURN;
    END;

--Sprawdzanie czy dla modelu dostepny jest silnik--
    IF NOT EXISTS (SELECT * FROM Silnik_W_Modelu WHERE @id_model = model_id AND @id_silnika = typ_silnika_id)
    BEGIN 
        RAISERROR('W danym modelu nie ma takiego silnika',11,1);
        RETURN;
    END;
   
--Sprawdzanie czy rok jest poprawny--
    IF (YEAR(GETDATE()) < @rok OR @rok < 1886)
    BEGIN 
        RAISERROR('Nieprawidłowy rok produkcji',11,1);
        RETURN;
    END;

--Sprawdzneie czy taki dealer istnieje--
    IF @dealer_nazwa NOT IN (SELECT nazwa FROM Dealer)
    BEGIN 
        RAISERROR('Dealer o takiej nazwie nie istnieje',11,1);
        RETURN;
    END;


--Dodanie samochodu--
	INSERT INTO Samochod (VIN, rok_produkcji, przebieg, skrzynia_biegow, kraj, typ_silnika_id, model_id, dealer_nazwa) 
	VALUES (@vin, @rok, @przebieg, @skrzynia, @kraj, @id_silnika, @id_model, @dealer_nazwa);
--Dodanie oferty--
	INSERT INTO Oferta(dealer_nazwa, samochod_VIN) VALUES
	(@dealer_nazwa, @vin);
--Dodanie modelu do profilu dealera--
	IF NOT EXISTS (SELECT * FROM Profil_Dealera WHERE dealer_nazwa=@dealer_nazwa AND model_id=@id_model)
		BEGIN 
		INSERT INTO Profil_Dealera(dealer_nazwa, model_id) VALUES
		(@dealer_nazwa, @id_model);
		END;
END;
GO


--SPRZEDAWANIE AUTA--
CREATE OR ALTER PROCEDURE usp_sprzedaj
(
    @data DATE,
    @cena DECIMAL(10, 2),
    @id_klient INT,
    @VIN VARCHAR(64),
    @dealer_nazwa VARCHAR(128)
)
AS
BEGIN
    --Sprawdzneie czy taki samochod istnieje--
    IF @vin NOT IN (SELECT VIN FROM Samochod)
        BEGIN 
            RAISERROR('Samochod o takim vinie nie istnieje',11,1);
            RETURN;
        END;

    --Sprawdzanie czy data jest poprawna--
    IF GETDATE() < @data 
    BEGIN 
        RAISERROR('Nieprawidłowy rok produkcji',11,1);
        RETURN;
    END;
    
    --Sprawdzneie czy taki klient istnieje--
    IF @id_klient NOT IN (SELECT id FROM Klient)
        BEGIN 
            RAISERROR('Klient o podanym id nie istnieje',11,1);
            RETURN;
        END;
        
    --Sprawdzneie czy taki dealer istnieje--
    IF @dealer_nazwa NOT IN (SELECT nazwa FROM Dealer)
        BEGIN 
            RAISERROR('Dealer o takiej nazwie nie istnieje',11,1);
            RETURN;
        END;

    --Sprawdzneie czy dany dealer ma taki samochod w ofercie--    
    IF NOT EXISTS (SELECT 1 FROM Oferta WHERE @dealer_nazwa=dealer_nazwa AND @vin=Samochod_VIN )
        BEGIN 
            RAISERROR('Ten dealer nie ma tego samochodu w ofercie',11,1);
            RETURN;
        END;
    
    --Dodanie sprzedazy--
    INSERT INTO Sprzedaz (data, cena, klient_id, Samochod_VIN, dealer_nazwa)
    VALUES (@data, @cena, @id_klient, @VIN, @dealer_nazwa);

END;
GO

--TRIGGER SPRZEDANE--
CREATE OR ALTER TRIGGER tr_sprzedane
ON Sprzedaz AFTER INSERT
AS
    DECLARE @vin VARCHAR(64);
    DECLARE @dealer_nazwa VARCHAR(128);

    SET @vin =  (SELECT Samochod_VIN FROM inserted);
    SET @dealer_nazwa = (SELECT dealer_nazwa FROM inserted);

    --usuniecie samochodu z oferty--
    DELETE FROM Oferta WHERE (Samochod_VIN = @vin AND dealer_nazwa = @dealer_nazwa);
GO

--USUNIECIE Z OFERY SPRZEDANEGO SAMOCHODU--
CREATE OR ALTER PROCEDURE usp_sprzedane
(
    @vin VARCHAR(64)
)
AS
BEGIN
    --Sprawdzenie czy w ofercie jest podany samochod--
    IF NOT EXISTS(SELECT 1 FROM Oferta WHERE Samochod_VIN = @vin)
    BEGIN 
            RAISERROR('Takiego samochodu nie ma w ofercie',11,1);
            RETURN;
    END;
    DELETE FROM Oferta WHERE Samochod_VIN = @vin;
END;
GO


--DODAWANIE NOWEJ MARKI--
CREATE OR ALTER PROCEDURE usp_dodaj_model_marka
(
    @marka_nazwa VARCHAR(128),
    @marka_rok INT,
    @model_id INT,
    @model_nazwa VARCHAR(128),
    @model_rok INT,
    @model_poprzednik INT
)
AS
BEGIN
    --Sprawdzanie czy istanieje juz taka marka--
    IF EXISTS (SELECT 1 FROM Marka WHERE nazwa = @marka_nazwa)
    BEGIN
        RAISERROR('Marka o podanej nazwie juz istnieje.', 11, 1);
        RETURN;
    END;
    --Sprawdzanie czy istanieje juz taki model--
    IF EXISTS (SELECT 1 FROM Model WHERE id = @model_id)
    BEGIN
        RAISERROR('Model o podanym id juz istnieje.', 11, 1);
        RETURN;
    END;

    --Sprawdzanie czy rok produkcji jest poprawny--
    IF (YEAR(GETDATE()) < @model_rok OR @model_rok < 1886)
    BEGIN 
        RAISERROR('Nieprawidłowy rok produkcji modelu',11,1);
        RETURN;
    END;

    --Sprawdzanie czy rok powstania marki jest poprawny--
    IF (YEAR(GETDATE()) < @marka_rok OR @marka_rok < 1810)
    BEGIN 
        RAISERROR('Nieprawidłowy rok powstania marki',11,1);
        RETURN;
    END;

    --Sprawdzneie logiki dat--
    IF (@model_rok>@marka_rok)
    BEGIN 
        RAISERROR('Marka musi istnieć zamin powstanie model',11,1);
        RETURN;
    END;

    INSERT INTO Marka (nazwa, rok_zalozenia)
    VALUES (@marka_nazwa, @marka_rok);

    INSERT INTO Model (id, nazwa, rok_wprowadzenia, poprzednik, marka_nazwa)
    VALUES (@model_id, @model_nazwa, @model_rok, @model_poprzednik, @marka_nazwa);
END;
GO

--DODAWANIE NOWEGO MODELU--
CREATE OR ALTER PROCEDURE usp_dodaj_model
(
    @model_id INT,
    @model_nazwa VARCHAR(128),
    @model_rok INT,
    @model_poprzednik INT,
    @marka_nazwa VARCHAR(128)
)
AS
BEGIN
    --Sprawdzanie id modelu jest poprawne-- 
    IF EXISTS(SELECT 1 FROM Model WHERE id = @model_id)
    BEGIN 
        RAISERROR('Model o podanum id juz istnieje',11,1);
        RETURN;
    END;

    --Sprawdzanie czy rok produkcji jest poprawny--
    IF (YEAR(GETDATE()) < @model_rok OR @model_rok < 1886)
    BEGIN 
        RAISERROR('Nieprawidłowy rok produkcji modelu',11,1);
        RETURN;
    END;

    --Sprawdzanie czy marka istnieje--
    IF NOT EXISTS(SELECT 1 FROM Marka WHERE nazwa = @marka_nazwa)
    BEGIN 
        RAISERROR('Taka marka nie istnieje',11,1);
        RETURN;
    END;

INSERT INTO Model(id, nazwa, rok_wprowadzenia, poprzednik, marka_nazwa) 
VALUES (@model_id, @model_nazwa, @model_rok, @model_poprzednik, @marka_nazwa);
END;
GO

--PRZYPISANIE TYPU CIEZAROWEGO--
CREATE OR ALTER PROCEDURE usp_przypisz_ciezarowy
(
    @model_id INT,
    @ladownosc INT
)
AS
BEGIN  
     --Sprawdzanie id modelu jest poprawne-- 
    IF NOT EXISTS(SELECT 1 FROM Model WHERE id = @id_model)
    BEGIN 
        RAISERROR('Model o podanum id nie istnieje',11,1);
        RETURN;
    END;
     --Sprawdzanie czy model nie ma juz przypisanego typu--
    IF EXISTS(SELECT 1 FROM Osobowy WHERE @model_id = model_id OR SELECT 1 FROM Ciezarowy WHERE @model_id = model_id)
    BEGIN 
        RAISERROR('Model o podanum id ma juz typ',11,1);
        RETURN;
    END;

    INSERT INTO Ciezarowy (model_id, ladownosc) 
    VALUES (@model_id, @ladownosc);
END;
GO

--PRZYPISANIE TYPU OSOBOWEGO--
CREATE OR ALTER PROCEDURE usp_przypisz_osobowy
(
    @model_id INT,
    @licz_pas INT,
    @poj_bag INT
)
AS
BEGIN  
     --Sprawdzanie id modelu jest poprawne-- 
    IF NOT EXISTS(SELECT 1 FROM Model WHERE id = @model_id)
    BEGIN 
        RAISERROR('Model o podanum id nie istnieje',11,1);
        RETURN;
    END;
     --Sprawdzanie czy model nie ma juz przypisanego typu--
    IF EXISTS(SELECT 1 FROM Ciezarowy WHERE @model_id = model_id)
    BEGIN 
        RAISERROR('Model o podanum id ma juz typ',11,1);
        RETURN;
    END;

    INSERT INTO Osobowy (model_id, licz_pasazerow, pojemnosc_bagaznika) 
    VALUES (@model_id, @licz_pas, @poj_bag);
END;
GO

--SZCZEGOLY OFERTY DEALERA--
CREATE OR ALTER FUNCTION udf_oferta
(
    @dealer_nazwa VARCHAR(128)
)
    RETURNS TABLE
AS
RETURN
(
    SELECT O.dealer_nazwa, O.samochod_VIN, M.nazwa, S.rok_produkcji, S.przebieg, S.skrzynia_biegow, S.kraj, Si.rodzaj_paliwa, Si.opis_parametrow 
    FROM Oferta O
        INNER JOIN Samochod S ON S.VIN = O.samochod_VIN
        INNER JOIN Model M ON M.id = S.model_id
        INNER JOIN Silnik Si ON Si.id = S.typ_silnika_id
        WHERE O.dealer_nazwa = @dealer_nazwa;
);
GO

--WYSWIETLENIE INFORMACJI SAMOCHODOW OSOBOWYCH--
CREATE OR ALTER VIEW Osobowy_Info(model, marka, rok_wprowadzenia, licz_pasazerow, pojemonsc_bagaznika)
AS
(
    SELECT M.nazwa, M.marka_nazwa, M.rok_wprowadzenia, O.licz_pasazerow, O.pojemnosc_bagaznika
    FROM Model M INNER JOIN Osobowy O ON M.id = O.model_id
);
GO


--WYSWIETLENIE INFORMACJI SAMOCHODOW CIEZAROWYCH--
CREATE OR ALTER VIEW Ciezarowy_Info(model, marka, rok_wprowadzenia, ladownosc)
AS
(
    SELECT M.nazwa, M.marka_nazwa, M.rok_wprowadzenia, C.ladownosc
    FROM Model M INNER JOIN Ciezarowy C ON M.id = C.model_id
);
GO

--WYŚWIETLANIE SZCZEGÓŁÓW DOSTĘPNYCH SILNIKÓW W MODELU--
CREATE OR ALTER VIEW Silnik_W_M(marka, model,  rok_wprowadzenia, opis parametrow)
AS
(
    SELECT  M.marka_nazwa, M.nazwa, Si.rodzaj_paliwa, Si.opis_parametrow
    FROM Model M 
    INNER JOIN Silnik_W_Modelu Swm ON M.id = Swm.model_id
    INNER JOIN Silnik Si ON Swm.typ_silnika_id = Si.id
);
GO

--KTO NAJWIECEJ SPRZEDAJE--
CREATE OR ALTER VIEW best_dealer(dealer, liczba_sprzedanych)
AS
(
    SELECT dealer_nazwa, COUNT(*) AS liczba_sprzedanych
    FROM Sprzedaz
    GROUP BY dealer_nazwa
    ORDER BY liczba_sprzedanych DESC    
);
GO