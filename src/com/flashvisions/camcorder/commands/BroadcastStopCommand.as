package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	public class BroadcastStopCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(modelLocator.dvr){
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.DVRSTOP));
			}
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUBLISHSTOP));
		}
	}
}