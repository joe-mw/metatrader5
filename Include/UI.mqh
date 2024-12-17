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
    int m_iconWidth;
    int m_iconHeight;
    int m_iconBorderColor;
    int m_iconTextColor;

  public:
    UIHandler() {
        isTesterMode = (bool)MQLInfoInteger(MQL_TESTER) && (bool)MQLInfoInteger(MQL_VISUAL_MODE);

        // Datetime label
        m_dateLabelName = "DATETIME_LABEL";

        // Main Pause/Play Button properties
        m_isTradingActive      = false;   // true = trading on
        m_pauseButtonName      = "BUTTON_PAUSE";
        m_pauseButtonXPosition = 310;
        m_pauseButtonYPosition = 100;
        m_pauseButtonWidth     = 130;
        m_pauseButtonHeight    = 50;
        m_buttonCorner         = CORNER_RIGHT_UPPER;
        m_buttonFont           = "Comic Sans MS";
        m_buttonFontSize       = 12;
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
        m_iconWidth       = 60;
        m_iconHeight      = m_pauseButtonHeight;
        m_iconBorderColor = clrYellow;
        m_iconTextColor   = clrWhite;

        // Timestamp label
        DrawDateTimeLabel();

        // Controls
        DrawPauseTradingStateButton();
        DrawPauseBuyButton();
        DrawPauseSellButton();
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
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_XDISTANCE, 150);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_YDISTANCE, 100);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_XSIZE, m_iconWidth);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_YSIZE, m_iconHeight);
        ObjectSetInteger(0, m_buyButtonName, OBJPROP_CORNER, m_buttonCorner);
        ObjectSetString(0, m_buyButtonName, OBJPROP_FONT, m_buttonFont);
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
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_XDISTANCE, 70);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_YDISTANCE, 100);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_XSIZE, m_iconWidth);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_YSIZE, m_iconHeight);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_CORNER, m_buttonCorner);
        ObjectSetString(0, m_sellButtonName, OBJPROP_FONT, m_buttonFont);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_FONTSIZE, m_buttonFontSize);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_COLOR, m_iconTextColor);
        ObjectSetInteger(0, m_sellButtonName, OBJPROP_BORDER_COLOR, m_iconBorderColor);
        ObjectSetString(0, m_sellButtonName, OBJPROP_TEXT, "▼");

        SetPauseSellButtonState(m_isSellActive);
    }

    // USED IN LIVE CHART, NOT USED IN STRATEGY TESTER AT ALL
    bool Render(const string &sparam, const int &id) {
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

    // Delete all/Clean up
    void DeletePauseButtons() {
        Print("Deleting UI items");
        ObjectDelete(0, m_dateLabelName);
        ObjectDelete(0, m_pauseButtonName);
        ObjectDelete(0, m_buyButtonName);
        ObjectDelete(0, m_sellButtonName);
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

        ChartRedraw();   // after updating UI properties
    }

    void SetPauseBuyButtonState(bool state) {
        m_isBuyActive = state;
        if(ObjectFind(0, m_buyButtonName) >= 0) {
            ObjectSetInteger(0, m_buyButtonName, OBJPROP_STATE, m_isBuyActive);
            ObjectSetInteger(0, m_buyButtonName, OBJPROP_BGCOLOR, (m_isBuyActive ? clrGreen : clrGray));
        }
        ChartRedraw();   // after updating UI properties
    }

    void SetPauseSellButtonState(bool state) {
        m_isSellActive = state;
        if(ObjectFind(0, m_sellButtonName) >= 0) {
            ObjectSetInteger(0, m_sellButtonName, OBJPROP_STATE, m_isSellActive);
            ObjectSetInteger(0, m_sellButtonName, OBJPROP_BGCOLOR, (m_isSellActive ? clrRed : clrGray));
        }
        ChartRedraw();   // after updating UI properties
    }
};
