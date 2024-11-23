package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.Protocol;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceType;
	
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.utils.URLUtil;
	
	public class LicenceInvalidCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			/* LIMITED RECORDING FOR UNREGISERED CUSTOMERS */
			modelLocator.appmode = LicenceType.TRIAL;
			
			/* set time limit only if app is not chatanywhere and not using rtmfp */
			if(!(URLUtil.getProtocol(modelLocator.destination) == Protocol.RTMFP && BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE))
			modelLocator.maxRecordDuration = 180;
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.READY));
		}
	}
}