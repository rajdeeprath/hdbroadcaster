package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.business.ConfigurationDelegate;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	
	/**
	 * Loads settinsg object from flashvars
	 **/
	public class LoadLocalConfigurationCommand implements ICommand
	{
		private var logger:ILogger = Log.getLogger("LocalConfigurationLoadCommand");
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			try
			{
				logger.info("loading settings from flashvars");
				
				var settings:Object = modelLocator.notificationClient.loadConfiguration();
				if(!settings.userPresets) throw new Error("Invalid configuration data");
				
				result(settings);
			}
			catch(e:Error)
			{
				logger.error("error loading settings from external interface " + e.message);
				fault(e);
			}
		}
		
	
		
		public function result(data:Object):void
		{
			logger.info("loaded settings from flashvars");
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_SUCCESS, data));
		}
		
		
		
		
		public function fault(event:Object):void
		{
			logger.info("Failed to load settings from flashvars");
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_FAILED,"Error loading configuration data"));
		}
		

	}
}