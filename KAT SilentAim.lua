if not Drawing then
    warn("Drawing library unsupported")
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local CurrentCamera = workspace.CurrentCamera

local function GetClosest(Fov)
    local Target, Closest = nil, Fov or math.huge
    for i, v in pairs(Players:GetPlayers()) do
        if (v.Character and v ~= Player and v.Character:FindFirstChild("Head")) then
            local Position, OnScreen = CurrentCamera:WorldToScreenPoint(v.Character["Head"].Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if (Distance < Closest and OnScreen) then
                Closest = Distance
                Target = v
            end
        end
    end
    return Target
end

local Target
local circle = Drawing.new("Circle")

RunService.RenderStepped:Connect(function()
    circle.Radius = 150
    circle.Thickness = 2
    circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    circle.Transparency = 1
    circle.Color = Color3.fromRGB(255, 0, 0)
    circle.Visible = true
    circle.ZIndex = 2
    Target = GetClosest(150)
end)

local Old; Old = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Args = {...}
    if not checkcaller() and getnamecallmethod() == "FindPartOnRayWithIgnoreList" then
        if (table.find(Args[2], workspace.WorldIgnore.Ignore) and Target and Target.Character) then
            local o = Args[1].Origin
            Args[1] = Ray.new(o, Target.Character["Head"].Position - o)
        end
    end
    return Old(Self, unpack(Args))
end))