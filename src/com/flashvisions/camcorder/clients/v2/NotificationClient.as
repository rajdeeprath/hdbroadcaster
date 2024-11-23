package com.flashvisions.camcorder.clients.v2
{
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.interfaces.INotificationClient;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class NotificationClient extends EventDispatcher implements INotificationClient
	{
		private var logger:ILogger = Log.getLogger("NotificationClient");
		
		private static const METHOD_SCOPER:String = ".";		
		private static const GLOBAL_JS_EXTERNAL_RECEIVER:String = "oninvoke";
		private static const GLOBAL_JS_EXTERNAL_SETTINGS_PROVIDER:String = "loadsettings";
		private static const GLOBAL_JS_EXTERNAL_AVAILABILITY_PROVIDER:String = "isavailable";
		private static const NAMESPACE:String = "default";
		
		private var _objectName:String;
		private var _configuration:Object;
		
		private var _namespace:String;
		
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		
		
		
		public function NotificationClient(_scope:String, _namespace:String = "default")
		{
			super();
			
			this._namespace = _scope + METHOD_SCOPER + _namespace;
			this.initialize();
		}
		
		
		
		public function initialize():void
		{			
			Security.allowDomain(Security.pageDomain);
			Security.allowDomain(SecurityDomain.currentDomain);
			
			ExternalInterface.addCallback("isAvailable", this.isInterfaceAvailable);
			ExternalInterface.addCallback("isBroadcasting",this.isBroadcasting);
			ExternalInterface.addCallback("isConnected",this.isConnected);
			ExternalInterface.addCallback("stopBroadcast",this.stopBroadcast);
			ExternalInterface.addCallback("startBroadcast",this.startBroadcast);
			ExternalInterface.addCallback("denyMicrophone",this.denyMicrophone);
			ExternalInterface.addCallback("allowMicrophone",this.allowMicrophone);
			ExternalInterface.addCallback("isAudioAllowed",this.isAudioAllowed);
			ExternalInterface.addCallback("denyCamera",this.denyCamera);
			ExternalInterface.addCallback("allowCamera",this.allowCamera);
			ExternalInterface.addCallback("isVideoAllowed",this.isVideoAllowed);			
			ExternalInterface.addCallback("setMicGain",this.setMicGain);
			ExternalInterface.addCallback("getMicGain",this.getMicGain);
			ExternalInterface.addCallback("pushExtraData",this.pushExtraData);
			ExternalInterface.addCallback("toggleView",this.toggleView);
			ExternalInterface.addCallback("getCurrentView",this.getCurrentView);
			ExternalInterface.addCallback("applyPreset",this.applyPreset);
			
			
			invokeExternal(ApplicationEvent.JSBRIDGEREADY, modelLocator.bridgeConfiguration);
		}
		
		
		
		
		
		public function isInterfaceAvailable(callback:String = null):Boolean
		{
			if(callback && ExternalInterface.available) {
				ExternalInterface.call(callback, true);
			}
			
			return ExternalInterface.available;
		}
		
		
		
		
		public function get objectName():String
		{
			_objectName = (_objectName == null || _objectName == "")? getSWFObjectName():_objectName;
			return _objectName;
		}
		
		
		
		
		/** 
		 * Utility function to find swfObject's name
		 */ 
		protected function getSWFObjectName(): String {
			// Returns the SWF's object name for getElementById
			// Based on https://github.com/millermedeiros/Hasher_AS3_helper/blob/master/dev/src/org/osflash/hasher/Hasher.as
			
			var js:XML;
			js = <script><![CDATA[
				function(__randomFunction) {
					var check = function(objects){
							for (var i = 0; i < objects.length; i++){
								if (objects[i][__randomFunction]) return objects[i].id;
							}
							return undefined;
						};
					
						return check(document.getElementsByTagName("object")) || check(document.getElementsByTagName("embed"));
				}
			]]></script>;
			
			var __randomFunction:String = "checkFunction_" + Math.floor(Math.random() * 99999); // Something random just so it's safer
			ExternalInterface.addCallback(__randomFunction, getSWFObjectName); // The second parameter can be anything, just passing a function that exists
			
			return ExternalInterface.call(js, __randomFunction);
		}
		
		
		
		
		public function isBridgeAvailable():Boolean{
			
			if(isInterfaceAvailable())
			{
				try
				{
					return ExternalInterface.call("function(){ return (typeof("+_namespace+") === 'object' && typeof("+_namespace+".isavailable) === 'function') }");
				}
				catch(e:Error)
				{
					return false;
				}
			}
			
			return false;
		}
		
		
		
		
		public function invokeExternal(notification:String, params:Object=null):*
		{
			if(isBridgeAvailable())
			{
				var data:String = (params != null) 
					? (params is String) 
					? params.toString()
					: JSON.stringify(params):null;
				
				
				
				var args:Array = new Array();
				args.push(_namespace + METHOD_SCOPER + GLOBAL_JS_EXTERNAL_RECEIVER);
				args.push(objectName);
				args.push(notification);
				args.push(data);
				
				
				try
				{
					return ExternalInterface.call.apply(ExternalInterface,  args);
				}
				catch(e:Error)
				{
					logger.error("JS Interface call error " + e.message);
				}
			}
			else
			{
				logger.error("Exterinterface not available or method not found");
			}
		}
		
		
		
		
		
		public function loadConfiguration():Object
		{
			if(isBridgeAvailable())
			{
				var args:Array = new Array();
				args.push(_namespace + METHOD_SCOPER + GLOBAL_JS_EXTERNAL_SETTINGS_PROVIDER);
				args.push(objectName);
				
				
				try
				{
					return ExternalInterface.call.apply(ExternalInterface,  args);
				}
				catch(e:Error)
				{
					logger.error("JS Interface call error " + e.message);
					throw e;
				}
			}
			else
			{
				throw new Error("Exterinterface not available or method not found");
			}
			
			return null;
		}
		
		
		
		
		
		
		/**************** JAVASCRIPT ACCESSIBLE FUNCTIONS *************/
		/*****************************************************************/
		
		
		public function generateSnapshot():void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.SNAPSHOT));
		}
		
		
		
		public function isAudioAllowed():Boolean
		{
			return modelLocator.allowAudio;
		}
		
		
		
		
		public function isAudioEnabled():Boolean
		{
			return modelLocator.broadcastAudio;
		}		
		
		
		
		
		public function isVideoAllowed():Boolean
		{
			return modelLocator.allowVideo;
		}
		
		
		
		
		public function isVideoEnabled():Boolean
		{
			return modelLocator.broadcastVideo;
		}
		
		
		
		
		
		
		public function applyPreset(presetName:String):void
		{
			var index:int = modelLocator.presetIndex = modelLocator.getPresetIndexByLabel(presetName);
			var settings:Object = modelLocator.broadcastQuality.getItemAt(index);
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.APPLYPRESET,settings));
		}
		
		
		
		
		
		public function pushExtraData(method:String, json:String):void
		{
			var data:Object = JSON.parse(json);
			
			if(modelLocator.isBroadcasting)
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUSHEXTRADATA, data));
		}
		
		
		
		
		
		public function viewStream(stream:String):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.STARTPLAYBACK,stream));
		}
		
		
		
		
		
		public function stopBroadcast():void
		{
			if(modelLocator.isBroadcasting)
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTOP));
		}
		
		
		
		
		
		public function startBroadcast():void
		{
			if(!modelLocator.isBroadcasting)
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTART));
		}
		
		
		
		
		
		public function isBroadcasting():Boolean
		{
			return modelLocator.isBroadcasting;
		}
		
		
		
		
		
		public function isConnected():Boolean
		{
			return modelLocator.isConnected;
		}
		
		
		
		
		
		public function denyMicrophone():void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.DISABLEAUDIOBROADCAST));
		}
		
		
		
		
		
		
		public function allowMicrophone():void
		{
			if(modelLocator.mic != null)
				CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.ENABLEAUDIOBROADCAST));
		}
		
		
		
		
		
		
		public function denyCamera():void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.DISABLEVIDEOBROADCAST));
		}
		
		
		
		
		
		
		public function allowCamera():void
		{
			if(modelLocator.camera != null)
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.ENABLEVIDEOBROADCAST));
		}
		
		
		
		
		
		
		public function toggleView():void
		{
			modelLocator.currentView = (modelLocator.currentView == BroadcastModelLocator.CAMERAVIEW)?BroadcastModelLocator.PLAYBACKVIEW:BroadcastModelLocator.CAMERAVIEW;
		}
		
		
		
		
		
		public function setMicGain(gain:Number):void
		{
			if(!isNaN(gain) && gain>=0 && gain<=100)
			modelLocator.micGain = gain;
			
			if(modelLocator.mic)
			CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.MICROPHONE_INITIALIZE));
		}
		
		
		
		
		
		
		public function getMicGain():Number
		{
			return modelLocator.micGain;
		}
		
		
		
		
		
		public function getCameraList():Array
		{
			return Camera.names;
		}
		
		
		
		
		
		
		public function getMicrophoneList():Array
		{
			return Microphone.names;
		}
		
		
		
		
		
		public function getActiveCamera():String
		{
			return (modelLocator.camera != null)?modelLocator.camera.name:null;
		}
		
		
		
		
		
		
		public function getActiveMicrophone():String
		{
			return (modelLocator.mic != null)?modelLocator.mic.name:null;
		}
		
		
		
		
		
		
		public function setActiveCamera(candidate:String):void
		{
			var index:int = -1;
			
			
			for(var i:uint=0;i<modelLocator.cameras.length;i++){
				var camInfo:Object = modelLocator.cameras.getItemAt(i);
				var camera:String = camInfo.label; 
				if(candidate == camera){
					index = camInfo.data;
					break;
				}
			}
			
			
			if(index>=0){
				modelLocator.cameraIndex = index;
				CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.CAMERA_SOURCE_CHANGE));
			}else{
				throw new Error("Invalid camera name " + candidate);
			}
		}
		
		
		
		
		
		
		public function setActiveMicrophone(candidate:String):void
		{
			var index:int = -1;
			
			
			for(var i:uint=0;i<modelLocator.microphones.length;i++){
				var micInfo:Object = modelLocator.microphones.getItemAt(i);
				var microphone:String = micInfo.label; 
				if(candidate == microphone){
					index = micInfo.data;
					break;
				}
			}
			
			
			if(index>=0){
				modelLocator.micIndex = index;
				CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.MICROPHONE_SOURCE_CHANGE));
			}else{
				throw new Error("Invalid microphone name " + candidate);
			}
		}
		
		
		
		
		
		
		public function getCurrentView():String
		{
			return modelLocator.currentView;
		}
	}
}