package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	public class DisableAudioBroadcastCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(modelLocator.mic)
			{
				if(modelLocator.isBroadcasting)
				modelLocator.broadcastDownStream.attachAudio(null);
				modelLocator.allowAudio = false;
				
				
				CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.AUDIOBROADCASTDISABLED,modelLocator.mic.name));
			}
			
			
		}
	}
}