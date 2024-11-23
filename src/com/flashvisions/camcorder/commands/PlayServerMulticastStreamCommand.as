package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.CamcorderMode;
	import com.flashvisions.camcorder.Protocol;
	import com.flashvisions.camcorder.clients.PlaybackStreamClient;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.VideoCodec;
	import flash.net.GroupSpecifier;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	
	public class PlayServerMulticastStreamCommand implements ICommand
	{
		[Bindable]
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		private var p2pstream:String;
		
		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			modelLocator.playbackName =  streamEvent.params[0];
			
			try
			{
				if(!modelLocator.isConnected) throw new Error("Not connected!");
				if(modelLocator.isPlaying) deinitStream();
				initStream();
				playStream();	
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		

		private function initStream():void
		{
			if(!modelLocator.playbackStream)
			modelLocator.playbackStream = new NetStream(modelLocator.broadcastConnection);
			modelLocator.playbackStream.addEventListener(NetStatusEvent.NET_STATUS, onStreamStatus, false, 0, true);
			modelLocator.playbackStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true); 
			modelLocator.playbackStream.client = new PlaybackStreamClient();
			modelLocator.playbackStream.bufferTime = modelLocator.previewbuffer;
			
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.TOGGLESTREAMAUDIO, modelLocator.previewAudio));
		}
		
		private function deinitStream():void
		{
			if(modelLocator.playbackStream.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.playbackStream.removeEventListener(NetStatusEvent.NET_STATUS, onStreamStatus);
			
			if(modelLocator.playbackStream.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
			modelLocator.playbackStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			modelLocator.playbackStream.close();
			modelLocator.playbackStream = null;
			
			refreshPeerStream();
		}
		
		
		private function playStream():void
		{
			modelLocator.playbackStream.play(modelLocator.playbackName);
		}
		
		
		private function refreshPeerStream():void
		{
			modelLocator.peerStream = null;
			modelLocator.peerStream = 	modelLocator.playbackStream;
		}
				
		
		/* Event Handler */
		
		private function asyncErrorHandler(ns:AsyncErrorEvent):void
		{
			trace("async error");
		}
		
		private function onStreamStatus(ns:NetStatusEvent):void
		{
			switch(ns.info.code)
			{
				case "NetStream.Buffer.Full":
				break;
				
				case "NetStream.Buffer.Empty":
				break;
				
				case "NetStream.Play.Reset":
				refreshPeerStream();
				break;
				
				case "NetStream.Play.Start":
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PLAYBACKSTARTED));
				refreshPeerStream();
				break;
				
				case "NetStream.Play.Stop":
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PLAYBACKSTOPPED));
				break;
				
				case "NetStream.Unpause.Notify":
				break;
				
				case "NetStream.Pause.Notify":
				break;
				
				case "NetStream.Play.InsufficientBW":
				break;
			}
		}
	}
}