package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.events.Event;
	import flash.media.VideoCodec;
	
	public class VideoCodecChangedCommand implements ICommand
	{
		
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			var cameraEvent:CameraEvent = event as CameraEvent;
			modelLocator.videoCodec = cameraEvent.params[0] as String;
				
			modelLocator.broadcastQuality = (modelLocator.videoCodec ==  VideoCodec.SORENSON)?modelLocator.sdQuality:modelLocator.hdQuality;
			modelLocator.presetIndex = modelLocator.getPresetIndexByLabel(modelLocator.forceQuality); 
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.APPLYPRESET,modelLocator.broadcastQuality.getItemAt(modelLocator.presetIndex)));
			
			if(modelLocator.videoCodec != VideoCodec.SORENSON)
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.DEACTIVATEAUTOSENSE));
		}
	}
}