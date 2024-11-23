package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.media.MicrophoneEnhancedOptions;
	
	public class ApplyEnhancedMicrophoneOptionsCommand implements ICommand
	{
		[Bindable]
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance()
			
		public function execute(event:CairngormEvent):void
		{
			var microphoneEvent:MicrophoneEvent = event as MicrophoneEvent;
			var params:Array = microphoneEvent.params;
			var enhancedOptions:MicrophoneEnhancedOptions = params[0] as MicrophoneEnhancedOptions;
			
			modelLocator.mic.enhancedOptions = enhancedOptions;
		}
	}
}