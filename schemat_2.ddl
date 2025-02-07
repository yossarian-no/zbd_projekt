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

CREATE SEQUENCE  "SEQ_ID_AUTA"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

CREATE SEQUENCE  "SEQ_ID_OPINII"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 12 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

CREATE SEQUENCE  "SEQ_NR_ZAMOWIENIA"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
------------------------------------------------------------------
-- Funkcje, procedury
------------------------------------------------------------------

create or replace FUNCTION get_avg_rating(p_nazwa_dilera VARCHAR2)
RETURN NUMBER IS
    v_avg_rating NUMBER(5,3);
BEGIN
    SELECT NVL(AVG(ocena), 0)
    INTO v_avg_rating
    FROM Opinie
    WHERE nazwa_dilera = p_nazwa_dilera;

    RETURN v_avg_rating;
END get_avg_rating;
/

-------------------------------
create or replace PROCEDURE update_avg_rating(p_nazwa_dilera VARCHAR2) IS
BEGIN
    UPDATE Dilery
    SET sr_ocena = get_avg_rating(p_nazwa_dilera)
    WHERE nazwa_dilera = p_nazwa_dilera;
END update_avg_rating;
/

--=-=-=-=-=-=--

create or replace TRIGGER trg_id_auta
BEFORE INSERT ON auta
FOR EACH ROW
BEGIN
    
    SELECT seq_id_auta.NEXTVAL
    INTO :new.id_auta
    FROM dual;
END;
/

create or replace TRIGGER trg_nr_zamowienia
BEFORE INSERT ON Zamowienia
FOR EACH ROW
BEGIN
    SELECT seq_nr_zamowienia.NEXTVAL
    INTO :new.NR_ZAMOWIENIA
    FROM dual;
END;
/

create or replace TRIGGER trg_opinie_before_insert
BEFORE INSERT ON OPINIE
FOR EACH ROW
BEGIN
    
    SELECT seq_id_opinii.NEXTVAL
    INTO :new.ID_OPINII
    FROM dual;
END;
/

create or replace TRIGGER trg_update_avg_rating
AFTER INSERT OR UPDATE OR DELETE ON Opinie
DECLARE
    CURSOR cur_dilery IS
        SELECT DISTINCT nazwa_dilera FROM Opinie;
BEGIN
    FOR rec IN cur_dilery LOOP
        update_avg_rating(rec.nazwa_dilera);
    END LOOP;
END trg_update_avg_rating;
/

create or replace TRIGGER TR_BLOCK_CLIENT_DELETE
BEFORE DELETE ON KLIENCI
FOR EACH ROW
DECLARE
    v_count_zamowienia NUMBER := 0;
    v_count_opinie NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count_zamowienia
    FROM ZAMOWIENIA
    WHERE id_klienta = :OLD.PESEL;

    SELECT COUNT(*) INTO v_count_opinie
    FROM OPINIE
    WHERE id_autora = :OLD.PESEL;

    IF v_count_zamowienia > 0 AND v_count_opinie > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie można usunąć klienta: posiada opinie i zamówienia w systemie!');
    ELSIF v_count_zamowienia > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nie można usunąć klienta: posiada zamówienia w systemie!');
    ELSIF v_count_opinie > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nie można usunąć klienta: posiada opinie w systemie!');
    END IF;
END;
/

create or replace TRIGGER TR_BLOCK_DILER_DELETE
BEFORE DELETE ON DILERY
FOR EACH ROW
DECLARE
    v_count_zamowienia NUMBER := 0;
    v_count_opinie NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count_zamowienia
    FROM ZAMOWIENIA
    WHERE diler = :OLD.nazwa_dilera;

    SELECT COUNT(*) INTO v_count_opinie
    FROM OPINIE
    WHERE nazwa_dilera = :OLD.nazwa_dilera;

    IF v_count_zamowienia > 0 AND v_count_opinie > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Nie można usunąć dilera: posiada opinie i zamówienia w systemie!');
    ELSIF v_count_zamowienia > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nie można usunąć dilera: posiada zamówienia w systemie!');
    ELSIF v_count_opinie > 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Nie można usunąć dilera: posiada opinie w systemie!');
    END IF;
END;
/

create or replace TRIGGER TR_BLOCK_KOMPONENT_DELETE
BEFORE DELETE ON KOMPONENTY
FOR EACH ROW
DECLARE
    v_count_sterio NUMBER := 0;
    v_count_silniki NUMBER := 0;
    v_count_felgi NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count_sterio
    FROM STERIO_SYSTEMY
    WHERE nazwa_komponentu = :OLD.nazwa_komponentu;

    SELECT COUNT(*) INTO v_count_silniki
    FROM SILNIKI
    WHERE nazwa_komponentu = :OLD.nazwa_komponentu;

    SELECT COUNT(*) INTO v_count_felgi
    FROM FELGI
    WHERE nazwa_komponentu = :OLD.nazwa_komponentu;

    IF v_count_sterio > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Nie można usunąć komponentu: jest używany w tabeli "Sterio_systemy"!');
    ELSIF v_count_silniki > 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Nie można usunąć komponentu: jest używany w tabeli "Silniki"!');
    ELSIF v_count_felgi > 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Nie można usunąć komponentu: jest używany w tabeli "Felgi"!');
    END IF;
END;
/

create or replace TRIGGER TR_BLOCK_MODELE_DELETE
BEFORE DELETE ON MODELE
FOR EACH ROW
DECLARE
    v_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM AUTA
    WHERE model = :OLD.nazwa_modeli;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Nie można usunąć modelu: jest używany w tabeli "Auta"!');
    END IF;
END;
/

create or replace TRIGGER TR_BLOCK_NADWOZIE_DELETE
BEFORE DELETE ON NADWOZIA
FOR EACH ROW
DECLARE
    v_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM MODELE
    WHERE nadwozie = :OLD.nazwa_nadwozia;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Nie można usunąć nadwozia: jest używane w tabeli "Modele"!');
    END IF;
END;
/

create or replace TRIGGER TR_BLOCK_SERIA_DELETE
BEFORE DELETE ON RODZINY_MODELI
FOR EACH ROW
DECLARE
    v_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM MODELE
    WHERE seria = :OLD.nazwa_serii;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Nie można usunąć serii: jest używana w tabeli "Modele"!');
    END IF;
END;
/

create or replace TRIGGER TR_BLOCK_ZAMOWIENIE_DELETE
BEFORE DELETE ON ZAMOWIENIA
FOR EACH ROW
DECLARE
    v_count NUMBER := 0;
BEGIN
    
    SELECT COUNT(*) INTO v_count
    FROM AUTA
    WHERE nr_zamowienia = :OLD.nr_zamowienia;

    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Nie można usunąć zamówienia: istnieje Auto do zamowiena!');
    END IF;
END;
/

