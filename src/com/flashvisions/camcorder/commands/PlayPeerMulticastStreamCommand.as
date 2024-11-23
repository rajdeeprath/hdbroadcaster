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
	
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.VideoCodec;
	import flash.net.GroupSpecifier;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	
	public class PlayPeerMulticastStreamCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			modelLocator.playbackName =  streamEvent.params[0];
			
			try
			{
				if(!modelLocator.isConnected) throw new Error("Not connected!");
				if(modelLocator.isPlaying) deInitMulticastStream();
				initStream();
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		

		private function initStream():void
		{
			initMulticastStreamConnectionListener();
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.CREATEBROADCASTGROUP));
			
			if(!modelLocator.playbackGroup)initMulticastGroup();
			else initMulticastStream();
		}
				
		
		private function initMulticastGroup():void
		{ 
			modelLocator.playbackGroup = new NetGroup(modelLocator.broadcastConnection,modelLocator.groupspec.groupspecWithAuthorizations());
			modelLocator.playbackGroup.addEventListener(NetStatusEvent.NET_STATUS,onplaybackGroupStatus);
		}
		
		private function deInitMulticastGroup():void
		{
			deInitMulticastStream();
			
			if(modelLocator.playbackGroup.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.playbackGroup.removeEventListener(NetStatusEvent.NET_STATUS,onplaybackGroupStatus);
			
			if(modelLocator.broadcastConnection.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastConnection.removeEventListener(NetStatusEvent.NET_STATUS, streamConnectionStatus);
			
			modelLocator.playbackGroup.close();
			modelLocator.playbackGroup = null;
		}
		
		private function initMulticastStream():void
		{
			if(!modelLocator.playbackStream)
			modelLocator.playbackStream = new NetStream(modelLocator.broadcastConnection,modelLocator.groupspec.groupspecWithAuthorizations());
			modelLocator.playbackStream.addEventListener(NetStatusEvent.NET_STATUS, onStreamStatus, false, 0, true);
			modelLocator.playbackStream.bufferTime = modelLocator.previewbuffer;
			modelLocator.playbackStream.client = new PlaybackStreamClient();
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.TOGGLESTREAMAUDIO, modelLocator.previewAudio));
		}
		
		private function deInitMulticastStream():void
		{
			if(modelLocator.playbackStream.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.playbackStream.removeEventListener(NetStatusEvent.NET_STATUS, onStreamStatus);
			
			modelLocator.playbackStream.close();
			modelLocator.playbackStream = null;
			
			refreshPeerStream();
		}
		
		private function playStream():void
		{
			trace("playing .. "+modelLocator.playbackName);
			modelLocator.playbackStream.play(modelLocator.playbackName);
		}
		
		private function refreshPeerStream():void
		{
			modelLocator.peerStream = null;
			modelLocator.peerStream = 	modelLocator.playbackStream;
		}
		
		private function deInitMulticastStreamConnectionListener():void
		{
			//if(modelLocator.broadcastConnection.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastConnection.removeEventListener(NetStatusEvent.NET_STATUS, streamConnectionStatus);
		}
		
		private function initMulticastStreamConnectionListener():void
		{
			//if(!modelLocator.broadcastConnection.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastConnection.addEventListener(NetStatusEvent.NET_STATUS, streamConnectionStatus);
		}
		
		private function onplaybackGroupStatus(ns:NetStatusEvent):void
		{
			trace("group "+ns.info.code);
			
			switch(ns.info.code)
			{
				case "NetGroup.MulticastStream.UnpublishNotify":
				case "NetGroup.MulticastStream.PublishNotify":
				refreshPeerStream();
				break;
				
				case "NetGroup.Neighbor.Connect":
				break;
			}
		}
		
		private function streamConnectionStatus(ns:NetStatusEvent):void
		{
			trace("connction "+ns.info.code);
			
			switch(ns.info.code)
			{
				case "NetStream.Connect.Success":
				playStream();
				deInitMulticastStreamConnectionListener();
				break;
				
				case "NetGroup.Connect.Success":
				initMulticastStream();
				break;
				
				case "NetStream.Connect.Rejected":
				case "NetGroup.Connect.Rejected":
				case "NetGroup.Connect.Failed":
				deInitMulticastGroup();
				break;
			}
		}
				
		
		private function onStreamStatus(ns:NetStatusEvent):void
		{
			trace("stream "+ns.info.code);
			
			switch(ns.info.code)
			{
				case "NetStream.MulticastStream.Reset":
				refreshPeerStream();
				break;
				
				case "NetStream.Buffer.Full":
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
			}
		}
	}
}