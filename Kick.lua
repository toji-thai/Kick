local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- พิกัดจุดเริ่มต้น (จุดที่จะวาร์ปกลับมา)
local startPos = CFrame.new(696, 3, 240)

-- 1. ระบบเดินและเช็คขอบเขต (Boundary Check)
RunService.RenderStepped:Connect(function()
    if humanoid and rootPart then
        -- สั่งให้เดินตรงไปข้างหน้าตลอดเวลา
        humanoid:Move(Vector3.new(0, 0, -1), true)
        
        -- เช็คว่าออกนอกเขตหรือไม่ (ถ้า X เกิน 708 หรือ Z เกิน 290)
        local currentPos = rootPart.Position
        if currentPos.X > 708 or currentPos.Z > 290 then
            rootPart.CFrame = startPos
            print("ออกนอกเขต! วาร์ปกลับจุดเริ่มต้น")
        end
    end
end)

-- 2. ลูปสำหรับรัน Remote Event ทุกๆ 1 วินาที
task.spawn(function()
    while true do
        local networkPath = game:GetService("ReplicatedStorage")
            :WaitForChild("Shared")
            :WaitForChild("Packages")
            :WaitForChild("Network")
            :WaitForChild("rev_KickEvent")

        if networkPath then
            -- ส่งอาร์กิวเมนต์ตามที่คุณกำหนด
            networkPath:FireServer(0.9527527689933777)
        end
        
        task.wait(1.5)
    end
end)
