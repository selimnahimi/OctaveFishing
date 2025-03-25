FishTest = {}

function FishTest:Tick(deltaTime)
    if (not Input.IsPointerDown()) then
        return
    end

    local pointerX, pointerY = Input.GetPointerPosition()

    self:SetPosition(pointerX, pointerY)
end