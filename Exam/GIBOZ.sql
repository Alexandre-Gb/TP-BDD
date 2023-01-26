--  Utilisez le script boardgame.sql afin de créer la base de données qui sera utilisée pour les questions suivantes.
--  Prenez le temps de vous familiariser avec les différentes tables et leur contenu avant de commencer à répondre aux questions.
--  Pour chaque question, donnez la requête SQL permettant d'obtenir le résultat demandé, et ajoutez en commentaire le nombre de lignes renvoyées par cette requête. Pour les requêtes ne renvoyant qu'une seule ligne, indiquez également la ligne renvoyée.
--  Soignez la présentation (indentation, nom des variables, etc.) de vos requêtes. La lisibilité de votre travail sera prise en compte.
--  A la fin du TP, déposez votre fichier dans la zone de rendu prévue à cet effet sur elearning.
--  Pensez à enregistrer régulièrement votre travail afin de ne pas le perdre en cas de panne.
--
--
--1. La liste de tous les jeux avec tous leurs attributs.
SELECT *
FROM jeu;
-- 24 lignes


--2. La liste des pseudonymes de joueurs qui ont déjà organisé une partie, sans doublons.
SELECT DISTINCT pseudo
FROM joueur
WHERE pseudo IN
      (SELECT organisateur
       FROM partie);
-- 154 lignes


--3. Le nom complet (prénom nom) des joueurs de sexe féminin.
SELECT CONCAT(prenom, ' ', nom) AS nom_complet
FROM joueur
WHERE lower(sexe) = 'f';
-- 74 lignes

--4. La liste des joueurs (pseudo, prenom, naissance) qui sont nés en 2000.
SELECT pseudo, prenom, naissance
FROM joueur
WHERE naissance BETWEEN '2000-01-01' AND '2000-12-31';
-- 14 lignes


--5. La liste des joueurs (pseudo) qui n'ont pas renseigné soit leur nom ou leur sexe.
SELECT pseudo
FROM joueur
WHERE nom IS NULL
   OR sexe IS NULL;
-- 79 lignes


--6. La liste des joueurs (pseudo, nom, prenom) qui ont gagné une partie de 7Wonders.
SELECT pseudo,
       nom,
       prenom
FROM joueur
    NATURAL JOIN participe
    NATURAL JOIN partie
    NATURAL JOIN jeu
WHERE lower(jeu.titre) = '7wonders'
    AND rang = 1
    AND partie.statut = 'terminée';
-- 38 Lignes


--7. Les joueurs (pseudo, prenom, nom) qui ont déjà organisé une partie de Dixit.
SELECT pseudo,
       prenom,
       nom
FROM joueur
    NATURAL JOIN partie
    NATURAL JOIN jeu
WHERE lower(jeu.titre) = 'dixit'
    AND organisateur = pseudo;
-- 32 Lignes


--8. Le joueur (pseudo, prenom, nom, naissance) le plus jeune de la plateforme.
SELECT pseudo,
       prenom,
       nom,
       naissance
FROM joueur
WHERE naissance =
      (SELECT max(naissance)
       FROM joueur)
LIMIT 1;
-- 1 Ligne


--9. Les joueurs (pseudo) qui ont déjà organisé au moins une partie de Codenames et une partie de Decrypto.
SELECT pseudo
FROM joueur
WHERE pseudo IN
      (SELECT organisateur
       FROM partie
                NATURAL JOIN jeu
       WHERE lower(jeu.titre) = 'codenames' )
  AND pseudo IN
      (SELECT organisateur
       FROM partie
                NATURAL JOIN jeu
       WHERE lower(jeu.titre) = 'decrypto' );
-- 10 Lignes


--10. Les joueurs (pseudo) qui n'ont jamais gagné à aucun jeu.
SELECT pseudo
FROM joueur
WHERE pseudo NOT IN
      (SELECT pseudo
       FROM joueur
           NATURAL JOIN participe
           NATURAL JOIN partie
        WHERE rang = 1
            AND statut = 'terminée');
-- 1 Ligne


--11. Les nombres minimum et maximum de joueurs pour jouer une partie (quel que soit le jeu).
SELECT max(nbmax) AS nb_max,
       min(nbmin) AS nb_min
FROM jeu;
-- 24 Lignes


--12. La liste des joueurs (pseudo), avec pour chacun le nombre de parties qu'il a organisées,
-- triée par nombre de parties organisées décroissant.
-- Attention à ne pas perdre les joueurs qui n'ont jamais organisé de parties !
SELECT pseudo,
       count(organisateur) AS nb_organisees
FROM joueur
    LEFT JOIN partie ON joueur.pseudo = partie.organisateur
GROUP BY pseudo
ORDER BY nb_organisees DESC;
-- 200 Lignes


--13. La liste des parties (idpartie, titre du jeu) en attente qui ne peuvent pas accueillir plus de joueurs.
SELECT idpartie,
       titre
