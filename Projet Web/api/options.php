<?php
require_once __DIR__ . '/../inc/data_utils.php';

$options = get_form_options();

send_json(array(
    'success' => true,
    'options' => $options,
));
