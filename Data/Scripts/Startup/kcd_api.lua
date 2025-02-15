KCDAPI = {
    name = "KCD API",
    version = "0.1",
    debug = false,
    EventManager = {
        listeners = {},
    },
}

function KCDAPI.Log(message, ...)
    local formattedMessage = message
    if select("#", ...) > 0 then 
        local success, formatted = pcall(string.format, message, ...)
        if success then
            formattedMessage = formatted
        end
    end

    local logMessage = string.format("[%s] %s", KCDAPI.name, formattedMessage)

    if System and System.LogAlways then
        System.LogAlways(logMessage)
    end
end

-- Function to register an event listener
function KCDAPI.EventManager.AddListener(eventName, callback)
    if not KCDAPI.EventManager.listeners[eventName] then
        KCDAPI.EventManager.listeners[eventName] = {}
    end
    table.insert(KCDAPI.EventManager.listeners[eventName], callback)
    KCDAPI.Log("Listener added for event: %s (Total: %d)", eventName, #KCDAPI.EventManager.listeners[eventName])
end

-- Function to trigger an event
function KCDAPI.EventManager.TriggerEvent(eventName, ...)
    if KCDAPI.EventManager.listeners[eventName] then
        KCDAPI.Log("Triggering event: %s (Listeners: %d)", eventName, #KCDAPI.EventManager.listeners[eventName])
        for _, callback in ipairs(KCDAPI.EventManager.listeners[eventName]) do
            local success, err = pcall(callback, ...)
            if not success then
                KCDAPI.Log("Error in event %s: %s", eventName, tostring(err))
            end
        end
    else
        KCDAPI.Log("No listeners for event: %s", eventName)
    end
end

-- Initialize the mod
function KCDAPI.OnInit()
    System.LogAlways("Initializing KCDAPI...")    
    KCDAPI.Log("Loading mod: %s, version: %s", KCDAPI.name, KCDAPI.version)

    Script.ReloadScript("Scripts/PlayerActions.lua")

    PlayerActions.Initialize()

    System.LogAlways("KCDAPI Initialization Complete!")
end

-- Initialize the mod
KCDAPI.OnInit()