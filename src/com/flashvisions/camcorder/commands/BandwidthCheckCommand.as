package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.server.RTMPServerType;
	import com.flashvisions.camcorder.view.BwCheckUI;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.NetConnection;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.red5.flash.bwcheck.ClientServerBandwidth;
	import org.red5.flash.bwcheck.app.BandwidthDetectionApp;
	import org.red5.flash.bwcheck.events.BandwidthDetectEvent;
	
	public class BandwidthCheckCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var autoConfigUI:BwCheckUI;
		
		public function execute(event:CairngormEvent):void
		{
			var applicationEvent:ApplicationEvent = event as ApplicationEvent;
			var connection:NetConnection = applicationEvent.params[0] as NetConnection;
			
			modelLocator.serverType = modelLocator.serverType.toLowerCase();
			
			switch(modelLocator.serverType)
			{
				case RTMPServerType.RED5:
					Red5ClientServer(connection);
				break;
				
				case RTMPServerType.WOWZA:
				break;
				
				case RTMPServerType.FMS:
				break;
			}
			
			createUI();
		}
		
		protected function createUI():void
		{
			autoConfigUI = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,BwCheckUI,true) as BwCheckUI;
			autoConfigUI.message = "CHECKING CONNECTION"
			PopUpManager.centerPopUp(autoConfigUI);
		}
		
		protected function removeUI():void
		{
			PopUpManager.removePopUp(autoConfigUI);
		}
		
		public function Red5ClientServer(connection:NetConnection):void
		{
			var clientServer:ClientServerBandwidth  = new ClientServerBandwidth();
			clientServer.connection = connection;
			clientServer.service = "checkBandwidthUp"; // Red5 1.0 onwards
			clientServer.addEventListener(BandwidthDetectEvent.DETECT_COMPLETE,onClientServerComplete);
			clientServer.addEventListener(BandwidthDetectEvent.DETECT_STATUS,onClientServerStatus);
			clientServer.addEventListener(BandwidthDetectEvent.DETECT_FAILED,onDetectFailed);
			clientServer.start();
		}
		
		/* Event Handlers */
		
		public function onDetectFailed(event:BandwidthDetectEvent):void
		{
			removeUI();
			modelLocator.detectedBandWidth = 0;
			
			trace("Detection failed with error");
		}
		
		public function onClientServerComplete(event:BandwidthDetectEvent):void
		{		
			var kbitUp:Number = event.info.kbitUp;
			var deltaUp:Number = event.info.deltaUp;
			var latency:uint = event.info.latency;
			var KBytes:Number = event.info.KBytes;
			
			trace("Client to Server Bandwidth Detection Complete");
			
			removeUI();
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.BANDWIDTHDETECTED, kbitUp));
		}
		
		public function onClientServerStatus(event:BandwidthDetectEvent):void
		{
			if (event.info) {
				trace("count: "+event.info.count+ " sent: "+event.info.sent+" timePassed: "+event.info.timePassed+" latency: "+event.info.latency+" overhead:  "+event.info.overhead+" packet interval: " + event.info.pakInterval + " cumLatency: " + event.info.cumLatency);
			}
		}
	}
}