local ESX = nil
local QBCore = nil
local PlayerData = {}
local blanchisseurPed = nil
local isNearPed = false
local blanchimentMenu = RageUI.CreateMenu(Config.Texts.menuTitle, Config.Texts.menuSubtitle)
local montantABlanchir = 0
local processing = false
local currentPosition = 2 -- Position initiale (index dans Config.MovementZone.positions)
local lastPositionChange = 0 -- Timestamp du dernier changement de position
local nextChangeTime = 0 -- Timestamp du prochain changement de position

-- Initialisation du framework
CreateThread(function()
    if Config.Framework == "esx" then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(0)
        end
        
        while ESX.GetPlayerData().job == nil do
            Wait(10)
        end
        
        PlayerData = ESX.GetPlayerData()
        
        RegisterNetEvent('esx:playerLoaded')
        AddEventHandler('esx:playerLoaded', function(xPlayer)
            PlayerData = xPlayer
        end)
        
        RegisterNetEvent('esx:setJob')
        AddEventHandler('esx:setJob', function(job)
            PlayerData.job = job
        end)
    elseif Config.Framework == "qbcore" then
        QBCore = exports['qb-core']:GetCoreObject()
        
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
        AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
            PlayerData = QBCore.Functions.GetPlayerData()
        end)
        
        RegisterNetEvent('QBCore:Client:OnJobUpdate')
        AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
            PlayerData.job = job
        end)
    end
    
    -- Création du PNJ à la position initiale
    CreateBlanchisseurPed(2) -- L'index 2 correspond à la position initiale dans notre configuration
    
    -- Démarrer le thread de déplacement
    StartPedMovementThread()
end)

