-- GG.99 - VoidWare Ultimate Edition
-- By: GG Team
-- Versão: 2.0.0

local GG = {}
GG.__index = GG

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

-- Configurações
GG.Settings = {
    Name = "GG.99",
    Version = "2.0.0",
    Prefix = ".",
    Debug = false,
    
    -- Cores do tema (igual VoidWare)
    Theme = {
        Primary = Color3.fromRGB(255, 0, 140),
        Secondary = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(10, 10, 20),
        Text = Color3.fromRGB(255, 255, 255),
        Highlight = Color3.fromRGB(255, 200, 0)
    }
}

-- Sistema de níveis e experiência
GG.Levels = {}
GG.Experience = {}
GG.LevelRewards = {
    [1] = {Ability = "SpeedBoost", Name = "Velocidade das Sombras"},
    [5] = {Ability = "Invisibility", Name = "Espectro Noturno"},
    [10] = {Ability = "VoidJump", Name = "Salto do Vazio"},
    [15] = {Ability = "EnergyShield", Name = "Barreira Arcana"},
    [20] = {Ability = "VoidBeam", Name = "Raio do Vazio"},
    [25] = {Ability = "TimeStop", Name = "Parada Temporal"},
    [30] = {Ability = "VoidStorm", Name = "Tempestade do Vazio"}
}

-- Habilidades
GG.Abilities = {}
GG.ActiveEffects = {}
GG.Cooldowns = {}
GG.PlayerData = {}

-- Sistema de GUI
function GG:CreateMainGUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GG99_Main"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal (igual VoidWare)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = GG.Settings.Theme.Background
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    -- Efeito de vidro
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = GG.Settings.Theme.Primary
    stroke.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "GG.99 - VOIDWARE"
    title.TextColor3 = GG.Settings.Theme.Primary
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Abas
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "Tabs"
    tabsFrame.Size = UDim2.new(1, 0, 0, 40)
    tabsFrame.Position = UDim2.new(0, 0, 0, 50)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = mainFrame
    
    local abilitiesTab = GG:CreateTab("HABILIDADES", UDim2.new(0, 0, 0, 0), tabsFrame)
    local statsTab = GG:CreateTab("ESTATÍSTICAS", UDim2.new(0, 133, 0, 0), tabsFrame)
    local settingsTab = GG:CreateTab("CONFIG", UDim2.new(0, 266, 0, 0), tabsFrame)
    
    -- Conteúdo das abas
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -120)
    contentFrame.Position = UDim2.new(0, 10, 0, 100)
    contentFrame.BackgroundTransparency = 1
    contentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    contentFrame.ScrollBarThickness = 5
    contentFrame.ScrollBarImageColor3 = GG.Settings.Theme.Primary
    contentFrame.Parent = mainFrame
    
    -- Botão de fechar
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://3926305904"
    closeBtn.ImageColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Parent = mainFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    
    -- Botão de abrir (na tela)
    local openBtn = Instance.new("TextButton")
    openBtn.Name = "OpenBtn"
    openBtn.Size = UDim2.new(0, 50, 0, 50)
    openBtn.Position = UDim2.new(0, 20, 1, -70)
    openBtn.BackgroundColor3 = GG.Settings.Theme.Primary
    openBtn.Text = "GG"
    openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    openBtn.TextScaled = true
    openBtn.Font = Enum.Font.GothamBold
    openBtn.Parent = screenGui
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = openBtn
    
    openBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    
    -- HUD de habilidades
    GG:CreateAbilityHUD(player, screenGui)
    
    return screenGui
end

function GG:CreateTab(text, position, parent)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 133, 1, 0)
    tab.Position = position
    tab.BackgroundTransparency = 1
    tab.Text = text
    tab.TextColor3 = GG.Settings.Theme.Text
    tab.TextScaled = true
    tab.Font = Enum.Font.Gotham
    tab.Parent = parent
    
    tab.MouseButton1Click:Connect(function()
        -- Aqui vai a lógica de trocar abas
    end)
    
    return tab
end

