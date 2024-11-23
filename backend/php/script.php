<?php
include "./config.php";

define("LICENSE", $config['license']);
define("RTMP", $config['rtmp']);
define("STREAM", $config['stream']);
define("THUMBS_DIR", $config['thumbs']);
define("LOGO", $config['logo']);
define("AUTOSTART", $config['autoStart']);
define("DISABLEINTERACTION", $config['disableInteraction']);
define("ENABLEPREVIEW", $config['enablePreview']);

$streamname = $_REQUEST["recorded"];
$snapshot = = $_REQUEST["image"];
$autoSnapInterval = 30;
$encoderPresets = "";

if($snapshot == "" || $snapshot == null || !isset($snapshot))
{
	$res = "";
	$publishName = "stream";

	$res += "licencekey=".LICENSE; 
	$res .= "&"; 
	$res .= "publishName=".STREAM; 
	$res .= "&"; 
	res .= "destination=".RTMP; 
	$res .= "&";
	$res .= "autoSnapInterval=".$autoSnapInterval;
	$res .= "&";
	$res .= "videocodec=H264Avc";
	$res .= "&";
	$res .= "forceQuality=";
	$res .= "&";
	$res .= "autoStart=".AUTOSTART;
	$res .= "&";
	$res .= "userPresets=".file_get_contents($encoderPresets);
}
else
{
	// $snapshot is a base 64 encoded string which is a image
	// decode it and write to file with jpg extension
	$res = "done=1";
}

echo $res;
?>