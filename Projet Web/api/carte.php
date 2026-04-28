<?php
require_once __DIR__ . '/../inc/data_utils.php';

$clusterCount = '2';

if (isset($_GET['clusters']) && ($_GET['clusters'] === '2' || $_GET['clusters'] === '3')) {
    $clusterCount = $_GET['clusters'];
}

$projectRoot = dirname(__DIR__, 2);
$pythonScript = $projectRoot . '/Projet Web/python/script_python_adapte_devwebb1.py';
$pythonBinary = $projectRoot . '/.venv/bin/python';

if (!file_exists($pythonBinary)) {
    send_json(array(
        'success' => false,
        'message' => 'Python virtuel introuvable.',
    ), 500);
}

if (!file_exists($pythonScript)) {
    send_json(array(
        'success' => false,
        'message' => 'Script Python introuvable.',
    ), 500);
}

$command = escapeshellarg($pythonBinary)
    . ' '
    . escapeshellarg($pythonScript)
    . ' 2 '
    . escapeshellarg($clusterCount)
    . ' 2>&1';

$output = shell_exec($command);

if ($output === null || trim($output) === '') {
    send_json(array(
        'success' => false,
        'message' => 'La carte n a pas pu etre generee.',
    ), 500);
}

if (stripos($output, 'Traceback') !== false) {
    send_json(array(
        'success' => false,
        'message' => 'Erreur Python lors de la generation de la carte.',
        'details' => $output,
    ), 500);
}

send_json(array(
    'success' => true,
    'map_html' => $output,
));
