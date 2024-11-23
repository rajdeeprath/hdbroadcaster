package com.flashvisions.camcorder.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import mx.rpc.IResponder;

	
	public class SaveSessionDelegate
	{
		private var responder:IResponder;
		private var service:Object;
		
		public function SaveSessionDelegate(responder:IResponder)
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getRemoteObject("localService");
		}
		
		public function saveSession(configuration:Object,publishName:String,previewData:ByteArray=null,duration:Number=0):void
		{
			var call:Object = this.service.saveSession(ExternalInterface.objectID,configuration,publishName,previewData,duration);
			call.addResponder(this.responder);
		}
	}
}