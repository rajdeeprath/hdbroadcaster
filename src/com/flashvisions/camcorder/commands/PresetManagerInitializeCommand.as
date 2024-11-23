package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.Aspect;
	import com.flashvisions.camcorder.BroadcastQuality;
	import com.flashvisions.camcorder.OperationMode;
	import com.flashvisions.camcorder.business.ConfigurationDelegate;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.LicenceEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.server.RTMPServerType;
	import com.flashvisions.remoting.RemotingConnection;
	import com.hurlant.crypto.symmetric.BlowFishKey;
	import com.hurlant.crypto.symmetric.ECBMode;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.media.VideoCodec;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class PresetManagerInitializeCommand implements ICommand
	{
		private var logger:ILogger = Log.getLogger("PresetManagerInitializeCommand");
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{	
			logger.info(" Preparing to read user presets");
			
			if(!initializeUserPresets())
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_FAILED, "Error parsing presets data"));
			else
			CairngormEventDispatcher.getInstance().dispatchEvent(new LicenceEvent(LicenceEvent.VALIDATE,modelLocator.licence));
		}
		
		
		
		private function initializeUserPresets():Boolean
		{
			var settings:Object;
			var sdPresets:ArrayCollection;
			var hdPresets:ArrayCollection;
			
			try{
				
				if(!modelLocator.userPresets.hasOwnProperty("presets"))
				throw new Error("Invalid user preset data");
				
				settings = modelLocator.userPresets.presets;
				
				
				if(!settings.hasOwnProperty("sd"))
				throw new Error("Invalid sd presets");
				modelLocator.sdQuality = getSanitizedArrayCollection(settings.sd.preset as Array);
				
				
				if(!settings.hasOwnProperty("hd"))
				throw new Error("Invalid hd presets");
				modelLocator.hdQuality = getSanitizedArrayCollection(settings.hd.preset as Array);
				
				
				if((BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.HDBROADCASTER || BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE) && (modelLocator.sdQuality.length>0 && modelLocator.hdQuality.length>0))
				return true;
				else if(BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.FXBROADCASTER && modelLocator.sdQuality.length>0)
				return true;
			}
			catch(e:Error)
			{
				logger.error("Failed to read presets. Cause " + e.message);
				return false;	
			}
			
			
			logger.error("Presets read successfully");
			return false;
		}
		
		
		
		private function getSanitizedArrayCollection(presets:Array):ArrayCollection
		{
			var sanitizedPresets:ArrayCollection = new ArrayCollection();
			
			
			for each(var preset:Object in presets)
			{
				
				if(preset.hasOwnProperty("keyframeInterval"))
				{
					preset["keyframe"]	=	preset["keyframeInterval"];
					delete preset["keyframeInterval"];
				}
				
				
				
				if(preset.hasOwnProperty("samplerate"))
				{
					preset["micrate"]	= 	preset["samplerate"];
					delete preset["samplerate"];
				}
				
				
				
				if(preset.hasOwnProperty("speexquality"))
				{
					preset["encodeQuality"]	=	preset["speexquality"];
					delete preset["speexquality"];
				}
				
				
				
				if(preset.videocodec == VideoCodec.H264AVC)
				{
					if(preset.hasOwnProperty("h264profile")){
					preset["profile"]	= 	preset["h264profile"];
					delete preset["h264profile"];
					}
					
					
					if(preset.hasOwnProperty("h264level")){
					preset["level"]		=	preset["h264level"];
					delete preset["h264level"];
					}
				}
				
				
				sanitizedPresets.addItem(preset);
			}
			
			
			
			return sanitizedPresets;
		}
		
		
		
		/** @private builds a Blowfish cipher algorithm. */
		private function _getCipher( $key:String, $pad:IPad ):ICipher {
			return new ECBMode( new BlowFishKey(Base64.decodeToByteArray( $key )), $pad );
		}
	}
}