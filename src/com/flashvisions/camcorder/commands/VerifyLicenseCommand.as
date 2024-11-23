package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceManager;
	import com.flashvisions.commercial.flex.LicenceType;
	import com.flashvisions.components.Alert;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.Responder;
	import flash.net.URLRequest;
	
	
	
	public class VerifyLicenseCommand implements ICommand
	{
		public static const RSLPATH:String = "http://licence.flashvisions.com/secure.validate.rsl.swf"
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var rslLoader:Loader;
		
		public function execute(event:CairngormEvent):void
		{
			var currentDomain:String = modelLocator.currentDomain;
			if(!modelLocator.isDomainWhiteListed(currentDomain)){	
			if(modelLocator.validatorRSL == null) loadRSL();
			else verifyLicense();
			}
		}
		
		private function loadRSL():void
		{
			rslLoader = new Loader();
			rslLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onRSLLoaded);
			rslLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			
			try{
			rslLoader.load(new URLRequest(RSLPATH));
			}catch(e:Error){
			// NO OP
			}
		}
		
		private function verifyLicense():void
		{
			modelLocator.validatorRSL.validate(modelLocator.licence, LicenceManager.allowedDomain , new Responder(onVerificationSuccess,onVerificationFailed));
		}
		
		/* Event Handler*/
		
		private function onRSLLoaded(e:Event):void
		{
			modelLocator.validatorRSL =  LoaderInfo(e.target).content;
			verifyLicense();
		}
		
		private function onVerificationSuccess(e:Object):void
		{
			var isValid:Boolean = e as Boolean;
			
			if(!isValid)
			{
				if(modelLocator.isConnected) CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.DISCONNECT));
				modelLocator.maxRecordDuration = 180;
				
				if(modelLocator.durationMonitor != null){
				modelLocator.durationMonitor.reset();
				modelLocator.durationMonitor.repeatCount = 180;
				}
				
				modelLocator.appmode = LicenceType.TRIAL;
			}
		}
		
		private function onVerificationFailed(e:Object):void
		{
			// NO OP 
		}
		
		private function onLoadError(e:Event):void
		{
			// NO OP
		}
	}
}