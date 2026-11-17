// somebar - dwl bar
// See LICENSE file for copyright and license details.

#pragma once
#include "common.hpp"

constexpr bool topbar = true;

constexpr int paddingX = 8;
constexpr int paddingY = 4;

// See https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
constexpr const char* font = "Hack Nerd Font 11";

// Everforest Dark Hard palette
// Inactive / Base: text #d3c6aa, background #232a2e
constexpr ColorScheme colorInactive = {Color(0xd3, 0xc6, 0xaa), Color(0x23, 0x2a, 0x2e)};
// Active Tag: text #232a2e, background #a7c080
constexpr ColorScheme colorActive = {Color(0x23, 0x2a, 0x2e), Color(0xa7, 0xc0, 0x80)};
// Occupied Tag: text #d3c6aa, background #2d353b
constexpr ColorScheme colorOccupied = {Color(0xd3, 0xc6, 0xaa), Color(0x2d, 0x35, 0x3b)};
// Empty Tag: text #7a8478, background #232a2e
constexpr ColorScheme colorEmpty = {Color(0x7a, 0x84, 0x78), Color(0x23, 0x2a, 0x2e)};
// Urgent Tag: text #232a2e, background #e67e80
constexpr ColorScheme colorUrgent = {Color(0x23, 0x2a, 0x2e), Color(0xe6, 0x7e, 0x80)};
// Layout: text #83c092, background #232a2e
constexpr ColorScheme colorLayout = {Color(0x83, 0xc0, 0x92), Color(0x23, 0x2a, 0x2e)};
// Title: text #d3c6aa, background #232a2e
constexpr ColorScheme colorTitle = {Color(0xd3, 0xc6, 0xaa), Color(0x23, 0x2a, 0x2e)};

constexpr const char* termcmd[] = {"foot", nullptr};

constexpr const char* wificmd = "/home/hysteria/.local/bin/somebar-wifi.sh";
constexpr const char* mutecmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && pkill -USR1 -f somebar-status.sh";
constexpr const char* batcmd  = "/home/hysteria/.local/bin/somebar-bat.sh";

constexpr Button buttons[] = {
	{ ClkTagBar,       BTN_LEFT,   view,       {0} },
	{ ClkTagBar,       BTN_RIGHT,  tag,        {0} },
	{ ClkTagBar,       BTN_MIDDLE, toggletag,  {0} },
	{ ClkLayoutSymbol, BTN_LEFT,   setlayout,  {.ui = 0} },
	{ ClkLayoutSymbol, BTN_RIGHT,  setlayout,  {.ui = 2} },
	{ ClkStatusWifi,   BTN_LEFT,   spawncmd,   {.v = wificmd} },
	{ ClkStatusVol,    BTN_LEFT,   spawncmd,   {.v = mutecmd} },
	{ ClkStatusBat,    BTN_LEFT,   spawncmd,   {.v = batcmd} },
};
