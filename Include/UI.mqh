//+------------------------------------------------------------------+
//|                                                            UI.mqh  |
//|                   Custom UI Utility for Expert Advisor          |
//|                                                                  |
//+------------------------------------------------------------------+
#property strict

// Datetime data
const string dateLabelName = "DATETIME_LABEL";

// Button data for Pause/Play
bool         ButtonState       = true;   // Button state, trading on or off, true = trade
const string ButtonName        = "BUTTON_PAUSE";
const int    ButtonXPosition   = 310;
const int    ButtonYPosition   = 100;
const int    ButtonWidth       = 130;
const int    ButtonHeight      = 50;
const int    ButtonCorner      = CORNER_RIGHT_UPPER;
const string ButtonFont        = "Comic Sans MS";
const int    ButtonFontSize    = 12;
const int    ButtonTextColour  = clrBlack;
const int    ButtonBorderColor = clrYellow;

const int IconWidth       = 60;
const int IconHeight      = ButtonHeight;
const int IconBorderColor = clrYellow;
const int IconTextColour  = clrWhite;

// Button data for Pause Buy
bool         ButtonStateBuy     = false;   // Pause Buy button state, false = allow buy trades
const string ButtonNameBuy      = "BUTTON_PAUSE_BUY";
const int    ButtonXPositionBuy = ButtonXPosition;
const int    ButtonYPositionBuy = ButtonYPosition + ButtonHeight + 10;

// Button data for Pause Sell
bool         ButtonStateSell     = false;   // Pause Sell button state, false = allow sell trades
const string ButtonNameSell      = "BUTTON_PAUSE_SELL";
const int    ButtonXPositionSell = ButtonXPosition;
const int    ButtonYPositionSell = ButtonYPositionBuy + ButtonHeight + 10;

// When running
const string ButtonTextRunning   = "Running";
const int    ButtonColourRunning = clrMediumSpringGreen;

// When paused
const string ButtonTextPaused   = "Paused";
const int    ButtonColourPaused = clrBlueViolet;

void DrawDateTimeLabel() {
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

void DrawPauseButtons() {
    Print("Drawing Pause/Play buttons");

    // Draw Main Pause/Play Button
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
    ObjectSetInteger(0, ButtonName, OBJPROP_BORDER_COLOR, ButtonBorderColor);

    // Draw Pause Buy Button
    ObjectDelete(0, ButtonNameBuy);
    ObjectCreate(0, ButtonNameBuy, OBJ_BUTTON, 0, 0, 0);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_XDISTANCE, 150);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_YDISTANCE, 100);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_XSIZE, IconWidth);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_YSIZE, IconHeight);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_CORNER, ButtonCorner);
    ObjectSetString(0, ButtonNameBuy, OBJPROP_FONT, ButtonFont);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_FONTSIZE, ButtonFontSize);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_COLOR, IconTextColour);
    ObjectSetInteger(0, ButtonNameBuy, OBJPROP_BORDER_COLOR, IconBorderColor);
    ObjectSetString(0, ButtonNameBuy, OBJPROP_TEXT, "▲");

    // Draw Pause Sell Button
    ObjectDelete(0, ButtonNameSell);
    ObjectCreate(0, ButtonNameSell, OBJ_BUTTON, 0, 0, 0);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_XDISTANCE, 70);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_YDISTANCE, 100);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_XSIZE, IconWidth);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_YSIZE, IconHeight);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_CORNER, ButtonCorner);
    ObjectSetString(0, ButtonNameSell, OBJPROP_FONT, ButtonFont);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_FONTSIZE, ButtonFontSize);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_COLOR, IconTextColour);
    ObjectSetInteger(0, ButtonNameSell, OBJPROP_BORDER_COLOR, IconBorderColor);
    ObjectSetString(0, ButtonNameSell, OBJPROP_TEXT, "▼");

    // Set initial states
    SetButtonStates();
    Print("Drawing Pause buttons complete");
}

void DeletePauseButtons() {
    Print("Delete UI items");
    ObjectDelete(0, dateLabelName);
    ObjectDelete(0, ButtonName);
    ObjectDelete(0, ButtonNameBuy);
    ObjectDelete(0, ButtonNameSell);
}

void SetButtonStates() {
    // Main Pause/Play Button
    if(ObjectFind(0, ButtonName) >= 0) {
        ObjectSetInteger(0, ButtonName, OBJPROP_STATE, ButtonState);
        ObjectSetString(0, ButtonName, OBJPROP_TEXT, (ButtonState ? ButtonTextRunning : ButtonTextPaused));
        ObjectSetInteger(0, ButtonName, OBJPROP_BGCOLOR, (ButtonState ? ButtonColourRunning : ButtonColourPaused));
    }

    // Pause Buy Button
    if(ObjectFind(0, ButtonNameBuy) >= 0) {
        ObjectSetInteger(0, ButtonNameBuy, OBJPROP_STATE, ButtonStateBuy);
        ObjectSetInteger(0, ButtonNameBuy, OBJPROP_BGCOLOR, (ButtonStateBuy ? clrGray : clrGreen));
    }

    // Pause Sell Button
    if(ObjectFind(0, ButtonNameSell) >= 0) {
        ObjectSetInteger(0, ButtonNameSell, OBJPROP_STATE, ButtonStateSell);
        ObjectSetInteger(0, ButtonNameSell, OBJPROP_BGCOLOR, (ButtonStateSell ? clrGray : clrRed));
    }
}

bool RefreshButtons(const string &sparam, const int &id) {
    bool returnVal = false;

    // Add more detailed logging
    Print("RefreshButtons called with: sparam = " + sparam + ", id = " + (string)id);

    // Validate the event type first
    if(id != CHARTEVENT_OBJECT_CLICK) {
        Print("Event is not an object click. Exiting RefreshButtons.");
        return false;
    }

    // Check Main Pause/Play Button
    ButtonState = !ButtonState;   // Toggle the state
    SetButtonStates();
    PrintFormat("Main Pause/Play button toggled. New state: " + (string)ButtonState);

    // Check Pause Buy Button
    ButtonStateBuy = !ButtonStateBuy;   // Toggle the state
    SetButtonStates();
    PrintFormat("Pause Buy button toggled. New state: " + (string)ButtonStateBuy);

    // Check Pause Sell Button
    ButtonStateSell = !ButtonStateSell;   // Toggle the state
    SetButtonStates();
    PrintFormat("Pause Sell button toggled. New state: " + (string)ButtonStateSell);

    // Force chart redraw if state changed
    ChartRedraw();

    return returnVal;
}

// Modify the check methods to ensure consistency
bool CheckPauseButtonActiveCondition() {
    // Always check the current state, regardless of tester mode
    ButtonState = ObjectGetInteger(0, ButtonName, OBJPROP_STATE);
    SetButtonStates();
    return ButtonState;
}

bool CheckPauseBuyActiveCondition() {
    // Always check the current state, regardless of tester mode
    ButtonStateBuy = ObjectGetInteger(0, ButtonNameBuy, OBJPROP_STATE);
    SetButtonStates();
    return ButtonStateBuy;
}

bool CheckPauseSellActiveCondition() {
    // Always check the current state, regardless of tester mode
    ButtonStateSell = ObjectGetInteger(0, ButtonNameSell, OBJPROP_STATE);
    SetButtonStates();
    return ButtonStateSell;
}