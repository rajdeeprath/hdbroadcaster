package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import org.osmf.metadata.CuePoint;
	
	public class PushMetadataCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			var metadata:Object = streamEvent.params[0];
			
			modelLocator.broadcastDownStream.send("@setDataFrame", "onMetaData", metadata);	
		}
	}
}