-- Création du PNJ à la position spécifiée
function CreateBlanchisseurPed(positionIndex)
    -- Supprimer l'ancien PNJ s'il existe
    if DoesEntityExist(blanchisseurPed) then
        DeleteEntity(blanchisseurPed)
    end

    -- Chargement du modèle
    local pedModel = GetHashKey(Config.PedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end
    
    -- Déterminer la position
    local position = Config.MovementZone.positions[positionIndex]
    
    -- Création du PNJ
    blanchisseurPed = CreatePed(4, pedModel, position.x, position.y, position.z, position.h, false, true)
    SetEntityHeading(blanchisseurPed, position.h)
    FreezeEntityPosition(blanchisseurPed, true)
    SetEntityInvincible(blanchisseurPed, true)
    SetBlockingOfNonTemporaryEvents(blanchisseurPed, true)
    
    -- Animation idle
    TaskStartScenarioInPlace(blanchisseurPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
    
    -- Définir le moment du prochain changement de position
    local changeInterval = math.random(Config.MovementZone.changeTime.min, Config.MovementZone.changeTime.max) * 60 -- Conversion en secondes
    lastPositionChange = GetGameTimer()
    nextChangeTime = lastPositionChange + (changeInterval * 1000) -- Conversion en millisecondes
    
    currentPosition = positionIndex
    
    if Config.Debug then
        print("PNJ de blanchiment créé à la position " .. positionIndex)
    end
end

-- Configuration du menu RageUI
blanchimentMenu.Closed = function()
    RageUI.Visible(blanchimentMenu, false)
end

-- Thread principal pour vérifier la distance avec le PNJ
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pedCoords = GetEntityCoords(blanchisseurPed)
        local distance = #(playerCoords - pedCoords)
        
        isNearPed = distance < Config.InteractionDistance
        
        -- Mettre un délai approprié pour économiser les ressources
        if isNearPed then
            Wait(500)
        else
            Wait(1000)
        end
    end
end)

-- Thread pour gérer le déplacement périodique du PNJ
function StartPedMovementThread()
    CreateThread(function()
        while true do
            Wait(10000) -- Vérifie toutes les 10 secondes
            
            -- Vérifier s'il est temps de changer de position
            local currentTime = GetGameTimer()
            if currentTime > nextChangeTime then
                -- Choisir une nouvelle position aléatoire différente de la position actuelle
                local newPosition = currentPosition
                while newPosition == currentPosition do
                    newPosition = math.random(1, #Config.MovementZone.positions)
                end
                
                -- Notifier les joueurs proches si activé
                if Config.MovementZone.notifyChange then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local pedCoords = GetEntityCoords(blanchisseurPed)
                    local distance = #(playerCoords - pedCoords)
                    
                    if distance < 50.0 then
                        if Config.Framework == "esx" then
                            ESX.ShowNotification("Le blanchisseur a changé de position. Retrouvez-le ailleurs.") 
                        elseif Config.Framework == "qbcore" then
                            QBCore.Functions.Notify("Le blanchisseur a changé de position. Retrouvez-le ailleurs.", "info")
                        end
                    end
                end
                
                -- Déplacer le PNJ
                CreateBlanchisseurPed(newPosition)
                
                -- Ajouter un blip temporaire si le joueur était proche
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local pedCoords = GetEntityCoords(blanchisseurPed)
                local distance = #(playerCoords - pedCoords)
                
                if distance < 100.0 then
                    local newPosition = Config.MovementZone.positions[newPosition]
                    local blip = AddBlipForCoord(newPosition.x, newPosition.y, newPosition.z)
                    SetBlipSprite(blip, 500) -- Icone d'argent
                    SetBlipColour(blip, 2) -- Vert
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Blanchisseur")
                    EndTextCommandSetBlipName(blip)
                    
                    -- Supprimer le blip après 60 secondes
                    SetTimeout(60000, function() RemoveBlip(blip) end)
                end
                
                if Config.Debug then
                    print("PNJ déplacé vers la position " .. newPosition)
                end
            end
        end
    end)
end

-- Thread pour afficher le marqueur et le texte d'aide
CreateThread(function()
    while true do
        Wait(0)
        
        if isNearPed and not processing then
            -- Afficher texte d'aide
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_CONTEXT~ pour parler au blanchisseur")
            EndTextCommandDisplayHelp(0, false, true, -1)
            
            -- Vérifier si E est pressé
            if IsControlJustPressed(0, 38) then
                OpenBlanchimentMenu()
            end
        else
            Wait(500)
        end
    end
end)

-- Calculer les frais en fonction du montant
function CalculateFees(amount)
    local fees = Config.Fees.max
    if amount >= Config.MaxAmountForMinFee then
        fees = Config.Fees.min
    else
        -- Calculer les frais proportionnellement entre min et max
        local ratio = amount / Config.MaxAmountForMinFee
        fees = Config.Fees.max - (ratio * (Config.Fees.max - Config.Fees.min))
    end
    
    return math.floor(fees)
end

-- Ouvrir le menu de blanchiment
function OpenBlanchimentMenu()
    RageUI.Visible(blanchimentMenu, true)
    
    CreateThread(function()
        while RageUI.Visible(blanchimentMenu) do
            Wait(0)
            
            RageUI.IsVisible(blanchimentMenu, function()
                RageUI.Button(Config.Texts.buttonWash, nil, {RightLabel = "→"}, not processing, {
                    onSelected = function()
                        local input = KeyboardInput(Config.Texts.enterAmount, "", 10)
                        if input ~= nil then
                            input = tonumber(input)
                            if input > 0 then
                                montantABlanchir = input
                                
                                -- Calculer les frais
                                local fees = CalculateFees(montantABlanchir)
                                local amountAfterFees = math.floor(montantABlanchir * (1 - (fees / 100)))
                                
                                -- Afficher un message de confirmation
                                ESX.ShowNotification(string.format(Config.Texts.fees, fees))
                                ESX.ShowNotification(string.format(Config.Texts.youWillReceive, amountAfterFees))
                                
                                
                                -- Trigger côté serveur pour vérifier si le joueur a l'argent sale
                                TriggerServerEvent('lilgar_blanchiment:blanchirArgent', montantABlanchir)
                            end
                        end
                    end
                })
            end)
        end
    end)
end

-- Fonction pour l'input
function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

-- Événement pour démarrer l'animation de blanchiment
RegisterNetEvent('lilgar_blanchiment:startProcessing')
AddEventHandler('lilgar_blanchiment:startProcessing', function(amount)
    processing = true
    
    -- Fermer le menu
    RageUI.CloseAll()
    
    -- Temps de traitement proportionnel au montant
    local processingTime = math.floor((amount / 10000) * Config.ProcessingTime) * 1000
    if processingTime < 3000 then processingTime = 3000 end
    
    -- Afficher la notification
    ESX.ShowNotification(Config.Texts.processing)
    
    -- Animation
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    
    -- Attendre le temps de traitement
    Wait(processingTime)
    
    -- Terminer l'animation
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(playerPed)
    
    processing = false
end)

-- Événement pour afficher la notification de succès
RegisterNetEvent('lilgar_blanchiment:washSuccess')
AddEventHandler('lilgar_blanchiment:washSuccess', function(amountWashed, amountReceived)
    ESX.ShowNotification(string.format(Config.Texts.success, amountWashed, amountReceived))
end)

-- Thread pour le Debug
if Config.Debug then
    CreateThread(function()
        while true do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            DrawMarker(1, playerCoords.x, playerCoords.y, playerCoords.z-1.0, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 255, 0, 0, 200, false, false, 2, false, nil, nil, false)
            
            -- Afficher les coordonnées à l'écran pour faciliter le placement du PNJ
            SetTextFont(4)
            SetTextScale(0.4, 0.4)
            SetTextColour(255, 255, 255, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Coords: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)
            DrawText(0.5, 0.02)
        end
    end)
end
