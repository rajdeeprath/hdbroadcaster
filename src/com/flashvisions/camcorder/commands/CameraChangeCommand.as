package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	
	
	public class CameraChangeCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTOP));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(CameraEvent.CAMERA_SOURCE_CHANGE));
			
			if(modelLocator.cameraIndex >=0) CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ACQUIRE));
			else CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.DEINITIALIZE));
		}
	}
}