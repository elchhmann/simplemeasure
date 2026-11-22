---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global


function plankLength() -- EXPERIMENTAL
    local tool = GetString("game.player.tool")

    local plank_raycast
    local plank_dist
    local plank_end
    local plank_length

    local plank_maxDist = 3 -- Max distance of the raycast for planks
    local plank_multiplier = 1.5 -- when the end of the plank is x times further than the start point

    local plank_origin_set = false



    if tool == "plank" and not menu and config.enable_plank_length then
        plank_raycast, plank_dist = QueryRaycast(origin, cameraDirection, plank_maxDist)

        if InputDown("lmb") and plank_dist < plank_maxDist then
            if InputPressed("lmb") then
                if plank_origin_set == false then
                    plank_origin = VecAdd(origin, VecScale(cameraDirection, plank_dist))
                    plank_origin_set = true

                    plank_dist_static = plank_dist
                    -- DebugWatch("static dist", plank_dist_static)
                    -- DebugPrint("true")
                    -- DebugPrint(plank_origin)
                end
            end
            
            -- if plank_dist > plank_dist_static * 1.5 then
            --     DebugPrint("switch behavior at" .. plank_dist / plank_dist_static)
            -- else
            --     DebugPrint("standard behavior at " .. plank_dist / plank_dist_static)
            -- end

            -- plank_raycast, plank_dist = QueryRaycast(origin, cameraDirection, plank_dist)
            
            plank_end = VecAdd(origin, VecScale(cameraDirection, plank_dist))

            if plank_raycast then
                plank_end = VecAdd(origin, VecScale(cameraDirection, plank_dist))
            else
                plank_end = VecAdd(origin, VecScale(cameraDirection, plank_dist_static))
            end


            -- DebugPrint(plank_origin)

            plank_length = math.floor(VecLength(VecSub(plank_origin, plank_end)) * 10 / 2 + 0.5) * 2
            
            -- DebugWatch("plank_length", plank_length)
            -- DebugWatch("plank_origin", plank_origin)
            -- DebugWatch("dynamic dist", plank_dist)
            
            -- DebugCross(plank_origin)
            -- DebugCross(plank_end)
            
            if plank_length <= GetInt("game.tool.plank.length") then
                return plank_length, plank_length / 10
            end
        else
            plank_origin_set = false
            return
        end
    end
    
    -- DebugWatch("set", plank_origin_set)
    -- DebugPrint(tool)

    
    
    
end