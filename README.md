# Projekt z przedmiotu "Zarządzanie Bazami SQL i NoSQL" - Oracle APEX Database Application

Projekt z przedmiotu "Zarządzanie Bazami SQL i NoSQL" - Oracle APEX Database Application

2024/25 rok akademicki

Vasil Kusmartsev
Mikhail Rybalka

Projekt obsługuje bazę danych systemu sprzedaży samochodów.

## System sprzedaży samochodów w Oracle APEX

Projekt przedstawia aplikację webową opartą na relacyjnej bazie danych, stworzoną w Oracle APEX w ramach projektu akademickiego. Celem projektu było zaprojektowanie i wdrożenie systemu sprzedaży samochodów, umożliwiającego zarządzanie klientami, dealerami, zamówieniami, samochodami, modelami oraz opiniami.

## Opis projektu

Aplikacja została zaprojektowana jako system obsługujący bazę danych sprzedaży samochodów. Projekt obejmował pełny proces tworzenia rozwiązania — od analizy encji i relacji, przez przygotowanie diagramów oraz schematu relacyjnego, aż po implementację aplikacji w Oracle APEX.

System umożliwia przechowywanie i zarządzanie danymi dotyczącymi:
- klientów,
- dealerów,
- samochodów,
- zamówień,
- opinii,
- modeli i rodzin modeli,
- nadwozi,
- komponentów takich jak silniki, felgi i systemy stereo.

## Główne funkcjonalności

- przeglądanie, dodawanie i edycja danych w aplikacji Oracle APEX,
- zarządzanie informacjami o klientach i dealerach,
- obsługa zamówień oraz powiązanych z nimi samochodów,
- przechowywanie opinii klientów o dealerach,
- zarządzanie modelami samochodów, nadwoziami i komponentami,
- walidacja danych wprowadzanych przez użytkownika,
- obsługa błędów dla niepoprawnych lub zduplikowanych danych.

## Projekt bazy danych

Model bazy danych został zaprojektowany w oparciu o analizę relacji pomiędzy najważniejszymi encjami systemu sprzedaży samochodów. W projekcie przygotowano:
- diagram encji i związków (ERD),
- schemat relacyjny bazy danych,
- klucze główne i obce zapewniające integralność danych,
- powiązania między klientami, dealerami, zamówieniami, samochodami oraz opiniami.

Szczególną uwagę poświęcono spójności logicznej oraz poprawnemu odwzorowaniu zależności pomiędzy obiektami w systemie.

## Użyte technologie

- Oracle APEX
- SQL
- PL/SQL
- relacyjne bazy danych
- Oracle SQL Developer
- modelowanie ER
- projektowanie schematu relacyjnego

## Mój wkład

Moje zadania w projekcie obejmowały:
- projektowanie struktury relacyjnej bazy danych,
- przygotowanie diagramu ER oraz schematu relacyjnego,
- rozwój interfejsu aplikacji w Oracle APEX,
- tworzenie formularzy i widoków do zarządzania danymi,
- implementację walidacji po stronie klienta i serwera,
- obsługę różnych scenariuszy błędów podczas wprowadzania danych,
- dokumentowanie struktury bazy danych oraz głównych przepływów użytkownika.

## Walidacja i obsługa błędów

W aplikacji zaimplementowano mechanizmy walidacji mające na celu poprawę jakości danych oraz zapobieganie niespójnościom w bazie. Uwzględniono między innymi:
- sprawdzanie poprawności danych wejściowych,
- kontrolę wymaganych pól,
- obsługę błędów związanych z duplikatami,
- komunikaty informujące użytkownika o problemach przy wprowadzaniu danych.

Przykładem jest walidacja numeru PESEL klienta, która zapobiega dodaniu rekordu z istniejącym już identyfikatorem.

## Interfejs aplikacji

Aplikacja została zaprojektowana z naciskiem na czytelność i intuicyjną nawigację. Interfejs umożliwia szybki dostęp do najważniejszych sekcji systemu, takich jak:
- klienci,
- dealerzy,
- auta,
- zamówienia,
- opinie,
- modele i komponenty.

Formularze oraz widoki tabelaryczne zostały przygotowane w sposób ułatwiający przeglądanie oraz edycję danych.

## Zawartość repozytorium

Repozytorium zawiera:

- `aplikacja.sql` – eksport aplikacji Oracle APEX
- `skrypt.ddl` – skrypt DDL tworzący strukturę bazy danych
- `diagram-relacji.png` – schemat relacyjny bazy danych
- `diagram-zwiazkow-encji.png` – diagram związków encji (ERD)
- `README.md` – dokumentacja projektu
- `screenshots/` - zrzuty ekranu z działania aplikacji

## Rezultaty projektu

Projekt pozwolił rozwinąć praktyczne umiejętności w zakresie:
- projektowania relacyjnych baz danych,
- modelowania encji i relacji,
- tworzenia aplikacji w Oracle APEX,
- pracy z SQL i PL/SQL,
- walidacji danych i obsługi błędów,
- projektowania interfejsów wspierających zarządzanie danymi.


## Autor

Projekt został zrealizowany w ramach pracy zespołowej na uczelni.  
Mój wkład koncentrował się przede wszystkim na projektowaniu bazy danych, modelowaniu relacji, rozwoju aplikacji w Oracle APEX, walidacji danych oraz poprawie użyteczności interfejsu.
