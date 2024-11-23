package com.flashvisions.camcorder.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flashvisions.camcorder.model.BroadcastModelLocator;
	import com.flashvisions.camcorder.view.BwCheckUI;
	import com.flashvisions.camcorder.view.CallibrationWizard;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Fade;
	import mx.managers.PopUpManager;
	
	public class ShowCallibrationCommand implements ICommand
	{
		private var modelLocator:BroadcastModelLocator = BroadcastModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			modelLocator.wizard = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, CallibrationWizard,true) as CallibrationWizard;
			PopUpManager.centerPopUp(modelLocator.wizard);
			
			modelLocator.wizard.alpha = 0;	
			
			var fade:Fade = new Fade(modelLocator.wizard);
			fade.alphaFrom = 0;fade.alphaTo = 1;
			fade.duration = 500;fade.startDelay = 1000;
			fade.play();
		}
	}
}