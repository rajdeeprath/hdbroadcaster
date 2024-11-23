package com.flashvisions.camcorder.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import flash.external.ExternalInterface;
	import mx.rpc.IResponder;

	
	public class ConfigurationDelegate
	{
		private var responder:IResponder;
		private var service:Object;
		
		public function ConfigurationDelegate(responder:IResponder)
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getRemoteObject("localService");
		}
		
		public function loadSettings(configuration:Object):void
		{
			var call:Object = this.service.loadSettings(ExternalInterface.objectID,configuration);
			call.addResponder(this.responder);
		}
	}
}