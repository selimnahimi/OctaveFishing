Player = {}

function Player:Create()
    self.moveSpeed = 10
    self.cameraSpeed = 80
    self.stickDeadZone = 0.1
    self.gravity = -12
    self.currentFloor = nil
    self.addedVelocity = Vec()
    self.isJumping = false
    self.jumpTimer = 0
    self.jumpSpeed = 12
end

function Player:Start()
    self.camera = self:GetWorld():GetActiveCamera()
end

function Player:Tick(deltaTime)
    if (self.camera == nil) then
        return
    end

    local up = self:GetUpVector()

    -- Jump Input
    if (Input.IsGamepadPressed(Gamepad.A)
        and self.currentFloor ~= nil
        and not self.isJumping) then
        self.isJumping = true
    end

    -- Update Jumping
    if (self.isJumping and self.jumpTimer > 0.2) then
        self.isJumping = false
        self.jumpTimer = 0
    end

    -- Left Stick
    local gamepadLeftX = self:GetGamepadAxisWithDeadZone(Gamepad.AxisLX)
    local gamepadLeftY = self:GetGamepadAxisWithDeadZone(Gamepad.AxisLY)

    -- Right Stick
    local gamepadRightX = self:GetGamepadAxisWithDeadZone(Gamepad.AxisRX)
    local gamepadRightY = self:GetGamepadAxisWithDeadZone(Gamepad.AxisRY)

    -- Update camera rotation
    local cameraRotation = self.camera:GetRotation() + Vec(gamepadRightY, -gamepadRightX, 0) * self.cameraSpeed * deltaTime
    self.camera:SetRotation(cameraRotation)

    -- Get camera projection for movement
    local cameraForward = self.camera:GetForwardVector()
    local cameraRight = self.camera:GetRightVector()
    cameraForward.y, cameraRight.y = 0
    cameraForward = cameraForward:Normalize()
    cameraRight = cameraRight:Normalize()

    -- Update position
    local desiredMoveDirection = cameraRight * gamepadLeftX + cameraForward * gamepadLeftY
    self:AddVelocity(desiredMoveDirection * self.moveSpeed)

    if (self.currentFloor == nil and not self.isJumping) then
        self:AddVelocity(up * self.gravity)
    end

    if (self.isJumping) then
        self:AddVelocity(up * self.jumpSpeed)
    end

    local newPos = self:GetWorldPosition()
    newPos = newPos + self.addedVelocity * deltaTime
    self:SetWorldPosition(newPos)

    -- Reset floor
    self.currentFloor = nil

    -- Reset Added Velocity
    self.addedVelocity = Vec()

    -- Increase all timers
    self:TickAllTimers(deltaTime)
end

function Player:AddVelocity(velocity)
    self.addedVelocity = self.addedVelocity + velocity
end

function Player:TickAllTimers(deltaTime)
    if (self.isJumping) then
        self.jumpTimer = self.jumpTimer + deltaTime
    end
end

function Player:OnCollision(thisNode, otherNode, impactPoint, impactNormal, manifold)
    local pos = self:GetWorldPosition()
    Log.Debug("collision with " .. otherNode:GetName())
    Renderer.AddDebugLine(pos, pos + impactNormal * 50, Vec(255, 0, 0), 1)
    
    if (impactNormal.y > 0.95) then
        self.currentFloor = otherNode
    end
end

function Player:GetGamepadAxisWithDeadZone(gamepadAxis)
    local value = Input.GetGamepadAxis(gamepadAxis)
    local absValue = value * Math.Sign(value)

    if (absValue < self.stickDeadZone) then
        return 0
    end

    return value
end