function GG:CreateAbilityHUD(player, parent)
    local hud = Instance.new("Frame")
    hud.Name = "AbilityHUD"
    hud.Size = UDim2.new(0, 300, 0, 80)
    hud.Position = UDim2.new(0.5, -150, 1, -100)
    hud.BackgroundTransparency = 0.5
    hud.BackgroundColor3 = GG.Settings.Theme.Background
    hud.Parent = parent
    
    local hudCorner = Instance.new("UICorner")
    hudCorner.CornerRadius = UDim.new(0, 10)
    hudCorner.Parent = hud
    
    -- Slots de habilidades
    local slots = {}
    local slotPositions = {0, 75, 150, 225}
    
    for i = 1, 4 do
        local slot = Instance.new("Frame")
        slot.Name = "Slot" .. i
        slot.Size = UDim2.new(0, 60, 0, 60)
        slot.Position = UDim2.new(0, slotPositions[i] + 10, 0.5, -30)
        slot.BackgroundColor3 = GG.Settings.Theme.Primary
        slot.BackgroundTransparency = 0.7
        slot.Parent = hud
        
        local slotCorner = Instance.new("UICorner")
        slotCorner.CornerRadius = UDim.new(0, 8)
        slotCorner.Parent = slot
        
        local cooldown = Instance.new("Frame")
        cooldown.Name = "Cooldown"
        cooldown.Size = UDim2.new(1, 0, 0, 0)
        cooldown.Position = UDim2.new(0, 0, 1, 0)
        cooldown.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        cooldown.BackgroundTransparency = 0.5
        cooldown.Parent = slot
        
        slots[i] = {
            Frame = slot,
            Cooldown = cooldown
        }
    end
    
    return hud
end

-- Sistema de efeitos visuais avançados
function GG:CreateVoidEffect(position, color, size)
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(size, size, size)
    effect.Position = position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.3
    effect.BrickColor = BrickColor.new(color)
    effect.Material = Enum.Material.Neon
    effect.Shape = Enum.PartType.Ball
    effect.Parent = workspace
    
    -- Efeito de pulsação
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    )
    
    local tween = TweenService:Create(effect, tweenInfo, {
        Size = Vector3.new(size * 1.5, size * 1.5, size * 1.5),
        Transparency = 0.8
    })
    
    tween:Play()
    
    Debris:AddItem(effect, 2)
    return effect
end

