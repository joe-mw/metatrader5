//+------------------------------------------------------------------+
//|                                                            UI.mqh  |
//|                   Custom UI Utility for Expert Advisor          |
//|                                                                  |
//+------------------------------------------------------------------+
#property strict

// Datetime data
const string dateLabelName = "DATETIME_LABEL";

// Button data
bool         ButtonState      = true;   // Button state, trading on or off, true = trade
const string ButtonName       = "BUTTON_PAUSE";
const int    ButtonXPosition  = 310;
const int    ButtonYPosition  = 100;
const int    ButtonWidth      = 120;
const int    ButtonHeight     = 40;
const int    ButtonCorner     = CORNER_RIGHT_UPPER;
const string ButtonFont       = "Arial Bold";
const int    ButtonFontSize   = 10;
const int    ButtonTextColour = clrBlack;

// When running

const string ButtonTextRunning   = "Running";
const int    ButtonColourRunning = clrRed;

// When paused

const string ButtonTextPaused   = "Paused";
const int    ButtonColourPaused = clrBlueViolet;

void DrawDateTimeLabel() {

    // Get current time
    datetime    currentTime = TimeCurrent();
    MqlDateTime timeStruct;
    TimeToStruct(currentTime, timeStruct);

    string dayNames[]   = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
    string dayOfWeek    = dayNames[timeStruct.day_of_week];
    string timeString   = TimeToString(currentTime, TIME_SECONDS);
    string dateTimeText = (string)timeStruct.day + " " + dayOfWeek + " " + timeString;

    ObjectDelete(0, dateLabelName);
    ObjectCreate(0, dateLabelName, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, dateLabelName, OBJPROP_XDISTANCE, ButtonXPosition);
    ObjectSetInteger(0, dateLabelName, OBJPROP_YDISTANCE, ButtonYPosition - 50);
    ObjectSetInteger(0, dateLabelName, OBJPROP_CORNER, ButtonCorner);
    ObjectSetString(0, dateLabelName, OBJPROP_TEXT, dateTimeText);
    ObjectSetString(0, dateLabelName, OBJPROP_FONT, ButtonFont);
    ObjectSetInteger(0, dateLabelName, OBJPROP_FONTSIZE, ButtonFontSize);
    ObjectSetInteger(0, dateLabelName, OBJPROP_COLOR, clrWhite);
}

void DrawPauseButton() {
    Print("Draw Pause/Play button begin");

    ObjectDelete(0, ButtonName);
    ObjectCreate(0, ButtonName, OBJ_BUTTON, 0, 0, 0);
    ObjectSetInteger(0, ButtonName, OBJPROP_XDISTANCE, ButtonXPosition);
    ObjectSetInteger(0, ButtonName, OBJPROP_YDISTANCE, ButtonYPosition);
    ObjectSetInteger(0, ButtonName, OBJPROP_XSIZE, ButtonWidth);
    ObjectSetInteger(0, ButtonName, OBJPROP_YSIZE, ButtonHeight);
    ObjectSetInteger(0, ButtonName, OBJPROP_CORNER, ButtonCorner);
    ObjectSetString(0, ButtonName, OBJPROP_FONT, ButtonFont);
    ObjectSetInteger(0, ButtonName, OBJPROP_FONTSIZE, ButtonFontSize);
    ObjectSetInteger(0, ButtonName, OBJPROP_COLOR, ButtonTextColour);

    SetButtonState(ButtonState);
    Print("Drawing Pause/Play button complete with state: " + (string)ButtonState);
}

void DeletePauseButton() {
    Print("Delete Pause/Play button");
    ObjectDelete(0, dateLabelName);
    ObjectDelete(0, ButtonName);
}

void SetButtonState(bool state) {
    ButtonState = state;

    ObjectSetInteger(0, ButtonName, OBJPROP_STATE, ButtonState);
    ObjectSetString(0, ButtonName, OBJPROP_TEXT, ButtonText());
    ObjectSetInteger(0, ButtonName, OBJPROP_BGCOLOR, ButtonColour());
}

string ButtonText() {
    return (ButtonState ? ButtonTextRunning : ButtonTextPaused);
}

int ButtonColour() {
    return (ButtonState ? ButtonColourRunning : ButtonColourPaused);
}

bool RefreshButton(string &sparam, int &id) {

    bool returnVal = false;

    if(sparam != ButtonName)
        return returnVal;

    if(id != CHARTEVENT_OBJECT_CLICK)
        return returnVal;

    returnVal = true;
    SetButtonState(ObjectGetInteger(0, ButtonName, OBJPROP_STATE, 0));

    PrintFormat("Refresh Pause/Play button, new state: " + (string)ButtonState);

    return returnVal;
}

bool CheckPauseButtonActiveCondition() {
    // Print("Validate Pause/Play button induced state, current state: " + ButtonState);
    if((bool)MQLInfoInteger(MQL_TESTER) && (bool)MQLInfoInteger(MQL_VISUAL_MODE)) {
        SetButtonState(ObjectGetInteger(0, ButtonName, OBJPROP_STATE, 0));
    }
    return ButtonState;
}
