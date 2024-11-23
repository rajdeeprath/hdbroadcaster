package com.flashvisions.camcorder.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.IResponder;
	
	public class LicenceDelegate
	{
		private var responder:IResponder;
		private var service:Object;
		
		public function LicenceDelegate(responder:IResponder)
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getRemoteObject("licensingService");
		}
		
		public function validate(licence:String,currentDomain:String):void
		{
			var call:Object = 	this.service.validate(licence,currentDomain);
			call.addResponder(this.responder);
		}
	}
}