-- Habilidades especiais (estilo VoidWare)
function GG:InitializeAbilities()
    -- Habilidade 1: Velocidade das Sombras
    self:CreateAbility("SpeedBoost", {
        Name = "⚡ VELOCIDADE DAS SOMBRAS",
        Description = "Seus movimentos se tornam tão rápidos quanto a escuridão",
        Cooldown = 15,
        Duration = 5,
        Color = Color3.fromRGB(255, 0, 140),
        Icon = "rbxassetid://3926305904",
        OnActivate = function(player)
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Efeito visual
                    GG:CreateVoidEffect(character.HumanoidRootPart.Position, Color3.fromRGB(255, 0, 140), 5)
                    
                    -- Boost de velocidade
                    humanoid.WalkSpeed = 80
                    humanoid.JumpPower = 70
                    
                    -- Trail effect
                    local trail = Instance.new("Trail")
                    trail.Attachment0 = character.HumanoidRootPart:FindFirstChild("RootAttachment")
                    trail.Attachment1 = character.HumanoidRootPart:FindFirstChild("RootAttachment")
                    trail.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 140)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
                    })
                    trail.Lifetime = 0.5
                    trail.Parent = character.HumanoidRootPart
                    
                    Debris:AddItem(trail, 5)
                    
                    GG:ShowNotification(player, "⚡ VELOCIDADE DAS SOMBRAS ATIVADA!", Color3.fromRGB(255, 0, 140))
                end
            end
        end,
        OnDeactivate = function(player)
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
        end
    })
    
    -- Habilidade 2: Espectro Noturno (Invisibilidade melhorada)
    self:CreateAbility("Invisibility", {
        Name = "👻 ESPECTRO NOTURNO",
        Description = "Desapareça nas sombras, tornando-se quase intocável",
        Cooldown = 20,
        Duration = 6,
        Color = Color3.fromRGB(128, 0, 128),
        Icon = "rbxassetid://3926305904",
        OnActivate = function(player)
            local character = player.Character
            if character then
                -- Efeito de fade out
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        local tween = TweenService:Create(part, TweenInfo.new(0.5), {
                            Transparency = 0.9
                        })
                        tween:Play()
                    end
                end
                
                -- Efeito de sombra
                GG:CreateVoidEffect(character.HumanoidRootPart.Position, Color3.fromRGB(128, 0, 128), 8)
                GG:ShowNotification(player, "👻 ESPECTRO NOTURNO ATIVADO!", Color3.fromRGB(128, 0, 128))
            end
        end,
        OnDeactivate = function(player)
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local tween = TweenService:Create(part, TweenInfo.new(0.3), {
                            Transparency = 0
                        })
                        tween:Play()
                    end
                end
            end
        end
    })
    
    -- Habilidade 3: Salto do Vazio
    self:CreateAbility("VoidJump", {
        Name = "🦇 SALTO DO VAZIO",
        Description = "Salte através do vazio, alcançando alturas inimagináveis",
        Cooldown = 10,
        Duration = 3,
        Color = Color3.fromRGB(0, 255, 255),
        Icon = "rbxassetid://3926305904",
        OnActivate = function(player)
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 150
                    humanoid.UseJumpPower = true
                    
                    -- Efeito de asas
                    GG:CreateVoidEffect(character.HumanoidRootPart.Position, Color3.fromRGB(0, 255, 255), 3)
                    GG:ShowNotification(player, "🦇 SALTO DO VAZIO ATIVADO!", Color3.fromRGB(0, 255, 255))
                end
            end
        end,
        OnDeactivate = function(player)
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                end
            end
        end
    })
    
    -- Habilidade 4: Barreira Arcana
    self:CreateAbility("EnergyShield", {
        Name = "🛡️ BARREIRA ARCADA",
        Description = "Crie uma barreira de energia pura que te protege de danos",
        Cooldown = 25,
        Duration = 8,
        Color = Color3.fromRGB(0, 0, 255),
        Icon = "rbxassetid://3926305904",
        OnActivate = function(player)
            local character = player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Escudo esférico
                    local shield = Instance.new("Part")
                    shield.Size = Vector3.new(12, 12, 12)
                    shield.Position = hrp.Position
                    shield.Anchored = false
                    shield.CanCollide = false
                    shield.Transparency = 0.4
                    shield.BrickColor = BrickColor.new("Bright blue")
                    shield.Material = Enum.Material.ForceField
                    shield.Shape = Enum.PartType.Ball
                    shield.Parent = workspace
                    
                    local weld = Instance.new("Weld")
                    weld.Part0 = hrp
                    weld.Part1 = shield
                    weld.C0 = CFrame.new(0, 0, 0)
                    weld.Parent = shield
                    
                    -- Efeito de rotação
                    local rotation = 0
                    local connection
                    connection = RunService.Heartbeat:Connect(function(dt)
                        if shield and shield.Parent then
                            rotation = rotation + dt * 2
                            shield.CFrame = hrp.CFrame * CFrame.Angles(rotation, rotation, rotation)
                        else
                            connection:Disconnect()
                        end
                    end)
                    
                    Debris:AddItem(shield, 8)
                    GG:ShowNotification(player, "🛡️ BARREIRA ARCADA ATIVADA!", Color3.fromRGB(0, 0, 255))
                end
            end
        end
    })
    
    -- Habilidade 5: Raio do Vazio
    self:CreateAbility("VoidBeam", {
        Name = "⚡ RAIO DO VAZIO",
        Description = "Dispara um poderoso raio de energia do vazio",
        Cooldown = 30,
        Duration = 2,
        Color = Color3.fromRGB(255, 255, 0),
        Icon = "rbxassetid://3926305904",
        OnActivate = function(player)
            local character = player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Cria o raio
                    local beam = Instance.new("Part")
                    beam.Size = Vector3.new(2, 2, 100)
                    beam.Position = hrp.Position + hrp.CFrame.LookVector * 50
                    beam.Anchored = true
                    beam.CanCollide = false
                    beam.BrickColor = BrickColor.new("Bright yellow")
                    beam.Material = Enum.Material.Neon
                    beam.Parent = workspace
                    
                    -- Efeito de dano em área
                    for _, otherPlayer in pairs(Players:GetPlayers()) do
                        if otherPlayer ~= player then
                            local otherChar = otherPlayer.Character
                            if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                                local distance = (otherChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                                if distance < 30 then
                                    local humanoid = otherChar:FindFirstChild("Humanoid")
                                    if humanoid then
                                        humanoid:TakeDamage(30)
                                    end
                                end
                            end
                        end
                    end
                    
                    GG:CreateVoidEffect(hrp.Position, Color3.fromRGB(255, 255, 0), 10)
                    GG:ShowNotification(player, "⚡ RAIO DO VAZIO!", Color3.fromRGB(255, 255, 0))
                    
                    Debris:AddItem(beam, 1)
                end
            end
        end
    })
    
    -- Habilidade 6: Parada Temporal
    self:CreateAbility("TimeStop", {
        Name = "⏰ PARADA TEMPORAL",
        Description = "Pare o tempo ao seu redor por alguns segundos",
        Cooldown = 60,
        Duration = 3,
        Color = Color3.fromRGB(255, 255, 255),
        Icon = "rbxassetid://3926305904",
        OnActivate = function(player)
            -- Efeito visual de parada
            Lighting.TimeOfDay = "00:00:00"
            Lighting.Brightness = 0.2
            Lighting.Ambient = Color3.fromRGB(100, 100, 255)
            
            -- Congela outros jogadores
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        local humanoid = otherChar:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 0
                            humanoid.JumpPower = 0
                        end
                    end
                end
            end
            
            GG:CreateVoidEffect(player.Character.HumanoidRootPart.Position, Color3.fromRGB(255, 255, 255), 20)
            GG:ShowNotification(player, "⏰ PARADA TEMPORAL!", Color3.fromRGB(255, 255, 255))
        end,
        OnDeactivate = function(player)
            -- Restaura o tempo
            Lighting.TimeOfDay = "14:00:00"
            Lighting.Brightness = 1
            
            -- Descongela outros jogadores
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        local humanoid = otherChar:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 16
                            humanoid.JumpPower = 50
                        end
                    end
                end
            end
        end
    })
end

-- Sistema de notificações
function GG:ShowNotification(player, text, color)
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0, -50)
    notification.BackgroundColor3 = GG.Settings.Theme.Background
    notification.BackgroundTransparency = 0.2
    notification.Parent = playerGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Thickness = 2
    notifStroke.Color = color or GG.Settings.Theme.Primary
    notifStroke.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = color or GG.Settings.Theme.Text
    notifText.TextScaled = true
    notifText.Font = Enum.Font.GothamBold
    notifText.Parent = notification
    
    -- Animação de entrada
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(0.5, -150, 0, 50)
    })
    tweenIn:Play()
    
    -- Remove após 3 segundos
    task.wait(3)
    
    local tweenOut = TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(0.5, -150, 0, -50)
    })
    tweenOut:Play()
    
    tweenOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- Sistema de níveis
