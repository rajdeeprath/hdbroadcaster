package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flashvisions.camcorder.event.BroadcastEvent;
	import com.flashvisions.camcorder.event.CameraEvent;
	import com.flashvisions.camcorder.event.StreamEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.commercial.flex.LicenceType;
	import com.flashvisions.components.Alert;
	
	import flash.events.TimerEvent;
	
	
	public class StartDurationMonitorCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(!modelLocator.durationMonitor.hasEventListener(TimerEvent.TIMER_COMPLETE))
			modelLocator.durationMonitor.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			
			if(!modelLocator.durationMonitor.hasEventListener(TimerEvent.TIMER))
			modelLocator.durationMonitor.addEventListener(TimerEvent.TIMER,onTimer);
			
			modelLocator.durationMonitor.reset();
			modelLocator.durationMonitor.start();
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			if(modelLocator.appmode == LicenceType.TRIAL)
			Alert.show("Trial Version allows only "+modelLocator.maxRecordDuration/60+" minutes of broadcasting");
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSTOP));
		}
		
		private function onTimer(e:TimerEvent):void
		{
			if(modelLocator.durationMonitor.currentCount>0 && modelLocator.autoSnapInterval>0)
			{	
				if(modelLocator.durationMonitor.currentCount % modelLocator.autoSnapInterval == 0)
				{
					CairngormEventDispatcher.getInstance().dispatchEvent(new CameraEvent(CameraEvent.SNAPSHOT));
					CairngormEventDispatcher.getInstance().dispatchEvent(new BroadcastEvent(BroadcastEvent.BROADCASTSAVE));
				}
			}
		}
	}
}