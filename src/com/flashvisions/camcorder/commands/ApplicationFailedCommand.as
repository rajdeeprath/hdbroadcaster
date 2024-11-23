package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.event.ApplicationEvent;
	import com.flashvisions.components.Alert;
	
	public class ApplicationFailedCommand implements ICommand
	{
		public function execute(event:CairngormEvent):void
		{
			var applicationEvent:ApplicationEvent = event as ApplicationEvent;
			var msg:String="";
			
			for(var i:int=0;i<applicationEvent.params.length;i++)
			msg += applicationEvent.params[i];
			if(msg.length>0) Alert.show(msg);
		}
	}
}