package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import flash.external.ExternalInterface;
	
	public class ChangeViewModeCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			modelLocator.currentView = (modelLocator.currentView == BroadcastModelLocator.CAMERAVIEW)?BroadcastModelLocator.PLAYBACKVIEW:BroadcastModelLocator.CAMERAVIEW;
		}
	}
}