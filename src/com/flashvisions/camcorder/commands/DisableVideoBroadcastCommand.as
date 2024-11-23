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
	
	public class DisableVideoBroadcastCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(modelLocator.camera != null)
			{
				if(modelLocator.isBroadcasting)
				modelLocator.broadcastDownStream.attachCamera(null);
				modelLocator.allowVideo = false;
				
				CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.VIDEOBROADCASTDISABLED,modelLocator.camera.name));
			}
		}
	}
}