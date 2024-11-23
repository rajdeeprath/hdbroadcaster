<?php
$url = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on')) ? 'https://' : 'http://';
$url .= $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']);

$config['license'] = '';
$config['stream'] = 'rajdeep';
$config['rtmp'] = 'rtmp://87.248.192.55:1935/live';//'rtmp://192.168.1.45/live';
$config['logo'] = '';
$config['thumbs'] = "captured";
$config['autoStart'] = false;
$config['disableInteraction'] = false;
$config['enablePreview'] = false;
$config['base'] = $url."/swf/";
$config['videosPath'] = $config['rtmp'];
$config['serviceLocation'] = substr(dirname($_SERVER['PHP_SELF'])."/flashservices/",1);
$config['playerPath'] = $url."/swf/StrobeMediaPlayback.swf";
?>