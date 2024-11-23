package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.business.SaveSessionDelegate;
	import com.flashvisions.camcorder.clients.NotificationClient;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.LicenceEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.view.BwCheckUI;
	import com.flashvisions.components.Alert;
	import com.flashvisions.remoting.RemotingConnection;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.codec.JPEGEncoder;
	import mx.managers.PopUpManager;
	import mx.rpc.IResponder;
	import mx.utils.Base64Encoder;
	import mx.utils.URLUtil;
	
	public class BroadcastSaveCommand implements ICommand, IResponder
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var modalDialog:*;
		private var ba:ByteArray;
		private var duration:Number;
		private var autoConfigUI:BwCheckUI;
		private var saveDelegate:SaveSessionDelegate;
		private var base64Encoder:Base64Encoder;
		
		public function execute(event:CairngormEvent):void
		{
			try{
				ba = (modelLocator.allowVideo)?modelLocator.imageEncoder.encode(modelLocator.snapshot):null;
				duration = modelLocator.durationMonitor.currentCount;
				
				if(modelLocator.configuration.clientmode)
				{
					base64Encoder = new Base64Encoder();
					base64Encoder.encodeBytes(ba);
					
					var response:Object = new Object();
					for(var prop:* in modelLocator.configuration)
					response[prop] = modelLocator.configuration[prop];
					response.image = base64Encoder.toString();
					response.stream = modelLocator.publishName;
					response.duration = duration;
					
					CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSAVE, response));
				}
				else if(modelLocator.configuration.scriptLocation)
				{
					var variables:URLVariables = new URLVariables();
					
					base64Encoder = new Base64Encoder();
					base64Encoder.encodeBytes(ba);
					
					for(var prop:* in modelLocator.configuration)
					variables[prop] = modelLocator.configuration[prop];
					variables.objectid = ExternalInterface.objectID;
					variables.image = base64Encoder.toString();
					variables.stream = modelLocator.publishName;
					variables.duration = duration;
					
					var request:URLRequest = new URLRequest(modelLocator.gatewayURL);
					request.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
					request.method = URLRequestMethod.POST;
					request.data = variables;
					
					var snapshotPoster:URLLoader = new URLLoader();
					snapshotPoster.addEventListener(Event.COMPLETE, onPostComplete);
					snapshotPoster.addEventListener(IOErrorEvent.IO_ERROR, onPostError);
					
					try{
						CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSAVE, variables));
						snapshotPoster.load(request);
					}catch(e:Error){
						Alert.show(e.message);
					}finally{
						base64Encoder = null;
					}
					
				}
				else
				{
					saveDelegate = new SaveSessionDelegate(this);
					saveDelegate.saveSession(modelLocator.configuration, modelLocator.publishName,ba,duration);
					CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSAVE, {configuration: modelLocator.configuration, stream: modelLocator.publishName, image: ba, duration: duration}));
				}
				
			}
			catch(e:Error)
			{
				// NO OP
			}
			finally
			{
				saveDelegate = null;
				clearImageData();
			}
		}
		
		
		/* UrlLoader methods */
		private function onPostComplete(e:Event):void
		{
			var snapshotPoster:URLLoader = e.target as URLLoader;
			snapshotPoster.removeEventListener(Event.COMPLETE, onPostComplete);
			snapshotPoster.removeEventListener(IOErrorEvent.IO_ERROR, onPostError);
			
			clearImageData();
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSAVESUCCESS));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSAVESUCCESS, {stream: modelLocator.publishName, duration: duration}));
		}
		
		private function onPostError(e:IOErrorEvent):void
		{
			var snapshotPoster:URLLoader = e.target as URLLoader;
			snapshotPoster.removeEventListener(Event.COMPLETE, onPostComplete);
			snapshotPoster.removeEventListener(IOErrorEvent.IO_ERROR, onPostError);
			
			clearImageData();
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSAVEFAILED));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSAVEFAILED, {stream: modelLocator.publishName, duration: duration}));
			
		}
		
		/* Responder Methods */
		
		public function result(event:Object):void
		{
			clearImageData();
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSAVESUCCESS));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSAVESUCCESS, {stream: modelLocator.publishName, duration: duration}));
		}
		
		public function fault(event:Object):void
		{
			clearImageData();
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSAVEFAILED));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(BroadcastEvent.BROADCASTSAVEFAILED, {stream: modelLocator.publishName, duration: duration}));
		}
		
		private function clearImageData():void
		{
			if(ba)
				ba.clear();
			if(modelLocator.snapshot != null) 
				modelLocator.snapshot.dispose(); 
			modelLocator.snapshot = null;
		}
	}
	
	
}