package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.OperationMode;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.view.EchoControlPanel;
	
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class DevicesAcquiredActionCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(!modelLocator.acquired && modelLocator.isConnected && !modelLocator.isBroadcasting && ( (modelLocator.allowVideo && modelLocator.mode == OperationMode.VIDEO) || (modelLocator.allowAudio && modelLocator.mode == OperationMode.AUDIO) || ((modelLocator.allowVideo && modelLocator.allowAudio) && modelLocator.mode == OperationMode.DUPLEX)  || ((modelLocator.allowAudio || modelLocator.allowVideo) && modelLocator.mode == null)))
			{
				modelLocator.acquired = true;
				
				if(modelLocator.autoStart)
				setTimeout(autoPublish,800);
			}
		}
		
		private function autoPublish():void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTART));
		}
	}
}