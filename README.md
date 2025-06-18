# Simple Car HUD - FiveM Minimap System

A comprehensive minimap and vehicle HUD system for FiveM servers that provides essential information both in and out of vehicles.

## Features

### 🗺️ **Navigation & Location**
- **Real-time street names** - Displays current street name
- **Direction indicators** - Shows cardinal directions (N, NE, E, SE, S, SW, W, NW)
- **Street indexing** - Unique street identification system
- **Always-on location display** - Works both in vehicles and on foot

### ⏰ **Time System**
- **Game time display** - Shows current in-game time
- **24-hour format** - Clean time presentation
- **Always visible** - Time is displayed regardless of vehicle state

### 🚗 **Vehicle Information (When Driving)**
- **Gear display** - Shows current transmission state (P/R/N/D)
- **Automatic gear detection** - Changes based on vehicle movement and engine state
- **Speedometer** - Real-time speed display in km/h or mph
- **Speed limit integration** - Color-coded speed warnings
- **Fuel gauge** - Shows fuel level in liters with low fuel warnings
- **Cruise control** - Toggle with CAPSLOCK key

### 🚦 **Speed Limit System**
- **Dynamic speed limits** - Automatically detects and displays current speed limits
- **Color-coded warnings**:
  - 🟢 Green - Normal speed
  - 🟡 Yellow - Warning (close to limit)
  - 🔴 Red - Over the limit
- **Integration with street data** - Pulls speed limits from street database

### 🔒 **Seatbelt System**
- **Safety warnings** - Prompts player to buckle up when driving
- **Visual indicators** - Blinking seatbelt icon
- **Audio alerts** - Sound notifications for unbuckled drivers
- **Law enforcement notifications** - Alerts police about violations
- **Quick unbuckle** - Shift + F to quickly remove seatbelt

### 🎮 **Controls**
- **CAPSLOCK** - Toggle cruise control
- **K** (default) - Toggle seatbelt
- **Shift + F** - Quick seatbelt removal

## Installation

1. **Download the files** to your server's resources folder
2. **Add to server.cfg**:
   ```
   ensure CarHUD
   ensure speedlimit
   ensure seatbelt
   ```
3. **Restart your server**

## File Structure

```
CarHUD/
├── README.md
├── fxmanifest.lua
├── client/
│   └── SimpleCarHUD_cl.lua
└── speedlimit/
    ├── fxmanifest.lua
    ├── client/
    │   └── main.lua
    ├── shared.lua
    └── html/
        └── index.html
```

## Configuration

### Basic Settings
```lua
-- Screen position (relative to minimap)
local screenPosX = 0.165
local screenPosY = 0.845

-- Speed limit warning threshold
local speedLimit = 65.0

-- Fuel warning level
local fuelWarnLimit = 6.0

-- Always show location and time
local locationAlwaysOn = true
```

### Color Customization
```lua
-- Speed colors
local speedColorUnder = {196, 196, 196}  -- Normal speed
local speedColorOver = {255, 96, 96}     -- Over limit
local speedColorUnderWarn = {242, 185, 39} -- Warning

-- Fuel colors
local fuelColorOver = {196, 196, 196}    -- Good fuel level
local fuelColorUnder = {255, 96, 96}     -- Low fuel warning
```

## Dependencies

- **FiveM Server** - Required for script execution
- **Speed Limit Module** - For dynamic speed limit detection
- **Seatbelt Module** - For safety system integration

## Compatibility

- ✅ **FiveM** - Full compatibility
- ✅ **RedM** - May require minor adjustments
- ✅ **All vehicle types** - Cars, trucks, motorcycles
- ✅ **Controller support** - Xbox/PlayStation controllers

## Features in Detail

### Navigation System
The minimap provides comprehensive navigation information:
- **Street Names**: Real-time display of current street
- **Directional Indicators**: Cardinal directions in Russian (С, СЗ, З, ЮЗ, Ю, ЮВ, В, СВ)
- **Street Indexing**: Unique numerical identifiers for each street

### Vehicle HUD
When driving, the system displays:
- **Transmission State**: Automatic detection of Park (P), Reverse (R), Neutral (N), Drive (D)
- **Speed Display**: Real-time speed with unit conversion (km/h/mph)
- **Fuel Monitoring**: Fuel level in liters with visual warnings
- **Speed Limit Integration**: Dynamic speed limit detection with color coding

### Safety Features
- **Seatbelt Warnings**: Visual and audio alerts for unbuckled drivers
- **Law Enforcement Integration**: Automatic notifications to police
- **Safety Enforcement**: Prevents vehicle exit when seatbelt is engaged

## Support

For issues, questions, or feature requests, please create an issue in the repository.

## License

This project is open source and available under the MIT License.

---

**Note**: This system is designed for Russian-speaking servers but can be easily adapted for other languages by modifying the text strings in the configuration files. 