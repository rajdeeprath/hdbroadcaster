package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.vo.DVRInfo;
	import com.flashvisions.components.Alert;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	
	import mx.rpc.IResponder;
	
	public class DVRStartCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var connection:NetConnection = modelLocator.broadcastConnection;
			var stream:NetStream = modelLocator.broadcastDownStream;
			
			if(connection && connection.connected && stream && modelLocator.isBroadcasting)
			{
				var dvrInfo:DVRInfo = new DVRInfo();
				var callTime:Date = new Date();
				
				
				if(modelLocator.dvrInfo != null)
				{
					dvrInfo.streamName = modelLocator.publishName;
					dvrInfo.callTime = callTime;
					dvrInfo.startRec = callTime;
					dvrInfo.stopRec = new Date(1970, 0, 1, 0, 0, 0);
					dvrInfo.maxLen = dvrInfo.maxLen;
					dvrInfo.begOffset = dvrInfo.begOffset;
					dvrInfo.endOffset = dvrInfo.endOffset;
					dvrInfo.append = dvrInfo.append;
					dvrInfo.offline = dvrInfo.offline;
					dvrInfo.dynamicStreamSet = modelLocator.publishName;
				}
				else
				{
					dvrInfo.streamName = modelLocator.publishName;
					dvrInfo.callTime = callTime;
					dvrInfo.startRec = callTime;
					dvrInfo.stopRec = new Date(1970,01, 01);
					dvrInfo.maxLen = 0;
					dvrInfo.begOffset = 0;
					dvrInfo.endOffset = 0;
					dvrInfo.append = true;
					dvrInfo.offline = false;
					dvrInfo.dynamicStreamSet = modelLocator.publishName;
				}
				
				
				
				// make call to server
				
				try
				{
					connection.call("DVRSetStreamInfo", null , dvrInfo);
				}
				catch(e:Error)
				{
					trace("Error " + e.message);
				}
			}
		}
		
	}
}