require "WeightSettingsGlobal.lua"

WeightSettings.logger = {}


WeightSettings.logger.debugLevel   = -1
WeightSettings.logger.logLevel     =  0
WeightSettings.logger.infoLevel    =  1
WeightSettings.logger.warningLevel =  2
WeightSettings.logger.errorLevel   =  3

WeightSettings.logger.levelNames = {
    [WeightSettings.logger.errorLevel]   = "Error",
    [WeightSettings.logger.warningLevel] = "Warning",
    [WeightSettings.logger.infoLevel]    = "Info",
    [WeightSettings.logger.logLevel]     = "Log",
    [WeightSettings.logger.debugLevel]   = "Debug",
}


WeightSettings.logger.currentLevel = WeightSettings.logger.logLevel


WeightSettings.logger.isLevelEnabled = function(level)
    if WeightSettings.logger.currentLevel <= level then
        return true
    end

    return false
end


WeightSettings.logger.isErrorEnabled = function()
    return WeightSettings.logger.isLevelEnabled(WeightSettings.logger.errorLevel)
end


WeightSettings.logger.isWarningEnabled = function()
    return WeightSettings.logger.isLevelEnabled(WeightSettings.logger.warningLevel)
end


WeightSettings.logger.isInfoEnabled = function()
    return WeightSettings.logger.isLevelEnabled(WeightSettings.logger.infoLevel)
end


WeightSettings.logger.isLogEnabled = function()
    return WeightSettings.logger.isLevelEnabled(WeightSettings.logger.logLevel)
end


WeightSettings.logger.isDebugEnabled = function()
    return WeightSettings.logger.isLevelEnabled(WeightSettings.logger.debugLevel)
end


WeightSettings.logger.print = function(level, fmt, ...)
    if WeightSettings.logger.isLevelEnabled(level) then
        print("WeightSettings[" .. WeightSettings.logger.levelNames[level] .. "]: " .. string.format(fmt, ...))
    end
end


WeightSettings.logger.error = function(fmt, ...)
    WeightSettings.logger.print(WeightSettings.logger.errorLevel, fmt, ...)
end


WeightSettings.logger.warning = function(fmt, ...)
    WeightSettings.logger.print(WeightSettings.logger.warningLevel, fmt, ...)
end


WeightSettings.logger.info = function(fmt, ...)
    WeightSettings.logger.print(WeightSettings.logger.infoLevel, fmt, ...)
end


WeightSettings.logger.log = function(fmt, ...)
    WeightSettings.logger.print(WeightSettings.logger.logLevel, fmt, ...)
end


WeightSettings.logger.debug = function(fmt, ...)
    WeightSettings.logger.print(WeightSettings.logger.debugLevel, fmt, ...)
end
