package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.CryptoCode;
	import com.flashvisions.camcorder.Aspect;
	import com.flashvisions.camcorder.BroadcastQuality;
	import com.flashvisions.camcorder.OperationMode;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.LicenceEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.server.RTMPServerType;
	import com.flashvisions.components.Alert;
	import com.flashvisions.remoting.RemotingConnection;
	
	import flash.external.ExternalInterface;
	import flash.media.VideoCodec;
	import flash.net.Responder;
	import flash.net.URLLoader;
	
	
	
	public class ConfigurationSuccessCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var applicationEvent:ApplicationEvent = event as ApplicationEvent;
			var result:Object = applicationEvent.params[0];
			try
			{
				modelLocator.publishName = decrypt((result.publishName != undefined &&  result.publishName !=null)?result.publishName:null);
				modelLocator.publishQueryString = (result.publishQueryString)?result.publishQueryString:"";
				modelLocator.destination = decrypt(result.destination);
				modelLocator.maxRecordDuration = (result.broadcastTime == null)?0:parseInt(result.broadcastTime);
				modelLocator.broadcastMode = BroadcastModelLocator.BROADCASTMODE;
				modelLocator.licence = result.licencekey;
				modelLocator.bwCheck = (result.bwcheck == null || result.bwcheck == false || result.bwcheck == "false")?false:true;
				modelLocator.dvr = (result.dvr == null || result.dvr == false || result.dvr == "false")?false:true;
				modelLocator.dvrInfo = (result.dvrInfo)?JSON.parse(result.dvrInfo):null;
				modelLocator.serverType = (result.server == null)?RTMPServerType.RED5:result.server;
				modelLocator.mode = result.broadcastMode as String;
				modelLocator.logo = (result.logo)?result.logo:null;
				modelLocator.autoSnapInterval = (result.autoSnapInterval != null && parseInt(result.autoSnapInterval)>5)?parseInt(result.autoSnapInterval):0;
				modelLocator.enableAutoSense = (result.enableAutoSense == null || result.enableAutoSense == false || result.enableAutoSense == "false")?false:true;
				modelLocator.enablePreview = (result.enablePreview == null || result.enablePreview == false || result.enablePreview == "false" || BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE)?false:true;
				modelLocator.forceQuality = (result.forceQuality != null)?result.forceQuality as String:BroadcastQuality.AVERAGE;
				modelLocator.disableInteraction = (result.disableInteraction == null || result.disableInteraction == false || result.disableInteraction == "false")?false:true;
				modelLocator.encodingMode = ((result.mode == null || result.mode == VideoCodec.H264AVC) && (BroadcastModelLocator.APPLICATIONID != BroadcastModelLocator.FXBROADCASTER))?VideoCodec.H264AVC:VideoCodec.SORENSON;
				modelLocator.playbackURL = (result.playback)?result.playback:null;
				modelLocator.playbackName = (result.playbackName)?result.playbackName:null;
				modelLocator.bwStrict = (result.bwStrict == null || result.bwStrict == true || result.bwStrict == "true")?true:false;
				modelLocator.autoStart = (result.autoStart == null || result.autoStart == false || result.autoStart == "false")?false:true;
				modelLocator.asViewer = (BroadcastModelLocator.APPLICATIONID != BroadcastModelLocator.CHATANYWHERE || result.asViewer == null || result.asViewer == false || result.asViewer == "false")?false:true;
				
				modelLocator.userPresets = null;
				if(result.userPresets)
				{
					if(result.userPresets is String)
					{
						modelLocator.userPresets = JSON.parse(result.userPresets);
					}
					else
					{
						modelLocator.userPresets = result.userPresets as Object;
					}
				}
				
				
				modelLocator.transcoder = ((result.transcoder) && (BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.HDBROADCASTER))?result.transcoder as String:null;
				modelLocator.metadata = (result.metadata)?JSON.parse(result.metadata):null;
				modelLocator.previewbuffer = (result.previewbuffer != null)?parseInt(result.previewbuffer):0;
				
				CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PRESETMANAGER_LOAD));
			}
			catch(e:Error)
			{
				CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_FAILED,"Error loading configuration data"));
			}
			
		}
		
		private function decrypt(data:Object):String
		{
			var keyCode:String = modelLocator.configuration.timecode;
			if (!keyCode || !data) return data as String;
			var decrypter:CryptoCode = new CryptoCode(keyCode);
			var decrypted:String = decrypter.decrypt(data as String);
			decrypter = null;
			
			return decrypted;
		}
	}
}