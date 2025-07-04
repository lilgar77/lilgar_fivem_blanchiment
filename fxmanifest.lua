fx_version 'adamant'

game 'gta5'

author 'lilgar'
description 'Système de blanchiment d\'argent'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
  
    "src/components/Audio.lua",
    "src/components/Keys.lua",
    "src/components/Rectangle.lua",
    "src/components/Screen.lua",
    "src/components/Sprite.lua",
    "src/components/Text.lua",
    "src/components/Visual.lua",
  
    "src/menu/elements/ItemsBadge.lua",
    "src/menu/elements/ItemsColour.lua",
    "src/menu/elements/PanelColour.lua",
  
    "src/menu/items/UIButton.lua",
    "src/menu/items/UICheckBox.lua",
    "src/menu/items/UIProgress.lua",
    "src/menu/items/UISeparator.lua",
    "src/menu/items/UIList.lua",
    "src/menu/items/UISlider.lua",
    "src/menu/items/UISliderHeritage.lua",
    "src/menu/items/UISliderProgress.lua",
  
    "src/menu/panels/UIBoutonPanel.lua",
    "src/menu/panels/UIColourPanel.lua",
    "src/menu/panels/UIGridPanel.lua",
    "src/menu/panels/UIGridPanelHorizontal.lua",
    "src/menu/panels/UIGridPanelVertical.lua",
    "src/menu/panels/UIPercentagePanel.lua",
    "src/menu/panels/UIStatisticsPanel.lua",
  
    "src/menu/windows/UIHeritage.lua",
    'client/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
}

shared_script 'config.lua'