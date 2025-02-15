PlayerActions = {}

function PlayerActions:Initialize()
    local original_OnAction = Player.OnAction

    function Player:OnAction(action, activation, value)
        -- Call the original function
        if original_OnAction then
            original_OnAction(self, action, activation, value)
        end

        KCDAPI.EventManager.TriggerEvent("Player:OnAction", self, action, activation, value)

        -- Trigger a specific event for jump actions
        if action == "jump" and activation == "press" then
            KCDAPI.EventManager.TriggerEvent("Player:OnJump", self, action, activation, value)
        end
    end

    -- Log success
    KCDAPI.Log("Player action handler registered successfully!")
end