package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	public class ConnectionDisconnectCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			try
			{
				if(!modelLocator.isConnected)throw new Error("Nothing to Disconnected");
				CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTOP));
				modelLocator.broadcastConnection.close(); modelLocator.isConnected = false;
				CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(ConnectionEvent.DISCONNECT));
			}
			catch(e:Error){	}
			finally{
				/* If disconnect was not manual attempt reconnection*/
				if(modelLocator.wasConnected)CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.ATTEMPTRECONNECT));
			}
		}
	}
}