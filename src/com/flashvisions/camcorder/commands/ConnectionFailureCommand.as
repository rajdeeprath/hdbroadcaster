package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	public class ConnectionFailureCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var connectEvent:ConnectionEvent = event as ConnectionEvent;
			var info:Object = connectEvent.info;
			
			modelLocator.isConnected = false;
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(ConnectionEvent.CONNECTFAILED, info));
			
			/* If disconnect was not manual attempt reconnection on failure*/
			if(modelLocator.wasConnected)CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.ATTEMPTRECONNECT));
		}
	}
}