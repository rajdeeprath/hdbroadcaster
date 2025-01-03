package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.components.Alert;
	import flash.external.ExternalInterface;
	
	
	
	public class NotificationCommand implements ICommand
	{
		public function execute(event:CairngormEvent):void
		{
			var notification:NotificationEvent = event as NotificationEvent;
			var params:Object = new Object();
			
			for(var i:int=0; i < notification.params.length;i++)
			params["param"+i] = notification.params[i];
			
			if(ExternalInterface.available)
			ExternalInterface.call(notification.eventName,ExternalInterface.objectID,params);
			else Alert.show("ExternalInterface not found. callbacks will not work !");
			
			params = null;
		}
	}
}