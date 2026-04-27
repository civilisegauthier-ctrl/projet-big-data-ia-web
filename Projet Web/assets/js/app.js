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

document.addEventListener('DOMContentLoaded', function () {
    loadOptions();
    registerForm();
});
