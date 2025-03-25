if (not Engine.IsEditor()) then
    local mainMenuScene = LoadAsset('SC_Default')
    local mainMenu = mainMenuScene:Instantiate()
    Engine.GetWorld():SetRootNode(mainMenu)
end