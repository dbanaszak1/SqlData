DROP TABLE IF EXISTS Sprzedaz, Klient, Wyposazenie_Samochodu, Dodatkowe_Wypos, Oferta, Samochod, Profil_Dealera, Silnik_W_Modelu, Silnik, Ciezarowy, Osobowy, Dealer, Model, Marka;

CREATE TABLE Marka (
    nazwa VARCHAR(128) CONSTRAINT pk_Marka PRIMARY KEY,
    rok_zalozenia INT
);

CREATE TABLE Model (
    id INT CONSTRAINT pk_Model PRIMARY KEY,
    nazwa VARCHAR(128),
    rok_wprowadzenia INT,
    poprzednik INT,
    marka_nazwa VARCHAR(128) NOT NULL CONSTRAINT fk_Model_marka_nazwa REFERENCES Marka(nazwa)
);

CREATE TABLE Osobowy (
    model_id INT CONSTRAINT pk_Osobowy PRIMARY KEY,
    licz_pasazerow INT,
    pojemnosc_bagaznika INT,
    FOREIGN KEY (model_id) REFERENCES Model(id)
);

CREATE TABLE Ciezarowy (
    model_id INT CONSTRAINT pk_Ciezarowy PRIMARY KEY,
    ladownosc INT,
    FOREIGN KEY (model_id) REFERENCES Model(id)
);

CREATE TABLE Silnik (
    id INT CONSTRAINT pk_Silnik PRIMARY KEY,
    rodzaj_paliwa VARCHAR(128),
    opis_parametrow VARCHAR(256)
);

CREATE TABLE Silnik_W_Modelu (
    typ_silnika_id INT,
    model_id INT,
    CONSTRAINT pk_Silnik_W_Modelu PRIMARY KEY (typ_silnika_id, model_id),
    CONSTRAINT fk_Silnik_W_Modelu_model_id FOREIGN KEY (model_id) REFERENCES Model(id),
    CONSTRAINT fk_Silnik_W_Modelu_typ_silnika_id FOREIGN KEY (typ_silnika_id) REFERENCES Silnik(id)
    
);

CREATE TABLE Dealer (
    nazwa VARCHAR(128) CONSTRAINT pk_Dealer PRIMARY KEY,
    adres VARCHAR(128)
);

CREATE TABLE Profil_Dealera (
    dealer_nazwa VARCHAR(128),
    model_id INT,
    CONSTRAINT pk_Profil_Dealera PRIMARY KEY (dealer_nazwa, model_id),
    CONSTRAINT fk_Profil_Dealera_dealer_nazwa FOREIGN KEY (dealer_nazwa) REFERENCES Dealer(nazwa),
    CONSTRAINT fk_Profil_Dealera_model_id FOREIGN KEY (model_id) REFERENCES Model(id)
);

CREATE TABLE Samochod (
    VIN VARCHAR(64) CONSTRAINT pk_Samochod PRIMARY KEY,
    rok_produkcji INT,
    przebieg INT,
    skrzynia_biegow VARCHAR(128),
    kraj VARCHAR(128),
    typ_silnika_id INT NOT NULL,
    model_id INT NOT NULL,
    dealer_nazwa VARCHAR(128),
    CONSTRAINT fk_Samochod_typ_silnika_id FOREIGN KEY (typ_silnika_id) REFERENCES Silnik(id),
    CONSTRAINT fk_Samochod_model_id FOREIGN KEY (model_id) REFERENCES Model(id),
    CONSTRAINT fk_Samochod_dealer_nazwa FOREIGN KEY (dealer_nazwa) REFERENCES Dealer(nazwa)
);

CREATE TABLE Oferta (
    dealer_nazwa VARCHAR(128),
    samochod_VIN VARCHAR(64),
    CONSTRAINT pk_Oferta PRIMARY KEY (samochod_VIN, dealer_nazwa),
    CONSTRAINT fk_Oferta_dealer_nazwa FOREIGN KEY (dealer_nazwa) REFERENCES Dealer(nazwa),
    CONSTRAINT fk_Oferta_samochod_VIN FOREIGN KEY (samochod_VIN) REFERENCES Samochod(VIN)
);

