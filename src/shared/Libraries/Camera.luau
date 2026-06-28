local tween_service = game:GetService("TweenService")
local camera = {}

function  camera.RepositionLookAt()
    
end

function camera.TweenedRepositionLookAt(camera: Camera, at: Vector3, look_at: Vector3, duration: number)
    local tween = tween_service:Create(camera, TweenInfo.new(duration), {CFrame = CFrame.lookAt(at, look_at)})
    tween:Play()
    return tween
end

function camera.TweenedCFrameModification(camera: Camera, cframe: CFrame, duration)
    local tween = tween_service:Create(camera, TweenInfo.new(duration), {CFrame = cframe})
    tween:Play()
    return tween
end

return camera