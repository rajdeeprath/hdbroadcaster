package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class LicenceEvent extends CairngormEvent
	{
		public static const VALIDATION_SUCCESS:String = "LICENCEVALID";
		public static const VALIDATION_FAILURE:String = "LICENCEINVALID";
		public static const VALIDATE:String = "VALIDATELICENCE";
		public static const VERIFY:String = "VERIFYLICENCE";
		
		private var eventType:String;
		public var licence:String;
		
		public function LicenceEvent(type:String,licenceKey:String = null)
		{
			eventType = type;
			licence = licenceKey;
			
			super(eventType);
		}
		
		override public function clone() : Event
		{
			return new LicenceEvent(eventType,licence);
		}
	}
}