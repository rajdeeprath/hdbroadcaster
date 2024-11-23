package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.business.ConfigurationDelegate;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.server.RTMPServerType;
	import com.flashvisions.components.Alert;
	import com.flashvisions.remoting.RemotingConnection;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	
	public class LoadRemoteConfigurationCommand implements ICommand,IResponder
	{
		[Bindable]
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var __settingsLoader:URLLoader;
		
		public function execute(event:CairngormEvent):void
		{
			if(modelLocator.configuration.scriptLocation)
			{
				var variables:URLVariables = new URLVariables();
				var settingsLoader:URLLoader = new URLLoader();
				settingsLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
				settingsLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				settingsLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				
				for each(var prop:* in modelLocator.configuration)
				variables[prop] = modelLocator.configuration[prop];
				
				
				var request:URLRequest = new URLRequest(modelLocator.gatewayURL);
				request.data = variables;
				request.method = URLRequestMethod.POST;
				
				try{
					settingsLoader.load(request);
				}catch(e:Error){
					trace("Error "+e.message);
				}
			}
			else
			{
				var configurationDelegate:ConfigurationDelegate = new ConfigurationDelegate(this);
				configurationDelegate.loadSettings(modelLocator.configuration);
			}
		}
		
		
		private function onLoadComplete(e:Event):void
		{
			var settingsLoader:URLLoader = e.target as URLLoader;
			var settings:URLVariables = new URLVariables(settingsLoader.data);
			
			settingsLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
			settingsLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_SUCCESS, settings));
		}
		
		private function onError(e:IOErrorEvent):void
		{
			var settingsLoader:URLLoader = e.target as URLLoader;
			settingsLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
			settingsLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_FAILED,"Error loading configuration data"));
		}
		
		
		/* Responder Methods */
		
		public function result(event:Object):void
		{
			var rs:ResultEvent = event as ResultEvent;
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_SUCCESS,rs.result));
		}
		
		
		public function fault(event:Object):void
		{
			var fe:FaultEvent = event as FaultEvent;
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_FAILED,"Error loading configuration data"));
		}
		

	}
}