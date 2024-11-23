package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.BridgeConfigurationBuilder;
	import com.flashvisions.camcorder.clients.v2.NotificationClient;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	import com.flashvisions.remoting.RemotingConnection;
	
	import flash.system.Security;
	
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	import mx.utils.URLUtil;
	
	
	
	public class ApplicationStartUpCommand implements ICommand
	{
		private var logger:ILogger = Log.getLogger("ApplicationStartUpCommand");
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var serviceLocation:String;
		
		
		
		
		public function execute(event:CairngormEvent):void
		{
			var flashVars:Object = modelLocator.configuration = FlexGlobals.topLevelApplication.parameters;
			var broadcaster:HDBroadcaster = FlexGlobals.topLevelApplication as HDBroadcaster;
			var scriptLocation:String = modelLocator.configuration.scriptLocation;
			var serviceLocation:String = modelLocator.configuration.serviceLocation;
			var port:Object = URLUtil.getPort(FlexGlobals.topLevelApplication.loaderInfo.url);
			var protocol:String = URLUtil.getProtocol(FlexGlobals.topLevelApplication.loaderInfo.url);
			var currentDomain:String = (port)?URLUtil.getServerNameWithPort(FlexGlobals.topLevelApplication.loaderInfo.url):URLUtil.getServerName(FlexGlobals.topLevelApplication.loaderInfo.url);
			var themeColor:* = flashVars.themeColor;
			var contentBackgroundColor:* = flashVars.contentBackgroundColor;
			var chromeColor:* = flashVars.chromeColor;
			var textColor:* = flashVars.textColor;
			
			
			this.initLogging();
			
			
			if(themeColor)
			broadcaster.setStyle("backgroundColor", "#"+themeColor);
			
			if(chromeColor)
			broadcaster.setStyle("chromeColor", "#"+chromeColor);
			
			if(contentBackgroundColor)
			broadcaster.setStyle("contentBackgroundColor", "#"+contentBackgroundColor);
			
			if(textColor)
			broadcaster.setStyle("color", "#"+textColor);
			
			
			broadcaster.enabled = false;
			modelLocator.currentState = BroadcastModelLocator.PREINIT;
			modelLocator.currentDomain = currentDomain;
		
			
			/* javascript communication channel setup */
			var bridgeConfiguration:Object = BridgeConfigurationBuilder.buildConfiguration(modelLocator.configuration);
			var namespace:String = bridgeConfiguration.namespace;
			
			modelLocator.bridgeConfiguration = bridgeConfiguration;
			modelLocator.notificationClient = new NotificationClient(BroadcastModelLocator.APPWEBSCOPE, namespace);
			
			
			if(scriptLocation)	modelLocator.gatewayURL = protocol + ":" + "//" + currentDomain + "/" + scriptLocation;
			else modelLocator.gatewayURL = (serviceLocation == null)?protocol + ":" + "//" + currentDomain + "/flashservices/" : protocol + ":" + "//" + currentDomain + "/" + serviceLocation;
			
			
			logger.info("Ready to load configuration data from server");
		
			
			if(flashVars.clientmode)
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATIONLOAD_LOCAL));
			else
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIGURATION_LOAD_REMOTE));
		}
		
		
		
		private function initLogging():void
		{
			/* Create a target. */
			var logTarget:TraceTarget = new TraceTarget();
			
			/* Log all log levels. */
			logTarget.level = LogEventLevel.INFO;
			
			/* Add date, time, category, and log level to the output. */
			logTarget.includeDate = true;
			logTarget.includeTime = true;
			logTarget.includeCategory = true;
			logTarget.includeLevel = true;
			
			/* Begin logging. */
			Log.addTarget(logTarget);
			
			logger.info("Logger ready!");
		}
	}
}