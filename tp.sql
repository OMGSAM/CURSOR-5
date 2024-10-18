--QST1

DELIMITER //

CREATE PROCEDURE afficherComedies()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE numFilm INT;
    DECLARE titre VARCHAR(50);
    DECLARE count_comedies INT DEFAULT 0;

    
    DECLARE film_cursor CURSOR FOR
    SELECT numFilm, titre
    FROM film 
    JOIN genrefilm  ON f.numFilm = gf.numFilm
    WHERE gf.codeGenre = 'CO';

    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    
    OPEN film_cursor;

    
    read_loop: LOOP
        FETCH film_cursor INTO numFilm, titre;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SELECT CONCAT('Numéro du film: ', numFilm, ', Titre: ', titre);
        SET count_comedies = count_comedies + 1;
    END LOOP;

     
    CLOSE film_cursor;

    
    SELECT CONCAT('Nombre total de comédies: ', count_comedies) AS totalComedies;
END //

 



--QST2

CREATE TABLE TableBonus (
    Login VARCHAR(50),
    Bonus REAL,
    nbr INT
);


--QST4

DELIMITER //

CREATE PROCEDURE afficherRealisateur96Films()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE realisateurID INT;
    DECLARE realisateurNom VARCHAR(50);
    DECLARE count_realisateurs INT;

    
    SELECT COUNT(DISTINCT f.realisateur) INTO count_realisateurs
    FROM film 
    GROUP BY f.realisateur
    HAVING COUNT(numFilm) = 96;

    
    IF count_realisateurs = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aucun réalisateur ';
    ELSEIF count_realisateurs > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Plus d''un réalisateur avec 96 films.';
    ELSE
       
        SELECT numIndividu, nomIndividu
        FROM individu 
        JOIN film  ON i.numIndividu = f.realisateur
        GROUP BY numIndividu, nomIndividu
        HAVING COUNT(numFilm) = 96;
    END IF;
END //

 


--EX1


DELIMITER //

CREATE PROCEDURE filmsParCategorieActeur(  acteurID INT)
BEGIN
    SELECT libelleGenre, COUNT(numFilm) AS nombreFilms
    FROM acteur 
    JOIN film  ON a.numFilm = f.numFilm
    JOIN genrefilm  ON f.numFilm = gf.numFilm
    JOIN genre  ON gf.codeGenre = g.codeGenre
    WHERE numIndividu = acteurID
    GROUP BY libelleGenre;
END //

DELIMITER ;



--EX2


DELIMITER //

CREATE PROCEDURE nbFilmsParCategorieActeur(  acteurID INT)
BEGIN
    SELECT libelleGenre, COUNT(numFilm) AS nombreFilms
    FROM acteur a
    JOIN film  ON a.numFilm = f.numFilm
    JOIN genrefilm   ON f.numFilm = gf.numFilm
    JOIN genre   ON gf.codeGenre = g.codeGenre
    WHERE numIndividu = acteurID
    GROUP BY libelleGenre;
END //

DELIMITER ;

--EX3

DELIMITER //

CREATE PROCEDURE nbFilmsSansExemplaire()
BEGIN
    SELECT COUNT(numFilm) AS filmsSansExemplaire
    FROM film 
    LEFT JOIN exemplaire  ON f.numFilm = e.numFilm
    WHERE numExemplaire IS NULL;
END //

DELIMITER ;



