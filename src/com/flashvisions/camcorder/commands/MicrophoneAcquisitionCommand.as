package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.camcorder.event.MicrophoneEvent;
	import com.flashvisions.camcorder.event.NotificationEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.components.Alert;
	
	import flash.display.MovieClip;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.Timer;
	
	public class MicrophoneAcquisitionCommand implements ICommand
	{
		private static const SAMPLECOUNT:Number = 20; 
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		private var micActivityData:Number = 0;
		
		
		public function execute(event:CairngormEvent):void
		{
			acquireMicrophone();
		}
		
		private function acquireMicrophone():void
		{
			try
			{
				modelLocator.mic = Microphone.getMicrophone(modelLocator.micIndex);
				if(modelLocator.mic == null) throw new Error("No Microphone Found !");
				
				modelLocator.mic.setLoopBack(true);
				
				if(!modelLocator.mic.hasEventListener(StatusEvent.STATUS))
				modelLocator.mic.addEventListener(StatusEvent.STATUS,onMicStatus);
				
				if(!modelLocator.mic.muted)deviceOk();
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}

		}
		
		
		private function deviceOk():void
		{
			modelLocator.mic.setLoopBack(false);
			modelLocator.allowAudio = true;
			modelLocator.broadcastAudio = true
			
			if(!modelLocator.micMonitor.hasEventListener(TimerEvent.TIMER))
			modelLocator.micMonitor.addEventListener(TimerEvent.TIMER, onMicTimer);
			
			if(modelLocator.bidirectional)
			CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.APPLYENHANCEDOPTIONS));
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new MicrophoneEvent(MicrophoneEvent.MICROPHONE_INITIALIZE));
			CairngormEventDispatcher.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.DEVICEACQUIRED));
			CairngormEventDispatcher.getInstance().dispatchEvent(new NotificationEvent(MicrophoneEvent.MICROPHONE_ACQUIRE, modelLocator.mic.name));
		}
		
		private function deviceNotOk():void
		{
			modelLocator.mic.setLoopBack(false);
			modelLocator.allowAudio = false;
			modelLocator.broadcastAudio = false;
			Security.showSettings(SecurityPanel.PRIVACY);
		}
		
		
		/* Event Handler */
		
		private function onMicStatus(event:StatusEvent):void
		{
			if (event.code == "Microphone.Unmuted")deviceOk();
			else if (event.code == "Microphone.Muted")deviceNotOk();
		}
		
		private function onMicTimer(e:TimerEvent):void
		{
			modelLocator.micActiivity = modelLocator.mic.activityLevel;
		}
	}
}