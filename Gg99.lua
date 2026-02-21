-- GG.99 - Ultimate Edition (Tudo Ativado)
-- Versão: 3.1.0
-- By: GG Team

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- Variáveis principais
local GG = {}
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Configurações (TUDO ATIVADO)
GG.Settings = {
    Name = "GG.99",
    Version = "3.1.0",
    Prefix = ".",
    Debug = true,                      -- Agora true
    Theme = {
        Primary = Color3.fromRGB(255, 0, 140),
        Secondary = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(5, 5, 15),
        Text = Color3.fromRGB(255, 255, 255),
        Highlight = Color3.fromRGB(255, 200, 0),
        Success = Color3.fromRGB(0, 255, 0),
        Error = Color3.fromRGB(255, 0, 0),
        Warning = Color3.fromRGB(255, 150, 0)
    },
    Effects = {
        Enabled = true,                  -- Já era true
        Particles = true,                 -- Agora true
        Trails = true,                    -- Agora true
        Beams = true,                     -- Agora true
        Lighting = true                   -- Agora true
    }
}

-- Tabelas de dados
GG.Abilities = {}
GG.ActiveEffects = {}
GG.Cooldowns = {}
GG.UnlockedAbilities = {}
GG.PlayerData = {}
GG.Levels = {}
GG.Experience = {}

-- Sistema de níveis e recompensas (ATIVADO)
GG.LevelRewards = {
    [1] = {Ability = "SpeedBoost", Name = "⚡ Velocidade das Sombras"},
    [5] = {Ability = "Invisibility", Name = "👻 Espectro Noturno"},
    [10] = {Ability = "VoidJump", Name = "🦇 Salto do Vazio"},
    [15] = {Ability = "EnergyShield", Name = "🛡️ Barreira Arcana"},
    [20] = {Ability = "VoidBeam", Name = "⚡ Raio do Vazio"},
    [25] = {Ability = "TimeStop", Name = "⏰ Parada Temporal"},
    [30] = {Ability = "VoidStorm", Name = "🌪️ Tempestade do Vazio"},
    [35] = {Ability = "ShadowStep", Name = "🌑 Passo Sombrio"},
    [40] = {Ability = "VoidRift", Name = "🌀 Fenda do Vazio"},
    [45] = {Ability = "SoulSteal", Name = "💀 Roubo de Almas"},
    [50] = {Ability = "GodMode", Name = "👑 Modo Deus"}
}

-- Função auxiliar
function GG:TableFind(t, v)
    for _, val in pairs(t) do
        if val == v then return true end
    end
    return false
end

-- Criar habilidade
function GG:CreateAbility(name, data)
    local ability = {
        Name = data.Name or name,
        Description = data.Description or "",
        Cooldown = data.Cooldown or 5,
        Duration = data.Duration or 3,
        Color = data.Color or GG.Settings.Theme.Primary,
        Icon = data.Icon or "rbxassetid://3926305904",
        KeyBind = data.KeyBind,
        OnActivate = data.OnActivate or function() end,
        OnUpdate = data.OnUpdate or function() end,
        OnDeactivate = data.OnDeactivate or function() end
    }
    GG.Abilities[name] = ability
    return ability
end

-- Notificação profissional (ATIVADA)
function GG:ShowNotification(text, color, duration)
    color = color or GG.Settings.Theme.Primary
    duration = duration or 3

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GG99_Notify"
    screenGui.Parent = CoreGui
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 80)
    frame.Position = UDim2.new(0.5, -175, 0, -100)
    frame.BackgroundColor3 = GG.Settings.Theme.Background
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = color
    stroke.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 10, 0.5, -20)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://3926305904"
    icon.ImageColor3 = color
    icon.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -60, 1, 0)
    textLabel.Position = UDim2.new(0, 60, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = GG.Settings.Theme.Text
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 18
    textLabel.Parent = frame

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -175, 0, 20)
    })
    tweenIn:Play()

    task.wait(duration)

    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -175, 0, -100)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Efeito visual do vazio (ATIVADO)
