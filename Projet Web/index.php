<?php
$currentPage = 'accueil';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patrimoine arbore - Accueil</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <header class="site-header">
        <div class="container">
            <div class="brand">
                <p class="brand-top">Ville de Saint-Quentin</p>
                <h1>Gestion du patrimoine arbore</h1>
            </div>

            <nav class="main-nav">
                <a href="index.php" class="<?php echo $currentPage === 'accueil' ? 'active' : ''; ?>">Accueil</a>
                <a href="ajouter-arbre.php" class="<?php echo $currentPage === 'ajout' ? 'active' : ''; ?>">Ajouter un arbre</a>
                <a href="visualiser-arbres.php" class="<?php echo $currentPage === 'visualisation' ? 'active' : ''; ?>">Voir les arbres</a>
            </nav>
        </div>
    </header>

    <main>
        <section class="hero">
            <div class="container hero-content">
                <div class="hero-text">
                    <p class="eyebrow">Preuve de concept</p>
                    <h2>Une application simple pour suivre les arbres de Saint-Quentin</h2>
                    <p>
                        Ce site permet de centraliser les informations utiles sur les arbres de la ville,
                        de mieux suivre leur etat et de preparer l'ajout de nouveaux sujets dans une base commune.
                    </p>
                    <p>
                        L'objectif du projet est de proposer une base web claire, facile a expliquer
                        et compatible avec une architecture front-end HTML/CSS/JavaScript et back-end PHP.
                    </p>
                    <a class="button" href="ajouter-arbre.php">Acceder au formulaire</a>
                </div>

                <div class="hero-visual">
                    <img src="assets/img/foret-urbaine.svg" alt="Illustration d'arbres en ville">
                </div>
            </div>
        </section>

        <section class="project-section">
            <div class="container cards">
                <article class="card">
                    <h3>Pourquoi ce projet ?</h3>
                    <p>
                        Le patrimoine arbore fait partie du paysage urbain. Une application dediee aide
                        a mieux organiser les donnees, suivre l'etat des arbres et faciliter les futures analyses.
                    </p>
                </article>

                <article class="card">
                    <h3>Fonctionnalites visees</h3>
                    <p>
                        Cette premiere version inclut une page d'accueil, un menu de navigation, un formulaire
                        d'ajout d'arbre et un tableau pour visualiser les arbres enregistres en base.
                    </p>
                </article>

                <article class="card">
                    <h3>Approche technique</h3>
                    <p>
                        Les pages communiquent avec le back-end en AJAX. Les reponses sont envoyees en JSON,
                        ce qui facilitera ensuite le branchement sur MySQL ou PostgreSQL.
                    </p>
                </article>
            </div>
        </section>
    </main>
</body>
</html>
