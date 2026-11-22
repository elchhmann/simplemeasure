---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global


function plankLength() -- Credits to @lOcIEe
    local tool = GetString("game.player.tool")

    local plank_length

    if tool == "plank" and not menu and config.enable_plank_length then
        local cameraTransform = GetPlayerEyeTransform()
        local origin = cameraTransform.pos
        local forward = TransformToParentVec(cameraTransform, Vec(0, 0, -1))

        local hit, dist, _, shape = QueryRaycast(origin, forward, 3)
        local hitPos

        if InputPressed("lmb") then
            local hit, dist, _, shape = QueryRaycast(origin, forward, 3)

            if hit then
                local hitPos = VecAdd(origin, VecScale(forward, dist))
                client.plankHitPos = hitPos
                client.plankDist1 = dist
            end
        elseif InputDown("lmb") and dist < maxDist then
            
            -- DebugWatch('plank dist', client.plankDist1)
            -- DebugWatch('plank hitPos1', client.plankHitPos)
            if hit then
                hitPos = VecAdd(origin, VecScale(forward, dist))
                DrawShapeOutline(shape, 1, 0, 0, 1)
            else
                hitPos = VecAdd(origin, VecScale(forward, client.plankDist1))
            end
            -- DebugWatch('plank hitPos2', hitPos)
            -- DrawLine(client.plankHitPos, hitPos, 1, 0, 0, 1)

            plank_length = math.min(math.floor(VecLength(VecSub(client.plankHitPos, hitPos)) * 10 / 2 + 0.5) * 2, 40)
            
            if plank_length <= GetInt("game.tool.plank.length") then
                return plank_length, plank_length / 10
            end
        end
    end
end