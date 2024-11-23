package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.view.EchoControlPanel;
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class ShowEchoControPanellCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			modelLocator.echocontrolpanel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, EchoControlPanel,true);
			PopUpManager.centerPopUp(modelLocator.echocontrolpanel);
		}
	}
}