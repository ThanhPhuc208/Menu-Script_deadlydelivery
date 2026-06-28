-- Khởi tạo biến quản lý trạng thái Bật/Tắt của Script
getgenv().AutoFarmActive = true
getgenv().WebhookURL = ""

-- Hàm áp dụng cấu hình chạy tự động
local function applyConfig(isActive)
    if isActive then
        getgenv().ScriptConfig = {
            SellAll = true, 
            LockFoodAbove = 5000, 
            MinFoodPrice = 20, 
            FloorLimit = 45, -- ĐÃ SỬA: Nâng giới hạn cày lên Tầng 45 theo yêu cầu của bạn
            LobbySize = 1, 
            LobbyFriendsOnly = true, 
            PickupAttempts = 5, 
            InteractCooldown = 0.1, 
            StatusMenu = true, 
            HideFood = 100, 
            WaitBeforeVote = 0.1, 
            WalkSpeed = 20, 
        }
    else
        -- Khi tắt, hạ giới hạn về 0 và tăng cooldown tối đa để đóng băng hành động farm
        getgenv().ScriptConfig = {
            SellAll = false,
            LockFoodAbove = 999999,
            MinFoodPrice = 999999,
            FloorLimit = 0, 
            LobbySize = 12,
            LobbyFriendsOnly = false,
            PickupAttempts = 0,
            InteractCooldown = 999, 
            StatusMenu = false,
            HideFood = 0,
            WaitBeforeVote = 999,
            WalkSpeed = 16,
        }
    end
end

-- Kích hoạt cấu hình mặc định (Bật)
applyConfig(true)

----------------------------------------------------------------
-- GIAO DIỆN DI ĐỘNG ĐỂ BẬT/TẮT SCRIPT CŨ
----------------------------------------------------------------
local player = game:GetService("Players").LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SNSControlGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 100)
MainFrame.Position = UDim2.new(0.5, -120, 0.1, 0) -- Nằm gọn phía trên màn hình để không vướng
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
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
Title.Text = "SNS AUTOFARM CONTROL"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 180, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -90, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "AUTOFARM: ĐANG BẬT"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

-- Xử lý sự kiện bấm nút để Bật/Tắt luồng nạp cấu hình của Script gốc
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().AutoFarmActive = not getgenv().AutoFarmActive
    applyConfig(getgenv().AutoFarmActive)
    
    if getgenv().AutoFarmActive then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
        ToggleBtn.Text = "AUTOFARM: ĐANG BẬT"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        ToggleBtn.Text = "AUTOFARM: ĐANG TẮT"
        
        -- Cưỡng bức dừng hoạt ảnh đi bộ nếu nhân vật đang bị kẹt vòng lặp di chuyển
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):Move(Vector3.new(0,0,0))
            end
        end)
    end
end)

-- Gợi ý ẩn/hiện bảng điều khiển này bằng bong bóng chat
player.Chatted:Connect(function(msg)
    if msg:lower() == "/speed" then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
local TextChatService = game:GetService("TextChatService")
pcall(function()
	TextChatService.MessageReceived:Connect(function(message)
		if message.TextSource and message.TextSource.UserId == player.UserId and message.Text == "/speed" then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)
end)

-- Nạp tập lệnh thực thi gốc từ Github của SNSDARK
loadstring(game:HttpGet("https://raw.githubusercontent.com/SNSDARK/Scripts/refs/heads/main/Deadly%20Delivery.lua"))()

