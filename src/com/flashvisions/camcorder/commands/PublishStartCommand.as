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
	import flash.media.SoundTransform;
	import flash.media.VideoCodec;
	import flash.net.GroupSpecifier;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	
	public class PublishStartCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		
		public function execute(event:CairngormEvent):void
		{
			try
			{
				if(!modelLocator.isConnected) throw new Error("Not connected!");
				initStream();
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		

		private function initStream():void
		{
			switch(modelLocator.protocol)
			{
				case Protocol.RTMFP:
				//modelLocator.enablePreview = false;
				initMulticastStreamConnectionListener();
				CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.CREATEBROADCASTGROUP));
				if(!modelLocator.broadcastGroup)initMulticastGroup();
				else initMulticastStream();
				break;
				
				default:
				initUnicastStream();
				break;
			}
		}
		
		
		private function initMulticastGroup():void
		{ 
			modelLocator.broadcastGroup = new NetGroup(modelLocator.broadcastConnection,modelLocator.groupspec.groupspecWithAuthorizations());
			if(!modelLocator.broadcastGroup.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastGroup.addEventListener(NetStatusEvent.NET_STATUS,onBroadcastGroupStatus);
			
		}
		
		private function deInitMulticastGroup():void
		{
			if(modelLocator.broadcastGroup.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastGroup.removeEventListener(NetStatusEvent.NET_STATUS,onBroadcastGroupStatus);
			
			if(modelLocator.broadcastConnection.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastConnection.removeEventListener(NetStatusEvent.NET_STATUS, streamConnectionStatus);
			
			modelLocator.broadcastGroup.close();
			modelLocator.broadcastGroup = null;
		}
		
		private function initMulticastStream():void
		{
			modelLocator.broadcastDownStream = new NetStream(modelLocator.broadcastConnection,modelLocator.groupspec.groupspecWithAuthorizations());
			if(!modelLocator.broadcastDownStream.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastDownStream.addEventListener(NetStatusEvent.NET_STATUS, onStatus,false,0,true);
			modelLocator.broadcastDownStream.audioReliable = true;
			modelLocator.broadcastDownStream.bufferTime = .5; // FOR RTMFP
		}
		
		private function initUnicastStream():void
		{
			modelLocator.broadcastDownStream = new NetStream(modelLocator.broadcastConnection);
			if(!modelLocator.broadcastDownStream.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastDownStream.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			modelLocator.broadcastDownStream.bufferTime = 0; // FOR RTMP
			
			publishStream();
		}
		
		
		private function publishStream():void
		{
			if(modelLocator.allowAudio && modelLocator.broadcastAudio)	modelLocator.broadcastDownStream.attachAudio(modelLocator.mic);
			else modelLocator.broadcastDownStream.attachAudio(null);
			
			if(modelLocator.allowVideo && modelLocator.broadcastVideo)	modelLocator.broadcastDownStream.attachCamera(modelLocator.camera);
			else modelLocator.broadcastDownStream.attachCamera(null);
			
			if(!modelLocator.broadcastDownStream.hasEventListener(NetStatusEvent.NET_STATUS))
			modelLocator.broadcastDownStream.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			
			if (modelLocator.videoCodec == VideoCodec.H264AVC)
			modelLocator.broadcastDownStream.videoStreamSettings = modelLocator.h264Settings;
			else
			modelLocator.broadcastDownStream.videoStreamSettings = modelLocator.sorensonSettings;
			
			modelLocator.broadcastDownStream.publish(getPublishSafeString(modelLocator.publishName) + modelLocator.publishQueryString,modelLocator.broadcastMode);
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
		
		private function getPublishSafeString(stream:String):String
		{
			var extension:String;
			var extensionless:String;
			var publishName:String;
			var extensionIndex:Number = stream.lastIndexOf('.');
			
			// if no extension return as it is
			if((extensionIndex == -1)||(modelLocator.protocol == Protocol.RTMFP)) return stream;
			
			// else get name without extension ... if name is invalid (null or empty) throw error
			extensionless = stream.substr( 0, extensionIndex ); 
			if(extensionless.length == 0)throw new Error("Invalid stream name");
			
			// get stream extension
			extension = stream.substr(extensionIndex+1,stream.length-1);

			//validate extension
			switch(extension)
			{
				case 'mp4':
					publishName = "mp4:"+extensionless+".mp4";
					break;
				case 'mp3':
					publishName = "mp3:"+extensionless;
					break;
				case 'id3':
					publishName = "id3:"+extensionless;
					break;
				case 'f4v':
					publishName = "mp4:"+extensionless+".f4v";
					break;
				case '':
					publishName = stream;
					break;
				case 'flv':
					publishName = extensionless;
					break;
				default:
					throw new Error("Invalid stream name");
					break;
			}
			
			return publishName;
		}
		
		
		/* Event Handler */
		
		private function onBroadcastGroupStatus(ns:NetStatusEvent):void
		{
			//trace("Group "+ns.info.code);
		}
		
		private function streamConnectionStatus(ns:NetStatusEvent):void
		{
			//trace("Connection :"+ns.info.code);
			
			switch(ns.info.code)
			{
				case "NetStream.Connect.Success":
					publishStream();
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
				
		
		private function onStatus(ne:NetStatusEvent):void
		{
			var info:Object = new Object();
			info.code = ne.info.code;
			info.timestamp = new Date().time.toString();
			info.stream = getPublishSafeString(modelLocator.publishName);
			
			switch(ne.info.code)
			{
				case "NetStream.Publish.Start":
					CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUBLISHSUCCESS, info));
					break;
				
				case "NetStream.Failed":
				case "NetStream.Publish.BadName":
					CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUBLISHFAILED, info));
					break;
			}
		}
	}
}