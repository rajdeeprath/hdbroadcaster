package com.flashvisions.camcorder.server.bwcheck.red5 
{
	import com.flashvisions.camcorder.server.bwcheck.red5.events.BandwidthDetectEvent;
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	[Event(name=BandwidthDetectEvent.SERVER_CLIENT_BANDWIDTH, type="com.flashvisions.camcorder.server.bwcheck.red5.events.BandwidthDetectEvent")]
	[Event(name=BandwidthDetectEvent.CLIENT_SERVER_BANDWIDTH, type="com.flashvisions.camcorder.server.bwcheck.red5.events.BandwidthDetectEvent")]
	[Event(name=BandwidthDetectEvent.DETECT_FAILED, type="com.flashvisions.camcorder.server.bwcheck.red5.events.BandwidthDetectEvent")]
	
	public class BWCheck extends Sprite
	{
		private var _serverURL:String = "localhost";
		private var _serverApplication:String = "";
		private var _clientServerService:String = "";
		private var _serverClientService:String = "";
		private var nc:NetConnection; 
		
		public function BWCheck()
		{
			
		}
		
		public function set serverURL(url:String):void
		{
			_serverURL = url;
		}
		
		public function set serverApplication(app:String):void
		{
			_serverApplication = app;
		}
		
		public function set clientServerService(service:String):void
		{
			_clientServerService = service;
		}
		
		public function set serverClientService(service:String):void
		{
			_serverClientService = service;
		}
		
		public function connect():void
		{
			nc = new NetConnection();
			nc.objectEncoding = flash.net.ObjectEncoding.AMF0;
			nc.client = this;
			nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);	
			nc.connect(_serverURL);
		}
		
		
		private function onStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					ServerClient();
				break;
			}
			
		}
		
		public function ClientServer():void
		{
			var clientServer:ClientServerBandwidth  = new ClientServerBandwidth();
			clientServer.connection = nc;
			clientServer.service = _clientServerService;
			clientServer.addEventListener(BandwidthDetectEvent.DETECT_COMPLETE,onClientServerComplete);
			clientServer.addEventListener(BandwidthDetectEvent.DETECT_STATUS,onClientServerStatus);
			clientServer.addEventListener(BandwidthDetectEvent.DETECT_FAILED,onDetectFailed);
			clientServer.start();
		}
		
		public function ServerClient():void
		{
			var serverClient:ServerClientBandwidth = new ServerClientBandwidth();
			serverClient.connection = nc;
			serverClient.service = _serverClientService;
			serverClient.addEventListener(BandwidthDetectEvent.DETECT_COMPLETE,onServerClientComplete);
			serverClient.addEventListener(BandwidthDetectEvent.DETECT_STATUS,onServerClientStatus);
			serverClient.addEventListener(BandwidthDetectEvent.DETECT_FAILED,onDetectFailed);
			
			serverClient.start();
		}
		
		public function onDetectFailed(event:BandwidthDetectEvent):void
		{
			nc.close();
			//trace("\n Detection failed with error: " + event.info.application + " " + event.info.description);
			dispatch(event.info,BandwidthDetectEvent.DETECT_FAILED);
		}
		
		public function onClientServerComplete(event:BandwidthDetectEvent):void
		{			
			nc.close();
			//trace("\nClient Server Bandwidth:\n kbit Up = " + event.info.kbitUp + ", deltaUp= " + event.info.deltaUp + ", deltaTime = " + event.info.deltaTime + ", latency = " + event.info.latency + " KBytes " + event.info.KBytes+"\n");
			dispatch(event.info,BandwidthDetectEvent.CLIENT_SERVER_BANDWIDTH);
		}
		
		public function onClientServerStatus(event:BandwidthDetectEvent):void
		{
			if (event.info) {
				//trace("count: "+event.info.count+ " sent: "+event.info.sent+" timePassed: "+event.info.timePassed+" latency: "+event.info.latency+" overhead:  "+event.info.overhead+" packet interval: " + event.info.pakInterval + " cumLatency: " + event.info.cumLatency);
			}
		}
		
		public function onServerClientComplete(event:BandwidthDetectEvent):void
		{
			//trace("\nServer Client Bandwidth:\n kbit Down: " + event.info.kbitDown + " Delta Down: " + event.info.deltaDown + " Delta Time: " + event.info.deltaTime + " Latency: " + event.info.latency+"\n");
			dispatch(event.info,BandwidthDetectEvent.SERVER_CLIENT_BANDWIDTH);
			
			ClientServer();
		}
		
		public function onServerClientStatus(event:BandwidthDetectEvent):void
		{	
			if (event.info) {
				//trace("count: "+event.info.count+ " sent: "+event.info.sent+" timePassed: "+event.info.timePassed+" latency: "+event.info.latency+" cumLatency: " + event.info.cumLatency);
			}
		}
		
		protected function dispatch(info:Object, eventName:String):void
		{
			var event:BandwidthDetectEvent = new BandwidthDetectEvent(eventName);
			event.info = info;
			dispatchEvent(event);
		}

	}
}
