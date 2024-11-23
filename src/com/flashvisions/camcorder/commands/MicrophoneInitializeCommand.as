package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundCodec;
	import flash.media.SoundTransform;
	
	public class MicrophoneInitializeCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			
			switch(modelLocator.mic.codec = modelLocator.audioCodec)
			{
				case SoundCodec.NELLYMOSER:
					modelLocator.mic.setSilenceLevel(6);
					modelLocator.mic.rate = modelLocator.micRate;
				break;
				
				case SoundCodec.SPEEX:
					modelLocator.mic.enableVAD = true;
					modelLocator.mic.setSilenceLevel(0);
					modelLocator.mic.rate = 16;
					modelLocator.mic.encodeQuality = modelLocator.encodeQuality;
				break;
			}
			
			
			modelLocator.mic.gain = modelLocator.micGain;
			modelLocator.mic.setUseEchoSuppression(true);
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(MicrophoneEvent.MICROPHONE_INITIALIZE, modelLocator.mic.name));
		}

	}
}