package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import org.osmf.metadata.CuePoint;
	
	public class PushExtraDataCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			var method:String = streamEvent.params[0] as String;
			var extraData:Object = streamEvent.params[1];
			
			modelLocator.broadcastDownStream.send("@setDataFrame", method, extraData);	
		}
	}
}