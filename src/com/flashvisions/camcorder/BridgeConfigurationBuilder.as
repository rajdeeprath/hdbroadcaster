package com.flashvisions.camcorder
{
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.event.LicenceEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	
	import flash.events.Event;
	import flash.utils.describeType;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class BridgeConfigurationBuilder
	{
		private static var logger:ILogger = Log.getLogger("BridgeConfigurationBuilder");
		
		
		public static function buildConfiguration(fvars:Object):Object
		{
			logger.info("Building configuration object");
			
			var jsBridgeConfiguration:Object = new Object();;
			jsBridgeConfiguration.namespace = (fvars.hasOwnProperty("namespace"))?fvars.namespace:"default";
			jsBridgeConfiguration.flashvars = fvars;
			jsBridgeConfiguration.events = describeEvents();
			
			return jsBridgeConfiguration;
		}
		
		
		
		private static function describeEvents():Object {
			var events:Object = new Object();
			var classes:Array = [BroadcastEvent, ConnectionEvent, StreamEvent, ApplicationEvent, CameraEvent, MicrophoneEvent]
			
			for(var i:uint=0;i<classes.length; i++)
			{
				var evtClass:Class = classes[i] as Class;
				var constants:XMLList = flash.utils.describeType(evtClass).child("constant");
					
				for each(var constant:* in  constants)
				{
					var constName:String = constant.@name;
					var constValue:* = evtClass[constName];
					
					// add event name to object
					events[constName] = constValue;
				}
			}
			
			return events;
		}
	}
}