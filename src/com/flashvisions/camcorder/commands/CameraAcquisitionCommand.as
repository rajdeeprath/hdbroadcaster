package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.Camera;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	public class CameraAcquisitionCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			acquireCamera();
		}
		
		private function acquireCamera():void
		{
			try
			{
				modelLocator.camera = Camera.getCamera(String(modelLocator.cameraIndex));
				if(modelLocator.camera == null) throw new Error("No Camera Found !");
				
				modelLocator.video.attachCamera(modelLocator.camera);
				modelLocator.camera.setLoopback(false);
				
				if(!modelLocator.camera.hasEventListener(StatusEvent.STATUS))
				modelLocator.camera.addEventListener(StatusEvent.STATUS, onCameraStatus);
				
				if(!modelLocator.camera.muted) deviceOk();
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		private function deviceOk():void
		{
			modelLocator.allowVideo = true;
			modelLocator.broadcastVideo = true;
			CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.CAMERA_INITIALIZE));
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.DEVICEACQUIRED));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(CameraEvent.CAMERA_ACQUIRE, modelLocator.camera.name));
		}
		
		private function deviceNotOk():void
		{
			modelLocator.allowVideo = false;
			modelLocator.broadcastVideo = false;
			Security.showSettings(SecurityPanel.PRIVACY);
		}
		
		
		/* Event Handler */
	
		private function onCameraStatus(event:StatusEvent):void
		{
			if (event.code == "Camera.Unmuted")deviceOk();
			else if (event.code == "Camera.Muted")deviceNotOk();
		}
	}
}