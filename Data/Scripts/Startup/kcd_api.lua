KCDAPI = {
    name = "KCD API",
    version = "0.1",
    debug = false,
    EventManager = {
        listeners = {},
    },
}

-- Custom logging function without color
function KCDAPI:Log(message, ...)
    local formattedMessage = message
    if select("#", ...) > 0 then -- Ensure there are additional arguments
        local success, formatted = pcall(string.format, message, ...)
        if success then
            formattedMessage = formatted
        end
    end

    -- Log message with a simple prefix
    local logMessage = string.format("[%s] %s", self.name, formattedMessage)

    -- Check if System.LogAlways exists before calling it
    if System and System.LogAlways then
        System.LogAlways(logMessage)
    end
end

-- Function to register an event listener
function KCDAPI.EventManager:AddListener(eventName, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], callback)
    KCDAPI:Log("Listener added for event: %s (Total: %d)", eventName, #self.listeners[eventName])
end


-- Function to trigger an event
function KCDAPI.EventManager:TriggerEvent(eventName, ...)
    if self.listeners[eventName] then
        KCDAPI:Log("Triggering event: %s (Listeners: %d)", eventName, #self.listeners[eventName])
        for _, callback in ipairs(self.listeners[eventName]) do
            local success, err = pcall(callback, ...)
            if not success then
                KCDAPI:Log("Error in event %s: %s", eventName, tostring(err))
            end
        end
    else
        KCDAPI:Log("No listeners for event: %s", eventName)
    end
end

function KCDAPI:OnInit()
    System.LogAlways("Initializing KCDAPI...")  -- Debug log
    self:Log("Loading mod: %s, version: %s", self.name, self.version)

    Script.ReloadScript("Scripts/PlayerActions.lua")

    PlayerActions:Initialize()

    -- ✅ Example of global test event registration
    self.EventManager:AddListener("TestEvent", function()
        self:Log("TestEvent triggered from KCDAPI successfully!")
    end)

    self:Log("Loading finished for mod: %s", self.name)
    System.LogAlways("KCDAPI Initialization Complete!")  -- Debug log
end

-- Initialize the mod
KCDAPI:OnInit()

_G.KCDAPI = KCDAPI  -- Make it available globally
