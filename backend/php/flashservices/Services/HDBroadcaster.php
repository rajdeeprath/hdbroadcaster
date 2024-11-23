<?php
require AMFPHP_ROOTPATH . "../config.php";
session_start();

define("RED5", "red5");
define("FMS", "fms");
define("WOWZA", "wowza");

define("LICENSE", $config['license']);
define("RTMP", $config['rtmp']);
define("STREAM", $config['stream']);
define("THUMBS_DIR", $config['thumbs']);
define("LOGO", $config['logo']);
define("AUTOSTART", $config['autoStart']);
define("DISABLEINTERACTION", $config['disableInteraction']);
define("ENABLEPREVIEW", $config['enablePreview']);

class HDBroadcaster 
{ 
	var $key = "";
	var $capture_directory;
	var $destination;
	var $stream;
	var $bwcheck;
	var $server = RED5;
	var $logo;
	var $autoStart;
	var $disableInteraction;
	var $enablePreview;
	var $encoderPresets;
	
	function  HDBroadcaster()
	{	
		$this->encoderPresets = AMFPHP_ROOTPATH . "includes/encoderpresets.json";
		$this->enablePreview = ENABLEPREVIEW;
		$this->disableInteraction = DISABLEINTERACTION;
		$this->autoStart = AUTOSTART;
		$this->key = LICENSE;
		$this->capture_directory = AMFPHP_ROOTPATH . "../".THUMBS_DIR."/"; 
		$this->stream = (isset($_SESSION['stream']))?$_SESSION['stream']:STREAM;
		$this->destination = (isset($_SESSION['rtmp']))?$_SESSION['rtmp']:RTMP;
		$this->logo = LOGO;
				
		/* clear session data */
		unset($_SESSION['stream']);
		unset($_SESSION['rtmp']);
	}	
	
		
	function loadSettings($objectId, $configuration)
	{		
		$settings["licencekey"] = $this->key;
		$settings["publishName"] = $this->stream;
		$settings["destination"] = $this->destination;
		//$settings["playback"] = $settings["destination"];
		$settings["autoSnapInterval"] = 30;
		$settings["bwcheck"] = $this->bwcheck;
		$settings["server"] = $this->server;
		$settings["logo"] = $this->logo;
		$settings["enablePreview"] = $this->enablePreview;
		$settings["forceQuality"] = "HD SIF LOW";
		$settings["disableInteraction"] = $this->disableInteraction;
		$settings["autoStart"] = $this->autoStart;
		$settings["bwStrict"] = true;
		$settings["userPresets"] = file_get_contents($this->encoderPresets);
		
		return $settings;
	}
	
	function saveSession($objectId, $configuration, $streamname, $preview, $duration)
	{
		$outputfile = $this->capture_directory.$streamname.".jpg";
		if($preview->data) {
		file_put_contents($outputfile,$preview->data);
		$this->generateThumb($outputfile,$outputfile,320,240);
		}
		
		return;
	}
	
	function generateThumb($img,$output,$w,$h)
	{
		$x = @getimagesize($img);
		$sw = $x[0];
		$sh = $x[1];

		$im = @ImageCreateFromJPEG ($img) or $im = false;
		 
		if ($im) {
			$thumb = @ImageCreateTrueColor ($w, $h);
			@ImageCopyResampled ($thumb, $im, 0, 0, 0, 0, $w, $h, $sw, $sh);
			@ImageJPEG ($thumb,$output,100);
			imagedestroy($thumb);
			imagedestroy($im);
		}
	}
	
} 
?>