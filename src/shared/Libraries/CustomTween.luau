local custom_tween = {}

function custom_tween.RescaleModel(model, targetScale, duration)
    local tween_service = game:GetService("TweenService")
    local run_service = game:GetService("RunService")

    local tween_info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local start_scale = model:GetScale()

    local function tweenScale(start_scale : number, targetScale : number, tween_info : TweenInfo, model : Model)
        local elapsed = 0
        local scale = 0
        local tween_connection

        local function onStep(delta_time : number)
            elapsed = math.min(elapsed + delta_time, tween_info.Time)

            local alpha = tween_service:GetValue(elapsed / tween_info.Time, tween_info.EasingStyle, tween_info.EasingDirection)

            scale = start_scale + alpha * (targetScale - start_scale)

            model:ScaleTo(scale)

            if elapsed >= tween_info.Time then
                tween_connection:Disconnect()
            end
        end

        tween_connection = run_service.Heartbeat:Connect(onStep)
    end

    tweenScale(start_scale, targetScale, tween_info, model)
end

function custom_tween.RepositionModel(model : Model, target_position : Vector3, duration : Number, repeat_count : number, snap)
    -- Get primary part
    -- Get current CFrame
    -- Create tween with it
    -- Play and return tween
    local tween_service = game:GetService("TweenService")

    local primary_part = model.PrimaryPart
    local current_cframe = primary_part.CFrame
    local tween_info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, repeat_count, snap or false)
    local tween = tween_service:Create(primary_part, tween_info, {CFrame = current_cframe + target_position})

    tween:Play()
    return tween
end

return custom_tween