getgenv().SNS_AutoItems = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer

local function fireInteraction(target)
    if target:IsA("ClickDetector") then
        fireclickdetector(target)
    elseif target:IsA("ProximityPrompt") then
        fireproximityprompt(target)
    elseif target:IsA("BasePart") then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            firetouchinterest(root, target, 0)
            firetouchinterest(root, target, 1)
        end
    end
end

local function getElevatorFloor()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name == "ElevatorFloor" or v.Name == "LiftFloor") then
            return v
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:lower():match("elevator") or v.Name:lower():match("lift")) then
            local f = v:FindFirstChild("Floor") or v:FindFirstChild("Main") or v:FindFirstChildOfClass("BasePart")
            if f then return f end
		end
	end
	return nil
end

task.spawn(function()
    while task.wait(0.3) do
        if getgenv().SNS_AutoItems then
            pcall(function()
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if root and hum and hum.Health > 0 then
                    local targetItem = nil
                    local minDist = math.huge
                    
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") and (v.Name:lower():match("food") or v.Name:lower():match("item") or v.Name:lower():match("egg") or v.Name:lower():match("package") or v.Name:lower():match("loot")) then
                            if not v:IsDescendantOf(workspace:FindFirstChild("MainElevator") or workspace) or v.Position.Y < 500 then
                                local dist = (root.Position - v.Position).Magnitude
                                if dist < minDist and dist < 300 then
                                    minDist = dist
                                    targetItem = v
                                end
                            end
                        end
                    end
                    
                    if targetItem then
                        root.CFrame = targetItem.CFrame
                        fireInteraction(targetItem)
                        task.wait(0.1)
                        
                        local elevator = getElevatorFloor()
                        if elevator then
                            root.CFrame = elevator.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SNSGomDoOnlyGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 100)
MainFrame.Position = UDim2.new(0.5, -120, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "SNS LOOTER ONLY (TẦNG 45+)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 180, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -90, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "AUTO GOM ĐỒ: ĐANG BẬT"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().SNS_AutoItems = not getgenv().SNS_AutoItems
    if getgenv().SNS_AutoItems then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
        ToggleBtn.Text = "AUTO GOM ĐỒ: ĐANG BẬT"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        ToggleBtn.Text = "AUTO GOM ĐỒ: ĐANG TẮT"
    end
end)

local function toggleMenu(msg)
    if msg:lower() == "/speed" then MainFrame.Visible = not MainFrame.Visible end
end
player.Chatted:Connect(toggleMenu)
pcall(function()
	TextChatService.MessageReceived:Connect(function(message)
		if message.TextSource and message.TextSource.UserId == player.UserId and message.Text == "/speed" then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)
end)
