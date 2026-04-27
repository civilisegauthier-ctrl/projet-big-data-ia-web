<?php
$currentPage = 'ajout';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patrimoine arbore - Ajouter un arbre</title>
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
            </nav>
        </div>
    </header>

    <main class="page-form">
        <section class="container">
            <div class="page-intro">
                <p class="eyebrow">Fonctionnalite 2</p>
                <h2>Ajouter un nouvel arbre</h2>
                <p>
                    Les listes du formulaire sont chargees depuis le fichier `Données_V4.csv`.
                    L'age et le deracinement ne sont pas demandes, conformement aux consignes.
                </p>
            </div>

            <div class="form-card">
                <form id="tree-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="espece">Espece</label>
                            <select id="espece" name="espece" required>
                                <option value="">Chargement...</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="remarquable">Arbre remarquable</label>
                            <select id="remarquable" name="remarquable" required>
                                <option value="">Chargement...</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="hauteur_totale">Hauteur totale (m)</label>
                            <input type="number" id="hauteur_totale" name="hauteur_totale" min="0" step="0.1" required>
                        </div>

                        <div class="form-group">
                            <label for="hauteur_tronc">Hauteur du tronc (m)</label>
                            <input type="number" id="hauteur_tronc" name="hauteur_tronc" min="0" step="0.1" required>
                        </div>

                        <div class="form-group">
                            <label for="diametre_tronc">Diametre du tronc (cm)</label>
                            <input type="number" id="diametre_tronc" name="diametre_tronc" min="0" step="0.1" required>
                        </div>

                        <div class="form-group">
                            <label for="etat">Etat de l'arbre</label>
                            <select id="etat" name="etat" required>
                                <option value="">Chargement...</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="stade_developpement">Stade de developpement</label>
                            <select id="stade_developpement" name="stade_developpement" required>
                                <option value="">Chargement...</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="type_port">Type de port</label>
                            <select id="type_port" name="type_port" required>
                                <option value="">Chargement...</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="type_pied">Type de pied</label>
                            <select id="type_pied" name="type_pied" required>
                                <option value="">Chargement...</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="latitude">Latitude</label>
                            <input type="number" id="latitude" name="latitude" step="0.000001" required>
                        </div>

                        <div class="form-group">
                            <label for="longitude">Longitude</label>
                            <input type="number" id="longitude" name="longitude" step="0.000001" required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="button">Enregistrer l'arbre</button>
                    </div>
                </form>

                <div id="form-message" class="message-box" aria-live="polite"></div>
            </div>
        </section>
    </main>

    <script src="assets/js/app.js"></script>
</body>
</html>
