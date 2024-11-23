package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class StreamEvent extends CairngormEvent
	{
		public static const TOGGLESTREAMAUDIO:String = "TOGGLESTREAMAUDIO";
		
		public static const PUSHMETADATA:String = "PUSHMETADATA";
		public static const PUSHEXTRADATA:String = "PUSHEXTRADATA";
		
		public static const PLAYP2PMULTICAST:String = "PLAYP2PMULTICAST";
		public static const PLAYSERVERMULTICAST:String = "PLAYSERVERMULTICAST";
		public static const STOPP2PMULTICAST:String = "STOPP2PMULTICAST";
		public static const STOPSERVERMULTICAST:String = "STOPSERVERMULTICAST";
		
		public static const DISABLEPREVIEW:String = "DISABLEPREVIEW";
		public static const STARTPLAYBACK:String = "STARTPLAYBACK";
		public static const STOPPLAYBACK:String = "STOPPLAYBACK";
		
		public static const PLAYBACKSTARTED:String = "PLAYBACKSTARTED";
		public static const PLAYBACKSTOPPED:String = "PLAYBACKSTOPPED";
		
		public static const PUBLISHSTART:String = "PUBLISHSTART";
		public static const PUBLISHSTOP:String = "PUBLISHSTOP";
		public static const PUBLISHSUCCESS:String = "PUBLISHSUCCESS";
		public static const PUBLISHFAILED:String = "PUBLISHFAILED";

		public static const DVRSTART:String = "DVRSTART";
		public static const DVRSTOP:String = "DVRSTOP";
		
		private var eventType:String;
		public var params:Array;
		
		public function StreamEvent(type:String,...rest)
		{
			eventType = type;
			params = rest;
			super(eventType);
		}
		
		override public function clone() : Event
		{
			return new StreamEvent(eventType,params);
		}
	}
}