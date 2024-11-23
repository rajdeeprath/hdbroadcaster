package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class ConnectionEvent extends CairngormEvent
	{
		public static const ATTEMPTRECONNECT:String = "ATTEMPTRECONNECT";
		public static const CONNECT:String = "CONNECT";
		public static const DISCONNECT:String = "DISCONNECT";
		public static const CONNECTSUCCESS:String = "CONNECTSUCCESS";
		public static const CONNECTFAILED:String = "CONNECTFAILED";
		
		private var eventType:String;
		public var info:Object;
		
		public function ConnectionEvent(type:String, info:Object=null)
		{
			this.eventType = type;
			this.info = info;
			
			super(eventType);
		}
		
		override public function clone() : Event
		{
			return new ConnectionEvent(eventType,info);
		}
	}
}