function GG:CreateVoidEffect(position, color, size, duration)
    size = size or 5
    duration = duration or 3
    local part = Instance.new("Part")
    part.Size = Vector3.new(size, size, size)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.3
    part.BrickColor = BrickColor.new(color)
    part.Material = Enum.Material.Neon
    part.Shape = Enum.PartType.Ball
    part.Parent = workspace

    local tween = TweenService:Create(part, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Size = Vector3.new(size * 1.5, size * 1.5, size * 1.5),
        Transparency = 0.7
    })
    tween:Play()

    Debris:AddItem(part, duration)
    return part
end

-- Criar partículas (ATIVADO)
function GG:CreateParticles(parent, color, amount)
    local emitter = Instance.new("ParticleEmitter")
    emitter.Rate = amount or 50
    emitter.Lifetime = NumberRange.new(0.5, 1)
    emitter.SpreadAngle = Vector2.new(360, 360)
    emitter.Speed = NumberRange.new(5, 10)
    emitter.Texture = "rbxassetid://284052651"
    emitter.Color = ColorSequence.new(color)
    emitter.Parent = parent
    Debris:AddItem(emitter, 2)
    return emitter
end

-- Interface principal (igual VoidWare)
function GG:CreateGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "GG99"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    -- Botão flutuante GG
    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.new(0, 70, 0, 70)
    openBtn.Position = UDim2.new(0, 20, 1, -90)
    openBtn.BackgroundColor3 = GG.Settings.Theme.Primary
    openBtn.Text = "GG"
    openBtn.TextColor3 = Color3.new(1, 1, 1)
    openBtn.TextScaled = true
    openBtn.Font = Enum.Font.GothamBold
    openBtn.Parent = gui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = openBtn

    -- Glow no botão
    local btnGlow = Instance.new("ImageLabel")
    btnGlow.Size = UDim2.new(1, 10, 1, 10)
    btnGlow.Position = UDim2.new(0, -5, 0, -5)
    btnGlow.BackgroundTransparency = 1
    btnGlow.Image = "rbxassetid://3570695787"
    btnGlow.ImageColor3 = GG.Settings.Theme.Primary
    btnGlow.ImageTransparency = 0.7
    btnGlow.Parent = openBtn

    -- Menu principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    mainFrame.BackgroundColor3 = GG.Settings.Theme.Background
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = gui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 2
    mainStroke.Color = GG.Settings.Theme.Primary
    mainStroke.Transparency = 0.5
    mainStroke.Parent = mainFrame

    -- Gradiente de fundo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, GG.Settings.Theme.Background),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 30))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 70)
    title.BackgroundTransparency = 1
    title.Text = "GG.99 - VOIDWARE"
    title.TextColor3 = GG.Settings.Theme.Primary
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    -- Animação do título
    TweenService:Create(title, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextColor3 = GG.Settings.Theme.Secondary
    }):Play()

    -- Abas
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, -40, 0, 50)
    tabsFrame.Position = UDim2.new(0, 20, 0, 80)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = mainFrame

    local tabs = {"HABILIDADES", "ESTATÍSTICAS", "LOJA", "CONFIG"}
    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, -5, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
        btn.BackgroundColor3 = GG.Settings.Theme.Background
        btn.BackgroundTransparency = 0.5
        btn.Text = name
        btn.TextColor3 = GG.Settings.Theme.Text
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabsFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
    end

    -- Área de conteúdo
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -40, 1, -180)
    content.Position = UDim2.new(0, 20, 0, 140)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 2, 0)
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = GG.Settings.Theme.Primary
    content.Parent = mainFrame

    -- Botão fechar
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://3926305904"
    closeBtn.ImageColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    -- Abrir/fechar menu
    openBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            GG:ShowNotification("Menu GG.99 aberto", GG.Settings.Theme.Primary, 2)
        end
    end)

    -- HUD de habilidades
    local hud = Instance.new("Frame")
    hud.Size = UDim2.new(0, 400, 0, 90)
    hud.Position = UDim2.new(0.5, -200, 1, -110)
    hud.BackgroundColor3 = GG.Settings.Theme.Background
    hud.BackgroundTransparency = 0.2
    hud.BorderSizePixel = 0
    hud.Parent = gui

    local hudCorner = Instance.new("UICorner")
    hudCorner.CornerRadius = UDim.new(0, 15)
    hudCorner.Parent = hud

    local hudStroke = Instance.new("UIStroke")
    hudStroke.Thickness = 2
    hudStroke.Color = GG.Settings.Theme.Primary
    hudStroke.Transparency = 0.5
    hudStroke.Parent = hud

    -- Slots de habilidades (4 slots)
    local slotColors = {
        GG.Settings.Theme.Primary,
        Color3.fromRGB(128, 0, 128),
        GG.Settings.Theme.Secondary,
        Color3.fromRGB(0, 0, 255)
    }
    for i = 1, 4 do
        local slot = Instance.new("Frame")
        slot.Size = UDim2.new(0, 70, 0, 70)
        slot.Position = UDim2.new(0, 15 + (i-1)*100, 0.5, -35)
        slot.BackgroundColor3 = slotColors[i]
        slot.BackgroundTransparency = 0.3
        slot.Parent = hud

        local slotCorner = Instance.new("UICorner")
        slotCorner.CornerRadius = UDim.new(0, 10)
        slotCorner.Parent = slot

        local cooldown = Instance.new("Frame")
        cooldown.Name = "Cooldown"
        cooldown.Size = UDim2.new(1, 0, 0, 0)
        cooldown.Position = UDim2.new(0, 0, 1, 0)
        cooldown.BackgroundColor3 = Color3.new(0, 0, 0)
        cooldown.BackgroundTransparency = 0.5
        cooldown.Parent = slot

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(1, -10, 1, -10)
        icon.Position = UDim2.new(0, 5, 0, 5)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://3926305904"
        icon.ImageColor3 = Color3.new(1, 1, 1)
        icon.Parent = slot
    end
