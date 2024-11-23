package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import mx.collections.ArrayCollection;
	
	public class ToggleStreamAudioCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			var previewAudio:Boolean =  streamEvent.params[0];
			
			modelLocator.previewAudio = previewAudio;
			modelLocator.playBackSoundTransform.volume = (modelLocator.previewAudio)?1:0
			
			if(modelLocator.playbackStream)
			modelLocator.playbackStream.soundTransform = modelLocator.playBackSoundTransform;	
		}
	}
}