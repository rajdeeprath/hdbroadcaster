package com.flashvisions.camcorder.vo
{
	[RemoteClass(alias="org.red5.server.api.stream.data.DVRStreamInfo")]
	public class DVRInfo
	{
		public var streamName:String;
		public var callTime:Date;
		public var startRec:Date;
		public var stopRec:Date;
		public var maxLen:Number;
		public var begOffset:Number;
		public var endOffset:Number;
		public var append:Boolean;
		public var offline:Boolean;
		public var dynamicStreamSet:String;
		
		public function DVRInfo()
		{
		}
	}
}