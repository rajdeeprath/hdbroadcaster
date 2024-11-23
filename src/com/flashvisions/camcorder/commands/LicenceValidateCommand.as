package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.business.LicenceDelegate;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.LicenceEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceManager;
	import com.flashvisions.commercial.flex.LicenceType;
	import com.flashvisions.components.Alert;
	
	import flash.net.Responder;
	
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.URLUtil;
	
	/* Double Level Licence Validation */

	public class LicenceValidateCommand implements ICommand
	{
		private var logger:ILogger = Log.getLogger("LicenceValidateCommand");

		
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var responder:Responder;
	
		public function execute(event:CairngormEvent):void
		{
			var licenceValid:Boolean = LicenceManager.validateLicence(BroadcastModelLocator.APPLICATIONID,modelLocator.licence);
			var currentDomain:String = modelLocator.currentDomain;
			
			logger.info("License valid : " + licenceValid + "for domain " + currentDomain);
			
			if(licenceValid || modelLocator.isDomainWhiteListed(currentDomain))
			CairngormEventDispatcher.getInstance().dispatchEvent(new LicenceEvent(LicenceEvent.VALIDATION_SUCCESS));
			else
			CairngormEventDispatcher.getInstance().dispatchEvent(new LicenceEvent(LicenceEvent.VALIDATION_FAILURE));
		}
	}
}