function GG:AddExperience(player, amount)
    local userId = player.UserId
    self.Experience[userId] = (self.Experience[userId] or 0) + amount
    
    local currentXP = self.Experience[userId]
    local currentLevel = self.Levels[userId] or 1
    local nextLevelXP = currentLevel * 100
    
    if currentXP >= nextLevelXP then
        self:LevelUp(player)
    end
end

function GG:LevelUp(player)
    local userId = player.UserId
    self.Levels[userId] = (self.Levels[userId] or 1) + 1
    local newLevel = self.Levels[userId]
    
    -- Mostra efeito de level up
    GG:CreateVoidEffect(player.Character.HumanoidRootPart.Position, GG.Settings.Theme.Highlight, 15)
    GG:ShowNotification(player, "⬆️ LEVEL UP! Nível " .. newLevel, GG.Settings.Theme.Highlight)
    
    -- Recompensa de nível
    if self.LevelRewards[newLevel] then
        local reward = self.LevelRewards[newLevel]
        GG:ShowNotification(player, "🎁 Nova habilidade: " .. reward.Name, GG.Settings.Theme.Primary)
    end
end

-- Sistema de comandos
function GG:SetupCommands()
    Players.PlayerAdded:Connect(function(player)
        -- Inicializa dados do jogador
        self.PlayerData[player.UserId] = {
            Level = 1,
            Experience = 0,
            UnlockedAbilities = {"SpeedBoost", "Invisibility"}
        }
        
        -- Cria GUI
        self:CreateMainGUI(player)
        
        -- Sistema de chat
        player.Chatted:Connect(function(message)
            if string.sub(message, 1, 1) == self.Settings.Prefix then
                local args = string.split(string.lower(message), " ")
                local command = args[1]
                
                if command == ".gg" or command == ".menu" then
                    local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("GG99_Main")
                    if gui then
                        gui.MainFrame.Visible = not gui.MainFrame.Visible
                    end
                    
                elseif command == ".speed" then
                    self:ActivateAbility(player, "SpeedBoost")
                    
                elseif command == ".invis" then
                    self:ActivateAbility(player, "Invisibility")
                    
                elseif command == ".jump" then
                    self:ActivateAbility(player, "VoidJump")
                    
                elseif command == ".shield" then
                    self:ActivateAbility(player, "EnergyShield")
                    
                elseif command == ".beam" then
                    self:ActivateAbility(player, "VoidBeam")
                    
                elseif command == ".time" then
                    self:ActivateAbility(player, "TimeStop")
                    
                elseif command == ".level" then
                    local level = self.Levels[player.UserId] or 1
                    local xp = self.Experience[player.UserId] or 0
                    local nextXP = level * 100
                    
                    GG:ShowNotification(player, 
                        string.format("Nível %d | XP: %d/%d", level, xp, nextXP), 
                        GG.Settings.Theme.Highlight
                    )
                end
            end
        end)
    end)
