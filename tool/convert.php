<?php

define('WAV_DIR', dirname(__FILE__).'/../wav');

define('OUTPUT_DIR', dirname(__FILE__).'/../js');

$wavs = glob(WAV_DIR.'/*.wav');

var_dump($wavs);

$resources = [
  'wav' => [],
];
foreach ($wavs as $filepath) {
  if (!preg_match('`^(.+)\.wav$`i', end(explode('/', $filepath)), $matches)) continue;
  $filename = $matches[1];

  $resources['wav'][$filename] = 'data:audio/wav;base64,'.base64_encode(file_get_contents($filepath));
}


file_put_contents(OUTPUT_DIR.'/resource.js', 'window.RESOURCES = '.json_encode($resources).';');

