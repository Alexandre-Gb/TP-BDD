/* EXO 1 */

/* 4.
 Recupérez sur la page du cours le fichier magasin.sql, qui contient un dump d’une
base de données, c’est-à-dire un script SQL constitué d’une liste de commandes
permettant de créer les tables de la base de données voulue et de les remplir.
Exécutez le script fourni
 */

\i 'C:/Users/Alexey/OneDrive/ESIPE INFO/Info 1/Bases de Donnees/TPs/TP4/magasin.sql'


/* 5.
 Affichez la liste des tables créées et le schéma de chaque table.
La base de données fournie contient des informations sur des chaines de magasins,
les produits qu’ils vendent, leurs stocks, leurs clients, et les commandes qu’ils ont
passées. Prenez le temps de vous familiariser avec l’organisation de la base.
 */

 \c db_tp4
 \d



 /* EXO 2 */

 /* 1.
  La liste de tous les magasins, avec leur nom, leur ville et leur numéro de téléphone.
  */
SELECT nom, ville, tel FROM magasin;


/* 2.
  La liste des noms et prénoms de tous les clients
 */
SELECT nom, prenom FROM client;


/* 3.
   La liste des noms complets de tous les clients. Par exemple, pour la cliente dont le
nom est Gallois et le prénom Noémie, votre requête doit renvoyer la chaîne “Noémie
Gallois” dans une seule colonne.
 */
SELECT concat(nom, ' ', prenom) FROM client;


/* 4.
Modifiez la requête précédente pour éliminer les homonymes
 */
SELECT DISTINCT concat(nom, ' ', prenom) FROM client;


/* 5.
La liste des villes où il y a un magasin.
 */
SELECT DISTINCT ville FROM magasin;


/* 6.
La liste de toutes les informations sur les produits qui sont des souris.
 */

SELECT * FROM produit WHERE libelle = 'souris';


/* 7.
La liste des identifiants et libellés de produits dont la couleur n’est pas renseignée.
 */

SELECT idpro, libelle FROM produit WHERE couleur IS NULL;


/* 8.
La liste des libellés de produits qui sont des cables (quel que soit le type de cable).
 */

SELECT libelle FROM produit WHERE lower(libelle) LIKE 'cable%';


/* 9.
La liste des numéros de clients qui ont acheté des produits dans le magasin 17.
 */

SELECT DISTINCT numcli FROM facture WHERE idmag = 17;


/* 10.
La liste des noms et prénoms des clients qui ont acheté des produits dans le
magasin 17.
 */

SELECT DISTINCT nom, prenom FROM client, facture
WHERE client.numcli = facture.numcli
AND facture.idmag = 17;


/* 11.
La liste des magasins (idmag, nom, ville) qui ont des souris en stock
 */
SELECT magasin.idmag, nom, ville FROM magasin, stocke, produit
WHERE magasin.idmag = stocke.idmag
AND stocke.idpro = produit.idpro
AND lower(libelle) = 'souris';


/* 12.
Le nom et la ville du magasin le moins cher pour acheter une souris verte, avec le
prix du produit.
 */
SELECT nom, ville, prixunit FROM magasin, stocke, produit
WHERE magasin.idmag = stocke.idmag
AND stocke.idpro = produit.idpro
AND lower(libelle) = 'souris' AND lower(couleur) = 'vert'
LIMIT 1;


/* 13.
La liste des identifiants et noms de produits qui ont été vendus à plus de 120 euros
avec le prix de vente et le nom de l’acheteur.
 */
SELECT produit.idpro, libelle, concat(client.prenom, ' ', client.nom), prixunit
FROM produit, contient, facture, client
WHERE produit.idpro = contient.idpro
AND contient.idfac = facture.idfac
AND facture.numcli = client.numcli
AND prixunit > 120;


/* 14.
La liste des identifiants, libellés et prix de produits que l’on peut trouver à moins
de 5 euros en magasin, triés par prix croissants.
 */
SELECT produit.idpro, libelle, stocke.prixunit FROM produit, stocke
WHERE produit.idpro = stocke.idpro
AND prixunit < 5
ORDER BY prixunit;


/* 15.
La liste des libellés de produits qui existent à la fois en bleu et en jaune
 */
SELECT libelle FROM produit WHERE couleur = 'bleu'
INTERSECT
SELECT libelle FROM produit WHERE couleur = 'jaune';


/* 16.
La liste des numéros, noms et prénoms des clients qui ont acheté un bureau.
 */
SELECT client.numcli, prenom, nom FROM client, facture, contient, produit
WHERE client.numcli = facture.numcli
AND facture.idfac = contient.idfac
AND contient.idpro = produit.idpro
AND lower(libelle) = 'bureau';


/* 17.
La liste des numéros, noms et prénoms des clients qui n’ont jamais acheté de bureau.
 */
SELECT client.numcli, prenom, nom FROM client
EXCEPT
SELECT client.numcli, prenom, nom FROM client NATURAL JOIN facture NATURAL JOIN contient NATURAL JOIN produit
WHERE lower(libelle) = 'bureau';