end

-- Função para ativar habilidade
function GG:ActivateAbility(abilityName)
    local ability = GG.Abilities[abilityName]
    if not ability then return false end

    -- Verifica cooldown
    local key = Player.UserId .. "_" .. abilityName
    if GG.Cooldowns[key] and GG.Cooldowns[key] > tick() then
        local remaining = math.ceil(GG.Cooldowns[key] - tick())
        GG:ShowNotification("⏳ Cooldown: " .. remaining .. "s", GG.Settings.Theme.Warning, 1.5)
        return false
    end

    -- Ativa habilidade
    local effect = {
        Player = Player,
        Ability = ability,
        StartTime = tick(),
        EndTime = tick() + ability.Duration
    }
    table.insert(GG.ActiveEffects, effect)
    GG.Cooldowns[key] = tick() + ability.Cooldown

    GG:ShowNotification("✨ " .. ability.Name .. " ativada!", ability.Color, 2)
    ability.OnActivate()
    return true
end

-- Inicializar todas as habilidades (TODAS ATIVADAS)
function GG:InitAbilities()
    -- Velocidade das Sombras
    GG:CreateAbility("SpeedBoost", {
        Name = "⚡ VELOCIDADE DAS SOMBRAS",
        Description = "Aumenta drasticamente sua velocidade e agilidade.",
        Cooldown = 15,
        Duration = 5,
        Color = GG.Settings.Theme.Primary,
        OnActivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 80
                char.Humanoid.JumpPower = 80
                if GG.Settings.Effects.Trails then
                    local trail = Instance.new("Trail")
                    trail.Attachment0 = char.HumanoidRootPart:FindFirstChild("RootAttachment")
                    trail.Attachment1 = char.HumanoidRootPart:FindFirstChild("RootAttachment")
                    trail.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, GG.Settings.Theme.Primary),
                        ColorSequenceKeypoint.new(1, GG.Settings.Theme.Secondary)
                    })
                    trail.Lifetime = 0.8
                    trail.Parent = char.HumanoidRootPart
                    Debris:AddItem(trail, 5)
                end
                if GG.Settings.Effects.Particles then
                    GG:CreateParticles(char.HumanoidRootPart, GG.Settings.Theme.Primary, 30)
                end
                GG:CreateVoidEffect(char.HumanoidRootPart.Position, GG.Settings.Theme.Primary, 8, 3)
            end
        end,
        OnDeactivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
                char.Humanoid.JumpPower = 50
            end
        end
    })

    -- Espectro Noturno
    GG:CreateAbility("Invisibility", {
        Name = "👻 ESPECTRO NOTURNO",
        Description = "Desapareça nas sombras, tornando-se invisível.",
        Cooldown = 20,
        Duration = 6,
        Color = Color3.fromRGB(128, 0, 128),
        OnActivate = function()
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        TweenService:Create(part, TweenInfo.new(0.5), {Transparency = 0.9}):Play()
                    end
                end
                GG:CreateVoidEffect(char.HumanoidRootPart.Position, Color3.fromRGB(128, 0, 128), 10, 3)
            end
        end,
        OnDeactivate = function()
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        TweenService:Create(part, TweenInfo.new(0.3), {Transparency = 0}):Play()
                    end
                end
            end
        end
    })

    -- Salto do Vazio
    GG:CreateAbility("VoidJump", {
        Name = "🦇 SALTO DO VAZIO",
        Description = "Salte a alturas impossíveis com poder do vazio.",
        Cooldown = 10,
        Duration = 3,
        Color = GG.Settings.Theme.Secondary,
        OnActivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 150
                char.Humanoid.UseJumpPower = true
                if GG.Settings.Effects.Particles then
                    GG:CreateParticles(char.HumanoidRootPart, GG.Settings.Theme.Secondary, 40)
                end
                GG:CreateVoidEffect(char.HumanoidRootPart.Position, GG.Settings.Theme.Secondary, 5, 2)
                for i = 1, 3 do
                    task.wait(0.1)
                    char.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
                end
            end
        end,
        OnDeactivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 50
            end
        end
    })

    -- Barreira Arcana
    GG:CreateAbility("EnergyShield", {
        Name = "🛡️ BARREIRA ARCADA",
        Description = "Cria um escudo impenetrável de energia pura.",
        Cooldown = 25,
        Duration = 8,
        Color = Color3.fromRGB(0, 0, 255),
        OnActivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local shield = Instance.new("Part")
                shield.Size = Vector3.new(15, 15, 15)
                shield.Position = hrp.Position
                shield.Anchored = false
                shield.CanCollide = false
                shield.Transparency = 0.3
                shield.BrickColor = BrickColor.new("Bright blue")
                shield.Material = Enum.Material.ForceField
                shield.Shape = Enum.PartType.Ball
                shield.Parent = workspace

                local weld = Instance.new("Weld")
                weld.Part0 = hrp
                weld.Part1 = shield
                weld.Parent = shield

                local rot = 0
                local connection = RunService.Heartbeat:Connect(function(dt)
                    if shield and shield.Parent then
                        rot = rot + dt * 3
                        shield.CFrame = hrp.CFrame * CFrame.Angles(rot, rot, rot)
                    else
                        connection:Disconnect()
                    end
                end)

                if GG.Settings.Effects.Beams then
                    local damageConn = RunService.Heartbeat:Connect(function()
                        if not shield or not shield.Parent then
                            damageConn:Disconnect()
                            return
                        end
                        for _, otherPlayer in pairs(Players:GetPlayers()) do
                            if otherPlayer ~= Player then
                                local otherChar = otherPlayer.Character
                                if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                                    local dist = (otherChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                                    if dist < 10 then
                                        local hum = otherChar:FindFirstChild("Humanoid")
                                        if hum then
                                            hum:TakeDamage(2)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    Debris:AddItem(shield, 8)
                    task.wait(8)
                    damageConn:Disconnect()
                else
                    Debris:AddItem(shield, 8)
                end
                GG:CreateVoidEffect(hrp.Position, Color3.fromRGB(0, 0, 255), 12, 3)
            end
        end
    })

    -- Raio do Vazio
    GG:CreateAbility("VoidBeam", {
        Name = "⚡ RAIO DO VAZIO",
        Description = "Dispara um poderoso raio de energia que danifica todos na frente.",
        Cooldown = 30,
        Duration = 2,
        Color = Color3.fromRGB(255, 255, 0),
        OnActivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                if GG.Settings.Effects.Beams then
                    local beam = Instance.new("Part")
                    beam.Size = Vector3.new(3, 3, 100)
                    beam.Position = hrp.Position + hrp.CFrame.LookVector * 50
                    beam.Anchored = true
                    beam.CanCollide = false
                    beam.BrickColor = BrickColor.new("Bright yellow")
                    beam.Material = Enum.Material.Neon
                    beam.Parent = workspace
                    Debris:AddItem(beam, 1)
                end

                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= Player then
                        local otherChar = otherPlayer.Character
                        if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                            local dir = (otherChar.HumanoidRootPart.Position - hrp.Position).Unit
                            local dot = hrp.CFrame.LookVector:Dot(dir)
                            if dot > 0.5 then
                                local dist = (otherChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                                if dist < 50 then
                                    local hum = otherChar:FindFirstChild("Humanoid")
                                    if hum then
                                        hum:TakeDamage(50)
                                        GG:CreateVoidEffect(otherChar.HumanoidRootPart.Position, Color3.fromRGB(255, 0, 0), 5, 2)
                                    end
                                end
                            end
                        end
                    end
                end
                GG:CreateVoidEffect(hrp.Position, Color3.fromRGB(255, 255, 0), 15, 3)
            end
        end
    })

    -- Parada Temporal
    GG:CreateAbility("TimeStop", {
        Name = "⏰ PARADA TEMPORAL",
        Description = "Pare o tempo ao seu redor, congelando outros jogadores.",
        Cooldown = 60,
        Duration = 4,
        Color = Color3.fromRGB(255, 255, 255),
        OnActivate = function()
            if GG.Settings.Effects.Lighting then
                Lighting.TimeOfDay = "00:00:00"
                Lighting.Brightness = 0.2
                Lighting.Ambient = Color3.fromRGB(100, 100, 255)
                Lighting.FogEnd = 50
                Lighting.FogColor = Color3.fromRGB(0, 0, 50)
            end

            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= Player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        local hum = otherChar:FindFirstChild("Humanoid")
                        if hum then
                            hum.WalkSpeed = 0
                            hum.JumpPower = 0
                            hum.PlatformStand = true
                        end
                        if GG.Settings.Effects.Lighting then
                            for _, part in pairs(otherChar:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.BrickColor = BrickColor.new("Medium blue")
                                    part.Material = Enum.Material.Ice
                                end
                            end
                        end
                    end
                end
            end
            GG:CreateVoidEffect(Player.Character.HumanoidRootPart.Position, Color3.fromRGB(255, 255, 255), 30, 4)
        end,
        OnDeactivate = function()
            if GG.Settings.Effects.Lighting then
                Lighting.TimeOfDay = "14:00:00"
                Lighting.Brightness = 1
                Lighting.Ambient = Color3.fromRGB(128, 128, 128)
                Lighting.FogEnd = 100000
                Lighting.FogColor = Color3.fromRGB(128, 128, 128)
            end
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= Player then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        local hum = otherChar:FindFirstChild("Humanoid")
                        if hum then
                            hum.WalkSpeed = 16
                            hum.JumpPower = 50
                            hum.PlatformStand = false
                        end
                        if GG.Settings.Effects.Lighting then
                            for _, part in pairs(otherChar:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.BrickColor = BrickColor.new("Medium stone grey")
                                    part.Material = Enum.Material.Plastic
                                end
                            end
                        end
                    end
                end
            end
        end
    })

    -- Tempestade do Vazio (extra)
    GG:CreateAbility("VoidStorm", {
        Name = "🌪️ TEMPESTADE DO VAZIO",
        Description = "Invoca uma tempestade de energia que danifica todos ao redor.",
        Cooldown = 45,
        Duration = 6,
        Color = Color3.fromRGB(150, 0, 150),
        OnActivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                for i = 1, 20 do
                    local angle = (i / 20) * math.pi * 2
                    local pos = hrp.Position + Vector3.new(math.cos(angle) * 20, 0, math.sin(angle) * 20)
                    GG:CreateVoidEffect(pos, Color3.fromRGB(150, 0, 150), 3, 2)
                end
                local stormConn = RunService.Heartbeat:Connect(function()
                    for _, otherPlayer in pairs(Players:GetPlayers()) do
                        if otherPlayer ~= Player then
                            local otherChar = otherPlayer.Character
                            if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                                local dist = (otherChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                                if dist < 25 then
                                    local hum = otherChar:FindFirstChild("Humanoid")
                                    if hum then
                                        hum:TakeDamage(5)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(6)
                stormConn:Disconnect()
            end
        end
    })

    -- Passo Sombrio
    GG:CreateAbility("ShadowStep", {
        Name = "🌑 PASSO SOMBRIO",
        Description = "Teletransporta-se para a posição do mouse.",
        Cooldown = 15,
        Duration = 1,
        Color = Color3.fromRGB(50, 50, 50),
        OnActivate = function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local target = Mouse.Hit.p
                local oldPos = char.HumanoidRootPart.Position
                char:SetPrimaryPartCFrame(CFrame.new(target))
                GG:CreateVoidEffect(oldPos, Color3.fromRGB(50, 50, 50), 8, 2)
                GG:CreateVoidEffect(target, Color3.fromRGB(50, 50, 50), 8, 2)
            end
        end
    })
end

-- Loop de atualização dos efeitos
function GG:UpdateLoop()
    task.spawn(function()
        while true do
            task.wait(0.1)
            for i = #GG.ActiveEffects, 1, -1 do
                local eff = GG.ActiveEffects[i]
                if tick() >= eff.EndTime then
                    eff.Ability.OnDeactivate()
                    table.remove(GG.ActiveEffects, i)
                else
                    eff.Ability.OnUpdate()
                end
            end
        end
    end)
end

-- Sistema de comandos no chat
function GG:SetupCommands()
    Player.Chatted:Connect(function(msg)
        if string.sub(msg, 1, 1) == GG.Settings.Prefix then
            local cmd = string.lower(string.split(msg, " ")[1])
            if cmd == ".gg" or cmd == ".menu" then
                local gui = CoreGui:FindFirstChild("GG99")
                if gui then
                    local main = gui:FindFirstChild("MainFrame")
                    if main then main.Visible = not main.Visible end
                end
            elseif cmd == ".speed" then
                GG:ActivateAbility("SpeedBoost")
            elseif cmd == ".invis" then
                GG:ActivateAbility("Invisibility")
            elseif cmd == ".jump" then
                GG:ActivateAbility("VoidJump")
            elseif cmd == ".shield" then
                GG:ActivateAbility("EnergyShield")
            elseif cmd == ".beam" then
                GG:ActivateAbility("VoidBeam")
            elseif cmd == ".time" then
                GG:ActivateAbility("TimeStop")
            elseif cmd == ".storm" then
                GG:ActivateAbility("VoidStorm")
            elseif cmd == ".shadow" then
                GG:ActivateAbility("ShadowStep")
            elseif cmd == ".help" then
                GG:ShowNotification("Comandos: .gg, .speed, .invis, .jump, .shield, .beam, .time, .storm, .shadow", GG.Settings.Theme.Text, 5)
            elseif GG.Settings.Debug then
                print("[GG.99] Comando não reconhecido:", cmd)
            end
        end
    end)
end

-- Inicialização
function GG:Init()
    print("=" .. string.rep("=", 50))
    print("🚀 GG.99 - Ultimate Edition v" .. GG.Settings.Version)
    print("📅 Status: CARREGADO COM SUCESSO (Tudo Ativado)")
    print("=" .. string.rep("=", 50))

    GG:InitAbilities()
    GG:CreateGUI()
    GG:SetupCommands()
    GG:UpdateLoop()
    GG:ShowNotification("GG.99 carregado! Use .gg", GG.Settings.Theme.Primary, 4)
end

-- Executar
GG:Init()
