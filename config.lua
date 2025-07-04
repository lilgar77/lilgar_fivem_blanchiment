Config = {}

-- Position initiale du PNJ et du blanchiment
Config.Position = {
    x = 1136.14, 
    y = -989.64, 
    z = 46.11,
    h = 274.37 -- Heading du PNJ
}

-- Zone de déplacement du PNJ
Config.MovementZone = {
    -- Cette zone définit les limites dans lesquelles le PNJ peut se déplacer
    positions = {
        {x = 1143.42, y = -978.25, z = 46.21, h = 277.12}, -- Position 1
        {x = 1136.14, y = -989.64, z = 46.11, h = 274.37}, -- Position 2 (position initiale)
        {x = 1128.76, y = -980.11, z = 46.41, h = 53.84},  -- Position 3
        {x = 1123.55, y = -994.43, z = 46.11, h = 189.21}, -- Position 4
        {x = 1149.21, y = -992.68, z = 46.21, h = 323.47}  -- Position 5
    },
    -- Paramètres de déplacement
    changeTime = {min = 15, max = 30}, -- Temps en minutes entre les changements de position (aléatoire entre min et max)
    notifyChange = true -- Notification aux joueurs proches quand le PNJ se déplace
}

-- Modèle du PNJ
Config.PedModel = "s_m_m_highsec_01" -- Modèle du PNJ

-- Distance d'interaction avec le PNJ
Config.InteractionDistance = 2.0

-- Frais de blanchiment (pourcentage)
Config.Fees = {
    min = 10, -- Pourcentage minimum (pour les gros montants)
    max = 45  -- Pourcentage maximum (pour les petits montants)
}

-- Seuil à partir duquel le tarif minimum s'applique
Config.MaxAmountForMinFee = 100000

-- Temps de blanchiment en secondes par 10000$
Config.ProcessingTime = 3

-- ESX ou autre framework
Config.Framework = "esx" -- "esx" ou "qbcore"

-- Debug Mode (affiche des messages dans la console)
Config.Debug = true

-- Textes dans les notifications et le menu
Config.Texts = {
    menuTitle = "Blanchiment d'argent by LILGAR",
    menuSubtitle = "Blanchissez votre argent sale",
    buttonWash = "Blanchir de l'argent",
    amountLabel = "Montant à blanchir",
    processing = "Blanchiment en cours...",
    success = "Vous avez blanchi ~g~$%s~s~ et reçu ~g~$%s~s~ après les frais",
    notEnoughDirtyMoney = "Vous n'avez pas assez d'argent sale",
    enterAmount = "Entrez le montant à blanchir",
    fees = "Frais appliqués: %s%%",
    youWillReceive = "Vous recevrez: $%s"
}
