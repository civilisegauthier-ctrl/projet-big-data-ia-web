-- ----------------------------------------------------------
-- Script MYSQL pour mcd 
-- ----------------------------------------------------------


-- ----------------------------
-- Table: estimation
-- ----------------------------
CREATE TABLE estimation (
  id_estimation INT NOT NULL,
  age_estim INT NOT NULL,
  clc_nbr_diag INT NOT NULL,
  CONSTRAINT estimation_PK PRIMARY KEY (id_estimation)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: autour_arbre
-- ----------------------------
CREATE TABLE autour_arbre (
  id_autour INT NOT NULL,
  fk_revetement VARCHAR(50) NOT NULL,
  fk_situation VARCHAR(50) NOT NULL,
  CONSTRAINT autour_arbre_PK PRIMARY KEY (id_autour)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: ville
-- ----------------------------
CREATE TABLE ville (
  id_ville INT NOT NULL,
  clc_quartier VARCHAR(50) NOT NULL,
  clc_secteur VARCHAR(50) NOT NULL,
  villeca VARCHAR(50) NOT NULL,
  CONSTRAINT ville_PK PRIMARY KEY (id_ville),
  CONSTRAINT id_ville_UNQ UNIQUE (id_ville)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: espece
-- ----------------------------
CREATE TABLE espece (
  id_espece INT NOT NULL,
  nomfrancais VARCHAR(50) NOT NULL,
  nomlatin VARCHAR(50) NOT NULL,
  CONSTRAINT espece_PK PRIMARY KEY (id_espece)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: etat
-- ----------------------------
CREATE TABLE etat (
  id_etat INT NOT NULL,
  fk_arb_etat VARCHAR(50) NOT NULL,
  fk_stadedev VARCHAR(50) NOT NULL,
  CONSTRAINT etat_PK PRIMARY KEY (id_etat)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: arbre
-- ----------------------------
CREATE TABLE arbre (
  OBJECTID INT NOT NULL AUTO_INCREMENT,
  haut_tot INT NOT NULL,
  haut_tronc INT NOT NULL,
  tronc_diam INT NOT NULL,
  feuillage VARCHAR(50) NOT NULL,
  remarquable VARCHAR(50) NOT NULL,
  fk_port VARCHAR(50) NOT NULL,
  fk_pied VARCHAR(50) NOT NULL,
  id_ville INT NOT NULL,
  id_etat INT NOT NULL,
  id_autour INT NOT NULL,
  id_estimation INT NOT NULL,
  id_espece INT NOT NULL,
  id_position INT NOT NULL,
  CONSTRAINT arbre_PK PRIMARY KEY (OBJECTID),
  CONSTRAINT id_ville_UNQ UNIQUE (id_ville),
  CONSTRAINT arbre_id_ville_FK FOREIGN KEY (id_ville) REFERENCES ville (id_ville),
  CONSTRAINT arbre_id_etat_FK FOREIGN KEY (id_etat) REFERENCES etat (id_etat),
  CONSTRAINT arbre_id_autour_FK FOREIGN KEY (id_autour) REFERENCES autour_arbre (id_autour),
  CONSTRAINT arbre_id_estimation_FK FOREIGN KEY (id_estimation) REFERENCES estimation (id_estimation)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: position
-- ----------------------------
CREATE TABLE position (
  id_position INT NOT NULL,
  X INT NOT NULL,
  Y INT NOT NULL,
  latitude INT NOT NULL,
  longitude INT NOT NULL,
  OBJECTID INT NOT NULL,
  id_ville INT NOT NULL,
  CONSTRAINT position_PK PRIMARY KEY (id_position),
  CONSTRAINT id_ville_UNQ UNIQUE (id_ville),
  CONSTRAINT position_OBJECTID_FK FOREIGN KEY (OBJECTID) REFERENCES arbre (OBJECTID),
  CONSTRAINT position_id_ville_FK FOREIGN KEY (id_ville) REFERENCES ville (id_ville)
)ENGINE=InnoDB;


-- ===== FOREIGN KEYS =====

ALTER TABLE arbre
  ADD CONSTRAINT arbre_id_espece_FK FOREIGN KEY (id_espece)
  REFERENCES espèce (id_espece);

ALTER TABLE arbre
  ADD CONSTRAINT arbre_id_position_FK FOREIGN KEY (id_position)
  REFERENCES position (id_position);

-- ===== INDEX =====
CREATE INDEX OBJECTID_IDX ON arbre (OBJECTID);
CREATE INDEX OBJECTID_IDX ON position (OBJECTID);
