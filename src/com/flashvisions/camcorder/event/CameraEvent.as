package com.flashvisions.camcorder.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class CameraEvent extends CairngormEvent
	{
		public static const CAMERA_SOURCE_CHANGE:String = "CAMERASELECT";
		public static const CAMERA_ACQUIRE:String = "CAMERAACQUIRE";
		public static const CAMERA_INITIALIZE:String = "CAMERAINITIALIZE";
		public static const DEINITIALIZE:String = "CAMERARELEASE";
		public static const SNAPSHOT:String = "PREVIEW";
		public static const REFRESHLOCALVIEW:String = "REFRESHLOCALVIEW";
		public static const CHANGECODEC:String = "CHANGECODEC";
		
		private var eventType:String;
		public var params:Array;
		
		public function CameraEvent(type:String,...params)
		{
			eventType = type;
			this.params = params;
			
			super(eventType);
		}
		
		override public function clone() : Event
		{
			return new CameraEvent(eventType,params);
		}
	}
}