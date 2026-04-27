<?php

function get_db_connection()
{
    $host = 'localhost';
    $db = 'patrimoine_arbore';
    $user = 'root';
    $pass = 'root';
    $charset = 'utf8mb4';

    $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
    $options = array(
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    );

    try {
        return new PDO($dsn, $user, $pass, $options);
    } catch (PDOException $e) {
        throw new PDOException($e->getMessage(), (int)$e->getCode());
    }
}

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

    $headers = fgetcsv($handle, 0, ';', '"', '\\');

    if ($headers === false) {
        fclose($handle);
        return $rows;
    }

    if (!empty($headers[0])) {
        $headers[0] = preg_replace('/^\xEF\xBB\xBF/', '', $headers[0]);
    }

    while (($line = fgetcsv($handle, 0, ';', '"', '\\')) !== false) {
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

    // Les listes du formulaire viennent toujours du CSV.
    // Cela permet d'avoir des choix disponibles meme si la base SQL est vide.
    return array(
        'especes' => get_unique_values($rows, 'nomfrancais'),
        'etats' => get_unique_values($rows, 'fk_arb_etat'),
        'stades' => get_unique_values($rows, 'fk_stadedev'),
        'ports' => get_unique_values($rows, 'fk_port'),
        'pieds' => get_unique_values($rows, 'fk_pied'),
        'remarquables' => get_unique_values($rows, 'remarquable'),
    );
}

function read_added_trees()
{
    $pdo = get_db_connection();
    $stmt = $pdo->query("SELECT * FROM added_trees ORDER BY date_ajout DESC");

    return $stmt->fetchAll();
}

function read_trees_for_table()
{
    $trees = read_added_trees();

    return $trees;
}

function save_added_tree($treeData)
{
    $pdo = get_db_connection();

    $sql = "INSERT INTO added_trees (
                espece,
                hauteur_totale,
                hauteur_tronc,
                diametre_tronc,
                remarquable,
                latitude,
                longitude,
                etat,
                stade_developpement,
                type_port,
                type_pied,
                date_ajout
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";

    $stmt = $pdo->prepare($sql);
    $stmt->execute(array(
        $treeData['espece'],
        $treeData['hauteur_totale'],
        $treeData['hauteur_tronc'],
        $treeData['diametre_tronc'],
        $treeData['remarquable'],
        $treeData['latitude'],
        $treeData['longitude'],
        $treeData['etat'],
        $treeData['stade_developpement'],
        $treeData['type_port'],
        $treeData['type_pied']
    ));

    $treeData['id'] = $pdo->lastInsertId();
    $treeData['date_ajout'] = date('Y-m-d H:i:s');

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
