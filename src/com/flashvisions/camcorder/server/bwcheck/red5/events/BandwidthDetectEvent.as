package com.flashvisions.camcorder.server.bwcheck.red5.events 
{
	import flash.events.Event;
	
	public class BandwidthDetectEvent extends Event
	{
		public static const DETECT_STATUS:String = "detect_status";
		public static const DETECT_COMPLETE:String = "detect_complete";
		public static const DETECT_FAILED:String = "detect_failed";
		public static const SERVER_CLIENT_BANDWIDTH:String = "detect_serverclient";
		public static const CLIENT_SERVER_BANDWIDTH:String = "detect_clientserver";
		
		private var _info:Object;
		
		public function BandwidthDetectEvent(eventName:String)
        {
            super (eventName);
        }
        
        public function set info(obj:Object):void
        {
        	_info = obj;
        }
        
        public function get info():Object
        {
        	return _info;	
        }
      

	}
}