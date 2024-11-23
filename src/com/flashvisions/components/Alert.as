package com.flashvisions.components
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;

	public class Alert
	{
		private static var instance:IFlexDisplayObject;
		
		public static function show(message:String=null,title:String='Notification'):void
		{
			try
			{
				if(!instance) throw new Error("No instance available");
				MessageBox(instance).Title = title;
				MessageBox(instance).Message += '\n' + message;
			}
			catch(e:Error)
			{
				instance = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,MessageBox,true) as IFlexDisplayObject;
				MessageBox(instance).Title = title;
				MessageBox(instance).Message = message;
			}
			
			PopUpManager.centerPopUp(instance);
		}
		
		public static function hide(msgbox:IFlexDisplayObject):void
		{
			PopUpManager.removePopUp(msgbox as IFlexDisplayObject);
			instance = msgbox = null;
		}
	}
}