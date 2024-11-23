package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class ApplicationEvent extends CairngormEvent
	{
		public static const TRANSCODEREQUEST:String = "TRANSCODEREQUEST";
		public static const TRANSCODEREQUESTCOMPLETE:String = "TRANSCODEREQUESTCOMPLETE";
		public static const TRANSCODEREQUESTFAILED:String = "TRANSCODEREQUESTFAILED";
		
		public static const DEVICEACQUIRED:String = "DEVICEACQUIRED";
		
		public static const CHANGEVIEWMODE:String = "CHANGEVIEWMODE";
		public static const INITIALIZESPEAKERVOLUME:String = "INITIALIZESPEAKERVOLUME";
		public static const PRESETMANAGER_LOAD:String = "PRESETMANAGERLOAD";
		public static const PRESETMANAGER_SUCCESS:String = "PRESETMANAGERSUCCESS";
		public static const PRESETMANAGER_FAILED:String = "PRESETMANAGERFAILED";
		public static const BANDWIDTHCHECK:String = "BANDWIDTHCHECK";
		public static const BANDWIDTHDETECTED:String = "BANDWIDTHDETECTED";
		public static const STARTUP:String = "APPLICATIONSTARTUP";
		public static const SHUTDOWN:String = "APPLICATIONSHUTDOWN";
		public static const CONFIGURATION_LOAD:String = "CONFIGURATIONLOAD";
		public static const CONFIGURATION_LOAD_REMOTE:String = "CONFIGURATIONLOADREMOTE";
		public static const CONFIGURATIONLOAD_LOCAL:String = "CONFIGURATIONLOADLOCAL";
		public static const CONFIGURATION_FAILED:String = "CONFIGURATIONFAILED";
		public static const CONFIGURATION_SUCCESS:String = "CONFIGURATIONLOADED";
		public static const SKINLOADED:String = "SKINLOADED";
		public static const SKINERROR:String = "SKINERROR";
		public static const SKIN:String = "LOADSKIN";
		public static const JSBRIDGEREADY:String = "JSBRIDGEREADY";
		public static const READY:String = "APPLICATIONREADY";
		public static const FAILED:String = "APPLICATIONERROR";
		public static const GETBITRATE:String = "GETBITRATE";
		
		public static const ACTIVATEAUTOSENSE:String = "ACTIVATEAUTOSENSE";
		public static const DEACTIVATEAUTOSENSE:String = "DEACTIVATEAUTOSENSE";
		
		public static const SHOWCALIBRATIONWIZARD:String = "SHOWCALIBRATIONWIZARD";
		public static const HIDECALIBRATIONWIZARD:String = "HIDECALIBRATIONWIZARD";
				
		public static const BACKUPPRESET:String = "BACKUPPRESET";
		public static const RESTOREPRESET:String = "RESTOREPRESET";
		
		private var eventType:String;
		public var params:Array;
		
		public function ApplicationEvent(type:String,...params)
		{
			this.eventType = type;
			this.params = params;
			
			super(eventType);
		}
		
		override public function clone():Event
		{
			return new ApplicationEvent(eventType,params);
		} 
	}
}