/* EXO 1 */

/* 1.
   Le nombre total de factures stockées dans la base de données.
 */
SELECT count(*) FROM facture;

/* 2.
   La liste des noms de magasins, avec pour chacun le nombre de villes où ils sont
implantés. Le nombre maximum à trouver est 4.
 */
SELECT nom, count(DISTINCT ville) FROM magasin GROUP BY nom;

/* 3.
   La liste des numéros et noms de clients avec pour chacun le nombre de factures qui
le concernent. Attention à ne pas perdre les clients qui n’ont jamais rien acheté.
 */
SELECT numcli, nom, count(idfac) AS nb_factures
FROM client NATURAL JOIN facture
GROUP BY (numcli, nom);

/* 4.
    Le prix moyen, minimum et maximum d’un bureau à Paris.
 */
SELECT avg(prixunit) AS prix_moyen, min(prixunit) AS prix_min, max(prixunit) AS prix_max
FROM magasin NATURAL JOIN facture NATURAL JOIN produit NATURAL JOIN stocke
WHERE lower(libelle) = 'bureau' AND lower(magasin.ville) = 'paris';

/* 5.
   La liste des meilleurs prix pour chaque libellé de produit.
 */
SELECT libelle, min(prixunit) AS meilleur_prix
FROM produit NATURAL JOIN stocke GROUP BY libelle;

/* 6.
   La liste de toutes les factures, avec pour chacune le nom complet
   du client qui l’a contractée et son montant total,
   triées par montant décroissant.
   La facture la plus chère coûte 1712.45 euros.
 */
SELECT idfac, concat(prenom, ' ', nom) AS nom_complet, sum(prixunit * quantite) AS montant_total
FROM contient NATURAL JOIN facture NATURAL JOIN client
GROUP BY (idfac, nom_complet)
ORDER BY montant_total DESC;

/* 7.
   La liste des magasins qui vendent au moins 20 produits de libellés différents.
 */
SELECT nom, count(DISTINCT libelle) AS nb_produits
FROM magasin NATURAL JOIN stocke NATURAL JOIN produit
GROUP BY nom HAVING count(DISTINCT libelle) >= 20;

/* 8.

 */