end

-- Função principal de ativação
function GG:ActivateAbility(player, abilityName)
    local ability = self.Abilities[abilityName]
    if not ability then return false end
    
    -- Verifica cooldown
    local key = player.UserId .. "_" .. abilityName
    if self.Cooldowns[key] and self.Cooldowns[key] > tick() then
        local remaining = math.ceil(self.Cooldowns[key] - tick())
        GG:ShowNotification(player, "⏳ Cooldown: " .. remaining .. "s", Color3.fromRGB(255, 0, 0))
        return false
    end
    
    -- Verifica se tem a habilidade desbloqueada
    local playerData = self.PlayerData[player.UserId]
    if playerData and not table.find(playerData.UnlockedAbilities, abilityName) then
        GG:ShowNotification(player, "❌ Habilidade não desbloqueada!", Color3.fromRGB(255, 0, 0))
        return false
    end
    
    -- Ativa a habilidade
    local effect = {
        Player = player,
        Ability = ability,
        StartTime = tick(),
        EndTime = tick() + ability.Duration
    }
    
    table.insert(self.ActiveEffects, effect)
    self.Cooldowns[key] = tick() + ability.Cooldown
    
    -- Chama função de ativação
    ability.OnActivate(player)
    
    -- Adiciona experiência por usar habilidade
    self:AddExperience(player, 10)
    
    return true
end

-- Sistema de atualização
function GG:UpdateLoop()
    while true do
        task.wait(0.1)
        
        -- Atualiza efeitos ativos
        for i = #self.ActiveEffects, 1, -1 do
            local effect = self.ActiveEffects[i]
            
            if tick() >= effect.EndTime then
                effect.Ability.OnDeactivate(effect.Player)
                table.remove(self.ActiveEffects, i)
            else
                effect.Ability.OnUpdate(effect.Player)
            end
        end
    end
end

-- Inicialização
function GG:Init()
    print("=" .. string.rep("=", 50))
    print("🚀 GG.99 - VoidWare Ultimate Edition v" .. self.Settings.Version)
    print("📅 Criado por: GG Team")
    print("🎮 Status: CARREGADO COM SUCESSO!")
    print("=" .. string.rep("=", 50))
    
    self:InitializeAbilities()
    self:SetupCommands()
    self:UpdateLoop()
end

-- Executa
GG:Init()

return GG
