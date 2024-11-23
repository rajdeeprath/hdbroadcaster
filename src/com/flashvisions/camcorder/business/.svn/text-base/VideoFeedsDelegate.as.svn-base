package com.flashvisions.camcorder.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class VideoFeedsDelegate
	{
		private var responder:IResponder;
		private var service:Object;
		
		public function VideoFeedsDelegate(responder:IResponder)
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getRemoteObject("broadcasterService");
		}
		
		public function loadFeed():void
		{
			var call:Object = this.service.loadFeed();
			call.addResponder(this.responder);
		}
	}
}