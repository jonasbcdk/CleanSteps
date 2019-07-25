using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as Act;
using Toybox.Time.Gregorian as Greg;
using Toybox.Time as Time;

class CleanStepsView extends Ui.WatchFace {

	var months;
	var weekdays;
	var dateFormat;
	var lang;
	
	var watchHeight;
	var watchWidth;

	var foregroundColor;
	var backgroundColor;
	
    var scaleFactor;
	//var arialFont;
	var robotoFont;
	
    function initialize() {
        WatchFace.initialize();
        		
		foregroundColor = Gfx.COLOR_WHITE;
		backgroundColor = Gfx.COLOR_BLACK;
                
		// Get background color setting
		var colorNum = Application.getApp().getProperty("BackgroundColor");
		
		if (colorNum == 1) {
			foregroundColor = Gfx.COLOR_BLACK;
			backgroundColor = Gfx.COLOR_WHITE;		
		}
		
        months = [
			Ui.loadResource(Rez.Strings.Mon0),
			Ui.loadResource(Rez.Strings.Mon1),
			Ui.loadResource(Rez.Strings.Mon2),
			Ui.loadResource(Rez.Strings.Mon3),
			Ui.loadResource(Rez.Strings.Mon4),
			Ui.loadResource(Rez.Strings.Mon5),
			Ui.loadResource(Rez.Strings.Mon6),
			Ui.loadResource(Rez.Strings.Mon7),
			Ui.loadResource(Rez.Strings.Mon8),
			Ui.loadResource(Rez.Strings.Mon9),
			Ui.loadResource(Rez.Strings.Mon10),
			Ui.loadResource(Rez.Strings.Mon11)
		];
		
		weekdays = [
			Ui.loadResource(Rez.Strings.Day0),
			Ui.loadResource(Rez.Strings.Day1),
			Ui.loadResource(Rez.Strings.Day2),
			Ui.loadResource(Rez.Strings.Day3),
			Ui.loadResource(Rez.Strings.Day4),
			Ui.loadResource(Rez.Strings.Day5),
			Ui.loadResource(Rez.Strings.Day6)
		];
		
		dateFormat = Ui.loadResource(Rez.Strings.DateFormat);
		lang = Ui.loadResource(Rez.Strings.lang);
		
		//arialFont = Ui.loadResource(Rez.Fonts.arial);
		robotoFont = Ui.loadResource(Rez.Fonts.roboto);
    }

