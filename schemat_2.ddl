----------------------------------------------------
-- Tworzenie tabel
----------------------------------------------------

CREATE TABLE Klienci (
    pesel CHAR(11) PRIMARY KEY,
    imie VARCHAR2(50) NOT NULL,
    nazwisko VARCHAR2(50) NOT NULL,
    telefon VARCHAR2(15) NOT NULL
);

CREATE TABLE Dilery (
    nazwa_dilera VARCHAR2(50) PRIMARY KEY,
    adres VARCHAR2(255) NOT NULL,
    telefon VARCHAR2(15) NOT NULL,
    sr_ocena NUMBER(5, 3)
);

CREATE TABLE Zamowienia (
    nr_zamowienia NUMBER(10) PRIMARY KEY,
    data_zamowienia DATE NOT NULL,
    data_odbioru DATE NOT NULL,
    diler VARCHAR2(50) NOT NULL,
    id_klienta CHAR(11) NOT NULL,
    FOREIGN KEY (diler) REFERENCES Dilery(nazwa_dilera),
    FOREIGN KEY (id_klienta) REFERENCES Klienci(pesel)
);

CREATE TABLE Nadwozia (
    nazwa_nadwozia VARCHAR2(50) PRIMARY KEY,
    ilosc_drzwi NUMBER NOT NULL,
    typ VARCHAR2(50) NOT NULL
);

CREATE TABLE Rodziny_modeli (
    nazwa_serii VARCHAR2(50) PRIMARY KEY,
    segment VARCHAR2(50) NOT NULL,
    rok NUMBER NOT NULL
);

CREATE TABLE Modele (
    nazwa_modeli VARCHAR2(50) PRIMARY KEY,
    seria VARCHAR2(50) NOT NULL,
    nadwozie VARCHAR2(50) NOT NULL,
    FOREIGN KEY (seria) REFERENCES Rodziny_modeli(nazwa_serii),
    FOREIGN KEY (nadwozie) REFERENCES Nadwozia(nazwa_nadwozia)
);

CREATE TABLE Komponenty (
    nazwa_komponentu VARCHAR2(50) PRIMARY KEY,
    cena NUMBER(10, 2) NOT NULL
);

CREATE TABLE Sterio_systemy (
    nazwa_komponentu VARCHAR2(50) PRIMARY KEY,
    hi_fi VARCHAR2(1) CHECK (hi_fi IN ('Y', 'N')) NOT NULL,
    ilosc_glosnikow NUMBER NOT NULL,
    FOREIGN KEY (nazwa_komponentu) REFERENCES Komponenty(nazwa_komponentu)
);

CREATE TABLE Silniki (
    nazwa_komponentu VARCHAR2(50) PRIMARY KEY,
    objetosc NUMBER(5, 2) NOT NULL,
    moc NUMBER NOT NULL,
    FOREIGN KEY (nazwa_komponentu) REFERENCES Komponenty(nazwa_komponentu)
);

CREATE TABLE Felgi (
    nazwa_komponentu VARCHAR2(50) PRIMARY KEY,
    material VARCHAR2(50) NOT NULL,
    kolor VARCHAR2(30) NOT NULL,
    FOREIGN KEY (nazwa_komponentu) REFERENCES Komponenty(nazwa_komponentu)
);

CREATE TABLE Auta (
    id_auta NUMBER PRIMARY KEY,
    nr_zamowienia NUMBER NOT NULL,
    cena NUMBER(10, 2) NOT NULL,
    rok_produkcji NUMBER NOT NULL,
    sterio VARCHAR2(50) NOT NULL,
    silnik VARCHAR2(50) NOT NULL,
    felgi VARCHAR2(50) NOT NULL,
    model VARCHAR2(50) NOT NULL,
    FOREIGN KEY (nr_zamowienia) REFERENCES Zamowienia(nr_zamowienia),
    FOREIGN KEY (sterio) REFERENCES Sterio_systemy(nazwa_komponentu),
    FOREIGN KEY (silnik) REFERENCES Silniki(nazwa_komponentu),
    FOREIGN KEY (felgi) REFERENCES Felgi(nazwa_komponentu),
    FOREIGN KEY (model) REFERENCES Modele(nazwa_modeli)
);

CREATE TABLE Opinie (
    id_opinii NUMBER PRIMARY KEY,
    ocena NUMBER(2) NOT NULL,
    komentarz VARCHAR2(100) NOT NULL,
    nazwa_dilera VARCHAR2(50) NOT NULL,
    id_autora CHAR(11) NOT NULL,
    FOREIGN KEY (nazwa_dilera) REFERENCES Dilery(nazwa_dilera),
    FOREIGN KEY (id_autora) REFERENCES Klienci(pesel)
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

-------------------------------
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


--=-=-=-=-=-=--
