loadstring([[
-- LH HUB BOOSTER
-- Auto-walk in LAST movement direction
-- Stops fully reset last direction
-- Full key system + GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local CORRECT_KEY = "LhBooster1"
local DISCORD_LINK = "https://discord.gg/R5yZuWNxq"

-- Notification
local function notify(t, d)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = t,
            Text = d,
            Duration = 3
        })
    end)
end

-- Cleanup
pcall(function()
    player.PlayerGui:FindFirstChild("LH_KEY_GUI"):Destroy()
    player.PlayerGui:FindFirstChild("LH_BOOSTER_GUI"):Destroy()
end)

-- =====================
-- KEY GUI
-- =====================
local keyGui = Instance.new("ScreenGui", player.PlayerGui)
keyGui.Name = "LH_KEY_GUI"
keyGui.ResetOnSpawn = false

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.fromScale(0.45, 0.35)
frame.Position = UDim2.fromScale(0.275, 0.325)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.22)
title.BackgroundTransparency = 1
title.Text = "LH HUB BOOSTER (works in sab or escape tsunami)"
title.TextColor3 = Color3.fromRGB(170,60,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local keyBox = Instance.new("TextBox", frame)
keyBox.PlaceholderText = "Enter Key"
keyBox.Size = UDim2.fromScale(0.85, 0.18)
keyBox.Position = UDim2.fromScale(0.075, 0.28)
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,12)

local function makeButton(text, y, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.fromScale(0.85, 0.16)
    b.Position = UDim2.fromScale(0.075, y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = color
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
    return b
end

local submit = makeButton("Submit", 0.50, Color3.fromRGB(140,40,255))
local getKey = makeButton("Get Key (Discord)", 0.70, Color3.fromRGB(90,20,170))

getKey.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
        notify("Copied!", "Discord link copied to clipboard")
    end
end)

-- =====================
-- BOOSTER GUI
-- =====================
local function loadBooster()
    keyGui:Destroy()

    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "LH_BOOSTER_GUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.38, 0.28)
    main.Position = UDim2.fromScale(0.31, 0.36)
    main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

    local t = Instance.new("TextLabel", main)
    t.Size = UDim2.fromScale(1, 0.25)
    t.BackgroundTransparency = 1
    t.Text = "LH BOOSTER"
    t.TextColor3 = Color3.fromRGB(170,60,255)
    t.Font = Enum.Font.GothamBold
    t.TextScaled = true

    local speedBox = Instance.new("TextBox", main)
    speedBox.Text = "16"
    speedBox.PlaceholderText = "Speed (1 decimal)"
    speedBox.Size = UDim2.fromScale(0.85, 0.22)
    speedBox.Position = UDim2.fromScale(0.075, 0.33)
    speedBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
    speedBox.TextColor3 = Color3.new(1,1,1)
    speedBox.Font = Enum.Font.Gotham
    speedBox.TextScaled = true
    Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,12)

    local go = Instance.new("TextButton", main)
    go.Size = UDim2.fromScale(0.85, 0.22)
    go.Position = UDim2.fromScale(0.075, 0.62)
    go.Text = "Go"
    go.Font = Enum.Font.GothamBold
    go.TextScaled = true
    go.TextColor3 = Color3.new(1,1,1)
    go.BackgroundColor3 = Color3.fromRGB(140,40,255)
    Instance.new("UICorner", go).CornerRadius = UDim.new(0,14)

    local running = false
    local conn
    local lastDir = Vector3.zero

    go.MouseButton1Click:Connect(function()
        running = not running
        go.Text = running and "Stop" or "Go"

        if conn then
            conn:Disconnect()
            conn = nil
        end

        if not running then
            -- RESET LAST DIRECTION WHEN STOPPED
            lastDir = Vector3.zero
            return
        end

        conn = RunService.RenderStepped:Connect(function()
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if hum and root then
                local speed = tonumber(speedBox.Text)
                if speed then
                    speed = math.floor(speed * 10) / 10

                    local moveDir = hum.MoveDirection
                    if moveDir.Magnitude > 0 then
                        lastDir = moveDir.Unit
                    end

                    if lastDir.Magnitude > 0 then
                        root.AssemblyLinearVelocity = Vector3.new(
                            lastDir.X * speed,
                            root.AssemblyLinearVelocity.Y,
                            lastDir.Z * speed
                        )
                    end
                end
            end
        end)
    end)
end

submit.MouseButton1Click:Connect(function()
    if keyBox.Text == CORRECT_KEY then
        notify("Correct Key!", "Access granted..")
        task.wait(2)
        loadBooster()
    else
        notify("Wrong Key", "Invalid key")
    end
end)

]] )()
