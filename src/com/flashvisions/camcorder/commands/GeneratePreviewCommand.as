package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.model.IModelLocator;
	import com.flashvisions.FlashUtils;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	
	import mx.core.FlexGlobals;
	
	
	public class GeneratePreviewCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			var versionInfo:Object = FlashUtils.getPlayerVersion();
			
			if(modelLocator.snapshot != null) 
			modelLocator.snapshot.dispose();
			modelLocator.snapshot = null;
			
			
			if(versionInfo.major <= 11)
			modelLocator.snapshot = videoToByteArray();
			else
			modelLocator.snapshot = cameraToByteArray();
		}
		
		
		
		
		
		/* For FP <= 11.5 */
		private function videoToByteArray():BitmapData
		{
			var snapshot:BitmapData;
			
			try{
				modelLocator.video.attachCamera(modelLocator.localCamera);
				snapshot = new BitmapData(modelLocator.video.width, modelLocator.video.height);
				snapshot.draw(modelLocator.video,new Matrix());
			}catch(e:Error){
				snapshot = null;
			}
			
			return snapshot;
		}
			
		
		
		
		/* For FP > 11.5 */
		private function cameraToByteArray():BitmapData
		{
			var snapshot:BitmapData;
			
			try{
				snapshot = new BitmapData(modelLocator.cameraWidth, modelLocator.cameraHeight);
				modelLocator.camera.drawToBitmapData(snapshot);
			}catch(e:Error){
				snapshot = null;
			}
			
			return snapshot;
		}
	}
}