local ESX = nil
local QBCore = nil

-- Initialisation du framework
if Config.Framework == "esx" then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

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

-- Événement pour blanchir l'argent
RegisterNetEvent('lilgar_blanchiment:blanchirArgent')
AddEventHandler('lilgar_blanchiment:blanchirArgent', function(amount)
    local _source = source
    local xPlayer = nil
    
    -- Récupérer le joueur selon le framework
    if Config.Framework == "esx" then
        xPlayer = ESX.GetPlayerFromId(_source)
    elseif Config.Framework == "qbcore" then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    end
    
    if not xPlayer then return end
    
    -- Vérifier si le joueur a assez d'argent sale
    local blackMoney = 0
    
    if Config.Framework == "esx" then
        blackMoney = xPlayer.getAccount('black_money').money
    elseif Config.Framework == "qbcore" then
        blackMoney = xPlayer.Functions.GetItemByName("black_money").amount
    end
    
    if blackMoney >= amount then
        -- Calculer les frais
        local fees = CalculateFees(amount)
        local amountAfterFees = math.floor(amount * (1 - (fees / 100)))
        
        -- Retirer l'argent sale
        if Config.Framework == "esx" then
            xPlayer.removeAccountMoney('black_money', amount)
        elseif Config.Framework == "qbcore" then
            xPlayer.Functions.RemoveItem("black_money", amount)
        end
        
        -- Démarrer le traitement côté client
        TriggerClientEvent('lilgar_blanchiment:startProcessing', _source, amount)
        
        -- Attendre le temps de traitement
        local processingTime = math.floor((amount / 10000) * Config.ProcessingTime) * 1000
        if processingTime < 3000 then processingTime = 3000 end
        
        -- Utiliser SetTimeout pour ajouter l'argent propre après le délai
        SetTimeout(processingTime, function()
            -- Ajouter l'argent propre
            if Config.Framework == "esx" then
                xPlayer.addMoney(amountAfterFees)
            elseif Config.Framework == "qbcore" then
                xPlayer.Functions.AddMoney("cash", amountAfterFees)
            end
            
            -- Notifier le joueur
            TriggerClientEvent('lilgar_blanchiment:washSuccess', _source, amount, amountAfterFees)
            
            -- Log (optionnel)
            print(string.format("Joueur %s a blanchi %s$ et reçu %s$ après frais de %s%%", 
                GetPlayerName(_source), amount, amountAfterFees, fees))
        end)
    else
        if Config.Framework == "esx" then
            TriggerClientEvent('esx:showNotification', _source, Config.Texts.notEnoughDirtyMoney)
        elseif Config.Framework == "qbcore" then
            TriggerClientEvent('QBCore:Notify', _source, Config.Texts.notEnoughDirtyMoney, "error")
        end
    end
end)

-- Webhook Discord (Optionnel pour les logs)
function sendToDiscord(name, message, color)
    if Config.DiscordWebhook and Config.DiscordWebhook ~= "" then
        local embed = {
            {
                ["color"] = color,
                ["title"] = "**" .. name .. "**",
                ["description"] = message,
                ["footer"] = {
                    ["text"] = "lilgar_blanchiment - " .. os.date("%d/%m/%Y %H:%M:%S"),
                },
            }
        }
        PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
end
