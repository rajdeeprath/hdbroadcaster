package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.utils.setTimeout;
	
	public class AttemptReconnectionCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(!modelLocator.broadcastConnection.connected)setTimeout(reconnect,2000);
		}
		
		private function reconnect():void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT,modelLocator.broadcastConnection.uri));		
		}
	}
}