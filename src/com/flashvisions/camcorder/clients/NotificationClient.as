package com.flashvisions.camcorder.clients
{
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import mx.collections.ArrayCollection;
	
	
	public class NotificationClient extends EventDispatcher 
	{
		private var listeners:ArrayCollection = new ArrayCollection();
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function NotificationClient()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			ExternalInterface.addCallback("addNotificationListener",this.addNotificationListener);
			ExternalInterface.addCallback("removeNotificationListener",this.removeNotificationListener);
			
			ExternalInterface.addCallback("stopBroadcast",this.stopBroadcast);
			ExternalInterface.addCallback("startBroadcast",this.startBroadcast);
			ExternalInterface.addCallback("setVolume",this.setVolume);
			ExternalInterface.addCallback("getVolume",this.getVolume);
			ExternalInterface.addCallback("denyMicrophone",this.denyMicrophone);
			ExternalInterface.addCallback("allowMicrophone",this.allowMicrophone);
			ExternalInterface.addCallback("isAudioAllowed",this.isAudioAllowed);
			ExternalInterface.addCallback("denyCamera",this.denyCamera);
			ExternalInterface.addCallback("allowCamera",this.allowCamera);
			ExternalInterface.addCallback("isVideoAllowed",this.isVideoAllowed);			
			ExternalInterface.addCallback("setMicGain",this.setMicGain);
			ExternalInterface.addCallback("getMicGain",this.getMicGain);
			ExternalInterface.addCallback("pushExtraData",this.pushExtraData);
			ExternalInterface.addCallback("generateSnapshot",this.generateSnapshot);
			
			ExternalInterface.addCallback("viewStream",this.viewStream);
			ExternalInterface.addCallback("toggleView",this.toggleView);
			ExternalInterface.addCallback("getCurrentView",this.getCurrentView);
			
			
			
			/* 1.4.9 (beta) */
			ExternalInterface.addCallback("applyPreset",this.applyPreset);
		}
		
		public function addNotificationListener(event:String,callbackFunction:String):Boolean
		{
			if(listeners.contains({Notification:event,FunctionName:callbackFunction})) return false;
			listeners.addItem({Notification:event,FunctionName:callbackFunction});	return true;
		}
		
		public function removeNotificationListener(event:String,callbackFunction:String):Boolean
		{
			if(!listeners.contains({Notification:event,FunctionName:callbackFunction})) return false;
			var found:Number = listeners.getItemIndex({Notification:event,FunctionName:callbackFunction});
			
			if(found >=0){listeners.removeItemAt(found); return true;}
			else return false;
		}
		
		public function sendNotification(notification:String,params:Object=null):void
		{
			var data:String = (params != null)?JSON.stringify(params):null;
			for(var j:int=0; j<listeners.length;j++)
			if(listeners.getItemAt(j).Notification == notification)
			ExternalInterface.call(listeners.getItemAt(j).FunctionName,ExternalInterface.objectID,data);
		}
		
		public function notifyGlobal(notification:String,params:Object=null):void
		{
			var data:String = (params != null)?JSON.stringify(params):null;
			ExternalInterface.call(notification,ExternalInterface.objectID);
		}
		
		/**************** JAVASCRIPT ACCESSIBLE FUNCTIONS *************/
		/*****************************************************************/
		
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
		
		
		public function generateSnapshot():void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.SNAPSHOT));
		}
		
		
		/* 1.4.9 (beta) */
		public function applyPreset(label:String):void
		{
			var index:int = modelLocator.presetIndex = modelLocator.getPresetIndexByLabel(label);
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
		
		public function setVolume(volume:Number):void
		{
			if(!isNaN(volume) && volume>=0 && volume<=100)
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.INITIALIZESPEAKERVOLUME,(volume/100)));
		}
		
		public function getVolume():Number
		{
			return modelLocator.speakerVolume;
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
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.ENABLEVIDEOBROADCAST));
		}
		
		public function toggleView():void
		{
			modelLocator.currentView = (modelLocator.currentView == BroadcastModelLocator.CAMERAVIEW)?BroadcastModelLocator.PLAYBACKVIEW:BroadcastModelLocator.CAMERAVIEW;
		}
		
		public function setMicGain(gain:*):void
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
				
		public function getCurrentView():String
		{
			return modelLocator.currentView;
		}
	}
}