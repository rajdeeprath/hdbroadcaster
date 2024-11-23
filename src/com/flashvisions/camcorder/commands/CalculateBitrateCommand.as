package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;

	
	public class CalculateBitrateCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			// unit kbps
			modelLocator.bitrate = Math.round(modelLocator.cameraWidth * modelLocator.cameraHeight * modelLocator.cameraFPS)/1000;
			
		}
	}
}