CREATE TABLE Dodatkowe_Wypos (
    nazwa VARCHAR(128) CONSTRAINT pk_Dodatkowe_Wypos PRIMARY KEY
);

CREATE TABLE Wyposazenie_Samochodu (
    Samochod_VIN VARCHAR(64),
    dodatkowe_wypos_nazwa VARCHAR(128),
    CONSTRAINT pk_Wyposazenie_Samochodu PRIMARY KEY (Samochod_VIN, dodatkowe_wypos_nazwa),
    CONSTRAINT fk_Wyposazenie_Samochodu_Samochod_VIN FOREIGN KEY (Samochod_VIN) REFERENCES Samochod(VIN),
    CONSTRAINT fk_Wyposazenie_Samochodu_dodatkowe_wypos_nazwa FOREIGN KEY (dodatkowe_wypos_nazwa) REFERENCES Dodatkowe_Wypos(nazwa)
);

CREATE TABLE Klient (
    id INT CONSTRAINT pk_Klient PRIMARY KEY,
    imie VARCHAR(128),
    nazwisko VARCHAR(128),
    nr_tel VARCHAR(64)
);

CREATE TABLE Sprzedaz (
    data DATE,
    cena DECIMAL(10, 2),
    klient_id INT,
    Samochod_VIN VARCHAR(64),
    dealer_nazwa VARCHAR(128),
    CONSTRAINT pk_Sprzedaz PRIMARY KEY (data, klient_id, Samochod_VIN, dealer_nazwa),
    CONSTRAINT fk_Sprzedaz_klient_id FOREIGN KEY (klient_id) REFERENCES Klient(id),
    CONSTRAINT fk_Sprzedaz_Samochod_VIN FOREIGN KEY (Samochod_VIN) REFERENCES Samochod(VIN),
    CONSTRAINT fk_Sprzedaz_dealer_nazwa FOREIGN KEY (dealer_nazwa) REFERENCES Dealer(nazwa)
);


INSERT INTO Marka (nazwa, rok_zalozenia) VALUES 
('Toyota', 1955),
('Ford', 1965),
('Renault', 1950),
('Volkswagen', 1970);

INSERT INTO Model(id, nazwa, rok_wprowadzenia, poprzednik, marka_nazwa) VALUES 
(1, 'Camry', 2005, NULL, 'Toyota'),
(2, 'Mustang', 2002, NULL, 'Ford'),
(3, 'Megane', 2004, NULL, 'Renault'),
(4, 'Passat', 2012, NULL, 'Volkswagen'),
(5, 'Transporter', 2019, NULL, 'Volkswagen');

INSERT INTO Osobowy (model_id, licz_pasazerow, pojemnosc_bagaznika) VALUES 
(1, 4, 100),
(2, 5, 200),
(3, 4, 300),
(4, 5, 400);

INSERT INTO Silnik (id, rodzaj_paliwa, opis_parametrow) VALUES 
(1, 'Hybryda', '200 KM'),
(2, 'Benzyna', '150 KM'),
(3, 'Benzyna', '170 KM'),
(4, 'Diesel', '220 KM'),
(5, 'Elektryczny', '320 KM'),
(6, 'Hybryda', '120 KM'),
(7, 'Benzyna', '80 KM'),
(8, 'Diesel', '140 KM');

INSERT INTO Silnik_W_Modelu (typ_silnika_id, model_id) VALUES 
(1, 3),
(2, 1),
(3, 5),
(3, 1),
(4, 1),
(4, 2),
(4, 5),
(4, 4),
(5, 5),
(3, 3),
(5, 3);

INSERT INTO Ciezarowy (model_id, ladownosc) VALUES
(5, 10);

INSERT INTO Dealer (nazwa, adres) VALUES 
('DealerLech', 'os. Lecha 21'),
('DealerCzech', 'os. Checha 22'),
('DealerRus', 'os. Rusa 23'),
('Dealer1000', 'os. Tysiąclecia 24');

