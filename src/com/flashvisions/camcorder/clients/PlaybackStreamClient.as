package com.flashvisions.camcorder.clients
{
	public class PlaybackStreamClient
	{
		
		public function onMetaData(infoObject:Object):void 
		{ 
			trace("metadata"); 
		} 
		public function onCuePoint(infoObject:Object):void 
		{ 
			trace("cue point"); 
		} 
		
		public function setCaption(infoObject:Object):void 
		{ 
			trace("setCaption"); 
		}
		
		public function onTextData(infoObject:Object):void 
		{ 
			trace("onTextData"); 
		}
		
		
	}
}