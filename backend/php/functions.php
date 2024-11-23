<?php
function isValidConnectionURL($url)
	{
		return(isValidRTMFPURL($url) || isValidRTMPURL($url))?true:false;
	}
	
	function isValidStreamName($stream)
	{
		return (strlen($url)>2)?true:false;
	}
	
	function charAt($string, $index)
	{
		if($index < mb_strlen($string)){
			return mb_substr($string, $index, 1);
		}
		else{
			return -1;
		}
	}
	
	function isValidRTMFPURL($url)
	{
		$valid = true;
		$parts = parse_url($url);
		
		//Step1:
		$protocol = strtolower($parts['scheme']);
		if($protocol != "rtmfp") $valid = false;
		
		//Step 2:
		$servername = $parts['host'];
		if(($servername == NULL)||($servername == "")) $valid = false;
		
		//Step 3:
		if(charAt($url, strlen($url)-1) == "/") $valid = false;
		
		//Step 4:
		$lastSeparatorIndex = strrpos($url,"/");
		$groupName = substr($url,$lastSeparatorIndex+1,strlen($url));
		if(($groupName == NULL)||($groupName == "")) $valid = false;
		
		return $valid;
	}
	
	
	function isValidRTMPURL($url)
	{
		$valid = true;
		$parts = parse_url($url);
		
			
		//Step1:
		$protocol = strtolower($parts['scheme']);
		if($protocol != "rtmp") $valid = false;
		
		//Step 2:
		$servername = $parts['host'];
		if(($servername == NULL)||($servername == "")) $valid = false;
		
		//Step 3:
		$indexOfServerName = strpos($url,$servername);
		$serverlength = strlen($servername);
		$applicationName = substr($url,$indexOfServerName + $serverlength + 1,  strlen($url));
		if(($applicationName == NULL)||($applicationName == "")) $valid = false;
		
		//Step 4:
		if(charAt($url, strlen($url)-1) == "/") $valid = false;

		
		return $valid;
	}
?>