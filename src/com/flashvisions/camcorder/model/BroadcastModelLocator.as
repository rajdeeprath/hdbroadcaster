package com.flashvisions.camcorder.model
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.model.IModelLocator;
	import com.flashvisions.camcorder.Bitrate;
	import com.flashvisions.camcorder.BroadcastQuality;
	import com.flashvisions.camcorder.CamcorderMode;
	import com.flashvisions.camcorder.CameraQuality;
	import com.flashvisions.camcorder.FrameRate;
	import com.flashvisions.camcorder.MicrophoneAudioRate;
	import com.flashvisions.camcorder.clients.ConnectionClient;
	import com.flashvisions.camcorder.clients.StreamClient;
	import com.flashvisions.camcorder.interfaces.INotificationClient;
	import com.flashvisions.camcorder.server.ClientServers;
	import com.flashvisions.crypto.Signer;
	import com.flashvisions.remoting.RemotingConnection;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.media.VideoCodec;
	import flash.media.VideoStreamSettings;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFlexDisplayObject;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.codec.JPEGEncoder;
	
	
	[Bindable]
	public class BroadcastModelLocator implements IModelLocator
	{
		public static const RSA_PRIVATE_KEY:String  = "-----BEGIN PRIVATE KEY-----\n" +
			"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDjEP2VqnOJeBKo\n" +
			"Tf3Q7eQXoNsBtFi8LyrEqA5eGWZbxcO1tSAOIi6kaiK83LQvHYzXShV0Qd7hS3L0\n" +
			"Wd9cT0SOiMHXVUbQX/WMwHHoQbHhfNzsnZ9Qf+PkXa9NmLYSIYTGM4ioStEPWAkK\n" +
			"F9RIDd0D8u6E6O38lLVRpp8b25CkoR7EdoeY6ntl3VK9OJTCFnlCu23PuFSeOxaY\n" +
			"/RUmFKEgJhwijC4lDY2LNUeJMsGdEDGMMe5KUZAXSyLN/CEKo1BWP2S+oqtZgb4a\n" +
			"o8WwLQ8t54mE1WOi3o4eWdG+dPa4OqNjX986+sNrySb0VDgI+xsUt5ZymF42DFwG\n" +
			"4L+uvk9zAgMBAAECggEAJmDny5UsxA50cNgFz3t18vxwJ+CYou4B941EKGl4oIhT\n" +
			"pPHBQkJKyeVai7tuBQykknrmF2lOx5ueCWjrVMndF45L3R5/wpaFhU29svjvnOIi\n" +
			"4SdfFxcWqLGhAKeQFo5tx6ZMMc27ejFyDa+rZKZbNeCoqfRIzUlBQFS+TdIVp412\n" +
			"ejG7X0vbummldrn2YJ38fDOXE2vKm0g3SPYGMNdfUXSQB7jegtzvk66mLyMFFlfL\n" +
			"J+bohswNaUo1GFpoxjmX63xgWHWxoWxC6sL0/I0q62FBQlFsDEBUeoRFlXt862ij\n" +
			"5LCGdMW2fGjI8n5ce76qJrAh5uNQqeQsBUkPS5OcyQKBgQD6wtHkEbpoHCK2MT4H\n" +
			"PVK2Xq9S6cVA4Yq6ADwpZAGP4zlzru5scigrZ8p8YkF1W/p65BK9TjyGvnp2SW3t\n" +
			"iLorUJQW7Q4CXszCWHznGAwk7geQnZeJ41ARi6aIhj5HcSH5D8fR93FGDBWg5RFX\n" +
			"t4vx2lUgGZBy3Juh+hsqHpmwnwKBgQDnz3D5A8v1SKJTI0a5XqtgeuQGNrPGi3d4\n" +
			"+Qy+lE1BzE66y45EU/38gVW4LteAOO3tk0wh2pS+KLrk/O3DFMW2UaDE77GAHdCj\n" +
			"rppWb5ahn0vFJQZIjLoUggsJNTsLGZP0jSFrgN6f4Cs1AMlh6/8w3qCp0L2a2WLo\n" +
			"j8kzANWMrQKBgBxcNEjLCH4F0JcycoV3FgeyJboG3lw8JehrZmJ4AQU4+aJvwl9Z\n" +
			"edmO34O5yRVw1Z9YdBYc5xOGL2t5Wolm0Udc0aLWJKN3/UhtoZKxUY5LrWdZq23Y\n" +
			"25FgbfE63YhO7zyv4DWK+rClZTzRK2j0RUuRGdeLjJ6w/JkRJElbNJ6ZAoGACsja\n" +
			"36rujT3Q139Xpf4iiP2OqD9ZQ85vQ4CKuD8cDQidTRF1T/Z8ZYf63fPH8N41K41j\n" +
			"yFtr+iDY+RhPU3ke7amEikUAhA5fC45u/cB5SJGpq8VaMnvhmFyoeMgyNAT/niwG\n" +
			"twKq2NNMD043EEgzeimRXfUpLRAaCunNmYLbbI0CgYAu/0tdc//u2EqDRP0WG6Dw\n" +
			"h1lNBeN9V19ar/in/ACI14kjK1bEy8Ehj1LfNVYw5NRaszNI7mk1rUoRWStQV0WL\n" +
			"O08gVJQyM1kbvh4FcDdz+bBI1yLzbye6gH/hzxgNT7xDb6gw0DhER6ztA1OrO+Tc\n" +
			"TJmC9ETotUDzwomWe2CRnQ==\n" +
			"-----END PRIVATE KEY-----";
		
		
		public static const CHATANYWHERE:String  = "ChatAnywhere";
		public static const FXBROADCASTER:String = "FXBroadcaster";
		public static const HDBROADCASTER:String = "HDBroadcaster";
		public static const XTREMEBROADCASTER:String = "XtremeBroadcaster";
		
		public static const CHATANYWHERE_PRODUCT_LABEL:String  = "ChatAnywhere";
		public static const FXBROADCASTER_PRODUCT_LABEL:String = "WMLE";
		public static const HDBROADCASTER_PRODUCT_LABEL:String = "WMLE HD";
		
		public static const CHATANYWHERE_PRODUCT_VERSION:String  = "1.2.4";
		public static const FXBROADCASTER_PRODUCT_VERSION:String = "1.6.4";
		public static const HDBROADCASTER_PRODUCT_VERSION:String = "1.5.0";
		
		public static const CHATANYWHERE_PRODUCT_SERVICE:String  = "ChatBroadcaster";
		public static const FXBROADCASTER_PRODUCT_SERVICE:String = "FXBroadcaster";
		public static const HDBROADCASTER_PRODUCT_SERVICE:String = "HDBroadcaster";
		
		public static const HDBROADCASTER_APP_SCOPE:String = "HDBroadcasterBridge";
		
		
		/* Set product here */
		public static const APPLICATIONID:String = HDBROADCASTER;
		public static const APPWEBSCOPE:String = HDBROADCASTER_APP_SCOPE;
		public static const APPLICATION_PRODUCT_LABEL:String = HDBROADCASTER_PRODUCT_LABEL;
		public static const VERSION:String = HDBROADCASTER_PRODUCT_VERSION;		
		public var serviceName:String = HDBROADCASTER_PRODUCT_SERVICE;
		/* *************** */
		
		
		public static const BROADCASTMODE:String = "live";
		public static const ENCODERSCREEN:String = "EncoderScreen";
		
		public static const PREVIEWEXTERNAL:String = "PreviewExternal";
		public static const PREVIEWINTERNAL:String = "PreviewInternal";
		
		public static const PREINIT:String = "PreInit";
		public static const READY:String = "Ready";
		
		public var isPersonalEdition:Boolean = false;
		
		public var bidirectional:Boolean = false;
		public var autoStart:Boolean = false;
		public var wizard:IFlexDisplayObject = null;
		
		/* ChatAnyehere variables */
		public static const CAMERAVIEW:String = "CameraView";
		public static const PLAYBACKVIEW:String = "PlaybackView";
		public var playBackSoundTransform:SoundTransform = new SoundTransform();
		public var asViewer:Boolean = false;
		public var speakerVolume:Number = 1;
		public var broadcastVideo:Boolean = false;
		public var broadcastAudio:Boolean = false;
		public var currentView:String = CAMERAVIEW;
		public var memoryVolume:Number;
		public var speakerSoundTransform:SoundTransform = new SoundTransform(.8);
		
		public var bwStrict:Boolean = false;
		public var multiMode:Boolean = false;
		
		public var userPresets:Object;
		
		public var echocontrolpanel:*;
		public var playbackState:String; 
		public var currentState:String; 
		public var splash:IFlexDisplayObject;
		public var validatorRSL:Object = null;
		
		public var signer:Signer;
		
		public var transcoderLoader:URLLoader;
		public var transcoderParams:URLVariables;
		public var transcodeRequest:URLRequest;
		public var transcoder:String = null;
		
		public var dvr:Boolean = false;
		public var dvrInfo:Object;
		
		public var metadata:Object;
		
		/********* DEBUG VARIABLES *********/
		public var curr_bandwidth:Number;
		public var curr_activity:Number;
		public var curr_framerate:Number;
		public var curr_motionlevel:Number;
		public var curr_quality:Number;
		public var curr_kfi:Number;
		public var curr_bitrate:Number;
		public var framesDropped:int;
		public var curr_camerawidth:Number;
		public var curr_cameraheight:Number;
		
		//public var autosense:Boolean = false;
		public var enableAutoSense:Boolean = false;
		
		public var motionMonitor:Timer = null;
		public var autoSnapInterval:Number;
		public var connectionMonitor:Timer = new Timer(5000);
		public var wasConnected:Boolean = false;
		public var wasPublishing:Boolean = false;
		public var licence:String; 
		public var appmode:String = null;
		public var aspect:String;
		public var mode:String = null;
		public var encodingMode:String = VideoCodec.H264AVC;
		public var operationMode:String = CamcorderMode.RECORDING;
		public var configuration:Object; 
		public var gateway:RemotingConnection;
		public var currentDomain:String;
		public var destination:String;
		public var micfeedback:Boolean; 
		public var groupname:String;
		public var groupspec:GroupSpecifier;
		public var broadcastGroup:NetGroup;
		public var playbackGroup:NetGroup;
		public var protocol:String; 
		public var debugMode:Boolean;
		/********* CAMERA SETTINGS *********/
		
		public var acquired:Boolean = false;
		public var camera:Camera;
		public var cameraIndex:int = 0;
		public var cameras:ArrayCollection = new ArrayCollection();
		public var localCamera:Camera;
		public var cameraBandWidth:int;
		public var cameraWidth:int;
		public var cameraHeight:int;
		public var cameraKeyframe:int;
		public var cameraFPS:Number;
		public var videoQuality:Number = 85;
		
		public var altVideoQuality:int;
		public var altBandwidth:Number;
		public var altKFI:int;
		
		public var snapshot:BitmapData; 
		public var imageEncoder:JPEGEncoder = new JPEGEncoder(60);
		public var previewURL:String;
		
		public var h26level:String = H264Level.LEVEL_1;
		public var h264profile:String = H264Profile.BASELINE;
		
		/********  Microphone Settings  *****/
		public var mic:Microphone;
		
		public var micIndex:int = 0;
		public var microphones:ArrayCollection = new ArrayCollection();
		public var micRate:int;
		public var micGain:Number = 50;
		public var micActiivity:Number;
		public var audioQuality:Number;
		public var micMonitor:Timer;
		public var allowFeedback:Boolean = true;
		public var audioBandwidth:Number = 0;
		
		/******** Bandwidth Check Settings *****/
		public var serverType:String; 
		public var detectedBandWidth:Number = 0;
		public var bwCheck:Boolean;
		public var bitrate:Number;
		public var bufferTime:Number;
		public var bufferLength:Number;
		
		/******** Connection Settings *****/
		public var broadcastConnection:NetConnection;
		public var playbackStream:NetStream;
		public var peerStream:NetStream;
		public var broadcastDownStream:NetStream;
		public var altDownStream:NetStream;
		public var broadcastMode:String;
		public var publishName:String;
		public var publishQueryString:String;
		public var playbackName:String;
		public var publishType:String = "flv";
		public var forceQuality:String;
		
		/********  Others  ***************/
		public var masterVolume:Number = 0.3;
		public var disableInteraction:Boolean = false;
		public var enablePreview:Boolean;
		public var logo:String;
		public var video:Video = new Video(300,225);
		public var videoURL:String; 
		public var playbackURL:String;
		public var allowVideo:Boolean = false;
		public var allowAudio:Boolean = false;
		public var disableVideo:Boolean = false;
		public var disableAudio:Boolean = false;
		
		public var isBroadcasting:Boolean;
		public var isConnected:Boolean;
		public var isPlaying:Boolean = false;
		
		public var durationMonitor:Timer;
		public var maxRecordDuration:Number = 0; 
		
		public var connClient:ConnectionClient;
		public var upStreamClient:StreamClient;
		public var downStreamClient:StreamClient;
		public var notificationClient:INotificationClient;
		public var bridgeConfiguration:Object;
		
		public var motiondata:ArrayCollection = new ArrayCollection([
		{label:"LOW", motionLowerLimit:0, motionUpperLimit:8,qfactor: 1.06},
		{label:"AVERAGE", motionLowerLimit:8, motionUpperLimit:16,qfactor: 1.03},
		{label:"NORMAL", motionLowerLimit:16, motionUpperLimit:25,qfactor: 1},
		{label:"MEDIUM", motionLowerLimit:25, motionUpperLimit:35,qfactor: .96},
		{label:"HIGH", motionLowerLimit:35, motionUpperLimit:50,qfactor: .91},
		{label:"VERYHIGH", motionLowerLimit:50, motionUpperLimit:70,qfactor: .86},
		{label:"EXTREME", motionLowerLimit:70, motionUpperLimit:100,qfactor: .81}
		]);
		
		public var broadcastQuality:ArrayCollection = new ArrayCollection();
		public var settingsController:Object;
		
		public var sdQuality:ArrayCollection;
		public var hdQuality:ArrayCollection;
		
		
		public var resolution:ArrayCollection = new ArrayCollection([
		{label:CameraQuality.STANDARD720P,width:1280,height:720},
		{label:CameraQuality.STANDARD576I,width:720,height:576},
		{label:CameraQuality.STANDARD480P,width:640,height:480},
		{label:CameraQuality.STANDARD360P,width:640,height:360},
		{label:CameraQuality.STANDARD_CIF_SIF,width:352,height:288},
		{label:CameraQuality.STANDARD_SIF,width:320,height:240},
		{label:CameraQuality.HQVGA,width:240,height:160},
		{label:CameraQuality.WEBBEST,width:176,height:144},
		{label:CameraQuality.WEBHIGH,width:160,height:120},
		{label:CameraQuality.WEBGOOD,width:140,height:105},
		{label:CameraQuality.WEBAVERAGE,width:120,height:90},
		{label:CameraQuality.WEBBASIC,width:100,height:75},
		{label:CameraQuality.WEBLOW,width:80,height:60}]);
		
		public var fps:ArrayCollection = new ArrayCollection([{label:FrameRate.NTSC,fps:30},{label:FrameRate.STANDARD_BEST,fps:24},{label:FrameRate.CUSTOM,fps:22},{label:FrameRate.STANDARD_HIGH,fps:20},{label:FrameRate.STANDARD_GOOD,fps:18},{label:FrameRate.PAL,fps:25},{label:FrameRate.WEB_BEST,fps:15},{label:FrameRate.WEB_GOOD,fps:12},{label:FrameRate.WEB_AVERAGE,fps:10},{label:FrameRate.WEB_BASIC,fps:8},{label:FrameRate.WEB_LOW,fps:6}]); 
		public var micRates:ArrayCollection = new ArrayCollection([{label:MicrophoneAudioRate.BEST,rate:44},{label:MicrophoneAudioRate.HIGH,rate:22},{label:MicrophoneAudioRate.GOOD,rate:11},{label:MicrophoneAudioRate.LOW,rate:8}]);
		public var resolution_bkp:ArrayCollection = new ArrayCollection();
		public var speexBWUsage:ArrayCollection = new ArrayCollection([3.95,5.75,7.75,9.80,12.8,16.8,20.6,23.8,27.8,34.2,42.2]);
		
		
		public var selecedResolutionIndex:Number = 0;
		public var selectedFpsIndex:Number = 0;
		public var selectedMicRatesIndex:Number = 0;
		public var selectedAudioCodecIndex:Number = 0;
		public var selectedVideoCodecIndex:Number = 0;
		
		public var audioFormats:ArrayCollection = new ArrayCollection([SoundCodec.NELLYMOSER,SoundCodec.SPEEX]);
		public var videoFormats:ArrayCollection = new ArrayCollection([VideoCodec.SORENSON,VideoCodec.H264AVC]);
		
		public var audioCodec:String = SoundCodec.NELLYMOSER;
		public var encodeQuality:int = 5;
		
		public var videoCodec:String = VideoCodec.SORENSON;
		public var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
		public var sorensonSettings:VideoStreamSettings = new VideoStreamSettings();
		public var altStreamSettings:VideoStreamSettings = new VideoStreamSettings();
		
		public var presetIndex:int = 0;
		public var buffer:Number = 0;
		public var previewbuffer:Number = 0;
		public var liverecord:Boolean = false;
		
		public var previewAudio:Boolean = false;
		public var previewVideo:Boolean = false;
		
		public var gatewayURL:String; 

		private static var instance:BroadcastModelLocator;
		
		
		public function BroadcastModelLocator(enforcer:SingletonEnforcer = null)
		{
			if(enforcer == null)
			throw new CairngormError("Use getInstance to access this class !");
		}
		
		public static function getInstance():BroadcastModelLocator
		{
			if(instance == null) instance = new BroadcastModelLocator(new SingletonEnforcer());
			return instance;
		}
		
		public function getPresetIndexByLabel(needle:String):Number
		{
			for(var i:int=0;i<broadcastQuality.length;i++)
				if(broadcastQuality.getItemAt(i).label == needle) return i;
			return broadcastQuality.length-1;
		}
		
		public function isDomainWhiteListed(domain:String):Boolean
		{
			for(var i:int=0;i<ClientServers.SERVER_LIST.length;i++)
			if(ClientServers.SERVER_LIST.getItemAt(i) == domain) 
			return true;
			return false;
		}
	}
}