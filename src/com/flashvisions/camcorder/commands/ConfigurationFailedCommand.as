package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.remoting.RemotingConnection;
	
	import flash.external.ExternalInterface;
	import flash.net.Responder;
	import flash.net.URLLoader;
	
	public class ConfigurationFailedCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var applicationEvent:ApplicationEvent = event as ApplicationEvent;
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.FAILED,applicationEvent.params));
		}
	}
}