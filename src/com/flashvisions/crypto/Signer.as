package com.flashvisions.crypto
{
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.util.Hex;
	import com.hurlant.util.der.PEM;
	
	import flash.utils.ByteArray;

	public class Signer
	{
		private static var _instance:Signer;
		private var _privateKey:String;
		
		
		
		public static function newSigner():Signer
		{
			_instance = new Signer();
			return _instance;
		}
		
		public function usingKey(key:String):Signer
		{
			_instance._privateKey = key;
			return _instance;
		}
		
		
		public function encrypt(message:String):String
		{
			return _instance.signMessage(message);
		}
		
		
		private function signMessage(message:String):String
		{
			var rsa:RSAKey = PEM.readRSAPrivateKey(_instance._privateKey);
			var src:ByteArray = Hex.toArray(Hex.fromString(message));
			var dst:ByteArray = new ByteArray;
			rsa.sign(src, dst, src.length);
			
			return Hex.fromArray(dst); 
		}

	}
}