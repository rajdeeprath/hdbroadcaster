package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	
	public class ApplyBidirectionalAECCommand implements ICommand
	{
		[Bindable]
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance()
			
		public function execute(event:CairngormEvent):void
		{
			var enhancedOptions:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			enhancedOptions.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
			enhancedOptions.nonLinearProcessing = true;
			enhancedOptions.echoPath = 128;
			modelLocator.mic.enhancedOptions = enhancedOptions;
		}
	}
}