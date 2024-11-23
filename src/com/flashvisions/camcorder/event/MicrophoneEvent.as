package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class MicrophoneEvent extends CairngormEvent
	{
		public static const MICROPHONE_SOURCE_CHANGE:String = "MICROPHONESELECT";
		public static const MICROPHONE_ACQUIRE:String = "MICROPHONEACQUIRE";
		public static const MICROPHONE_INITIALIZE:String = "MICROPHONEINITIALIZE";
		public static const DEINITIALIZE:String = "MICROPHONERELEASE";
		public static const SHOWECHOCONTROL:String = "SHOWECHOCONTROL";
		public static const HIDEECHOCONTROL:String = "HIDEECHOCONTROL";
		public static const APPLYENHANCEDOPTIONS:String = "APPLYENHANCEDOPTIONS";
		
		private var eventType:String;
		public var params:Array;
		
		public function MicrophoneEvent(type:String,...params)
		{
			this.eventType = type;
			this.params = params;
			
			super(eventType);
		}
		
		override public function clone() : Event
		{
			return new MicrophoneEvent(eventType,params);
		}
	}
}