<?php
require_once __DIR__ . '/../inc/data_utils.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    send_json(array(
        'success' => false,
        'message' => 'Methode non autorisee.',
    ), 405);
}

$data = get_json_body();
$options = get_form_options();
$errors = validate_tree_data($data, $options);

if (!empty($errors)) {
    send_json(array(
        'success' => false,
        'message' => 'Le formulaire contient des erreurs.',
        'errors' => $errors,
    ), 422);
}

$tree = array(
    'espece' => sanitize_text($data['espece']),
    'hauteur_totale' => (float) str_replace(',', '.', $data['hauteur_totale']),
    'hauteur_tronc' => (float) str_replace(',', '.', $data['hauteur_tronc']),
    'diametre_tronc' => (float) str_replace(',', '.', $data['diametre_tronc']),
    'remarquable' => sanitize_text($data['remarquable']),
    'latitude' => (float) str_replace(',', '.', $data['latitude']),
    'longitude' => (float) str_replace(',', '.', $data['longitude']),
    'etat' => sanitize_text($data['etat']),
    'stade_developpement' => sanitize_text($data['stade_developpement']),
    'type_port' => sanitize_text($data['type_port']),
    'type_pied' => sanitize_text($data['type_pied']),
    'age' => null,
    'deracinement' => null,
);

$savedTree = save_added_tree($tree);

send_json(array(
    'success' => true,
    'message' => 'L arbre a bien ete ajoute dans le stockage temporaire.',
    'tree' => $savedTree,
));
