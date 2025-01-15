----------------------------------------------------
-- Tworzenie tabel
----------------------------------------------------

CREATE TABLE Klienci (
    pesel CHAR(11) PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    telefon VARCHAR(15) NOT NULL
);


CREATE TABLE Zamowienia (
    nr_zamowienia INT(10) PRIMARY KEY,
    data_zamowienia DATE NOT NULL,
    data_odbioru DATE NOT NULL,
    diler VARCHAR(50) NOT NULL,
    id_klienta CHAR(11) NOT NULL,
    FOREIGN KEY (diler) REFERENCES Dilery(nazwa_dilera),
    FOREIGN KEY (id_klienta) REFERENCES Klienci(pesel)
);


CREATE TABLE Auta (
    id_auta INT PRIMARY KEY,
    nr_zamowienia INT NOT NULL,
    cena DECIMAL(10, 2) NOT NULL,
    rok_produkcji INT NOT NULL,
    sterio VARCHAR(50) NOT NULL,
    silnik VARCHAR(50) NOT NULL,
    felgi VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    FOREIGN KEY (nr_zamowienia) REFERENCES Zamowienia(nr_zamowienia),
    FOREIGN KEY (sterio) REFERENCES Sterio_systemy(nazwa_komponentu),
    FOREIGN KEY (silnik) REFERENCES Silniki(nazwa_komponentu),
    FOREIGN KEY (felgi) REFERENCES Felgi(nazwa_komponentu),
    FOREIGN KEY (model) REFERENCES Modele(nazwa_modeli)
);


CREATE TABLE Modele (
    nazwa_modeli VARCHAR(50) PRIMARY KEY,
    seria VARCHAR(50) NOT NULL,
    nadwozie VARCHAR(50) NOT NULL,
    FOREIGN KEY (seria) REFERENCES Rodziny_modeli(nazwa_serii),
    FOREIGN KEY (nadwozie) REFERENCES Nadwozia(nazwa_nadwozia)
);


CREATE TABLE Nadwozia (
    nazwa_nadwozia VARCHAR(50) PRIMARY KEY,
    ilosc_drzwi INT NOT NULL,
    typ VARCHAR(50) NOT NULL
);


CREATE TABLE Rodziny_modeli (
    nazwa_serii VARCHAR(50) PRIMARY KEY,
    segment VARCHAR(50) NOT NULL,
    rok INT NOT NULL
);


CREATE TABLE Opinie (
    id_opinii INT PRIMARY KEY,
    ocena INT NOT NULL,
    komentarz VARCHAR(100) NOT NULL,
    nazwa_dilera VARCHAR(50) NOT NULL,
    id_autora CHAR(11) NOT NULL,
    FOREIGN KEY (nazwa_dilera) REFERENCES Dilery(nazwa_dilera),
    FOREIGN KEY (id_autora) REFERENCES Klienci(pesel)
);


CREATE TABLE Dilery (
    nazwa_dilera VARCHAR(50) PRIMARY KEY,
    adres VARCHAR(255) NOT NULL,
    telefon VARCHAR(15) NOT NULL,
    sr_ocena FLOAT(5, 3)
);


CREATE TABLE Komponenty (
    nazwa_komponentu VARCHAR(50) PRIMARY KEY,
    cena FLOAT(10, 2) NOT NULL
);


CREATE TABLE Sterio_systemy (
    nazwa_komponentu VARCHAR(50) PRIMARY KEY,
    hi_fi BOOLEAN NOT NULL,
    ilosc_glosnikow INT NOT NULL,
    FOREIGN KEY (nazwa_komponentu) REFERENCES Komponenty(nazwa_komponentu)
);


CREATE TABLE Silniki (
    nazwa_komponentu VARCHAR(50) PRIMARY KEY,
    objetosc FLOAT(5, 2) NOT NULL,
    moc INT NOT NULL,
    FOREIGN KEY (nazwa_komponentu) REFERENCES Komponenty(nazwa_komponentu)
);


CREATE TABLE Felgi (
    nazwa_komponentu VARCHAR(50) PRIMARY KEY,
    material VARCHAR(50) NOT NULL,
    kolor VARCHAR(30) NOT NULL,
    FOREIGN KEY (nazwa_komponentu) REFERENCES Komponenty(nazwa_komponentu)
);



--------------------------------------------------------------
-- Sekwencje
--------------------------------------------------------------

CREATE SEQUENCE id_klienci START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE nr_zamowienia START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_auta START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_modele START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_nadwozia START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_rodziny_modeli START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_opinie START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_dilery START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_komponenty START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_sterio_systemy START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_silniki START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE id_felgi START WITH 1 INCREMENT BY 1;


------------------------------------------------------------------
-- Funkcje, procedury
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE DodajKlienta (
    vPesel IN CHAR,
    vImie IN VARCHAR2,
    vNazwisko IN VARCHAR2,
    vTelefon IN VARCHAR2
) IS
BEGIN
    INSERT INTO Klienci (pesel, imie, nazwisko, telefon)
    VALUES (vPesel, vImie, vNazwisko, vTelefon);
END DodajKlienta;

---
CREATE OR REPLACE PROCEDURE DodajZamowienie (
    vDataZamowienia IN DATE,
    vDataOdbioru IN DATE,
    vDiler IN VARCHAR2,
    vIdKlienta IN CHAR
) IS
BEGIN
    INSERT INTO Zamowienia (nr_zamowienia, data_zamowienia, data_odbioru, diler, id_klienta)
    VALUES (id_zamowienia.NEXTVAL, vDataZamowienia, vDataOdbioru, vDiler, vIdKlienta);
END DodajZamowienie;

---
CREATE OR REPLACE PROCEDURE DodajOpinie (
    vOcena IN INT,
    vKomentarz IN VARCHAR2,
    vNazwaDilera IN VARCHAR2,
    vIdAutora IN CHAR
) IS
BEGIN
    INSERT INTO Opinie (id_opinii, ocena, komentarz, nazwa_dilera, id_autora)
    VALUES (id_opinie.NEXTVAL, vOcena, vKomentarz, vNazwaDilera, vIdAutora);
END DodajOpinie;

-------
CREATE OR REPLACE FUNCTION KosztZamowienia (vNrZamowienia IN INT)
RETURN DECIMAL IS
    vKoszt DECIMAL(10, 2);
BEGIN
    SELECT SUM(cena) INTO vKoszt
    FROM Auta
    WHERE nr_zamowienia = vNrZamowienia;
    
    RETURN vKoszt;
END KosztZamowienia;

CREATE OR REPLACE FUNCTION SredniRankingDilera (vNazwaDilera IN VARCHAR2)
RETURN FLOAT IS
    vSrednia FLOAT;
BEGIN
    SELECT AVG(ocena) INTO vSrednia
    FROM Opinie
    WHERE nazwa_dilera = vNazwaDilera;
    
    RETURN NVL(vSrednia, 0);
END SredniRankingDilera;










