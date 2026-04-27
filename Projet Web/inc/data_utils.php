<?php

function get_csv_path()
{
    return dirname(__DIR__, 2) . '/Données_V4.csv';
}

function read_tree_data()
{
    $csvPath = get_csv_path();
    $rows = array();

    if (!file_exists($csvPath)) {
        return $rows;
    }

    $handle = fopen($csvPath, 'r');

    if ($handle === false) {
        return $rows;
    }

    $headers = fgetcsv($handle, 0, ';');

    if ($headers === false) {
        fclose($handle);
        return $rows;
    }

    if (!empty($headers[0])) {
        $headers[0] = preg_replace('/^\xEF\xBB\xBF/', '', $headers[0]);
    }

    while (($line = fgetcsv($handle, 0, ';')) !== false) {
        if (count($line) !== count($headers)) {
            continue;
        }

        $rows[] = array_combine($headers, $line);
    }

    fclose($handle);

    return $rows;
}

function get_unique_values($rows, $columnName)
{
    $values = array();

    foreach ($rows as $row) {
        if (!isset($row[$columnName])) {
            continue;
        }

        $value = trim($row[$columnName]);

        if ($value === '' || $value === 'RAS') {
            continue;
        }

        $values[$value] = true;
    }

    $result = array_keys($values);
    sort($result, SORT_NATURAL | SORT_FLAG_CASE);

    return $result;
}

function get_form_options()
{
    $rows = read_tree_data();

    return array(
        'especes' => get_unique_values($rows, 'nomfrancais'),
        'etats' => get_unique_values($rows, 'fk_arb_etat'),
        'stades' => get_unique_values($rows, 'fk_stadedev'),
        'ports' => get_unique_values($rows, 'fk_port'),
        'pieds' => get_unique_values($rows, 'fk_pied'),
        'remarquables' => get_unique_values($rows, 'remarquable'),
    );
}

function get_storage_path()
{
    return dirname(__DIR__) . '/data/arbres_ajoutes.json';
}

function read_added_trees()
{
    $storagePath = get_storage_path();

    if (!file_exists($storagePath)) {
        return array();
    }

    $content = file_get_contents($storagePath);

    if ($content === false || trim($content) === '') {
        return array();
    }

    $data = json_decode($content, true);

    if (!is_array($data)) {
        return array();
    }

    return $data;
}

function save_added_tree($treeData)
{
    $trees = read_added_trees();
    $treeData['id'] = count($trees) + 1;
    $treeData['date_ajout'] = date('Y-m-d H:i:s');
    $trees[] = $treeData;

    file_put_contents(
        get_storage_path(),
        json_encode($trees, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)
    );

    return $treeData;
}

function send_json($data, $statusCode = 200)
{
    http_response_code($statusCode);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function get_json_body()
{
    $body = file_get_contents('php://input');
    $data = json_decode($body, true);

    if (!is_array($data)) {
        return array();
    }

    return $data;
}

function sanitize_text($value)
{
    return trim((string) $value);
}

function validate_tree_data($data, $options)
{
    $errors = array();

    $requiredFields = array(
        'espece',
        'hauteur_totale',
        'hauteur_tronc',
        'diametre_tronc',
        'remarquable',
        'latitude',
        'longitude',
        'etat',
        'stade_developpement',
        'type_port',
        'type_pied',
    );

    foreach ($requiredFields as $field) {
        if (!isset($data[$field]) || sanitize_text($data[$field]) === '') {
            $errors[$field] = 'Ce champ est obligatoire.';
        }
    }

    $listFields = array(
        'espece' => $options['especes'],
        'remarquable' => $options['remarquables'],
        'etat' => $options['etats'],
        'stade_developpement' => $options['stades'],
        'type_port' => $options['ports'],
        'type_pied' => $options['pieds'],
    );

    foreach ($listFields as $field => $allowedValues) {
        if (isset($data[$field]) && sanitize_text($data[$field]) !== '') {
            if (!in_array($data[$field], $allowedValues, true)) {
                $errors[$field] = 'Valeur non autorisée.';
            }
        }
    }

    $numberFields = array('hauteur_totale', 'hauteur_tronc', 'diametre_tronc', 'latitude', 'longitude');

    foreach ($numberFields as $field) {
        if (isset($data[$field]) && sanitize_text($data[$field]) !== '') {
            if (!is_numeric(str_replace(',', '.', $data[$field]))) {
                $errors[$field] = 'Veuillez saisir un nombre valide.';
            }
        }
    }

    return $errors;
}
