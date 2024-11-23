package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.external.ExternalInterface;
	
	public class MicrophoneChangeCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTOP));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(MicrophoneEvent.MICROPHONE_SOURCE_CHANGE));
			
			if(modelLocator.micIndex >=0)
			CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.MICROPHONE_ACQUIRE));
			else
			CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.DEINITIALIZE));
		}
	}
}