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
	
	public class PlaybackStopCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			try
			{
				switch(modelLocator.protocol)
				{
					case Protocol.RTMP:
					CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.STOPSERVERMULTICAST));
					break;
					
					case Protocol.RTMFP:
					CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.STOPP2PMULTICAST));
					break;
				}
			}
			catch(e:Error)
			{
				trace("error :"+e.message);
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PLAYBACKSTOPPED));
			}
			finally
			{
				modelLocator.playbackName = null;
			}
		}
		
	}
}