package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	public class CameraReleaseCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			modelLocator.camera = modelLocator.localCamera = null;
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(CameraEvent.DEINITIALIZE));
		}
	}
}