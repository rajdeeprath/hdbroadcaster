var recorderParams = {};
var pconf={widgetTitle: 'Share My Recording',useFacebookMystuff: 'false',defaultContent: 'codeBox',UIConfig: '<config baseTheme="v2"><display showEmail="true" showBookmark="true"></display></config>'};

function onBroadcasterReady(objid)
{
	var broadcaster = swfobject.getObjectById(objid);
	broadcaster.addNotificationListener("BROADCASTBEGIN","onBroadcastStarted");
	broadcaster.addNotificationListener("BROADCASTEND","onBroadcastClosed");
}

function onBroadcastStarted(objid,params)
{
	var streamname = eval(params)[0];
	var form = document.getElementById(recorderParams.form);
	var textarea = form.codeBox;
	
	var embedCode = '<object width="320" height="240"> <param name="movie" value="'+recorderParams.playerPath+'"></param><param name="flashvars" value="src='+recorderParams.playbackURL+'/'+streamname+recorderParams.extension+'&streamType=live&autoPlay=true&initialBufferTime=.1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="'+recorderParams.playerPath+'" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="320" height="240" flashvars="src='+recorderParams.playbackURL+'/'+streamname+recorderParams.extension+'&streamType=live&autoPlay=true&initialBufferTime=.1"></embed></object>';
	
	textarea.value = embedCode;
	
	
	if((recorderParams.playbackURL != null)&&(recorderParams.playbackURL != '')){
	Wildfire.initPost('615942', 'divWildfirePost', 320, 200, pconf);
	self.location.hash = "#embedcode";
	}
}

function onBroadcastClosed(objid,params)
{
	var streamname = eval(params)[0];
	var form = document.getElementById(recorderParams.form);
	var textarea = form.codeBox;
	textarea.value = "";
	document.getElementById('divWildfirePost').innerHTML = '<img src="images/gigya-highlights.jpg" />';
}
