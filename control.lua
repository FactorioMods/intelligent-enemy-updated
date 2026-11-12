require("lib.army")
require("lib.btfsm")
require("lib.f3")

-- Simple function to get distance between two positions.

-- 计算两点之间的距离
function getDistance(posA, posB)
    -- Get the length for each of the components x and y
    local xDist = posB.x - posA.x
    local yDist = posB.y - posA.y

    return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end

function attack(entity, group)
    local success, result = pcall(function()
        -- 检查实体是否有效且是敌人单位
        if entity and entity.type == "unit" and entity.force.name == "enemy" then
            -- 找到最近的玩家
            local player = game.players[1]  -- 假设只有一个玩家，你可以根据需要修改
            local closest_player = nil
            local min_distance = math.huge

            entity.release_from_spawner()

            for _, p in pairs(game.players) do
                -- 检查玩家和实体是否在同一个表面
                if p.surface == entity.surface then
                    local distance = getDistance(entity.position, p.position)
                    if distance < min_distance then
                        min_distance = distance
                        closest_player = p
                    end
                end
            end

            -- 如果找到最近的玩家，让实体攻击该玩家
            if closest_player then
                local commandable = entity.commandable
                if group then
                    commandable = group
                end
                if commandable then

                    commandable.set_command({
                        type = defines.command.attack_area,
                        destination = closest_player.position,
                        radius = 5,
                        force = true
                    })
                end
            end
        end

    end)

    if not success then
        -- 处理错误
        local error_message = "Error: " .. serpent.block(result)
        log(error_message)

        game.print(error_message)

        return nil
    end


end

script.on_event(defines.events.on_entity_spawned, function(event)

    -- 获取新生成的实体
    local entity = event.entity
    attack(entity)
end)

--script.on_event(defines.events.on_ai_command_completed, function(event)
--
--
--    -- 获取新生成的实体
--    local entity = game.get_entity_by_unit_number(event.unit_number)
--
--    attack(entity)
--
--end)

script.on_event(defines.events.on_unit_added_to_group, function(event)


    -- 获取新生成的实体
    local entity = (event.unit)

    attack(entity, event.group)

end)

--fixme 
--script.on_nth_tick(300, function()
--    for k, surface in pairs(game.surfaces) do
--        local allforces = {}
--        for name, force in pairs(game.forces) do
--            if name ~= 'neutral' and name ~= 'enemy' then
--                allforces[name] = 0
--            end
--        end
--
--        for p, player in pairs(game.players) do
--            if player then
--                allforces[player.force.name] = allforces[player.force.name] + 1
--                if allforces[player.force.name] < 2 then
--
--                    --https://lua-api.factorio.com/latest/classes/LuaSurface.html#find_enemy_units
--                    -- Find all units who would be interested to attack the player, within 100-tile area.
--                    local enemies = player.surface.find_enemy_units(player.position, 5000)
--                    if enemies then
--                        for k, enemy in pairs(enemies) do
--                            attack(enemy)
--                        end
--                    end
--                end
--            end
--        end
--    end
--end)
