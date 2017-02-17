using Toybox.System as Sys;

class Util {

	static function getCurrentTime() {
		var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        
        var time = new Time();
        time.hours = hours + "";
        time.minutes = clockTime.min.format("%02d");
                
        return time;
	}	
	
}

class Time {
	var hours;
	var minutes;
}