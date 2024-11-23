package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.CamcorderMode;
	import com.flashvisions.camcorder.Protocol;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceType;
	
	import flash.events.TimerEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	
	
	public class PublishSuccessCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var streamEvent:StreamEvent = event as StreamEvent;
			var info:Object = streamEvent.params[0];
			
			if(modelLocator.allowAudio)
			modelLocator.micMonitor.start();
			
			
			/* Force disable preview for RTMFP streaming */
			modelLocator.enablePreview = (modelLocator.protocol == Protocol.RTMFP)?false:modelLocator.enablePreview;
			
			
			if(modelLocator.enablePreview)
			{
				if(!modelLocator.isPlaying && !modelLocator.playbackURL) 
				CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.STARTPLAYBACK, modelLocator.publishName));
				else
				modelLocator.playbackName = modelLocator.publishName;	
			}
			
			modelLocator.isBroadcasting = true;
			modelLocator.wasPublishing = true;
			
			/* Push metadata if available */
			if(modelLocator.metadata != null)
			CairngormEventDispatcher.getInstance().dispatchEvent(new StreamEvent(StreamEvent.PUSHMETADATA, modelLocator.metadata));
			
			
			if(modelLocator.dvr)
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(StreamEvent.DVRSTART));
				
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.STARTDURATIONMONITOR));
			CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.SNAPSHOT));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSTART, info));
		}
		
		
		/* Utility function to return playsafe stream name */
		
		
		private function getPlaySafeStreamName(stream:String):String
		{
			var extension:String;
			var extensionless:String;
			var publishName:String;
			var extensionIndex:Number = stream.lastIndexOf('.');
			var separatorIndex:Number = stream.lastIndexOf('/');
			
			// check for stream name terminator
			if(separatorIndex != -1) stream = stream.substring(0,separatorIndex);
			
			
			// if no extension return as it is
			if(extensionIndex == -1) return stream;
			
	
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
	}
}