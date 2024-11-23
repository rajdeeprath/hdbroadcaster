package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.CamcorderMode;
	import com.flashvisions.camcorder.Protocol;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	
	public class PlaybackStartCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			var streamName:String =  streamEvent.params[0];
			
			modelLocator.playbackName = streamName;
			
			switch(modelLocator.protocol)
			{
				case Protocol.RTMP:
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PLAYSERVERMULTICAST,streamName));
				break;
				
				case Protocol.RTMFP:
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PLAYP2PMULTICAST,streamName));
				break;
			}
			
			modelLocator.currentView = BroadcastModelLocator.PLAYBACKVIEW;
		}
		
	}
}