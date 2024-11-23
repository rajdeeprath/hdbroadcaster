package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	public class PublishFailedCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			var info:Object = streamEvent.params[0];
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUBLISHSTOP));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTFAILED, info));
		}
	}
}