(function() {

    "use strict"; // http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/

    var counter = 0; // a counter for element id's and whatnot

    var reNamespace = /[^a-z0-9_\/]/ig; //a regex to find anything that's not letters, numbers underscore and forward slash
    var reId = /[^a-z0-9_]/ig; // same as above except no forward slashes
   
    function HDBroadcasterBridge(config) {
		
			config = config || {};		
			
			var defaults = {
				namespace: 'default',
				debug: false,
				onready: null,
				onerror: null,
				onconnect: null,
				onconnectsuccess: null,
				onconnectfailure: null,
				ondisconnect: null,
				onbroadcaststart: null,
				onbroadcaststop: null,
				onbroadcastfailed: null,
				onbroadcastsave: null,
				onbroadcastsavesuccess: null,
				onbroadcastsavefailure: null,
				oncamerachange: null,
				oncameraacquire: null,
				oncamerainitialize: null,
				oncamerasnapshot:null,
				onmicrophonechange: null,
				onmicrophoneacquire: null,
				onmicrophoneinitialize: null,
				onbridge: null,
				onevent: null,
				onloadsettings: null
			};
			
			
			var key;
			for (key in defaults) {
				if (defaults.hasOwnProperty(key)) {
					if (!config.hasOwnProperty(key)) {
						config[key] = defaults[key];
					}
				}
			}
			
			
			config.namespace = config.namespace.replace(reNamespace, '_');
			config.availablility = true;
	
	
	
			if (window.HDBroadcasterBridge[config.namespace]) {
				throw "There is already an instance of HDBroadcasterBridge using the '" + config.namespace + "' namespace. Use that instance or specify an alternate namespace in the config.";
			}
	
			this.config = config;
	
	
			HDBroadcasterBridge[config.namespace] = this;
			
		}




    	HDBroadcasterBridge.prototype = {
			
			
			
		/* A simple funtion to help flash determine if bridge is available or not */
		isavailable: function(){
			return this.config.availablility;
		},
		
			
			
			
		
		/**
		* Stores the swf bridge configuration data
		* 
		* @property _configuration
		* @type {Object}
		* @default {}
		*/
		_configuration: {},
		
		
		
		
		
		
		/**
		* @private
		* Stores the swf instance name associated to this bridge instance
		* 
		* @property _objectName
		* @type {String}
		* @default null
		*/
		_objectName: null,
		
		
		
		
		
		
		
		/* Getter for object name for this swf bridge */
		get objectName() {
			return _objectName;			
		},
		
		
		
		
		
		
		
		
		/**
		* @private	
		* This is an indicator of whether or not the client is ready for callbacks
		* 
		* @property _ready
		* @type {Boolean}
		* @default false
		*/
        _ready: false,
		
		
		
		
		
		
		
		
		

		_setConfiguration: function($obj){
			this.configuration = $obj ? JSON.parse($obj) : this.configuration;
		},
		
		
		
		
		
		
		get Events() {
			var evts = (this.configuration)?this.configuration.events:null;
			return evts;
		},


		
	
		
		
		
		
		
		/* Retreives the swf html entity */
		getSWF: function(){
			var objectName = (arguments.length>0)?arguments[0]:this._objectName;
			var obj = null;
			
			if (navigator.appName.indexOf("Microsoft") != -1)
			obj = window[objectName];
			else
			obj = document[objectName];
			
			if (obj) 
			return obj; 
			else 
			throw error("Invalid swf object");
		},
		
		
		
		
		
		
		
		
		/**
		* Starts broadcast
		*/
		startBroadcast: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				obj.startBroadcast();
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		/**
		* Stops an ongoing broadcast
		*/
		stopBroadcast: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				obj.stopBroadcast();
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		/**
		* Check if application is currently publishing stream
		*
		* @method isBroadcasting
		* @return {Boolean} Returns true if application is publishing stream, false otherwise
		*/
		isBroadcasting: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var broadcasting = obj.isBroadcasting();
				
				if(callback && typeof callback === 'function')
				callback(null, broadcasting);
				else
				return broadcasting;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		
		
		/**
		* Check if application is currently connected to media server
		*
		* @method isConnected
		* @return {Boolean} Returns true if application is connected, false otherwise
		*/
		isConnected: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var connected = obj.isConnected();
				
				if(callback && typeof callback === 'function')
				callback(null, broadcasting);
				else
				return connected;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		/**
		* Removes microphone from broadcast stream, causing audio to mute.
		* Note: This does not override the broadcast mode setting. If broadcast mode does not allow audio
		* in the first place, this call will not affect anything.
		*/
		denyMicrophone: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				obj.denyMicrophone();
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		/**
		* Attaches microphone to broadcast stream, causing audio to unmute (if it was muted).
		* Note: This does not override the broadcast mode setting. If broadcast mode does not allow audio
		* in the first place, this call will not affect anything.
		*/
		allowMicrophone: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				obj.allowMicrophone();
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		/**
		* Removes camera from broadcast stream, causing video to mute.
		* Note: This does not override the broadcast mode setting. If broadcast mode does not allow video
		* in the first place, this call will not affect anything.
		*/
		denyCamera: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				obj.denyCamera();
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		
		/**
		* Attaches camera to broadcast stream, causing video to unnmute (if it was muted).
		* Note: This does not override the broadcast mode setting. If broadcast mode does not allow video
		* in the first place, this call will not affect anything.
		*/
		allowCamera: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				obj.allowCamera();
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		
		/**
		* Gets video broadcast permission state. Checks to see if video broadcast is allowed or not.
		*
		* @method isVideoAllowed
		* @return {Boolean} Returns boolean true is video broadcast is allowed, otherwise returns false.
		*/
		isVideoAllowed: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var allowed = obj.isVideoAllowed();
				
				if(callback && typeof callback === 'function')
				callback(null, allowed);
				else
				return allowed;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		/**
		* Gets audio broadcast permission state. Checks to see if audio broadcast is allowed or not.
		*
		* @method isAudioAllowed
		* @return {Boolean} Returns boolean true is audio broadcast is allowed, otherwise returns false.
		*/
		isAudioAllowed: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var allowed = obj.isAudioAllowed();
				
				if(callback && typeof callback === 'function')
				callback(null, allowed);
				else
				return allowed;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		/**
		* Gets list of available camera devices accessible to flash player
		*
		* @method getCameraList
		* @param {Function} callback handler (Optional)
		* @return {Array} Returns list of Camera devices available to flash player
		*/
		getCameraList: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var devices = obj.getCameraList();
				
				if(callback && typeof callback === 'function')
				callback(null, devices);
				else
				return devices;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		/**
		* Gets list of available camera devices accessible to flash player
		*
		* @method getMicrophoneList
		* @param {Function} callback handler (Optional)
		* @return {Array} Returns list of Microphone devices available to flash player
		*/
		getMicrophoneList: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var devices = obj.getMicrophoneList();
				
				if(callback && typeof callback === 'function')
				callback(null, devices);
				else
				return devices;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		/**
		* Gets currently active camera device name
		*
		* @method getActiveCamera
		* @param {Function} callback handler (Optional)
		* @return {String} Returns name of currently active camera device
		*/
		getActiveCamera: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var device = obj.getActiveCamera();
				
				if(callback && typeof callback === 'function')
				callback(null, device);
				else
				return device;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		

		/**
		* Sets active camera (Camera device to use)
		*
		* @method setActiveCamera
		* @param {Function} callback handler (Optional)
		* @param {String} Camera device name
		*/
		setActiveCamera: function(){
			
			var deviceName = arguments[0];
			var callback = arguments[1];
			
			try
			{
				var obj = this.getSWF();
				obj.setActiveCamera(deviceName);
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		

		/**
		* Gets currently active microphone device name
		*
		* @method getActiveMicrophone
		* @return {String} Returns name of currently active microphone device
		*/
		getActiveMicrophone: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var device = obj.getActiveMicrophone();
				
				if(callback && typeof callback === 'function')
				callback(null, device);
				else
				return device;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		/**
		* Sets active microphone (Microphone device to use)
		*
		* @method setActiveMicrophone
		* @param {String} Microphone device name
		*/
		setActiveMicrophone: function(){
			
			var deviceName = arguments[0];
			var callback = arguments[1];
			
			try
			{
				var obj = this.getSWF();
				obj.setActiveMicrophone(deviceName);
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		
		/**
		* Sets microphone gain (amplification)
		*
		* @method setMicGain
		* @param {Number} Microphone gain value
		*/
		setMicGain: function(){
			
			var gain = arguments[0];
			var callback = arguments[1];
			
			try
			{
				var obj = this.getSWF();
				obj.setMicGain(gain);
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		
		/**
		* Gets current microphone gain (amplification)
		*
		* @method getMicGain
		* @return {Number} Returns current microphone gain value
		*/
		getMicGain: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var gain = obj.getMicGain();
				
				if(callback && typeof callback === 'function')
				callback(null, gain);
				else
				return gain;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		/**
		* Invokes an arbitrary function over broadcast stream
		* Note: This is effective only when a broadcast is in progress
		*
		* @method pushExtraData
		* @param {Object} Arbitrary json formatted string
		*/
		pushExtraData: function(){
			
			var method = arguments[0];
			var jsonDataString = arguments[1];
			var callback = arguments[2];
			
			try
			{
				var obj = this.getSWF();
				obj.pushExtraData(method, jsonDataString);
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		
		/**
		* Toggles view state of the application (If layout permits)
		*/
		toggleView: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				obj.toggleView();
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		getCurrentView: function(){
			
			var callback = arguments[0];
			
			try
			{
				var obj = this.getSWF();
				var viewName = obj.getCurrentView();
				
				if(callback && typeof callback === 'function')
				callback(null, viewName);
				else
				return viewName;
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		
		
		applyPreset: function(){
			
			var presetName = arguments[0];
			var callback = arguments[1];
			
			try
			{
				var obj = this.getSWF();
				obj.applyPreset(presetName);
			}
			catch(err)
			{
				if(callback && typeof callback === 'function')
				callback(err);
			}
		},
		
		
		
		/**********************************************
		**************** HANDLERS *********************
		**********************************************/
		
		_handleNotifications: function($object, $notification, $data){
			
			var that = this;
			
			
			var $obj = ($data != null) 
					? (typeof $data == 'string') 
					? $data.toString()
					: JSON.stringify($data):"";
					
			var $message = "[" + $notification + "]" + " => " + $obj;
			
					
			
			if(this.configuration)
			{
				this._eventHook.apply(that, arguments);
				
				this._handleApplicationEvents($object, $notification, $data);
				this._handleConnectionEvents($object, $notification, $data);
				this._handleBroadcastEvents($object, $notification, $data);
				this._handleCameraEvents($object, $notification, $data);
				this._handleMicrophoneEvents($object, $notification, $data);
			}
			else
			{
				throw error("configuration object not defined");
			}
			
		},
		
		
		
		
		
		
		
		_handleApplicationEvents: function($object, $notification, $data){
			
			var that = this;
			var Events = this.Events;
			
			switch($notification)
			{
				case Events.JSBRIDGEREADY:
				this.onbridge.apply(this, [$object, $data]);
				break;
				
				case Events.READY:
				this.onready.apply(this, [$object, $data]);
				break;
				
				case Events.FAILED:
				this.onerror.apply(this, [$object, $data]);
				break;
			}
			
		},
		
		
		
		
		
		_handleConnectionEvents: function($object, $notification, $data){
			
			var that = this;
			var Events = this.Events;
			
			switch($notification)
			{
				case Events.CONNECT:
				this.onconnect.apply(this, [$object, $data]);
				break;
				
				case Events.CONNECTSUCCESS:
				this.onconnectsuccess.apply(this, [$object, $data]);
				break;
				
				case Events.CONNECTFAILED:
				this.onconnectfailure.apply(this, [$object, $data]);
				break;
				
				case Events.DISCONNECT:
				this.ondisconnect.apply(this, [$object, $data]);
				break;
			}
			
		},
		
		
		
		
		
		_handleBroadcastEvents: function($object, $notification, $data){
			
			var that = this;
			var Events = this.Events;
			
			switch($notification)
			{
				case Events.BROADCASTSTART:
				this.onbroadcaststart.apply(this, [$object, $data]);
				break;
				
				case Events.BROADCASTSTOP:
				this.onbroadcaststop.apply(this, [$object, $data]);
				break;
				
				case Events.BROADCASTFAILED:
				this.onbroadcastfailed.apply(this, [$object, $data]);
				break;
				
				case Events.BROADCASTSAVE:
				this.onbroadcastsave.apply(this, [$object, $data]);
				break;
				
				
				case Events.BROADCASTSAVESUCCESS:
				this.onbroadcastsavesuccess.apply(this, [$object, $data]);
				break;
				
				case Events.BROADCASTSAVEFAILED:
				this.onbroadcastsavefailure.apply(this, [$object, $data]);
				break;
			}
			
		},
		
		
		
		
		
		_handleCameraEvents: function($object, $notification, $data){
			
			var that = this;
			var Events = this.Events;
			
			switch($notification)
			{
				case Events.CAMERA_SOURCE_CHANGE:
				this.oncamerachange.apply(this, [$object, $data]);
				break;
				
				
				case Events.CAMERA_ACQUIRE:
				this.oncameraacquire.apply(this, [$object, $data]);
				break;
				
				
				case Events.CAMERA_INITIALIZE:
				this.oncamerainitialize.apply(this, [$object, $data]);
				break;
				
				
				case Events.SNAPSHOT:
				this.oncamerasnapshot.apply(this, [$object, $data]);
				break;
				
			}
			
		},
		
		
		
		
		
		_handleMicrophoneEvents: function($object, $notification, $data){
			
			var that = this;
			var Events = this.Events;
			
			switch($notification)
			{
				case Events.MICROPHONE_SOURCE_CHANGE:
				this.onmicrophonechange.apply(this, [$object, $data]);
				break;
				
				
				case Events.MICROPHONE_ACQUIRE:
				this.onmicrophoneacquire.apply(this, [$object, $data]);
				break;
				
				
				case Events.MICROPHONE_INITIALIZE:
				this.onmicrophoneinitialize.apply(this, [$object, $data]);
				break;				
			}
			
		},
		
		
		
		
		
		_eventHook: function(){
			
			this._objectName = arguments[0];
									
			var that = this;	
			var fn = this.config.onevent;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		
		_writelog: function() {
			
			var $message = arguments[0];
			var $object = arguments[1];
			
			var $poster = ($object !== 'undefined' && $object != null)?$object:'[HDBroadcasterBridge]'
			
			if(typeof console !== 'undefined') 
			{
				try 
				{
					$message = (typeof $message === 'string') ? $message : JSON.stringify($message, null, 2);
				}
				catch(e) 
				{
					// skip
				}
				
				
				console.log($poster + " => " + $message);
			}
		},
		
		
		
		
		
		oninvoke: function()
		{
			var that = this;
			
			var $object = arguments[0];
			var $notification = arguments[1];
			var $data = arguments[2];
			
			
			/* the first event to be received is this */
			if($notification == 'JSBRIDGEREADY')
			this._setConfiguration($data);
			
			
			try
			{	
				this._handleNotifications.apply(this, arguments);
			}
			catch(e)
			{
				this._logMessage("Bridge error : " + JSON.stringify(e));
			}
		},
		
		
		
		
		
		loadsettings: function(){
			
			var that = this;	
			var fn = this.config.onloadsettings;
			if(fn && typeof fn == 'function'){
				return fn.apply(that, arguments);
			}else{
				throw error("Configuration not defined");	
			}
		},
		
		
		
		
		
		onlog: function($logMessage){
			
			if(this.config.debug)
			{
				this._writelog($logMessage);
			}
		},
		
		
		
		
		
		onbridge: function()
		{
			this._objectName = arguments[0];
									
			var that = this;	
			var fn = this.config.onbridge;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		
		onready: function()
		{
			this._ready = true;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onready;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		
		onerror: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onerror;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onconnect: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onconnect;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onconnectsuccess: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onconnectsuccess;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onconnectfailure: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onconnectfailure;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		ondisconnect: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.ondisconnect;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onbroadcaststart: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onbroadcaststart;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onbroadcaststop: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onbroadcaststop;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onbroadcastfailed: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onbroadcastfailed;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onbroadcastsave: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onbroadcastsave;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onbroadcastsavesuccess: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onbroadcastsavesuccess;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		
		onbroadcastsavefailure: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onbroadcastsavefailure;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		oncamerachange: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.oncamerachange;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		oncameraacquire: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.oncameraacquire;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		oncamerainitialize: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.oncamerainitialize;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onmicrophonechange: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onmicrophonechange;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onmicrophoneacquire: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onmicrophoneacquire;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},
		
		
		
		
		
		onmicrophoneinitialize: function()
		{
			this._ready = false;
			
			var that = this;	
			var objectName = arguments[0];
			var fn = this.config.onmicrophoneinitialize;
			if(fn && typeof fn == 'function'){
				fn.apply(that, arguments);
			}
		},

        
		};
		

		// UMD for working with requirejs / browserify
		if (typeof define === 'function' && define.amd) {
			// AMD. Register as an anonymous module.
			define([], HDBroadcasterBridge);
		} else if (typeof module === 'object' && module.exports) {
			// Browserify
			module.exports = HDBroadcasterBridge;
		}



   		// reguardless of UMD, HDBroadcasterBridge must be a global for flash to communicate with it
		window.HDBroadcasterBridge = HDBroadcasterBridge;

}());