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

            <div class="action-card">
                <div class="action-buttons">
                    <button type="button" id="toggle-age-button" class="button secondary-button">Predire l age de l arbre</button>
                    <button type="button" id="toggle-size-button" class="button secondary-button">Predire la taille de l arbre</button>
                    <button type="button" id="toggle-map-button" class="button">Afficher la carte</button>
                </div>
                <div id="action-message" class="message-box" aria-live="polite"></div>
            </div>

            <div id="age-card" class="table-card toggle-panel hidden-section">
                <div class="table-header">
                    <h3>Prediction de l age</h3>
                    <p>Fonctionnalite a implementer plus tard</p>
                </div>

                <div class="placeholder-box">
                    <p>Cette zone est reservee a la future prediction de l age de l arbre.</p>
                </div>
            </div>

            <div id="size-card" class="table-card prediction-card toggle-panel hidden-section">
                <div class="table-header">
                    <h3>Prediction de taille</h3>
                    <p>Traitement Python via AJAX</p>
                </div>

                <form id="size-prediction-form" class="prediction-form">
                    <div class="prediction-fields">
                        <div class="form-group">
                            <label for="prediction-height">Hauteur de l arbre (m)</label>
                            <input type="number" id="prediction-height" name="hauteur" min="0" step="1" required>
                        </div>

                        <div class="form-group">
                            <label for="prediction-clusters">Nombre de categories</label>
                            <select id="prediction-clusters" name="clusters" required>
                                <option value="2">2 categories</option>
                                <option value="3">3 categories</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="button">Predire la taille</button>
                    </div>
                </form>

                <div id="prediction-message" class="message-box" aria-live="polite"></div>
            </div>

            <div id="map-card" class="table-card toggle-panel hidden-section">
                <div class="table-header">
                    <h3>Carte des arbres</h3>
                    <p>Visualisation generee par Python</p>
                </div>

                <div class="map-controls">
                    <label for="map-clusters">Nombre de categories</label>
                    <select id="map-clusters">
                        <option value="2">2 categories</option>
                        <option value="3">3 categories</option>
                    </select>
                </div>

                <div id="map-message" class="message-box" aria-live="polite"></div>
                <div class="map-frame-wrapper">
                    <iframe id="tree-map-frame" title="Carte des arbres"></iframe>
                </div>
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
