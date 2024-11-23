package com.flashvisions
{
	import flash.system.Capabilities;

	public class FlashUtils
	{
		public static function getPlayerVersion():Object
		{
			var versionNumber:String = Capabilities.version;
			var versionArray:Array = versionNumber.split(",");
			var length:Number = versionArray.length;
			
			var platformAndVersion:Array = versionArray[0].split(" ");
			
			var majorVersion:Number = parseInt(platformAndVersion[1]);
			var minorVersion:Number = parseInt(versionArray[1]);
			var buildNumber:Number = parseInt(versionArray[2]);
			
			return {major: majorVersion, minor: minorVersion, build: buildNumber};
		}
	}
}