package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundMixer;
	
	public class InitializeSystemVolumeCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance()
			
		public function execute(event:CairngormEvent):void
		{
			var applicationEvent:ApplicationEvent = event as ApplicationEvent;
			var params:Array = applicationEvent.params;
			var volume:Number =  params[0] as Number;
			
			modelLocator.speakerVolume = volume;
			modelLocator.speakerSoundTransform.volume = modelLocator.speakerVolume;
			SoundMixer.soundTransform = modelLocator.speakerSoundTransform;
		}
	}
}