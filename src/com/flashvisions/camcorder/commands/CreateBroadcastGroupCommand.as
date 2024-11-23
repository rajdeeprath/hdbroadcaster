package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import flash.net.GroupSpecifier;
	
	public class CreateBroadcastGroupCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			if(!modelLocator.groupspec)
			modelLocator.groupspec = new GroupSpecifier(modelLocator.currentDomain+"/"+modelLocator.groupname);
			modelLocator.groupspec.multicastEnabled = true;
			modelLocator.groupspec.serverChannelEnabled = true;
			modelLocator.groupspec.postingEnabled = true;
		}
	}
}