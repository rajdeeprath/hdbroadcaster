package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class BroadcastEvent extends CairngormEvent
	{
		public static const ENABLEAUDIOBROADCAST:String = "ENABLEAUDIOBROADCAST";
		public static const DISABLEAUDIOBROADCAST:String = "DISABLEAUDIOBROADCAST";
		
		public static const AUDIOBROADCASTENABLED:String = "AUDIOBROADCASTENABLED";
		public static const AUDIOBROADCASTDISABLED:String = "AUDIOBROADCASTDISABLED";
		
		public static const ENABLEVIDEOBROADCAST:String = "ENABLEVIDEOBROADCAST";
		public static const DISABLEVIDEOBROADCAST:String = "DISABLEVIDEOBROADCAST";
		
		public static const VIDEOBROADCASTENABLED:String = "VIDEOBROADCASTENABLED";
		public static const VIDEOBROADCASTDISABLED:String = "VIDEOBROADCASTDISABLED";
		
		public static const STARTDURATIONMONITOR:String = "STARTDURATIONMONITOR";
		public static const STOPDURATIONMONITOR:String = "STOPDURATIONMONITOR";
		public static const BROADCASTSTART:String = "BROADCASTBEGIN";
		public static const BROADCASTSTOP:String = "BROADCASTEND";
		public static const BROADCASTFAILED:String = "BROADCASTERROR";
		public static const BROADCASTSAVE:String = "SESSIONSAVE";
		public static const BROADCASTSAVESUCCESS:String = "SESSIONSAVESUCCESS";
		public static const BROADCASTSAVEFAILED:String = "SESSIONSAVEFAILED";
		public static const STARTMONITOR:String = "STARTBROADCASTMONITOR";
		public static const STOPMONITOR:String = "STOPBROADCASTMONITOR";
		public static const APPLYPRESET:String = "APPLYPRESET";
		public static const PRESETCHANGED:String = "PRESETCHANGED";
		public static const CREATEBROADCASTGROUP:String = "CREATEBROADCASTGROUP";
		
		private var eventType:String;
		public var params:Array;
		
		public function BroadcastEvent(type:String,...rest)
		{
			eventType = type;
			params = rest;
			super(eventType);
		}
		
		override public function clone():Event
		{
			return new BroadcastEvent(eventType,params);
		}
	}
}