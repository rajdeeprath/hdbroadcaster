package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.serialization.json.JSON;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import flash.external.ExternalInterface;
	
	
	
	public class NotificationBroadcastCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var notification:NotificationEvent = event as NotificationEvent;
			var params:Object = notification.params;
			
			modelLocator.notificationClient.invokeExternal(notification.eventName, params);
		}
	}
}