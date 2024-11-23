package com.flashvisions.camcorder.interfaces
{
	public interface INotificationClient
	{
		function loadConfiguration():Object;
		function invokeExternal(notification:String,params:Object=null):*;
		
		function isAudioAllowed():Boolean;
		function isAudioEnabled():Boolean;
		
		function isVideoAllowed():Boolean;
		function isVideoEnabled():Boolean;
		
		function applyPreset(label:String):void;
		function pushExtraData(method:String, json:String):void;
		
		function stopBroadcast():void
		function startBroadcast():void
			
		function isBroadcasting():Boolean;
		function isConnected():Boolean;
			
		function denyMicrophone():void
		function allowMicrophone():void
			
		function denyCamera():void
		function allowCamera():void
			
		function toggleView():void
		function viewStream(stream:String):void
			
		function setMicGain(gain:Number):void
		function getMicGain():Number;
		
		function getCurrentView():String;
		function generateSnapshot():void
		
	}
}