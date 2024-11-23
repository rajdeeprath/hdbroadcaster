package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class TranscodeRequestCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			modelLocator.transcoderParams.stream = modelLocator.publishName;
			modelLocator.transcoderParams.timestamp = new Date().time;
			modelLocator.transcodeRequest.data = modelLocator.transcoderParams;
			modelLocator.transcodeRequest.method = URLRequestMethod.POST;
			
			modelLocator.transcoderLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			if(!modelLocator.transcoderLoader.hasEventListener(Event.COMPLETE))
			modelLocator.transcoderLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler,false,0,false);
			
			if(!modelLocator.transcoderLoader.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
			modelLocator.transcoderLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, false);
			
			if(!modelLocator.transcoderLoader.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			modelLocator.transcoderLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, false);
			
			if(!modelLocator.transcoderLoader.hasEventListener(IOErrorEvent.IO_ERROR))
			modelLocator.transcoderLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, false);
			
			
			try {
			modelLocator.transcoderLoader.load(modelLocator.transcodeRequest);
			} catch (e:Error) {
			trace(e);
			}
		}
		
		private function loaderCompleteHandler(e:Event):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TRANSCODEREQUESTCOMPLETE));				
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void
		{
			trace(e.status);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TRANSCODEREQUESTFAILED,e.text));
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TRANSCODEREQUESTFAILED,e.text));	
		}
	}
}