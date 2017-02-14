using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as Act;
using Toybox.Time.Gregorian as Greg;

class CleanStepsView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
		
		var watchHeight = dc.getHeight();
		var watchWidth = dc.getWidth();

		var foregroundColor = Gfx.COLOR_WHITE;
		var backgroundColor = Gfx.COLOR_BLACK;
		
		// Clear gfx
		//dc.clear();
		dc.setColor(backgroundColor, backgroundColor);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

		// Draw clock
		dc.setColor(foregroundColor, backgroundColor);		
		dc.drawText(watchWidth / 2, 25, Gfx.FONT_NUMBER_THAI_HOT, timeString, Gfx.TEXT_JUSTIFY_CENTER);

		
		// Draw steps
		var actinfo = Act.getInfo();

		var steps = actinfo.steps; // 3000
		var stepGoal = actinfo.stepGoal; //10000;
		var stepPercentage = 1.0 * steps / stepGoal; 
				
		var stepBarWidth = watchWidth * 0.6;
		var highlightWidth = stepBarWidth * stepPercentage;
				
		if (highlightWidth > stepBarWidth - 2)
		{
			highlightWidth = stepBarWidth - 2;
		}	
		
		dc.drawRectangle(watchWidth * 0.2, watchHeight - 30, stepBarWidth, 20);
		dc.setColor(Gfx.COLOR_BLUE, backgroundColor);
        dc.fillRectangle(watchWidth * 0.2 + 2, watchHeight - 28, highlightWidth, 16);
        dc.setColor(foregroundColor, backgroundColor);


		// Draw battery
		var systemStats = Sys.getSystemStats();
		var battery = systemStats.battery;
		var batteryBarLength = 0.18 * battery;

        dc.drawRectangle(40, 20, 20, 10);
        dc.drawRectangle(60, 22, 2, 6);
		        
        dc.setColor(Gfx.COLOR_LT_GRAY, backgroundColor);
        dc.fillRectangle(41, 21, batteryBarLength, 8);
        
        dc.setColor(foregroundColor, backgroundColor);
        
        dc.drawText(65, 14, Gfx.FONT_TINY, battery.format("%d") + "%", Gfx.TEXT_JUSTIFY_LEFT);


		// Draw notifications count
		var settings = Sys.getDeviceSettings();
		
		//if (settings.notificationCount>0)

		dc.drawRectangle(155, 20, 15, 10);
		dc.drawLine(155, 20, 162, 26);
		dc.drawLine(162, 26, 170, 20);

        dc.drawText(150, 14, Gfx.FONT_TINY, settings.notificationCount, Gfx.TEXT_JUSTIFY_RIGHT);
        

		// Draw date
		var dateinfo = Greg.info(Time.now(), Time.FORMAT_SHORT);
		
		var months = [
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
		
		var weekdays = [
			Ui.loadResource(Rez.Strings.Day0),
			Ui.loadResource(Rez.Strings.Day1),
			Ui.loadResource(Rez.Strings.Day2),
			Ui.loadResource(Rez.Strings.Day3),
			Ui.loadResource(Rez.Strings.Day4),
			Ui.loadResource(Rez.Strings.Day5),
			Ui.loadResource(Rez.Strings.Day6)
		];

		var lang = Ui.loadResource(Rez.Strings.lang);
		
		var dateText = weekdays[dateinfo.day_of_week-1] + ", " + months[dateinfo.month-1] + " " + dateinfo.day;
		
		if (lang.equals("da")) {
			dateText = weekdays[dateinfo.day_of_week-1] + ", " + dateinfo.day + ". " + months[dateinfo.month-1];
		}

		dc.drawText(watchWidth / 2, 120, Gfx.FONT_SYSTEM_SMALL, dateText, Gfx.TEXT_JUSTIFY_CENTER);

        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }  

}
