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
('3333333333333D', 2002, 410000, 'manualna', 'Polska', 2, 3, 'DealerLech'),
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

