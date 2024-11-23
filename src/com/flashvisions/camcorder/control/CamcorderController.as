package com.flashvisions.camcorder.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.flashvisions.camcorder.commands.*;
	import com.flashvisions.camcorder.event.*;
	
	public class CamcorderController extends FrontController
	{
		public function CamcorderController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.addCommand(ApplicationEvent.STARTUP,ApplicationStartUpCommand);
			this.addCommand(ApplicationEvent.SHUTDOWN,ApplicationShutDownCommand);
			this.addCommand(ApplicationEvent.CONFIGURATION_LOAD_REMOTE,LoadRemoteConfigurationCommand);
			this.addCommand(ApplicationEvent.CONFIGURATIONLOAD_LOCAL,LoadLocalConfigurationCommand);
			this.addCommand(ApplicationEvent.CONFIGURATION_SUCCESS,ConfigurationSuccessCommand);
			this.addCommand(ApplicationEvent.CONFIGURATION_FAILED,ConfigurationFailedCommand);
			this.addCommand(ApplicationEvent.READY,ApplicationReadyCommand);
			this.addCommand(ApplicationEvent.FAILED,ApplicationFailedCommand);
			this.addCommand(ApplicationEvent.BANDWIDTHCHECK,BandwidthCheckCommand);
			this.addCommand(ApplicationEvent.BANDWIDTHDETECTED,BandwidthDetectedCommand);
			this.addCommand(ApplicationEvent.GETBITRATE,CalculateBitrateCommand);
			this.addCommand(ApplicationEvent.SHOWCALIBRATIONWIZARD,ShowCallibrationCommand);
			this.addCommand(ApplicationEvent.HIDECALIBRATIONWIZARD,HideCallibrationCommand);
			this.addCommand(ApplicationEvent.PRESETMANAGER_LOAD,PresetManagerInitializeCommand);
			this.addCommand(ApplicationEvent.INITIALIZESPEAKERVOLUME,InitializeSystemVolumeCommand);
			this.addCommand(ApplicationEvent.CHANGEVIEWMODE,ChangeViewModeCommand);
			this.addCommand(ApplicationEvent.DEVICEACQUIRED,DevicesAcquiredActionCommand);
			this.addCommand(ApplicationEvent.TRANSCODEREQUEST, TranscodeRequestCommand);
			
			this.addCommand(BroadcastEvent.BROADCASTSTART,BroadcastStartCommand);
			this.addCommand(BroadcastEvent.BROADCASTSTOP,BroadcastStopCommand);
			this.addCommand(BroadcastEvent.BROADCASTSAVE,BroadcastSaveCommand);
			this.addCommand(BroadcastEvent.APPLYPRESET,ApplyPresetCommand);
			this.addCommand(BroadcastEvent.CREATEBROADCASTGROUP,CreateBroadcastGroupCommand);
			this.addCommand(BroadcastEvent.STARTDURATIONMONITOR,StartDurationMonitorCommand);
			this.addCommand(BroadcastEvent.STOPDURATIONMONITOR,StopDurationMonitorCommand);
			this.addCommand(BroadcastEvent.ENABLEAUDIOBROADCAST,EnableAudioBroadcastCommand);
			this.addCommand(BroadcastEvent.DISABLEAUDIOBROADCAST,DisableAudioBroadcastCommand);
			this.addCommand(BroadcastEvent.ENABLEVIDEOBROADCAST,EnableVideoBroadcastCommand);
			this.addCommand(BroadcastEvent.DISABLEVIDEOBROADCAST,DisableVideoBroadcastCommand);
			
			this.addCommand(ConnectionEvent.CONNECT,ConnectionConnectCommand);
			this.addCommand(ConnectionEvent.DISCONNECT,ConnectionDisconnectCommand);
			this.addCommand(ConnectionEvent.CONNECTSUCCESS,ConnectionSuccessCommand);
			this.addCommand(ConnectionEvent.CONNECTFAILED,ConnectionFailureCommand);
			this.addCommand(ConnectionEvent.ATTEMPTRECONNECT,AttemptReconnectionCommand);
			
			this.addCommand(CameraEvent.CAMERA_SOURCE_CHANGE,CameraChangeCommand);
			this.addCommand(CameraEvent.CAMERA_ACQUIRE,CameraAcquisitionCommand);
			this.addCommand(CameraEvent.CAMERA_INITIALIZE,CameraInitializeCommand);
			this.addCommand(CameraEvent.DEINITIALIZE,CameraReleaseCommand);
			this.addCommand(CameraEvent.SNAPSHOT,GeneratePreviewCommand);
			this.addCommand(CameraEvent.REFRESHLOCALVIEW,RefreshCameraDisplayCommand);
			this.addCommand(CameraEvent.CHANGECODEC,VideoCodecChangedCommand);
			
			this.addCommand(MicrophoneEvent.MICROPHONE_SOURCE_CHANGE,MicrophoneChangeCommand);
			this.addCommand(MicrophoneEvent.MICROPHONE_ACQUIRE,MicrophoneAcquisitionCommand);
			this.addCommand(MicrophoneEvent.MICROPHONE_INITIALIZE,MicrophoneInitializeCommand);
			this.addCommand(MicrophoneEvent.DEINITIALIZE,MicrophoneReleaseCommand);
			this.addCommand(MicrophoneEvent.SHOWECHOCONTROL,ShowEchoControPanellCommand);
			this.addCommand(MicrophoneEvent.HIDEECHOCONTROL,HideEchoControPanellCommand);
			this.addCommand(MicrophoneEvent.APPLYENHANCEDOPTIONS,ApplyBidirectionalAECCommand);
			
			this.addCommand(LicenceEvent.VALIDATION_SUCCESS,LicenceValidCommand);
			this.addCommand(LicenceEvent.VALIDATION_FAILURE,LicenceInvalidCommand);
			this.addCommand(LicenceEvent.VALIDATE,LicenceValidateCommand);
			this.addCommand(LicenceEvent.VERIFY,VerifyLicenseCommand);
			
			this.addCommand(StreamEvent.PUBLISHSTART,PublishStartCommand);
			this.addCommand(StreamEvent.PUBLISHSTOP,PublishStopCommand);
			this.addCommand(StreamEvent.PUBLISHFAILED,PublishFailedCommand);
			this.addCommand(StreamEvent.PUBLISHSUCCESS,PublishSuccessCommand);
			this.addCommand(StreamEvent.PLAYSERVERMULTICAST,PlayServerMulticastStreamCommand);
			this.addCommand(StreamEvent.PLAYP2PMULTICAST,PlayPeerMulticastStreamCommand);
			this.addCommand(StreamEvent.STOPSERVERMULTICAST,StopServerMulticastStreamCommand);
			this.addCommand(StreamEvent.STOPP2PMULTICAST,StopPeerMulticastStreamCommand);
			
			this.addCommand(StreamEvent.STARTPLAYBACK, PlaybackStartCommand);
			this.addCommand(StreamEvent.STOPPLAYBACK, PlaybackStopCommand);
			this.addCommand(StreamEvent.PLAYBACKSTARTED, PlaybackStartedCommand);
			this.addCommand(StreamEvent.PLAYBACKSTOPPED, PlaybackStoppedCommand);
			this.addCommand(StreamEvent.TOGGLESTREAMAUDIO, ToggleStreamAudioCommand);
			this.addCommand(StreamEvent.PUSHMETADATA, PushMetadataCommand);
			this.addCommand(StreamEvent.PUSHEXTRADATA, PushExtraDataCommand);
			
			this.addCommand(StreamEvent.DVRSTART, DVRStartCommand);
			this.addCommand(StreamEvent.DVRSTOP, DVRStopCommand);
			
			this.addCommand(NotificationEvent.NOTIFY,NotificationBroadcastCommand);
		}
	}
}