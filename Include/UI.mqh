//+------------------------------------------------------------------+
//|                                                            UI.mqh  |
//|                   Custom UI Utility for Expert Advisor          |
//|                                                                  |
//+------------------------------------------------------------------+
#property strict

class UIHandler {
  private:
    bool isTesterMode;

    // Datetime label
    string m_dateLabelName;

    // Main Pause/Play Button properties
    bool   m_isTradingActive;
    string m_pauseButtonName;
    int    m_pauseButtonXPosition;
    int    m_pauseButtonYPosition;
    int    m_pauseButtonWidth;
    int    m_pauseButtonHeight;
    int    m_buttonCorner;
    string m_buttonFont;
    int    m_buttonFontSize;
    int    m_buttonTextColor;
    int    m_buttonBorderColor;

    // Buy Pause Button properties
    bool   m_isBuyActive;
    string m_buyButtonName;

    // Sell Pause Button properties
    bool   m_isSellActive;
    string m_sellButtonName;

    // Button labels and colors
    string m_buttonTextRunning;
    int    m_buttonColorRunning;
    string m_buttonTextPaused;
    int    m_buttonColorPaused;

    // Icon properties
    int    m_iconWidth;
    int    m_iconHeight;
    int    m_iconBorderColor;
    int    m_iconTextColor;
    int    m_iconFontSize;
    string m_iconFont;

    // New Day Trading Controls
    bool m_isDayTradingActive[5];

    string m_dayNames[5];
    string m_dayButtonNames[5];

    datetime m_dayStartTimes[5];
    string   m_dayStartTimeInputNames[5];

    datetime m_dayEndTimes[5];
    string   m_dayEndTimeInputNames[5];

    string m_dayTimeResetButtonNames[5];

  public:
    UIHandler() {
        isTesterMode = (bool)MQLInfoInteger(MQL_TESTER) && (bool)MQLInfoInteger(MQL_VISUAL_MODE);

        // Datetime label
        m_dateLabelName = "DATETIME_LABEL";

        // Main Pause/Play Button properties
        m_isTradingActive      = true;   // true = trading on
        m_pauseButtonName      = "BUTTON_PAUSE";
        m_pauseButtonXPosition = 370;
        m_pauseButtonYPosition = 100;
        m_pauseButtonWidth     = 100;
        m_pauseButtonHeight    = 30;
        m_buttonCorner         = CORNER_RIGHT_UPPER;
        m_buttonFont           = "Comic Sans MS";
        m_buttonFontSize       = 9;
        m_buttonTextColor      = clrBlack;
        m_buttonBorderColor    = clrYellow;

        // Buy Pause Button properties
        m_isBuyActive   = true;   // true = allow buy trades
        m_buyButtonName = "BUTTON_PAUSE_BUY";

        // Sell Pause Button properties
        m_isSellActive   = true;   // true = allow sell trades
        m_sellButtonName = "BUTTON_PAUSE_SELL";

        // Button labels and colors
        m_buttonTextRunning  = "Running";
        m_buttonColorRunning = clrMediumSpringGreen;
        m_buttonTextPaused   = "Paused";
        m_buttonColorPaused  = clrBlueViolet;

        // Icon properties
        m_iconWidth       = 40;
        m_iconHeight      = m_pauseButtonHeight;
        m_iconBorderColor = clrYellow;
        m_iconTextColor   = clrWhite;
        m_iconFont        = "MS UI Gothic";
        m_iconFontSize    = 16;

        // Initialize day names
        m_dayNames[0] = "Mon";
        m_dayNames[1] = "Tue";
        m_dayNames[2] = "Wed";
        m_dayNames[3] = "Thur";
        m_dayNames[4] = "Fri";

        // Initialize day trading state (all days active by default)
        for(int i = 0; i < 5; i++) {
            m_isDayTradingActive[i] = true;

            // Create day button names
            m_dayButtonNames[i]          = "DAY_BUTTON_" + m_dayNames[i];
            m_dayStartTimeInputNames[i]  = "START_TIME_INPUT_" + m_dayNames[i];
            m_dayEndTimeInputNames[i]    = "END_TIME_INPUT_" + m_dayNames[i];
            m_dayTimeResetButtonNames[i] = "DAY_TIME_RESET_" + m_dayNames[i];

            // Set default start and end times (example times)
            m_dayStartTimes[i] = StringToTime("04:00");
            m_dayEndTimes[i]   = StringToTime("18:00");
        }

        // Timestamp label
        DrawDateTimeLabel();

        // Controls
        DrawPauseTradingStateButton();
        DrawPauseBuyButton();
        DrawPauseSellButton();

        // Day time controls
        DrawDayButtons();
        DrawDayTimeInputFields();
    }