INSERT INTO Profil_Dealera(dealer_nazwa, model_id) VALUES
('DealerLech', 3),
('DealerCzech', 1),
('DealerRus', 2),
('Dealer1000', 4);

INSERT INTO Samochod (VIN, rok_produkcji, przebieg, skrzynia_biegow, kraj, typ_silnika_id, model_id, dealer_nazwa) VALUES 
('1111111111111A', 2018, 12345, 'manualna', 'Czechy', 2, 1, 'DealerCzech'),
('2222222222222B', 2011, 43211, 'automatyczna', 'Niemcy', 1, 2, 'DealerRus'),
('3333333333333C', 2002, 40000, 'manualna', 'Polska', 1, 3, 'DealerLech'),
('3333333333333D', 2002, 410000, 'manualna', 'Polska', 2, 4, 'DealerLech'),
('4444444444444D', 2010, 10000, 'automatyczna', 'Polska', 4, 4, 'Dealer1000');

INSERT INTO Oferta(dealer_nazwa, samochod_VIN) VALUES
('DealerLech', '3333333333333C'),
('DealerLech', '3333333333333D'),
('DealerCzech', '1111111111111A'),
('DealerRus', '2222222222222B'),
('Dealer1000', '4444444444444D');


INSERT INTO Dodatkowe_Wypos (nazwa) VALUES 
('Klimatyzacja'),
('System nagłośnienia'),
('Skórzana tapicerka'),
('Nawigacja'),
('Podgrzewane fotele'),
('Ambient light'),
('Tryb Sport');

INSERT INTO Wyposazenie_Samochodu (Samochod_VIN, dodatkowe_wypos_nazwa) VALUES
('1111111111111A', 'Nawigacja'),
('2222222222222B','Nawigacja'),
('3333333333333C','Klimatyzacja'),
('4444444444444D','System nagłośnienia');

INSERT INTO Klient (id, imie, nazwisko, nr_tel) VALUES 
(1, 'Adam', 'Nowak', '123456789'),
(2, 'Adam', 'Małysz', '444555666');

INSERT INTO Sprzedaz (data, cena, klient_id, Samochod_VIN, dealer_nazwa) VALUES 
('2020-01-29', 100000.00, 1, '1111111111111A', 'DealerCzech'),
('2021-02-19', 50000.00, 2, '2222222222222B', 'DealerRus');

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

--WYŚWIETLANIE SZCZEGÓŁÓW DOSTĘPNYCH SILNIKÓW W MODELU--
CREATE OR ALTER VIEW Silnik_W_M(marka, model,  rok_wprowadzenia, opis_parametrow)
AS
(
    SELECT  M.marka_nazwa, M.nazwa, Si.rodzaj_paliwa, Si.opis_parametrow
    FROM Model M 
    INNER JOIN Silnik_W_Modelu Swm ON M.id = Swm.model_id
    INNER JOIN Silnik Si ON Swm.typ_silnika_id = Si.id
);
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
    IF (@model_rok<@marka_rok)
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
    IF NOT EXISTS(SELECT 1 FROM Model WHERE id = @model_id)
    BEGIN 
        RAISERROR('Model o podanum id nie istnieje',11,1);
        RETURN;
    END;
     --Sprawdzanie czy model nie ma juz przypisanego typu--
    IF EXISTS(SELECT 1 FROM Osobowy WHERE @model_id = model_id)
    BEGIN 
        RAISERROR('Model o podanum id ma juz typ',11,1);
        RETURN;
    END;

    INSERT INTO Ciezarowy (model_id, ladownosc) 
    VALUES (@model_id, @ladownosc);
END;
GO

--KTO NAJWIECEJ SPRZEDAJE--
CREATE OR ALTER VIEW best_dealer(dealer, liczba_sprzedanych)
AS
(
    SELECT dealer_nazwa, COUNT(*) AS liczba_sprzedanych
    FROM Sprzedaz
    GROUP BY dealer_nazwa
);
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


