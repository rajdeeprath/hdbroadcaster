package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.BridgeConfigurationBuilder;
	import com.flashvisions.camcorder.BroadcastQuality;
	import com.flashvisions.camcorder.OperationMode;
	import com.flashvisions.camcorder.clients.ConnectionClient;
	import com.flashvisions.camcorder.clients.v2.NotificationClient;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.ConnectionEvent;
	import com.flashvisions.camcorder.event.LicenceEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceType;
	import com.flashvisions.components.Alert;
	import com.flashvisions.crypto.Signer;
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.VideoCodec;
	import flash.net.NetConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	
	public class ApplicationReadyCommand implements ICommand
	{
		[Bindable]
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			var licenceEvent:LicenceEvent = event as LicenceEvent;
			
			for(var i:int = 0;i < flash.media.Camera.names.length;i++)
			modelLocator.cameras.addItem({label:flash.media.Camera.names[i],data:i});
			
			for(var j:int = 0;j < flash.media.Microphone.names.length;j++)
			modelLocator.microphones.addItem({label:flash.media.Microphone.names[j],data:j});
			
			modelLocator.allowVideo = modelLocator.allowAudio = false;
			modelLocator.isConnected = modelLocator.isBroadcasting = false;
			
			if(modelLocator.mode == OperationMode.AUDIO)modelLocator.disableVideo = true;
			else if(modelLocator.mode == OperationMode.VIDEO)modelLocator.disableAudio = true;
			else if(modelLocator.mode != OperationMode.DUPLEX)modelLocator.mode = null;
			
			modelLocator.connClient = new ConnectionClient();
			modelLocator.broadcastConnection = new NetConnection();
			modelLocator.broadcastConnection.client = modelLocator.connClient;
						
			modelLocator.durationMonitor = new Timer(1000,modelLocator.maxRecordDuration);
			modelLocator.micMonitor = new Timer(50);
			
			
			/* init signer */
			modelLocator.signer = Signer.newSigner();
			
			
			/* Auto enable audio preview for chat anywhere  */
			if(BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE){
			modelLocator.previewAudio = true;
			modelLocator.bidirectional = true;
			}
			
			
			/* Remove H264 option for incompatible product */
			if(BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.FXBROADCASTER)
			modelLocator.videoFormats.removeItemAt(modelLocator.videoFormats.getItemIndex(VideoCodec.H264AVC));
			
			
			//Set default encoder
			modelLocator.selectedVideoCodecIndex = getCodecIndex(modelLocator.encodingMode,modelLocator.videoFormats);
			modelLocator.selectedVideoCodecIndex = (modelLocator.selectedVideoCodecIndex<0)?0:modelLocator.selectedVideoCodecIndex;
			modelLocator.videoCodec = modelLocator.videoFormats.getItemAt(modelLocator.selectedVideoCodecIndex) as String;
			
			modelLocator.broadcastQuality = (modelLocator.videoCodec ==  VideoCodec.SORENSON)?modelLocator.sdQuality:modelLocator.hdQuality;
			
			
			/* Check for transcoder */
			if(modelLocator.transcoder){
			modelLocator.transcodeRequest = new URLRequest(modelLocator.transcoder);
			modelLocator.transcoderParams = new URLVariables(); 
			modelLocator.transcoderLoader = new URLLoader();
			}
			
			//Load default for bandwidth settings 
			modelLocator.presetIndex = modelLocator.getPresetIndexByLabel(modelLocator.forceQuality);
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.APPLYPRESET,modelLocator.broadcastQuality.getItemAt(modelLocator.presetIndex)));

			if(modelLocator.autoStart && !modelLocator.asViewer)
			modelLocator.wasPublishing = true;
			
			if(modelLocator.destination != null)
			CairngormEventDispatcher.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT,modelLocator.destination));
			
			if(modelLocator.asViewer) modelLocator.currentView = BroadcastModelLocator.PLAYBACKVIEW;
			modelLocator.playbackState = (modelLocator.playbackURL)?BroadcastModelLocator.PREVIEWEXTERNAL:BroadcastModelLocator.PREVIEWINTERNAL;
			
			
			buildContextMenu();
			FlexGlobals.topLevelApplication.enabled = true;
						
			
			FlexGlobals.topLevelApplication.currentState = BroadcastModelLocator.READY;
			modelLocator.notificationClient.invokeExternal(ApplicationEvent.READY);
		}
		
		
		/* Utility function */
		
		public function getCodecIndex(needle:String,haystack:ArrayCollection):Number
		{
			for(var i:int=0;i<haystack.length;i++)
				if(haystack.getItemAt(i) == needle) return i;
			return -1;
		}
		
		public function getPresetIndexByLabel(needle:String,haystack:ArrayCollection):Number
		{
			for(var i:int=0;i<haystack.length;i++)
			if(haystack.getItemAt(i).label == needle) return i;
			return haystack.length-1;
		}
		
		public function buildContextMenu():void
		{
			var application:Object = FlexGlobals.topLevelApplication;
			var licenseInfo:String = modelLocator.appmode as String;
			var appname:String = BroadcastModelLocator.APPLICATION_PRODUCT_LABEL;
			var versioninfo:ContextMenuItem = new ContextMenuItem(appname+" "+BroadcastModelLocator.VERSION+" ("+licenseInfo+")",false,true,true);
			var toggleView:ContextMenuItem = new ContextMenuItem("Toggle View",false,true,true);
			toggleView.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toggleViewHandler);
			var deviceSelector:ContextMenuItem = new ContextMenuItem("Device(s)",false,true,true);
			deviceSelector.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deviceSelectorHandler);
			
			var contextMenuCustomItems:Array = application.contextMenu.customItems;
			contextMenuCustomItems.push(versioninfo);
			contextMenuCustomItems.push(deviceSelector);
			if(BroadcastModelLocator.APPLICATIONID == BroadcastModelLocator.CHATANYWHERE && !modelLocator.asViewer)
			contextMenuCustomItems.push(toggleView);
		}
		
		private function toggleViewHandler(e:ContextMenuEvent):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CHANGEVIEWMODE));
		}
		
		private function deviceSelectorHandler(e:ContextMenuEvent):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOWCALIBRATIONWIZARD));
		}
	}
}