    void DrawDateTimeLabel() {
        datetime    currentTime = TimeCurrent();
        MqlDateTime timeStruct;
        TimeToStruct(currentTime, timeStruct);

        string dayNames[]   = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
        string dayOfWeek    = dayNames[timeStruct.day_of_week];
        string timeString   = TimeToString(currentTime, TIME_SECONDS);
        string dateTimeText = (string)timeStruct.day + " " + dayOfWeek + " " + timeString;

        ObjectDelete(0, m_dateLabelName);
        ObjectCreate(0, m_dateLabelName, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, m_dateLabelName, OBJPROP_XDISTANCE, m_pauseButtonXPosition);
        ObjectSetInteger(0, m_dateLabelName, OBJPROP_YDISTANCE, m_pauseButtonYPosition - 50);
        ObjectSetInteger(0, m_dateLabelName, OBJPROP_CORNER, m_buttonCorner);
        ObjectSetString(0, m_dateLabelName, OBJPROP_TEXT, dateTimeText);
        ObjectSetString(0, m_dateLabelName, OBJPROP_FONT, m_buttonFont);
        ObjectSetInteger(0, m_dateLabelName, OBJPROP_FONTSIZE, m_buttonFontSize);
        ObjectSetInteger(0, m_dateLabelName, OBJPROP_COLOR, clrWhite);
    }

