package com.flashvisions.camcorder.clients
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;

	public class ConnectionClient
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function onBWCheck(info:Object):Number
		{
			return 0;
		}
		
		public function onBWDone(...rest):void
		{
			if (rest.length > 0)CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.BANDWIDTHDETECTED,rest[0]));
		}
		
		public function closeConnection(...rest):void
		{
			modelLocator.wasPublishing = false;
			modelLocator.wasConnected = false;
			
			if(modelLocator.isConnected)
			CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.DISCONNECT));
		}
		
		public function closeStream(...rest):void
		{
			modelLocator.wasPublishing = false;
			
			if(modelLocator.isBroadcasting)
			CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUBLISHSTOP));
		}
		
		
		public function close(...args):void
		{
			trace("close connection");
		}
	}
}