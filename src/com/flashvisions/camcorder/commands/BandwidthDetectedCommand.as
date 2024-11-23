package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.Aspect;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceType;
	
	public class BandwidthDetectedCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var index:int;
		private var candidateBandwidth:int;
		private var settings:Object;
		
		public function execute(event:CairngormEvent):void
		{
			var applicationEvent:ApplicationEvent = event as ApplicationEvent;
			
			/* BW DETECTION ONLY FOR REGISERED CUSTOMERS */
			if(modelLocator.appmode != LicenceType.REGISTERED) return;
			
			modelLocator.detectedBandWidth = applicationEvent.params[0]; // kbits
			modelLocator.detectedBandWidth = Math.round(modelLocator.detectedBandWidth * 125); // convert kilobits to bytes
			
			index = getIndexByBandWidth(modelLocator.detectedBandWidth);
			candidateBandwidth = modelLocator.broadcastQuality.getItemAt(index).bandwidth;
			index = (candidateBandwidth-modelLocator.detectedBandWidth > 75000)?((index-1<0)?0:index-1):index;
			
			settings = modelLocator.broadcastQuality.getItemAt(index);
			modelLocator.presetIndex = index;
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.APPLYPRESET,settings));
		}
		
		protected function getIndexByBandWidth(bandwidth:int):int
		{
			var min:int;
			var index:int = 0;
			var bwdifference:Array = new Array();
			
			
			/* Check for BW Differences */
			for(var i:int=0;i<modelLocator.broadcastQuality.length;i++){
				var diff:int = Math.abs(bandwidth - modelLocator.broadcastQuality.getItemAt(i).bandwidth);
				bwdifference.push({difference:diff,index:i});
			}
			
			/* Capture the smallest BW Difference */
			bwdifference.sortOn("difference",Array.NUMERIC); 
			min = bwdifference[0].difference;
			index = bwdifference[0].index;
			
			return index;
		}
	}
}