FROM partie
    NATURAL JOIN jeu
WHERE statut = 'en attente'
AND nbmax =
    (SELECT count(*) FROM participe
    WHERE idpartie = partie.idpartie);
-- 11 Lignes


--14. La liste des joueurs (pseudo) qui ont joué au moins 3 parties de '6 qui prend!', triée par nombre de parties jouées décroissant.
SELECT pseudo
FROM joueur
    NATURAL JOIN participe
    NATURAL JOIN partie
    NATURAL JOIN jeu
WHERE lower(titre) = '6 qui prend!'
GROUP BY pseudo
HAVING COUNT(*) >= 3
ORDER BY COUNT(*) DESC;
-- 18 Lignes


--15. La liste des paires de joueurs (pseudo1, pseudo2) qui sont arrivés ex aequo dans une partie de Saboteur.
SELECT t1.pseudo AS pseudo1,
       t2.pseudo AS pseudo2
FROM participe AS t1
    NATURAL JOIN participe AS t2
    NATURAL JOIN partie NATURAL JOIN jeu
WHERE lower(titre) = 'saboteur'
AND t1.rang = t2.rang
AND t1.idpartie = t2.idpartie
AND t1.pseudo <> t2.pseudo;
-- 218 Lignes


--16. Le nombre moyen de parties jouées par joueur.
SELECT pseudo,
       avg(nb_parties) AS moyenne_parties
FROM
    (SELECT pseudo,
            count(*) AS nb_parties
    FROM joueur
        NATURAL JOIN participe
    GROUP BY pseudo) AS moy_parties
GROUP BY pseudo;
-- 200 Lignes


--17. La liste des jeux (titre, idjeu), avec pour chacun le nombre moyen de joueurs dans une partie terminée de ce jeu.
SELECT idjeu,
       titre,
       avg(nb_joueurs) AS moyenne_joueurs
FROM
    (SELECT titre,
            idjeu,
            count(*) AS nb_joueurs
    FROM jeu
        NATURAL JOIN partie
        NATURAL JOIN participe
    WHERE statut = 'terminée'
    GROUP BY titre, idjeu) AS moy_joueurs
GROUP BY titre, idjeu
ORDER BY idjeu;
-- 24 Lignes


--18. La liste des jeux (titre), avec pour chacun le pseudo d'un des joueurs qui a gagné le plus de parties de ce jeu.
SELECT titre,
       pseudo
FROM
    (SELECT titre,
            pseudo,
            count(*) AS nb_victoires
    FROM jeu
        NATURAL JOIN partie
        NATURAL JOIN participe
    WHERE rang = 1
    GROUP BY titre, pseudo) AS victoires
WHERE nb_victoires =
    (SELECT max(nb_victoires)
     FROM (SELECT titre,
                  pseudo,
                  count(*) AS nb_victoires
           FROM jeu
               NATURAL JOIN partie
               NATURAL JOIN participe
           WHERE rang = 1
           GROUP BY titre, pseudo) AS victoires
     WHERE titre = victoires.titre
);
-- 3 Lignes


--19. La liste des joueurs (pseudo), avec pour chacun son taux de victoire, c'est-à-dire
-- le pourcentage de parties qu'il a gagnées par rapport au nombre de parties qu'il a jouées,
-- triée par taux de victoire décroissant.
SELECT pseudo,
       (100*victoires)/parties AS taux
FROM
    (SELECT joueur.pseudo,
            count(*) AS parties
     FROM joueur
              LEFT JOIN participe ON joueur.pseudo = participe.pseudo
     GROUP BY joueur.pseudo) AS parties_jouees
        NATURAL JOIN
    (SELECT joueur.pseudo,
            count(*) AS victoires
     FROM joueur
              LEFT JOIN participe ON joueur.pseudo = participe.pseudo
              LEFT JOIN partie ON participe.idpartie = partie.idpartie
     WHERE statut = 'terminée'
       AND rang = 1
     GROUP BY joueur.pseudo) AS parties_gagnees
ORDER BY taux DESC;
-- 199 Lignes


--20. Les joueurs qui ont gagné au moins une partie de tous les jeux dont ils ont déjà organisé une partie.
SELECT pseudo
FROM joueur
    NATURAL JOIN participe
    NATURAL JOIN partie
WHERE rang = 1
AND statut = 'terminée'
AND idjeu IN
    (SELECT idjeu
     FROM partie
    WHERE organisateur = joueur.pseudo)
  AND idjeu NOT IN
      (SELECT idjeu
       FROM partie
       WHERE organisateur = joueur.pseudo
       AND idpartie NOT IN
           (SELECT idpartie
            FROM participe
            WHERE pseudo = joueur.pseudo
            AND rang <> 1
            AND statut = 'terminée')
);
-- 29 Lignes