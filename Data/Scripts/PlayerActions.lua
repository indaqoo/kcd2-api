PlayerActions = {}

function PlayerActions:Initialize()
    local original_OnAction = Player.OnAction

    function Player:OnAction(action, activation, value)
        -- Call the original function
        if original_OnAction then
            original_OnAction(self, action, activation, value)
        end

        if action == "jump" and activation == "press" then
            KCDAPI.EventManager:TriggerEvent("KCDAPI:Player:OnJump", self, action, activation, value)
        end

    end

    KCDAPI:Log("Player action handler registered successfully!")
end
