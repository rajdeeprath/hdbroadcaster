<?php
	session_start();

	include_once('./config.php');
	include_once('./functions.php');
	
	
	if(isset($_POST['txtDestination']) && isset($_POST['txtStream']))
	{
		$_SESSION['rtmp'] = $_POST['txtDestination'];
		$_SESSION['stream'] = $_POST['txtStream'];
	}
	
	$videopath = $config['videosPath'];
	$swfbasePath = $config['base'];
	$serviceLocation = $config['serviceLocation'];
	$playerPath = $config['playerPath'];
	$extension = '';
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Web Media Live Encoder</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="style.css" rel="stylesheet" type="text/css" media="screen" />
<script type="text/javascript" src="scripts/BroadcasterBridge.js"></script> 
<script type="text/javascript">
var bridge = new HDBroadcasterBridge({
	onready: function(){
		console.log("app ready");
	}
});
</script>
<script src="js/fxbroadcaster.js" language="javascript"></script>
<script src="js/swfobject.js" language="javascript"></script>
<script type="text/javascript">
swfobject.registerObject("broadcaster", "11.2.0", "swf/playerProductInstall.swf");
</script>
<script language="javascript" type="text/javascript">

function init()
{
	recorderParams.form = "broadcaster_form";
	recorderParams.playbackURL = "<?php echo $videopath; ?>";
	recorderParams.extension = "<?php echo $extension; ?>";
	recorderParams.playerPath = "<?php echo $playerPath; ?>";
}


function validateForm()
{
	var rtmp = document.getElementById("txtDestination").value;
	var stream = document.getElementById("txtStream").value;

	if((rtmp.length>7)&&(stream.length>2))
	document.getElementById("broadcasterForm").submit();
}

/*--------------------*/
init();
</script>
</head>
<body>
<div class="main">
  <div class="header">
    <div class="clr"></div>
  </div>
</div>
<div id="slider">
  <!-- start slideshow -->
  <div id="slideshow">  
 <?php 
 if(isValidConnectionURL($_SESSION['rtmp']) && isset($_SESSION['stream']))
 {
  	echo '<div>
	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="650" height="540" id="broadcaster" name="broadcaster">
	<param name="movie" value="swf/HDBroadcaster.swf" />
	<param name="base" value="'.$swfbasePath.'" />
	<param name="flashvars" value="themeColor=cccccc&chromeColor=990000&contentBackgroundColor=000000&textColor=ffffff&serviceLocation='.$serviceLocation.'" />
	<!--[if !IE]>-->
	<object type="application/x-shockwave-flash" data="swf/HDBroadcaster.swf" width="650" height="540">
	<param name="base" value="'.$swfbasePath.'" />
	<param name="flashvars" value="themeColor=cccccc&chromeColor=990000&contentBackgroundColor=000000&textColor=ffffff&serviceLocation='.$serviceLocation.'" />
	<!--<![endif]-->
	<a href="http://www.adobe.com/go/getflashplayer">
	<img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
	</a>
	<!--[if !IE]>-->
	</object>
	<!--<![endif]-->
	</object>
	</div>';
 }
 else
 {
	  echo '<img src="images/HD-BANNER.jpg" /><br>';
  	  echo'<form id="broadcasterForm" name="broadcasterForm" method="post" action="'.htmlentities($_SERVER['PHP_SELF']).'">
  	    <div class="box">
          <h1>'.$message.'</h1>
  	      <label> <span>CONNECTION URL</span>
          <input type="text" class="input_text" name="txtDestination" id="txtDestination"/>
          </label>
          <label> <span>STREAM NAME</span>
          <input type="text" class="input_text" name="txtStream" id="txtStream"/>
          </label>
          <input type="button" class="button" value="Go Live !" onclick="validateForm();" />
        </div>
  	  </form>';
 }
 ?>
  
</div>
<div class="clr"></div>
<div class="main">
  <div class="body">
    <div class="clr"></div>
    <div class="body_resize">
      <div class="left">
	  
		<img src="images/hd.png" width="50" height="50" />
		
		<p>
        <h2>Web Media Live Encoder HD</h2>
		</p>
		
        <p> Web Media Live Encoder HD is a revolutionary product, perfectly suited for setting up your own video broadcasting. Web Media Live Encoder works with any RTMP server, to bring you loads of options and control over your stream. You can choose to broadcast audio only streams, video only streams or both. With a very comprehensive interface it is the perfect choice for online broadcasting solutions. </p>
        <ul style="width:250px;">
          <li> Broadcast in audio/video modes </li>
          <li> Professional UI </li>
          <li> Generates preview image of recording without ffmpeg </li>
          <li> HD Support as of flash player 11 </li>
        </ul>
        <ul>
          <li> Generates recording duration without flvTools</li>
          <li> Built upon Adobe Cairngorm micro-architecture </li>
          <li> Amf-php based integration </li>
          <li> Only broadcaster with P2P support </li>
        </ul>
      </div>
      <div class="right">
      <h2>Share with the world - Broadcast now !</h2>
      <form id="broadcaster_form" name="broadcaster_form">
        <a name="embedcode" id="embedcode"></a>
        <div id="divWildfirePost"><img src="images/gigya-highlights.jpg" /></div>
		<textarea name="codeBox" cols="50" rows="2" id="codeBox" style="display:none"></textarea>
      </form>
      </div>
      <p>&nbsp;</p>
      <div class="clr"></div>
      <p><b>Note:</b> <font color="#990000">The default install pack does not include player for RTMFP streaming. If you wish to Obtain you it , you can do it from:</font>&nbsp;&nbsp;<a href="http://code.google.com/p/p2pmediaplayer/">http://code.google.com/p/p2pmediaplayer/</a></p>
    </div>
    <div class="clr"></div>
  </div>
  <div class="footer">
    <div class="footer_resize">
      <p class="leftt">© Copyright rtmpworld.com. All Rights Reserved</p>
      <p class="rightt">&nbsp;</p>
      <div class="clr"></div>
      <div class="clr"></div>
    </div>
  </div>
</div>
</body>
</html>