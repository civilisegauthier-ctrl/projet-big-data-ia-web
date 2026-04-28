function fillSelect(selectId, values, placeholder) {
    var select = document.getElementById(selectId);

    if (!select) {
        return;
    }

    select.innerHTML = '';

    var defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = placeholder;
    select.appendChild(defaultOption);

    values.forEach(function (value) {
        var option = document.createElement('option');
        option.value = value;
        option.textContent = value;
        select.appendChild(option);
    });
}

function showMessage(text, type) {
    var box = document.getElementById('form-message');

    if (!box) {
        return;
    }

    box.textContent = text;
    box.className = 'message-box ' + type;
}

function showTableMessage(text, type) {
    var box = document.getElementById('table-message');

    if (!box) {
        return;
    }

    box.textContent = text;
    box.className = 'message-box ' + type;
}

function showActionMessage(text, type) {
    var box = document.getElementById('action-message');

    if (!box) {
        return;
    }

    box.textContent = text;
    box.className = 'message-box ' + type;
}

function showMapMessage(text, type) {
    var box = document.getElementById('map-message');

    if (!box) {
        return;
    }

    box.textContent = text;
    box.className = 'message-box ' + type;
}

function loadOptions() {
    fetch('api/options.php')
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (!data.success) {
                showMessage('Impossible de charger les listes du formulaire.', 'error');
                return;
            }

            fillSelect('espece', data.options.especes, 'Choisir une espece');
            fillSelect('remarquable', data.options.remarquables, 'Choisir une valeur');
            fillSelect('etat', data.options.etats, 'Choisir un etat');
            fillSelect('stade_developpement', data.options.stades, 'Choisir un stade');
            fillSelect('type_port', data.options.ports, 'Choisir un type de port');
            fillSelect('type_pied', data.options.pieds, 'Choisir un type de pied');
        })
        .catch(function () {
            showMessage('Une erreur est survenue pendant le chargement des options.', 'error');
        });
}

function getFormData(form) {
    var formData = new FormData(form);

    return {
        espece: formData.get('espece'),
        hauteur_totale: formData.get('hauteur_totale'),
        hauteur_tronc: formData.get('hauteur_tronc'),
        diametre_tronc: formData.get('diametre_tronc'),
        remarquable: formData.get('remarquable'),
        latitude: formData.get('latitude'),
        longitude: formData.get('longitude'),
        etat: formData.get('etat'),
        stade_developpement: formData.get('stade_developpement'),
        type_port: formData.get('type_port'),
        type_pied: formData.get('type_pied')
    };
}

function registerForm() {
    var form = document.getElementById('tree-form');

    if (!form) {
        return;
    }

    form.addEventListener('submit', function (event) {
        event.preventDefault();

        var data = getFormData(form);

        fetch('api/ajouter_arbre.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (result) {
                if (!result.success) {
                    showMessage(result.message, 'error');
                    return;
                }

                form.reset();
                showMessage(result.message, 'success');
            })
            .catch(function () {
                showMessage('L enregistrement a echoue.', 'error');
            });
    });
}

function createTableCell(text) {
    var cell = document.createElement('td');
    cell.textContent = text;
    return cell;
}

function renderTreeTable(trees) {
    var tableBody = document.getElementById('tree-table-body');
    var treeCount = document.getElementById('tree-count');

    if (!tableBody || !treeCount) {
        return;
    }

    tableBody.innerHTML = '';
    treeCount.textContent = trees.length + ' arbre(s) enregistre(s)';

    if (trees.length === 0) {
        var emptyRow = document.createElement('tr');
        var emptyCell = document.createElement('td');
        emptyCell.colSpan = 11;
        emptyCell.textContent = 'Aucun arbre n est encore enregistre dans la base.';
        emptyRow.appendChild(emptyCell);
        tableBody.appendChild(emptyRow);
        return;
    }

    trees.forEach(function (tree) {
        var row = document.createElement('tr');

        row.appendChild(createTableCell(tree.espece));
        row.appendChild(createTableCell(tree.hauteur_totale));
        row.appendChild(createTableCell(tree.hauteur_tronc));
        row.appendChild(createTableCell(tree.diametre_tronc));
        row.appendChild(createTableCell(tree.remarquable));
        row.appendChild(createTableCell(tree.latitude));
        row.appendChild(createTableCell(tree.longitude));
        row.appendChild(createTableCell(tree.etat));
        row.appendChild(createTableCell(tree.stade_developpement));
        row.appendChild(createTableCell(tree.type_port));
        row.appendChild(createTableCell(tree.type_pied));

        tableBody.appendChild(row);
    });
}

function loadTrees() {
    var tableBody = document.getElementById('tree-table-body');

    if (!tableBody) {
        return;
    }

    fetch('api/arbres.php')
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (!data.success) {
                showTableMessage('Impossible de charger les arbres.', 'error');
                return;
            }

            renderTreeTable(data.trees);
        })
        .catch(function () {
            showTableMessage('Une erreur est survenue pendant le chargement du tableau.', 'error');
        });
}

function loadMap() {
    var button = document.getElementById('show-map-button');
    var mapCard = document.getElementById('map-card');
    var frame = document.getElementById('tree-map-frame');
    var clusterSelect = document.getElementById('map-clusters');

    if (!button || !mapCard || !frame || !clusterSelect) {
        return;
    }

    showMapMessage('Chargement de la carte...', 'success');

    fetch('api/carte.php?clusters=' + encodeURIComponent(clusterSelect.value))
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (!data.success) {
                showMapMessage(data.message || 'Impossible de charger la carte.', 'error');
                return;
            }

            mapCard.classList.remove('hidden-section');
            frame.srcdoc = data.map_html;
            showMapMessage('Carte chargee avec succes.', 'success');
        })
        .catch(function () {
            showMapMessage('Une erreur est survenue pendant le chargement de la carte.', 'error');
        });
}

function registerVisualisationActions() {
    var predictButton = document.getElementById('predict-age-button');
    var mapButton = document.getElementById('show-map-button');
    var clusterSelect = document.getElementById('map-clusters');

    if (predictButton) {
        predictButton.addEventListener('click', function () {
            showActionMessage('La prediction de l age sera ajoutee dans une prochaine fonctionnalite.', 'success');
        });
    }

    if (mapButton) {
        mapButton.addEventListener('click', function () {
            loadMap();
        });
    }

    if (clusterSelect) {
        clusterSelect.addEventListener('change', function () {
            var mapCard = document.getElementById('map-card');

            if (mapCard && !mapCard.classList.contains('hidden-section')) {
                loadMap();
            }
        });
    }
}

document.addEventListener('DOMContentLoaded', function () {
    loadOptions();
    registerForm();
    loadTrees();
    registerVisualisationActions();
});