    void DrawPauseTradingStateButton() {
        Print("Drawing Pause/Play buttons");

        // Draw Main Pause/Play Button
        ObjectDelete(0, m_pauseButtonName);
        ObjectCreate(0, m_pauseButtonName, OBJ_BUTTON, 0, 0, 0);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_XDISTANCE, m_pauseButtonXPosition);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_YDISTANCE, m_pauseButtonYPosition);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_XSIZE, m_pauseButtonWidth);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_YSIZE, m_pauseButtonHeight);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_CORNER, m_buttonCorner);
        ObjectSetString(0, m_pauseButtonName, OBJPROP_FONT, m_buttonFont);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_FONTSIZE, m_buttonFontSize);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_COLOR, m_buttonTextColor);
        ObjectSetInteger(0, m_pauseButtonName, OBJPROP_BORDER_COLOR, m_buttonBorderColor);

        SetPauseTradingButtonState(m_isTradingActive);
    }

    void DrawPauseBuyButton() {
        // Draw Buy Pause Button
        ObjectDelete(0, m_buyButtonName);
        ObjectCreate(0, m_buyButtonName, OBJ_BUTTON, 0, 0, 0);
        // ObjectSetInteger(0, m_buyButtonName, OBJPROP_XDISTANCE, m_pauseButtonXPosition);
        // ObjectSetInteger(0, m_buyButtonName, OBJPROP_YDISTANCE, m_pauseButtonYPosition + m_pauseButtonHeight + 10);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_XDISTANCE, m_pauseButtonXPosition - 140);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_YDISTANCE, 100);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_XSIZE, m_iconWidth);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_YSIZE, m_iconHeight);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_CORNER, m_buttonCorner);
        ObjectSetString(0, m_buyButtonName, OBJPROP_FONT, m_iconFont);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_FONTSIZE, m_buttonFontSize);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_COLOR, m_iconTextColor);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_BORDER_COLOR, m_iconBorderColor);
        ObjectSetString(0, m_buyButtonName, OBJPROP_TEXT, "▲");

        SetPauseBuyButtonState(m_isBuyActive);
    }

    void DrawPauseSellButton() {
        // Draw Sell Pause Button
        ObjectDelete(0, m_sellButtonName);
        ObjectCreate(0, m_sellButtonName, OBJ_BUTTON, 0, 0, 0);
        // ObjectSetInteger(0, m_sellButtonName, OBJPROP_XDISTANCE, m_pauseButtonXPosition);
        // ObjectSetInteger(0, m_sellButtonName, OBJPROP_YDISTANCE, m_pauseButtonYPosition + (m_pauseButtonHeight + 10) * 2);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_XDISTANCE, m_pauseButtonXPosition - 240);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_YDISTANCE, 100);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_XSIZE, m_iconWidth);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_YSIZE, m_iconHeight);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_CORNER, m_buttonCorner);
        ObjectSetString(0, m_sellButtonName, OBJPROP_FONT, m_iconFont);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_FONTSIZE, m_buttonFontSize);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_COLOR, m_iconTextColor);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_BORDER_COLOR, m_iconBorderColor);
        ObjectSetString(0, m_sellButtonName, OBJPROP_TEXT, "▼");

        SetPauseSellButtonState(m_isSellActive);
    }

    void DrawDayButtons() {
        for(int i = 0; i < 5; i++) {
            ObjectDelete(0, m_dayButtonNames[i]);
            ObjectCreate(0, m_dayButtonNames[i], OBJ_BUTTON, 0, 0, 0);

            // Position buttons below existing controls
            ObjectSetInteger(0, m_dayButtonNames[i], OBJPROP_XDISTANCE, m_pauseButtonXPosition);
            ObjectSetInteger(0, m_dayButtonNames[i], OBJPROP_YDISTANCE, 100 + (m_pauseButtonHeight * (i + 2)));
            ObjectSetString(0, m_dayButtonNames[i], OBJPROP_FONT, m_buttonFont);
            ObjectSetInteger(0, m_dayButtonNames[i], OBJPROP_FONTSIZE, m_buttonFontSize);
            ObjectSetInteger(0, m_dayButtonNames[i], OBJPROP_XSIZE, 100);
            ObjectSetInteger(0, m_dayButtonNames[i], OBJPROP_YSIZE, m_pauseButtonHeight);
            ObjectSetInteger(0, m_dayButtonNames[i], OBJPROP_CORNER, m_buttonCorner);
            ObjectSetString(0, m_dayButtonNames[i], OBJPROP_TEXT, m_dayNames[i]);
            SetDayButtonState(i, m_isDayTradingActive[i]);
        }
    }

    void DrawDayTimeInputFields() {
        for(int i = 0; i < 5; i++) {
            datetime defaultStartTime = StringToTime("04:00");
            datetime defaultEndTime   = StringToTime("18:00");

            // Start Time Input
            ObjectDelete(0, m_dayStartTimeInputNames[i]);
            ObjectCreate(0, m_dayStartTimeInputNames[i], OBJ_EDIT, 0, 0, 0);
            ObjectSetInteger(0, m_dayStartTimeInputNames[i], OBJPROP_XDISTANCE, m_pauseButtonXPosition - 120);
            ObjectSetInteger(0, m_dayStartTimeInputNames[i], OBJPROP_YDISTANCE, 100 + (m_pauseButtonHeight * (i + 2)));
            ObjectSetInteger(0, m_dayStartTimeInputNames[i], OBJPROP_XSIZE, 80);
            ObjectSetInteger(0, m_dayStartTimeInputNames[i], OBJPROP_YSIZE, m_pauseButtonHeight);
            ObjectSetInteger(0, m_dayStartTimeInputNames[i], OBJPROP_CORNER, m_buttonCorner);
            ObjectSetString(0, m_dayStartTimeInputNames[i], OBJPROP_FONT, m_buttonFont);
            ObjectSetInteger(0, m_dayStartTimeInputNames[i], OBJPROP_FONTSIZE, m_buttonFontSize);

            // Color logic for start time
            bool isDefaultStart = (m_dayStartTimes[i] == defaultStartTime);
            ObjectSetInteger(0, m_dayStartTimeInputNames[i], OBJPROP_COLOR, isDefaultStart ? clrWhite : clrYellow);

            ObjectSetString(0, m_dayStartTimeInputNames[i], OBJPROP_TEXT, TimeToString(m_dayStartTimes[i], TIME_MINUTES));

            // End Time Input
            ObjectDelete(0, m_dayEndTimeInputNames[i]);
            ObjectCreate(0, m_dayEndTimeInputNames[i], OBJ_EDIT, 0, 0, 0);
            ObjectSetInteger(0, m_dayEndTimeInputNames[i], OBJPROP_XDISTANCE, m_pauseButtonXPosition - 220);
            ObjectSetInteger(0, m_dayEndTimeInputNames[i], OBJPROP_YDISTANCE, 100 + (m_pauseButtonHeight * (i + 2)));
            ObjectSetInteger(0, m_dayEndTimeInputNames[i], OBJPROP_XSIZE, 80);
            ObjectSetInteger(0, m_dayEndTimeInputNames[i], OBJPROP_YSIZE, m_pauseButtonHeight);
            ObjectSetInteger(0, m_dayEndTimeInputNames[i], OBJPROP_CORNER, m_buttonCorner);
            ObjectSetString(0, m_dayEndTimeInputNames[i], OBJPROP_FONT, m_buttonFont);
            ObjectSetInteger(0, m_dayEndTimeInputNames[i], OBJPROP_FONTSIZE, m_buttonFontSize);

            // Color logic for end time
            bool isDefaultEnd = (m_dayEndTimes[i] == defaultEndTime);
            ObjectSetInteger(0, m_dayEndTimeInputNames[i], OBJPROP_COLOR, isDefaultEnd ? clrWhite : clrYellow);

            ObjectSetString(0, m_dayEndTimeInputNames[i], OBJPROP_TEXT, TimeToString(m_dayEndTimes[i], TIME_MINUTES));

            // Reset Button
            ObjectDelete(0, m_dayTimeResetButtonNames[i]);
            ObjectCreate(0, m_dayTimeResetButtonNames[i], OBJ_BUTTON, 0, 0, 0);
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_XDISTANCE, m_pauseButtonXPosition - 320);
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_YDISTANCE, 100 + (m_pauseButtonHeight * (i + 2)));
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_XSIZE, 30);
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_YSIZE, m_pauseButtonHeight);
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_CORNER, m_buttonCorner);
            ObjectSetString(0, m_dayTimeResetButtonNames[i], OBJPROP_FONT, m_iconFont);
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_FONTSIZE, m_iconFontSize);
            ObjectSetString(0, m_dayTimeResetButtonNames[i], OBJPROP_TEXT, "⟲");
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_COLOR, clrWhite);
            ObjectSetInteger(0, m_dayTimeResetButtonNames[i], OBJPROP_BGCOLOR, clrDarkGray);
        }
    }

    // Overload Render method to handle new day buttons
    bool Render(const string &sparam, const int &id) {

        // First, check time input changes
        if(HandleTimeInputChanges(sparam)) {
            return true;
        }

        // Handle reset button clicks
        for(int i = 0; i < 5; i++) {
            if(sparam == m_dayTimeResetButtonNames[i]) {
                // Reset both start and end times to default
                SetDayTradingTimes(i, StringToTime("04:00"), StringToTime("18:00"));

                // Redraw input fields to update colors and values
                DrawDayTimeInputFields();
                return true;
            }
        }

        // Then check existing parent method logic
        bool baseResult = BaseRender(sparam, id);
        if(baseResult)
            return true;

        // Check for day button clicks
        for(int i = 0; i < 5; i++) {
            if(sparam == m_dayButtonNames[i]) {
                // Toggle day trading state
                SetDayButtonState(i, !m_isDayTradingActive[i]);
                return true;
            }
        }

        return false;
    }

    // USED IN LIVE CHART, NOT USED IN STRATEGY TESTER AT ALL
    bool BaseRender(const string &sparam, const int &id) {
        if(id != CHARTEVENT_OBJECT_CLICK) {
            Print("Event is not an object click. Exiting RefreshButtons.");
            return false;
        }

        if(sparam == m_pauseButtonName) {
            m_isTradingActive = !m_isTradingActive;

            if(!m_isTradingActive) {
                // If pausing, also pause buy and sell buttons
                m_isBuyActive  = false;
                m_isSellActive = false;
            }

            SetPauseTradingButtonState(m_isTradingActive);

            if(!m_isTradingActive) {
                // Only update buy and sell buttons if trading is paused
                SetPauseBuyButtonState(m_isBuyActive);
                SetPauseSellButtonState(m_isSellActive);
            }

            PrintFormat("Main Pause/Play button toggled. New state: " + (string)m_isTradingActive);
            return true;
        }

        // Only allow toggling buy/sell buttons if trading is active
        if(m_isTradingActive) {
            if(sparam == m_buyButtonName) {
                m_isBuyActive = !m_isBuyActive;
                SetPauseBuyButtonState(m_isBuyActive);
                PrintFormat("Pause Buy button toggled. New state: " + (string)m_isBuyActive);
                return true;
            }

            if(sparam == m_sellButtonName) {
                m_isSellActive = !m_isSellActive;
                SetPauseSellButtonState(m_isSellActive);
                PrintFormat("Pause Sell button toggled. New state: " + (string)m_isSellActive);
                return true;
            }
        }

        return false;
    }

    // USED IN STRATEGY TESTER, NOT USED IN LIVE CHART AT ALL
    bool GetTradingState() {

        // In tester mode, allow manual override
        if(isTesterMode) {
            // Check if button exists and get its current state
            if(ObjectFind(0, m_pauseButtonName) >= 0) {
                m_isTradingActive = ObjectGetInteger(0, m_pauseButtonName, OBJPROP_STATE);
                SetPauseTradingButtonState(m_isTradingActive);
            }
        }

        return m_isTradingActive;
    }

    bool GetBuyState() {

        // In tester mode, allow manual override
        if(isTesterMode) {
            // Check if button exists and get its current state
            if(ObjectFind(0, m_buyButtonName) >= 0) {
                m_isBuyActive = ObjectGetInteger(0, m_buyButtonName, OBJPROP_STATE);
                SetPauseBuyButtonState(m_isBuyActive);
            }
        }

        return m_isBuyActive;
    }

    bool GetSellState() {

        // In tester mode, allow manual override
        if(isTesterMode) {
            // Check if button exists and get its current state
            if(ObjectFind(0, m_sellButtonName) >= 0) {
                m_isSellActive = ObjectGetInteger(0, m_sellButtonName, OBJPROP_STATE);
                SetPauseSellButtonState(m_isSellActive);
            }
        }

        return m_isSellActive;
    }

    // Getters for day trading states
    bool GetDayActiveState(int dayIndex) {
        if(dayIndex < 0 || dayIndex >= 5)
            return false;
        return m_isDayTradingActive[dayIndex];
    }

    datetime GetDayStartTime(int dayIndex) {
        if(dayIndex < 0 || dayIndex >= 5)
            return 0;
        return m_dayStartTimes[dayIndex];
    }

    datetime GetDayEndTime(int dayIndex) {
        if(dayIndex < 0 || dayIndex >= 5)
            return 0;
        return m_dayEndTimes[dayIndex];
    }

    // Delete all/Clean up
    void DeleteButtons() {

        Print("Deleting UI items");

        // Delete first row
        ObjectDelete(0, m_dateLabelName);
        ObjectDelete(0, m_pauseButtonName);
        ObjectDelete(0, m_buyButtonName);
        ObjectDelete(0, m_sellButtonName);

        // Delete day buttons and time inputs
        for(int i = 0; i < 5; i++) {
            ObjectDelete(0, m_dayButtonNames[i]);
            ObjectDelete(0, m_dayStartTimeInputNames[i]);
            ObjectDelete(0, m_dayEndTimeInputNames[i]);
            ObjectDelete(0, m_dayTimeResetButtonNames[i]);
        }
    }

  private:
    // Update Button States
    void SetPauseTradingButtonState(bool state) {
        m_isTradingActive = state;
        if(ObjectFind(0, m_pauseButtonName) >= 0) {
            ObjectSetInteger(0, m_pauseButtonName, OBJPROP_STATE, m_isTradingActive);
            ObjectSetString(0, m_pauseButtonName, OBJPROP_TEXT, (m_isTradingActive ? m_buttonTextRunning : m_buttonTextPaused));
            ObjectSetInteger(0, m_pauseButtonName, OBJPROP_BGCOLOR, (m_isTradingActive ? m_buttonColorRunning : m_buttonColorPaused));
        }

        ChartRedraw(0);   // after updating UI properties
    }

    void SetPauseBuyButtonState(bool state) {
        m_isBuyActive = state;
        if(ObjectFind(0, m_buyButtonName) >= 0) {
            ObjectSetInteger(0, m_buyButtonName, OBJPROP_STATE, m_isBuyActive);
            ObjectSetInteger(0, m_buyButtonName, OBJPROP_BGCOLOR, (m_isBuyActive ? clrGreen : clrGray));
        }
        ChartRedraw(0);   // after updating UI properties
    }

    void SetPauseSellButtonState(bool state) {
        m_isSellActive = state;
        if(ObjectFind(0, m_sellButtonName) >= 0) {
            ObjectSetInteger(0, m_sellButtonName, OBJPROP_STATE, m_isSellActive);
            ObjectSetInteger(0, m_sellButtonName, OBJPROP_BGCOLOR, (m_isSellActive ? clrRed : clrGray));
        }
        ChartRedraw(0);   // after updating UI properties
    }

    void SetDayButtonState(int dayIndex, bool state) {
        if(dayIndex < 0 || dayIndex >= 5)
            return;

        m_isDayTradingActive[dayIndex] = state;
        if(ObjectFind(0, m_dayButtonNames[dayIndex]) >= 0) {
            ObjectSetInteger(0, m_dayButtonNames[dayIndex], OBJPROP_STATE, state);
            ObjectSetInteger(0, m_dayButtonNames[dayIndex], OBJPROP_BGCOLOR, (state ? m_buttonColorRunning : clrBlueViolet));
        }
        PrintFormat(m_dayButtonNames[dayIndex] + " toggled. New state: " + (string)state);
        ChartRedraw(0);
    }

    // Update day time for when trading is allowed
    void SetDayTradingTimes(int dayIndex, datetime startTime, datetime endTime) {
        if(dayIndex < 0 || dayIndex >= 5)
            return;

        datetime defaultStartTime = StringToTime("04:00");
        datetime defaultEndTime   = StringToTime("18:00");

        m_dayStartTimes[dayIndex] = startTime;
        m_dayEndTimes[dayIndex]   = endTime;

        // Update button texts
        if(ObjectFind(0, m_dayStartTimeInputNames[dayIndex]) >= 0) {
            ObjectSetString(0, m_dayStartTimeInputNames[dayIndex], OBJPROP_TEXT,
                            TimeToString(startTime, TIME_MINUTES));

            ObjectSetInteger(0, m_dayStartTimeInputNames[dayIndex], OBJPROP_COLOR,
                             (startTime == defaultStartTime) ? clrWhite : clrYellow);
        }
        if(ObjectFind(0, m_dayEndTimeInputNames[dayIndex]) >= 0) {
            ObjectSetString(0, m_dayEndTimeInputNames[dayIndex], OBJPROP_TEXT,
                            TimeToString(endTime, TIME_MINUTES));

            ObjectSetInteger(0, m_dayEndTimeInputNames[dayIndex], OBJPROP_COLOR,
                             (endTime == defaultEndTime) ? clrWhite : clrYellow);
        }

        PrintFormat("Day Trading Time Change: dayIndex: %s, startTime: %s, endTime: %s", (string)dayIndex, TimeToString(startTime, TIME_MINUTES), TimeToString(endTime, TIME_MINUTES));
        ChartRedraw(0);
    }

    // Enhanced method to handle time input changes
    bool HandleTimeInputChanges(const string &sparam) {
        for(int i = 0; i < 5; i++) {
            if(sparam == m_dayStartTimeInputNames[i]) {
                // Get the new time from the input
                datetime newStartTime = StringToTime(ObjectGetString(0, sparam, OBJPROP_TEXT));
                SetDayTradingTimes(i, newStartTime, m_dayEndTimes[i]);
                return true;
            }

            if(sparam == m_dayEndTimeInputNames[i]) {
                // Get the new time from the input
                datetime newEndTime = StringToTime(ObjectGetString(0, sparam, OBJPROP_TEXT));
                SetDayTradingTimes(i, m_dayStartTimes[i], newEndTime);
                return true;
            }
        }
        return false;
    }
};
