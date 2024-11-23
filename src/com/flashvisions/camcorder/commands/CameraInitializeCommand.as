package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceType;
	
	import flash.external.ExternalInterface;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.VideoCodec;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class CameraInitializeCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var logger:ILogger = Log.getLogger("CameraInitializeCommand");
		
		
		public function execute(event:CairngormEvent):void
		{
			/* Initialize Camera */
			modelLocator.cameraBandWidth = (modelLocator.detectedBandWidth > modelLocator.cameraBandWidth)?modelLocator.detectedBandWidth:modelLocator.cameraBandWidth;
			modelLocator.cameraBandWidth = modelLocator.cameraBandWidth - modelLocator.audioBandwidth;
			modelLocator.cameraBandWidth = (!modelLocator.bwStrict && modelLocator.videoCodec == VideoCodec.H264AVC)?0:modelLocator.cameraBandWidth;
			modelLocator.cameraBandWidth = (modelLocator.appmode == LicenceType.TRIAL && BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE && modelLocator.cameraBandWidth>25000)?25000:modelLocator.cameraBandWidth;
			
			/* Limit width height to 320/240 because this is only for chat */
			modelLocator.cameraWidth = ((BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE) && (modelLocator.cameraWidth > 320))?320:modelLocator.cameraWidth;
			modelLocator.cameraHeight = ((BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE) && (modelLocator.cameraHeight > 240))?240:modelLocator.cameraHeight;
			
			modelLocator.camera.setMode(modelLocator.cameraWidth,modelLocator.cameraHeight, modelLocator.cameraFPS);
			modelLocator.camera.setQuality(modelLocator.cameraBandWidth, modelLocator.videoQuality);
			modelLocator.camera.setKeyFrameInterval(modelLocator.cameraKeyframe);
			modelLocator.camera.setMotionLevel(modelLocator.camera.fps);
			
			switch(modelLocator.videoCodec)
			{
				case VideoCodec.SORENSON:
					modelLocator.sorensonSettings.setMode(modelLocator.cameraWidth,modelLocator.cameraHeight, modelLocator.cameraFPS);
					modelLocator.sorensonSettings.setQuality(modelLocator.cameraBandWidth,modelLocator.videoQuality);
					modelLocator.sorensonSettings.setKeyFrameInterval(modelLocator.cameraKeyframe);
				break;
				
				
				case VideoCodec.H264AVC:
					modelLocator.h264Settings.setProfileLevel(modelLocator.h264profile, modelLocator.h26level);
					modelLocator.h264Settings.setMode(modelLocator.cameraWidth,modelLocator.cameraHeight,modelLocator.cameraFPS);
					modelLocator.h264Settings.setQuality(modelLocator.cameraBandWidth,modelLocator.videoQuality);
					modelLocator.h264Settings.setKeyFrameInterval(modelLocator.cameraKeyframe);
				break;
			}
			
			
			modelLocator.localCamera = modelLocator.camera;
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(CameraEvent.CAMERA_INITIALIZE,modelLocator.camera.name));
		}
	}
}