<?php
require_once __DIR__ . '/../inc/data_utils.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    send_json(array(
        'success' => false,
        'message' => 'Methode non autorisee.',
    ), 405);
}

$data = get_json_body();
$clusterCount = isset($data['clusters']) ? (string) $data['clusters'] : '';
$height = isset($data['hauteur']) ? (string) $data['hauteur'] : '';

if (($clusterCount !== '2' && $clusterCount !== '3') || $height === '') {
    send_json(array(
        'success' => false,
        'message' => 'Veuillez renseigner une hauteur et un nombre de categories valides.',
    ), 422);
}

if (!is_numeric(str_replace(',', '.', $height))) {
    send_json(array(
        'success' => false,
        'message' => 'La hauteur doit etre un nombre valide.',
    ), 422);
}

$projectRoot = dirname(__DIR__, 2);
$pythonScript = $projectRoot . '/Projet Web/python/script_python_adapte_devwebb1.py';
$pythonBinary = $projectRoot . '/.venv/bin/python';
$heightValue = (string) ((int) round((float) str_replace(',', '.', $height)));

$command = escapeshellarg($pythonBinary)
    . ' '
    . escapeshellarg($pythonScript)
    . ' 1 '
    . escapeshellarg($clusterCount)
    . ' '
    . escapeshellarg($heightValue)
    . ' 2>&1';

$output = shell_exec($command);

if ($output === null || trim($output) === '') {
    send_json(array(
        'success' => false,
        'message' => 'La prediction n a pas pu etre generee.',
    ), 500);
}

if (stripos($output, 'Traceback') !== false) {
    send_json(array(
        'success' => false,
        'message' => 'Erreur Python lors de la prediction.',
        'details' => $output,
    ), 500);
}

send_json(array(
    'success' => true,
    'prediction' => trim($output),
));
