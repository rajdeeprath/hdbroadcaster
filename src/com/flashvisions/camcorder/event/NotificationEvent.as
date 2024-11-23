package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class NotificationEvent extends CairngormEvent
	{
		public static const NOTIFY:String = "NOTIFY";
		
		public var eventName:String;
		public var params:Object;
		
		public function NotificationEvent(eventName:String, params:Object = null)
		{
			this.eventName = eventName;
			this.params = params;
			
			super(NOTIFY);
		}
		
		override public function clone() : Event
		{
			return new NotificationEvent(eventName,params);
		}
	}
}