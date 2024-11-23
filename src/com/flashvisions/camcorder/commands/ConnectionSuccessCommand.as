package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.event.LicenceEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.server.RTMPServerType;
	import com.flashvisions.commercial.flex.LicenceType;
	import com.flashvisions.components.Alert;
	
	import flash.media.Microphone;

	public class ConnectionSuccessCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var connectEvent:ConnectionEvent = event as ConnectionEvent;
			var info:Object = connectEvent.info;
			
			modelLocator.isConnected = true;
			modelLocator.wasConnected = true;
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(ConnectionEvent.CONNECTSUCCESS, info));
			
			// Acquire devices 
			if(!modelLocator.disableVideo && !modelLocator.asViewer)
			CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ACQUIRE));
			
			if(!modelLocator.disableAudio && !modelLocator.asViewer)
			CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.MICROPHONE_ACQUIRE));
			
			/* Check bandwidth for Red5*/
			if(modelLocator.bwCheck == true && modelLocator.forceQuality == null && (modelLocator.serverType == RTMPServerType.RED5))
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.BANDWIDTHCHECK, modelLocator.broadcastConnection));
			
			
			/*Reconnect is previously disconnected by network issues */
			if(modelLocator.wasPublishing && modelLocator.acquired) CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTART));
			else if(modelLocator.asViewer && modelLocator.playbackName) CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.STARTPLAYBACK, modelLocator.playbackName));
		
			/* Verify licence on each connect */
			if(modelLocator.appmode == LicenceType.REGISTERED)
			CairngormEventDispatcher.getInstance().dispatchEvent(new LicenceEvent(LicenceEvent.VERIFY));
			
			
		}
	}
}