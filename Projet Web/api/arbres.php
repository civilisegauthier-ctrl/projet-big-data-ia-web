<?php
require_once __DIR__ . '/../inc/data_utils.php';

try {
    $trees = read_trees_for_table();
} catch (PDOException $exception) {
    send_json(array(
        'success' => false,
        'message' => 'Erreur lors de la lecture des arbres dans la base de donnees.',
    ), 500);
}

send_json(array(
    'success' => true,
    'trees' => $trees,
));
