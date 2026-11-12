-- 定义状态
local states = {
    assembly = "assembly",
    encirclement = "encirclement",
    assault = "assault",
    retreat = "retreat",
    reinforcement = "reinforcement",
    counterattack = "counterattack",
    breakthrough = "breakthrough",
    surpriseattack = "surpriseattack",
    rallyingcry = "rallyingcry",
    playerhunting = "playerhunting"
}

-- 定义军队实体
local army = {
    units = {},
    state = states.playerhunting,
    target = nil,
    assembly_point = nil,
    health_threshold = 50 -- 撤退的生命值阈值
}

-- 状态机函数
local function assembly(army)
    -- 军队移动到集结点
    for _, unit in pairs(army.units) do
        unit.set_command({type = defines.command.go_to_location, destination = army.assembly_point})
    end
    -- 检查是否所有单位都已到达
    local all_assembled = true
    for _, unit in pairs(army.units) do
        if unit.position.distance(army.assembly_point) > 5 then
            all_assembled = false
            break
        end
    end
    if all_assembled then
        army.state = states.encirclement
    end
end

local function encirclement(army)
    -- 军队从多个方向包围玩家
    local positions = {
        {x = army.target.position.x - 10, y = army.target.position.y},
        {x = army.target.position.x + 10, y = army.target.position.y},
        {x = army.target.position.x, y = army.target.position.y - 10},
        {x = army.target.position.x, y = army.target.position.y + 10}
    }
    for i, unit in pairs(army.units) do
        unit.set_command({type = defines.command.go_to_location, destination = positions[i % #positions + 1]})
    end
    -- 确保包围圈没有漏洞
    local encircled = true
    for _, pos in pairs(positions) do
        if not army.target.surface.find_entity("unit", pos) then
            encircled = false
            break
        end
    end
    if encircled then
        army.state = states.assault
    end
end

local function assault(army)
    -- 军队集中火力攻击玩家
    for _, unit in pairs(army.units) do
        unit.set_command({type = defines.command.attack, target = army.target})
    end
    -- 根据战况调整攻击策略
    local total_health = 0
    for _, unit in pairs(army.units) do
        total_health = total_health + unit.health
    end
    if total_health < army.health_threshold * #army.units then
        army.state = states.retreat
    end
end

local function retreat(army)
    -- 军队有序撤退到安全区域
    local retreat_point = {x = army.assembly_point.x + 20, y = army.assembly_point.y + 20}
    for _, unit in pairs(army.units) do
        unit.set_command({type = defines.command.go_to_location, destination = retreat_point})
    end
    -- 重新评估战况，准备下一次进攻
    local all_retreated = true
    for _, unit in pairs(army.units) do
        if unit.position.distance(retreat_point) > 5 then
            all_retreated = false
            break
        end
    end
    if all_retreated then
        army.state = states.playerhunting
    end
end

local function reinforcement(army)
    -- 请求增援部队加入战斗
    -- 这里可以添加代码来生成或调用增援部队
    -- 等待增援部队到达
    -- 一旦增援部队到达，切换到其他状态
end

local function counterattack(army)
    -- 在被攻击时，立即组织反击
    local attacker = army.units[1].surface.find_nearest_enemy({position = army.units[1].position, max_distance = 10})
    if attacker then
        for _, unit in pairs(army.units) do
            unit.set_command({type = defines.command.attack, target = attacker})
        end
    end
end

local function breakthrough(army)
    -- 集中力量攻击玩家防线的弱点
    -- 这里可以添加代码来识别和攻击防线弱点
    -- 突破防线后，继续进攻
end

local function surpriseattack(army)
    -- 选择合适的时机和地点，发动突然袭击
    -- 打乱玩家部署后，继续进攻
end

local function rallyingcry(army)
    -- 在关键时刻，发出激励军队的呐喊
    -- 提高军队的战斗力和士气
end

local function playerhunting(army)
    -- 主动寻找玩家位置
    army.target = army.units[1].surface.find_nearest_enemy({position = army.units[1].position, max_distance = 50})
    if army.target then
        army.state = states.encirclement
        army.assembly_point = {x = army.target.position.x + 20, y = army.target.position.y + 20}
    end
end

-- 状态机更新函数
local function update_army(army)
    if army.state == states.assembly then
        assembly(army)
    elseif army.state == states.encirclement then
        encirclement(army)
    elseif army.state == states.assault then
        assault(army)
    elseif army.state == states.retreat then
        retreat(army)
    elseif army.state == states.reinforcement then
        reinforcement(army)
    elseif army.state == states.counterattack then
        counterattack(army)
    elseif army.state == states.breakthrough then
        breakthrough(army)
    elseif army.state == states.surpriseattack then
        surpriseattack(army)
    elseif army.state == states.rallyingcry then
        rallyingcry(army)
    elseif army.state == states.playerhunting then
        playerhunting(army)
    end
end

-- 主循环
--script.on_event(defines.events.on_tick, function(event)
--    -- 假设我们有一个armies表，包含所有军队的实例
--    for _, a in pairs(armies) do
--        update_army(a)
--    end
--end)
--
---- 初始化军队
--script.on_event(defines.events.on_entity_spawned, function(event)
--    if event.entity.type == "unit" then
--        local army_found = false
--        for _, a in pairs(armies) do
--            if #a.units < 10 then
--                table.insert(a.units, event.entity)
--                army_found = true
--                break
--            end
--        end
--        if not army_found then
--            table.insert(armies, {units = {event.entity}, state = states.playerhunting, target = nil, assembly_point = nil, health_threshold = 50})
--        end
--    end
--end)
