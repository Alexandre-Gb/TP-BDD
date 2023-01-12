CREATE DATABASE db_tp5 ENCODING = 'UTF-8';

/* 2.
   Créez la ou les tables nécessaires pour représenter les informations souhaitées, sans
oublier de spécifier les contraintes et valeurs par défaut pertinentes.
 */
CREATE TABLE carte(
    numcarte serial PRIMARY KEY,
    datecreation date DEFAULT now(),
    points int DEFAULT 0 CHECK ( points >= 0 ),
    numcli int REFERENCES client(numcli) ON DELETE CASCADE ON UPDATE CASCADE,
    idmag int REFERENCES magasin(idmag) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(numcli, idmag)
);

/* 3.
   Noémie Gallois vient de créer une carte de fidélité pour le magasin “La cabale des
cables” de Marseille. Cherchez dans la base de données les informations pertinentes
puis exécutez la requête pour y ajouter sa carte.
 */

 /* Mag 20 */
SELECT idmag FROM magasin WHERE lower(nom) = 'la cabale des cables' AND lower(ville) = 'marseille';

/* Client 25 */
SELECT numcli FROM client WHERE lower(concat(prenom, ' ', nom)) = 'noémie gallois';

INSERT INTO carte(numcli, idmag)
VALUES (25, 20);

/* 4.
 Noémie passe une commande qui lui rapporte 5 points de fidélité. Ajoutez ces points
sur sa carte.
 */
 UPDATE carte SET points = points + 5 WHERE numcli = 25;

/* 5.
Thomas et Diane DuvalJuro (les clients 37 et 38) ont tous les deux créé une carte de fidélité
   au Manut de Marseille (le magasin 9) quand ils s’y sont rendus le 1er janvier 2017.
   Ils ont accumulé respectivement 75 et 40 points de fidélité.
   Créez leurs cartes de fidélité dans la base de données.
 */
INSERT INTO carte(numcli, idmag, points) VALUES (37, 9, 75);
INSERT INTO carte(numcli, idmag, points) VALUES (38, 9, 40);

/* 6.
   Le magasin Manut de Marseille décide d’offrir à ses clients un cadeau de 10% de points de fidélité
   sur toutes les cartes créées avant le 25 décembre 2018.
   Écrivez une requête pour effectuer cette modification.
   Vérifiez que seules les cartes concernées ont été modifiées.
 */
SELECT * FROM carte WHERE datecreation < '2018-12-25' AND idmag = 9;
UPDATE carte SET points = points * 1.10 WHERE datecreation < '2018-12-25' AND idmag = 9;

/* 7.
   Noémie décide de résilier toutes ses cartes de fidélité. Effacez-les de la base.
 */
DELETE FROM carte WHERE numcli = 25;