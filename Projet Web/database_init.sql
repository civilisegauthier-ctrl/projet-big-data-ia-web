-- ----------------------------------------------------------
-- Script MySQL pour l'application web
-- Projet : gestion du patrimoine arbore - Saint-Quentin
-- ----------------------------------------------------------

-- Pour relancer facilement le script
DROP TABLE IF EXISTS position;
DROP TABLE IF EXISTS arbre;
DROP TABLE IF EXISTS estimation;
DROP TABLE IF EXISTS autour_arbre;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS espece;
DROP TABLE IF EXISTS ville;


-- ----------------------------
-- Table: estimation
-- Remarque :
-- l'age n'est pas fourni lors de l'ajout d'un nouvel arbre,
-- donc cette table peut rester vide au debut.
-- ----------------------------
CREATE TABLE estimation (
  id_estimation INT NOT NULL AUTO_INCREMENT,
  age_estim INT NULL,
  clc_nbr_diag INT NULL,
  CONSTRAINT estimation_PK PRIMARY KEY (id_estimation)
) ENGINE=InnoDB;


-- ----------------------------
-- Table: autour_arbre
-- ----------------------------
CREATE TABLE autour_arbre (
  id_autour INT NOT NULL AUTO_INCREMENT,
  fk_revetement VARCHAR(50) NULL,
  fk_situation VARCHAR(50) NULL,
  CONSTRAINT autour_arbre_PK PRIMARY KEY (id_autour)
) ENGINE=InnoDB;


-- ----------------------------
-- Table: ville
-- Une ville contient plusieurs arbres.
-- On retire donc toute contrainte UNIQUE inutile sur id_ville
-- dans les autres tables.
-- ----------------------------
CREATE TABLE ville (
  id_ville INT NOT NULL AUTO_INCREMENT,
  clc_quartier VARCHAR(50) NOT NULL,
  clc_secteur VARCHAR(50) NOT NULL,
  villeca VARCHAR(50) NOT NULL,
  CONSTRAINT ville_PK PRIMARY KEY (id_ville)
) ENGINE=InnoDB;


-- ----------------------------
-- Table: espece
-- ----------------------------
CREATE TABLE espece (
  id_espece INT NOT NULL AUTO_INCREMENT,
  nomfrancais VARCHAR(50) NOT NULL,
  nomlatin VARCHAR(50) NULL,
  CONSTRAINT espece_PK PRIMARY KEY (id_espece)
) ENGINE=InnoDB;


-- ----------------------------
-- Table: etat
-- Le schema d'origine regroupait l'etat et le stade
-- dans la meme table. On le conserve pour rester proche
-- de votre MCD, meme si ce n'est pas ideal en normalisation.
-- ----------------------------
CREATE TABLE etat (
  id_etat INT NOT NULL AUTO_INCREMENT,
  fk_arb_etat VARCHAR(50) NOT NULL,
  fk_stadedev VARCHAR(50) NOT NULL,
  CONSTRAINT etat_PK PRIMARY KEY (id_etat)
) ENGINE=InnoDB;


-- ----------------------------
-- Table: arbre
-- id_estimation reste facultatif car age/diagnostic
-- ne sont pas fournis dans la fonctionnalite 2.
-- feuillage reste facultatif pour la meme raison.
-- id_position a ete retire pour eviter la dependance
-- circulaire avec la table position.
-- ----------------------------
CREATE TABLE arbre (
  OBJECTID INT NOT NULL AUTO_INCREMENT,
  haut_tot INT NOT NULL,
  haut_tronc INT NOT NULL,
  tronc_diam INT NOT NULL,
  feuillage VARCHAR(50) NULL,
  remarquable VARCHAR(50) NOT NULL,
  fk_port VARCHAR(50) NOT NULL,
  fk_pied VARCHAR(50) NOT NULL,
  id_ville INT NOT NULL,
  id_etat INT NOT NULL,
  id_autour INT NULL,
  id_estimation INT NULL,
  id_espece INT NOT NULL,
  CONSTRAINT arbre_PK PRIMARY KEY (OBJECTID),
  CONSTRAINT arbre_id_ville_FK FOREIGN KEY (id_ville)
    REFERENCES ville (id_ville),
  CONSTRAINT arbre_id_etat_FK FOREIGN KEY (id_etat)
    REFERENCES etat (id_etat),
  CONSTRAINT arbre_id_autour_FK FOREIGN KEY (id_autour)
    REFERENCES autour_arbre (id_autour),
  CONSTRAINT arbre_id_estimation_FK FOREIGN KEY (id_estimation)
    REFERENCES estimation (id_estimation),
  CONSTRAINT arbre_id_espece_FK FOREIGN KEY (id_espece)
    REFERENCES espece (id_espece)
) ENGINE=InnoDB;


-- ----------------------------
-- Table: position
-- Une position appartient a un arbre.
-- Les coordonnees GPS sont stockees en DECIMAL.
-- X et Y sont gardes mais rendus facultatifs.
-- ----------------------------
CREATE TABLE position (
  id_position INT NOT NULL AUTO_INCREMENT,
  X DECIMAL(12,4) NULL,
  Y DECIMAL(12,4) NULL,
  latitude DECIMAL(10,7) NOT NULL,
  longitude DECIMAL(10,7) NOT NULL,
  OBJECTID INT NOT NULL,
  id_ville INT NULL,
  CONSTRAINT position_PK PRIMARY KEY (id_position),
  CONSTRAINT position_OBJECTID_FK FOREIGN KEY (OBJECTID)
    REFERENCES arbre (OBJECTID),
  CONSTRAINT position_id_ville_FK FOREIGN KEY (id_ville)
    REFERENCES ville (id_ville)
) ENGINE=InnoDB;


-- ----------------------------
-- Index utiles
-- ----------------------------
CREATE INDEX arbre_id_ville_IDX ON arbre (id_ville);
CREATE INDEX arbre_id_etat_IDX ON arbre (id_etat);
CREATE INDEX arbre_id_espece_IDX ON arbre (id_espece);
CREATE INDEX position_OBJECTID_IDX ON position (OBJECTID);
CREATE INDEX position_id_ville_IDX ON position (id_ville);
