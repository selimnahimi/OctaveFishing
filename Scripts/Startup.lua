if (not Engine.IsEditor()) then
    local topScreenScene = LoadAsset('SC_Default')
    local main = topScreenScene:Instantiate()
    local bottomScreenScene = LoadAsset('SC_Inventory')
    local inventory = bottomScreenScene:Instantiate()
    
    Engine.GetWorld(1):SetRootNode(main)
    Engine.GetWorld(2):SetRootNode(inventory)
end