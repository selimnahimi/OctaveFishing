Player = {}

function Player:Create()
    self.velocity = Vec()
    self.moveSpeed = 10
    self.cameraSpeed = 80
    self.stickDeadZone = 0.1
    -- self.gravity = -50
    -- self.jumpSpeed = 30
end

function Player:Start()
    self.camera = self:GetWorld():GetActiveCamera()
end

function Player:Tick(deltaTime)
    if (self.camera == nil) then
        return
    end

    local gamepadLeftX = self:GetGamepadAxisWithDeadZone(Gamepad.AxisLX)
    local gamepadLeftY = self:GetGamepadAxisWithDeadZone(Gamepad.AxisLY)

    self.velocity = Vec(gamepadLeftX, 0, -gamepadLeftY) * self.moveSpeed

    local gamepadRightX = self:GetGamepadAxisWithDeadZone(Gamepad.AxisRX)
    local gamepadRightY = self:GetGamepadAxisWithDeadZone(Gamepad.AxisRY)

    local cameraRotation = self.camera:GetRotation() + Vec(gamepadRightY, -gamepadRightX, 0) * self.cameraSpeed * deltaTime
    self.camera:SetRotation(cameraRotation)

    local forward = self.camera:GetForwardVector()
    local right = self.camera:GetRightVector()

    forward.y = 0
    right.y = 0
    forward = forward:Normalize()
    right = right:Normalize()

    local desiredMoveDirection = right * gamepadLeftX + forward * gamepadLeftY

    local newPos = self:GetWorldPosition()
    newPos = newPos + desiredMoveDirection * self.moveSpeed * deltaTime
    self:SetWorldPosition(newPos)
end

function Player:GetGamepadAxisWithDeadZone(gamepadAxis)
    local value = Input.GetGamepadAxis(gamepadAxis)
    local absValue = value

    if (Math.Sign(value) == -1) then
        absValue = -value
    end

    if (absValue < self.stickDeadZone) then
        return 0
    end

    return value
end

function Player:Stop()

end