SELECT * FROM udf_oferta('DealerLech');
SELECT * FROM Osobowy_Info;
SELECT * FROM Ciezarowy_Info;
SELECT * FROM best_dealer ORDER BY liczba_sprzedanych DESC;
SELECT * FROM Silnik_W_M ORDER BY model;

EXEC usp_dodaj_oferte '1111111111111A', 2022, 5000, 'Automatyczna', 'Polska', 1, 2, 'Nazwa Dealera';
EXEC usp_dodaj_oferte 'ABC123456789', 2022, 5000, 'Automatyczna', 'Polska', 1, 20, 'Nazwa Dealera';
EXEC usp_dodaj_oferte 'ABC123456789', 2022, 5000, 'Automatyczna', 'Polska', 7, 3, 'Nazwa Dealera';
EXEC usp_dodaj_oferte 'ABC123456789', 2022, 5000, 'Automatyczna', 'Polska', 3, 3, 'Nazwa Dealera';
EXEC usp_dodaj_oferte 'ABC123456789', 2032, 5000, 'Automatyczna', 'Polska', 3, 3, 'Nazwa Dealera';
EXEC usp_dodaj_oferte 'ABC123456789', 2020, 5000, 'Automatyczna', 'Polska', 3, 3, 'DealerLech';


EXEC usp_sprzedaj '2023-06-15', 25000.00, 1, 'TENVINNIEISTNIEJE', 'Nazwa Dealera';
EXEC usp_sprzedaj '2024-06-15', 25000.00, 1, '1111111111111A', 'Nazwa Dealera';
EXEC usp_sprzedaj '2023-06-15', 25000.00, 10, '1111111111111A', 'Nazwa Dealera';
EXEC usp_sprzedaj '2023-06-15', 25000.00, 1, '1111111111111A', 'Nazwa Dealera';
EXEC usp_sprzedaj '2023-06-15', 25000.00, 1, '1111111111111A', 'DealerLech';
EXEC usp_sprzedaj '2023-06-15', 25000.00, 1, '3333333333333D', 'DealerLech';

SELECT * FROM Sprzedaz;
SELECT * FROM Oferta;

EXEC usp_sprzedane 'ABC1234567893';
EXEC usp_sprzedane '3333333333333C';

SELECT * FROM Oferta;

EXEC usp_dodaj_model_marka 'Renault', 2020, 1, 'Nowy Model', 2023, NULL;
EXEC usp_dodaj_model_marka 'Nowa Marka', 2020, 1, 'Nowy Model', 2023, NULL;
EXEC usp_dodaj_model_marka 'Nowa Marka', 2030, 10, 'Nowy Model', 2023, NULL;
EXEC usp_dodaj_model_marka 'Nowa Marka', 2020, 10, 'Nowy Model', 2033, NULL;
EXEC usp_dodaj_model_marka 'Nowa Marka', 2020, 10, 'Nowy Model', 2010, NULL;
EXEC usp_dodaj_model_marka 'Nowa Marka', 2020, 10, 'Nowy Model', 2021, NULL;

SELECT * FROM Marka;
SELECT * FROM Model;

EXEC usp_dodaj_model 2, 'Nowy Model', 2023, NULL, 'Nazwa Marki';
EXEC usp_dodaj_model 12, 'Nowy Model', 2024, NULL, 'Nazwa Marki';
EXEC usp_dodaj_model 12, 'Nowy Model', 2020, NULL, 'Nazwa Marki';
EXEC usp_dodaj_model 12, 'Nowy Model', 2020, NULL, 'Renault';

SELECT * FROM Model;

EXEC usp_przypisz_ciezarowy 200, 5000;
EXEC usp_przypisz_ciezarowy 2, 5000;
EXEC usp_przypisz_ciezarowy 12, 5000;
SELECT * FROM Ciezarowy;

EXEC usp_dodaj_model 13, 'Nowy Model', 2020, NULL, 'Renault';
EXEC usp_przypisz_osobowy 200, 4, 500;
EXEC usp_przypisz_osobowy 5, 5, 500;
EXEC usp_przypisz_osobowy 13, 5,500;
SELECT * FROM Osobowy;

