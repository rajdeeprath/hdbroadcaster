package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.CamcorderMode;
	import com.flashvisions.camcorder.Protocol;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.VideoCodec;
	import flash.net.GroupSpecifier;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	
	public class StopPeerMulticastStreamCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			try
			{
				modelLocator.playbackStream.close();
				modelLocator.playbackGroup.close();
			}
			catch(e:Error)
			{
				trace("error : "+e.message);
			}
			finally
			{
				modelLocator.playbackGroup = null;
				modelLocator.playbackStream = null;
				modelLocator.peerStream = null;
				
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PLAYBACKSTOPPED));
			}
		}
	}
}