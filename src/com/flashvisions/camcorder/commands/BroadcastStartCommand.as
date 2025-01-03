package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.CamcorderMode;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	
	public class BroadcastStartCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			if(!modelLocator.isBroadcasting)
			{
				try
				{
					if(!modelLocator.isConnected) throw new Error("Not connected!");
					else if(modelLocator.publishName == "")throw new Error("Please provide a stream name for broadcast !");
					else if((modelLocator.allowVideo)&&(modelLocator.camera == null)) throw new Error("Please select a video source !");
					else if((modelLocator.allowAudio)&&(modelLocator.mic == null)) throw new Error("Please select a audio source !");
					CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUBLISHSTART));
					
					/* Invoke transcoder */
					if(modelLocator.transcoder)
					CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TRANSCODEREQUEST));
				}
				catch(e:Error)
				{
					Alert.show(e.message.toString());
				}
				finally
				{
					modelLocator.operationMode = CamcorderMode.RECORDING;
				}
			
			}
		}
		
	}
}