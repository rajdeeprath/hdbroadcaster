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
	import com.flashvisions.camcorder.view.BwCheckUI;
	
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class PublishStopCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var watchDog:uint;
		private var autoConfigUI:BwCheckUI;
		
		public function execute(event:CairngormEvent):void
		{
			try
			{
				if(!modelLocator.isBroadcasting)throw new Error("Broadcast already stopped")
				modelLocator.broadcastDownStream.attachAudio(null);
				modelLocator.broadcastDownStream.attachCamera(null);
				modelLocator.broadcastDownStream.close();
				modelLocator.broadcastDownStream = null;
				modelLocator.isBroadcasting = false;
				
				if(modelLocator.allowAudio){
				modelLocator.micMonitor.stop();
				modelLocator.micMonitor.reset();
				}
				

				
				if(modelLocator.enablePreview)
				{
					if(modelLocator.isPlaying && !modelLocator.playbackURL) 
					CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.STOPPLAYBACK));
					else
					modelLocator.playbackName = null;;	
				}
				
				
				CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.STOPDURATIONMONITOR));
				CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSTOP, modelLocator.publishName));
				
			}
			catch(e:Error){
				trace(e.message);
			}
		}
	}
}