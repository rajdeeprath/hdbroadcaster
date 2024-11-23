package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.Protocol;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	import mx.utils.URLUtil;
	
	public class ConnectionConnectCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var connectEvent:ConnectionEvent = event as ConnectionEvent;
			var url:String = connectEvent.info as String;
			
			
			/* Check Valid RTMP/RTMFP URL */
			if(!isValidRTMPURL(url) && !isValidRTMFPURL(url))return;
			modelLocator.protocol = URLUtil.getProtocol(url);
			
			
			/* Extract RTMFP URL & Group Name */
			if(isValidRTMFPURL(url)){
				modelLocator.groupname = url.substring(url.lastIndexOf("/")+1, url.length);
				url = url.substring(0, url.lastIndexOf("/")+1);
			}
			
			
			try
			{
				if(modelLocator.broadcastConnection == null)
				modelLocator.broadcastConnection = new NetConnection();
				
				modelLocator.broadcastConnection.client = modelLocator.connClient;
				
				if(!modelLocator.broadcastConnection.hasEventListener(NetStatusEvent.NET_STATUS))
				modelLocator.broadcastConnection.addEventListener(NetStatusEvent.NET_STATUS,onStatus);
				
				if(!modelLocator.broadcastConnection.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
				modelLocator.broadcastConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
				
				if(modelLocator.broadcastConnection.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
				modelLocator.broadcastConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);	
				
				if((!modelLocator.broadcastConnection.connected)&&(url != null))
				{
					if(BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.XTREMEBROADCASTER)
					{
						var time:Number = new Date().milliseconds;
						var raw:String = BroadcastModelLocator.APPLICATIONID + time.toString();
						var signature:String = modelLocator.signer.usingKey(BroadcastModelLocator.RSA_PRIVATE_KEY).encrypt(raw);
						
						modelLocator.broadcastConnection.connect(url, BroadcastModelLocator.APPLICATIONID, time.toString(), signature);
					}
					else
					{
						modelLocator.broadcastConnection.connect(url);
					}
				}
				
				// sends notification message
				var info:Object = new Object();
				info.code = null;
				info.uri = url;
				info.timestamp = new Date().time.toString();
				CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(ConnectionEvent.CONNECT, info));
			
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		
		private function isValidRTMFPURL(url:String):Boolean
		{
			var valid:Boolean = true;
			
			try
			{
				//Step1:
				var protocol:String = URLUtil.getProtocol(url);
				if(protocol != "rtmfp") throw new Error("Invalid protocol");
				
				//Step 2:
				var servername:String = URLUtil.getServerName(url);
				if((servername == null)||(servername == "")) throw new Error("Invalid server");
				
				//Step 3:
				if(url.charAt(url.length-1) == "/") throw new Error("Invalid rtmpf address");
				
				//Step 4:
				var lastSeparatorIndex:int = url.lastIndexOf("/");
				var groupName:String = url.substring(lastSeparatorIndex+1,url.length);
				if((groupName == null)||(groupName == "")) throw new Error("Invalid group name");
				
			}catch(e:Error){
				valid = false;
			}
			
			return valid;
		}
		
		
		private function isValidRTMPURL(url:String):Boolean
		{
			var valid:Boolean = true;
			
			try
			{
				
				//Step1:
				var protocol:String = URLUtil.getProtocol(url);
				if((protocol != "rtmp")&&(protocol != "rtmpt")&&(protocol != "rtmpe")&&(protocol != "rtmps")) throw new Error("Invalid protocol");
				
				//Step 2:
				var servername:String = URLUtil.getServerName(url);
				if((servername == null)||(servername == "")) throw new Error("Invalid server");
				
				/*
				//Step 3:
				var indexOfServerName:Number = url.indexOf(servername);
				var serverlength:int = servername.length;
				var applicationName:String = url.substring(indexOfServerName + serverlength + 1, url.length);
				if((applicationName == null)||(applicationName == "")) throw new Error("Invalid application name");
				
				//Step 4:
				if(url.charAt(url.length-1) == "/") throw new Error("Invalid rtmp address");
				*/
				
			}catch(e:Error){
				valid = false;
			}
			
			
			return valid;
		}
		
		
		
		/* Event Handlers */
		
		private function onAsyncError(ae:AsyncErrorEvent):void
		{
			Alert.show(ae.text);
		}
		
		
		private function onSecurityError(se:SecurityErrorEvent):void
		{
			Alert.show(se.text);
		}
		
		private function onStatus(ns:NetStatusEvent):void
		{
			var info:Object = new Object();
			info.code = ns.info.code;
			info.uri = NetConnection(ns.target).uri;
			info.timestamp = new Date().time.toString();
			
			switch(ns.info.code)
			{
				case "NetConnection.Connect.Success":
					CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTSUCCESS, info));
					break;
				
				case "NetConnection.Connect.Closed":
					CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.DISCONNECT, info));
					break;
				
				case "NetStream.Connect.Success":
					break;
				
				case "NetGroup.Connect.Success":
					break;
				
				case "NetStream.Connect.Rejected":
					break;
				
				case "NetGroup.Connect.Rejected":
				case "NetGroup.Connect.Failed":
					break;
				
				case "NetConnection.Connect.AppShutdown":
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.InvalidApp":
					CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTFAILED, info));
					break;	
			}
		}
	}
}