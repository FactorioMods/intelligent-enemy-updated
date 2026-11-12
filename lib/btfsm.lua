-- 定义状态
local states = {
    patrol = "patrol",
    search = "search",
    attack = "attack",
    retreat = "retreat"
}

-- 定义敌人实体
local enemy = {
    entity = nil,
    state = states.patrol,
    target = nil,
    health_threshold = 50 -- 撤退的生命值阈值
}

-- 状态机函数
local function patrol(enemy)
    -- 随机移动
    enemy.entity.set_command({type = defines.command.wander})
    -- 检查是否发现玩家
    if enemy.entity.surface.find_nearest_enemy({position = enemy.entity.position, max_distance = 10}) then
        enemy.state = states.attack
        enemy.target = enemy.entity.surface.find_nearest_enemy({position = enemy.entity.position, max_distance = 10})
    end
end

local function search(enemy)
    -- 向玩家的最后已知位置移动
    if enemy.target then
        enemy.entity.set_command({type = defines.command.go_to_location, destination = enemy.target.position})
        -- 如果找到玩家，切换到攻击状态
        if enemy.entity.position.distance(enemy.target.position) < 5 then
            enemy.state = states.attack
        end
    else
        enemy.state = states.patrol
    end
end

local function attack(enemy)
    -- 向玩家移动并攻击
    if enemy.target and enemy.entity.position.distance(enemy.target.position) > 2 then
        enemy.entity.set_command({type = defines.command.go_to_location, destination = enemy.target.position})
    elseif enemy.target then
        enemy.entity.set_command({type = defines.command.attack, target = enemy.target})
    end
    -- 如果生命值低，切换到撤退状态
    if enemy.entity.health < enemy.health_threshold then
        enemy.state = states.retreat
    end
end

local function retreat(enemy)
    -- 远离玩家
    if enemy.target then
        local retreat_position = {x = enemy.entity.position.x + (enemy.entity.position.x - enemy.target.position.x), y = enemy.entity.position.y + (enemy.entity.position.y - enemy.target.position.y)}
        enemy.entity.set_command({type = defines.command.go_to_location, destination = retreat_position})
    end
    -- 如果生命值恢复或玩家远离，切换回巡逻状态
    if enemy.entity.health > enemy.health_threshold * 1.5 or not enemy.target then
        enemy.state = states.patrol
    end
end

-- 状态机更新函数
local function update_enemy(enemy)
    if enemy.state == states.patrol then
        patrol(enemy)
    elseif enemy.state == states.search then
        search(enemy)
    elseif enemy.state == states.attack then
        attack(enemy)
    elseif enemy.state == states.retreat then
        retreat(enemy)
    end
end

-- 主循环
--script.on_event(defines.events.on_tick, function(event)
--    -- 假设我们有一个enemy表，包含所有敌人的实例
--    for _, e in pairs(enemies) do
--        update_enemy(e)
--    end
--end)
--
---- 初始化敌人
--script.on_event(defines.events.on_entity_spawned, function(event)
--    if event.entity.type == "unit" then
--        table.insert(enemies, {entity = event.entity, state = states.patrol, target = nil, health_threshold = 50})
--    end
--end)