    // Load your resources here
    function onLayout(dc) {    
        watchHeight = dc.getHeight();
		watchWidth = dc.getWidth();
				
		//scaleFactor = 1.0;
				
		scaleFactor = watchHeight / 180.0;
		
		System.println("watch height: " + watchHeight);
		System.println("scaleFactor: " + scaleFactor);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {       	      	
		// Clear gfx
		dc.setColor(backgroundColor, backgroundColor);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		
		// Draw clock
		drawClock(dc);
				
		// Draw battery
		drawBattery(dc);

		var settings = Sys.getDeviceSettings();

		// Draw notifications count
		drawNotifications(dc, settings.notificationCount);
                
        // Draw bluetooth icon
        if (settings.phoneConnected) {
    		drawBluetooth(dc);
        }
                
		// Draw date
		drawDate(dc);
							
		// Draw steps
		drawSteps(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	//System.println("exit sleep");
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	//System.println("enter sleep");
    }  

	function drawBluetooth(dc) {	
        dc.setColor(Gfx.COLOR_BLUE, backgroundColor);
        
		var x = dc.getWidth() / 2;
		var y = 20 * scaleFactor;
        
    	dc.drawLine(x, y, x+6, y+6);
    	dc.drawLine(x+6, y+6, x+3, y+9);
    	dc.drawLine(x+3, y+9, x+3, y-3);
    	dc.drawLine(x+3, y-3, x+6, y);
    	dc.drawLine(x+6, y, x-1, y+6);
    	
        dc.setColor(foregroundColor, backgroundColor);
	}

	function drawClock(dc) {
		dc.setColor(foregroundColor, backgroundColor);
			
		var time = Util.getCurrentTime();
			
		var timeHeight = dc.getTextDimensions(time.minutes, Gfx.FONT_NUMBER_THAI_HOT)[1];
		
		System.println("timeHeight: " + timeHeight);
		
        var timeString = Lang.format("$1$:$2$", [time.hours, time.minutes]);
        var timeY = watchHeight / 2 - timeHeight / 2 - 13 * scaleFactor;
				
		System.println("timeY: " + timeY);
		System.println("watchWidth: " + watchWidth);
		
		// FR45 fix
    	if (watchHeight == 208)
    	{
    		//Gfx.FONT_LARGE works on FR45
    		//Gfx.FONT_NUMBER_HOT doesn't!
    		//Gfx.FONT_NUMBER_THAI_HOT doesn't!
    		//Gfx.FONT_SYSTEM_NUMBER_THAI_HOT doesn't!
    		dc.drawText(watchWidth / 2, 50, robotoFont, timeString, Gfx.TEXT_JUSTIFY_CENTER);
    	}
		else
		{
			dc.drawText(watchWidth / 2, timeY, Gfx.FONT_NUMBER_THAI_HOT, timeString, Gfx.TEXT_JUSTIFY_CENTER);
		}		
	}
	
	function drawBattery(dc) {
		var batteryY = 20 * scaleFactor;
		var batteryX = watchWidth * 0.2;
		
		// Vivoactive HR fix
    	if (watchWidth == 148)
    	{
			batteryX = 20;
		}
		
		var systemStats = Sys.getSystemStats();
		var battery = systemStats.battery;
		var batteryBarLength = 0.18 * battery;

        dc.setColor(foregroundColor, backgroundColor);
        
        /*if (systemStats.charging) { // later SDK
			dc.setColor(Gfx.COLOR_GREEN);        	
        }*/
                
        dc.drawRectangle(batteryX, batteryY, 20, 10);
        dc.drawRectangle(batteryX+20, batteryY + 2, 2, 6);
		
		dc.setColor(Gfx.COLOR_GREEN, backgroundColor);
				
		if (battery < 20) {
			dc.setColor(Gfx.COLOR_ORANGE, backgroundColor);			
		}
		if (battery < 10) {
			dc.setColor(Gfx.COLOR_RED, backgroundColor);			
		} 
						        
        dc.fillRectangle(batteryX + 1, batteryY + 1, batteryBarLength, 8);
        
        dc.setColor(foregroundColor, backgroundColor);
        
        var batteryTextHeight = dc.getTextDimensions("0", Gfx.FONT_XTINY)[1];
        
        //System.println("batteryTextHeight: " + batteryTextHeight);
        
        // FR45 fix
    	if (watchHeight == 208)
    	{
    		batteryY = batteryY + 10;
    	}
        
        dc.drawText(batteryX + 25, batteryY - batteryTextHeight * 0.3, Gfx.FONT_XTINY, battery.format("%d") + "%", Gfx.TEXT_JUSTIFY_LEFT);
	}

	function drawNotifications(dc, count) {
		dc.setColor(foregroundColor, backgroundColor);
		
		var notificationsY = 20 * scaleFactor;
		var notificationsX = watchWidth - watchWidth * 0.2;	
		
		// Vivoactive HR fix
    	if (watchWidth == 148)
    	{
			notificationsX = 148 - 20;
		}
		
		dc.drawRectangle(notificationsX - 15, notificationsY, 15, 10);
		dc.drawLine(notificationsX - 15, notificationsY, notificationsX - 8, notificationsY + 6);
		dc.drawLine(notificationsX - 8, notificationsY + 6, notificationsX, notificationsY);

		var notificationsTextHeight = dc.getTextDimensions("0", Gfx.FONT_XTINY)[1];

		// FR45 fix
    	if (watchHeight == 208)
    	{
    		notificationsY = notificationsY + 10;
    	}

        dc.drawText(notificationsX - 20, notificationsY - notificationsTextHeight * 0.3, Gfx.FONT_XTINY, count, Gfx.TEXT_JUSTIFY_RIGHT);
	}

	function drawDate(dc) {
		dc.setColor(foregroundColor, Gfx.COLOR_TRANSPARENT);
		
		var dateinfo = Greg.info(Time.now(), Time.FORMAT_SHORT);
				
		var weekday = weekdays[dateinfo.day_of_week-1];
		var month = months[dateinfo.month-1];
		var date = dateinfo.day;
		
		var dateText = Lang.format(dateFormat, [weekday, month, date]);
		
		//var dateTextHeight = dc.getTextDimensions("0", Gfx.FONT_SYSTEM_SMALL)[1];
		var dateTextHeight = dc.getTextDimensions("0", Gfx.FONT_MEDIUM)[1];
		
		//var dateY = watchHeight - watchHeight * 0.25 - dateTextHeight;
		var dateY = watchHeight - watchHeight * 0.23 - dateTextHeight;
				
		//System.println("dateTextHeight: " + dateTextHeight);
		
		// FR45 fix
    	if (watchHeight == 208)
    	{
    		dc.drawText(watchWidth / 2, dateY, Gfx.FONT_LARGE, dateText, Gfx.TEXT_JUSTIFY_CENTER);
    	}
    	else
    	{
			//dc.drawText(watchWidth / 2, dateY, Gfx.FONT_SYSTEM_SMALL, dateText, Gfx.TEXT_JUSTIFY_CENTER);
			dc.drawText(watchWidth / 2, dateY, Gfx.FONT_MEDIUM, dateText, Gfx.TEXT_JUSTIFY_CENTER);    	
    	}		 
	}

	function drawSteps(dc) {
		dc.setColor(foregroundColor, backgroundColor);
		var actinfo = Act.getInfo();

		var steps = actinfo.steps; // 3000
		var stepGoal = actinfo.stepGoal; //10000;
						
		var stepBarWidth = watchWidth * 0.6;
				
		var highlightWidth = stepBarWidth * steps / stepGoal;
		
		var stepBarY = watchHeight - watchHeight * 0.15 * scaleFactor;
		
		dc.drawRectangle(watchWidth * 0.2, stepBarY, stepBarWidth, 18);
		
		// Get steps bar color setting
		var colorNum = Application.getApp().getProperty("StepsBarColor");
		
		if (colorNum == 0)
		{
			dc.setColor(Gfx.COLOR_GREEN, backgroundColor);		
		}
		else if (colorNum == 1)
		{
			dc.setColor(Gfx.COLOR_BLUE, backgroundColor);		
		}
		else if (colorNum == 2)
		{
			dc.setColor(Gfx.COLOR_RED, backgroundColor);		
		}
		else if (colorNum == 3)
		{
			dc.setColor(Gfx.COLOR_YELLOW, backgroundColor);		
		}
				
				
		if (highlightWidth > stepBarWidth - 4)
		{
			highlightWidth = stepBarWidth - 4;
			dc.setColor(Gfx.COLOR_GREEN, backgroundColor);
		}	
						
        dc.fillRectangle(watchWidth * 0.2 + 2, stepBarY + 2, highlightWidth, 14);
	}

}
