<?php
$currentPage = 'visualisation';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patrimoine arbore - Tableau des arbres</title>
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

    <main class="page-form">
        <section class="container">
            <div class="page-intro">
                <h2>Tableau des arbres en base</h2>
                <p>
                    Cette page affiche les arbres enregistres dans la base de donnees web.
                    Seuls les nouveaux arbres ajoutes depuis l'application apparaissent ici.
                </p>
            </div>

            <div class="table-card">
                <div class="table-header">
                    <h3>Liste des arbres</h3>
                    <p id="tree-count">Chargement...</p>
                </div>

                <div id="table-message" class="message-box" aria-live="polite"></div>

                <div class="table-wrapper">
                    <table class="tree-table">
                        <thead>
                            <tr>
                                <th>Espece</th>
                                <th>Hauteur totale</th>
                                <th>Hauteur tronc</th>
                                <th>Diametre tronc</th>
                                <th>Remarquable</th>
                                <th>Latitude</th>
                                <th>Longitude</th>
                                <th>Etat</th>
                                <th>Stade</th>
                                <th>Port</th>
                                <th>Pied</th>
                            </tr>
                        </thead>
                        <tbody id="tree-table-body">
                            <tr>
                                <td colspan="11">Chargement des donnees...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>

    <script src="assets/js/app.js"></script>
</body>
</html>
