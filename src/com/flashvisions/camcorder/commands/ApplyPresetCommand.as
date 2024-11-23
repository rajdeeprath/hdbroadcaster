package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.OperationMode;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.vo.BroadcastPreset;
	
	import flash.media.Sound;
	import flash.media.SoundCodec;
	
	import mx.collections.ArrayCollection;
	
	public class ApplyPresetCommand extends SequenceCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		override public function execute(event:CairngormEvent):void
		{
			var broadcastEvent:BroadcastEvent = event as BroadcastEvent;
			var settings:Object = broadcastEvent.params[0] as Object;
			
			
			/* Set UI Indexes */
			modelLocator.selectedFpsIndex = getItemIndexByProperty(modelLocator.fps,"fps",settings.fps);
			modelLocator.selectedMicRatesIndex = getItemIndexByProperty(modelLocator.micRates,"rate",settings.micrate);
			modelLocator.selecedResolutionIndex = getMultiItemIndexByProperty(modelLocator.resolution,"width","height",settings.width,settings.height);
			modelLocator.selectedAudioCodecIndex = getAudioCodecIndex(modelLocator.audioFormats,settings.audiocodec);
			
			/* Apply Settings */
			modelLocator.h26level =  settings.level;
			modelLocator.h264profile = settings.profile;
			
			modelLocator.cameraWidth = settings.width;
			modelLocator.cameraHeight = settings.height;
			modelLocator.cameraFPS = settings.fps;
			modelLocator.cameraKeyframe = settings.keyframe;
			modelLocator.cameraBandWidth = settings.bandwidth;
			modelLocator.videoQuality = settings.quality;
			
			modelLocator.micRate = settings.micrate;
			modelLocator.audioCodec = settings.audiocodec;
			modelLocator.encodeQuality = settings.encodeQuality;
			

			/* calculate audio bandwidth */
			
			if(!modelLocator.disableAudio)
			{
				switch(modelLocator.audioCodec)
				{
					case SoundCodec.NELLYMOSER:
					modelLocator.audioBandwidth = Math.round((modelLocator.micRate * 2) * 125);
					break;
					
					case SoundCodec.SPEEX:
					modelLocator.audioBandwidth = Math.round(Number(modelLocator.speexBWUsage.getItemAt(modelLocator.encodeQuality)) * 125);
					break;
				}
			}

			
			if(modelLocator.mic != null)
			CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.MICROPHONE_INITIALIZE));
			
			if(modelLocator.camera != null)
			CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.CAMERA_INITIALIZE));
			
			/* Get Bitrate */
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.GETBITRATE));
			
			
			modelLocator.notificationClient.invokeExternal(BroadcastEvent.PRESETCHANGED, settings);
		}
		
		
		public function getAudioCodecIndex(array:ArrayCollection, value:String):Number
		{
			for (var i:Number = 0; i < array.length; i++)
			{
				var codec:String = array.getItemAt(i) as String;
				if (codec == value)	return i;
			}
			
			return -1;
		}
		
		public function getItemIndexByProperty(array:ArrayCollection, property:String, value:String):Number
		{
			for (var i:Number = 0; i < array.length; i++)
			{
				var obj:Object = array.getItemAt(i) as Object;
				if (obj[property] == value)	return i;
			}
			
			return -1;
		}
		
		public function getMultiItemIndexByProperty(array:ArrayCollection, property1:String, property2:String, value1:String, value2:String):Number
		{
			for (var i:Number = 0; i < array.length; i++)
			{
				var obj:Object = array.getItemAt(i) as Object;
				if ((obj[property1] == value1)&&(obj[property2] == value2))	return i;
			}
			
			return -1;
		}
	}
}