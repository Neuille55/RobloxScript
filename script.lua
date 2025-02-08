local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera

local function getClosestPlayer()
    local closest, distance = nil, math.huge
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local magnitude = (Vector2.new(screenPoint.X, screenPoint.Y) - userInputService:GetMouseLocation()).magnitude
                if magnitude < distance then
                    closest, distance = head, magnitude
                end
            end
        end
    end
    return closest
end

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 and not gameProcessed then
        local target = getClosestPlayer()
        if target then
            local targetPosition = target.Position
            local direction = (targetPosition - camera.CFrame.Position).unit
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
        end
    end
end)
