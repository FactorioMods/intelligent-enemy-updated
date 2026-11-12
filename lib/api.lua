--https://lua-api.factorio.com/latest/concepts/Command.html
--https://lua-api.factorio.com/latest/classes/LuaCommandable.html
--https://lua-api.factorio.com/latest/classes/LuaAISettings.html

-- 事件注册

-- 注册区块删除事件
script.on_event(defines.events.on_chunk_deleted, onChunkDeleted)
-- 注册表面删除事件
script.on_event(defines.events.on_surface_deleted, onSurfaceDeleted)
-- 注册表面清空事件
script.on_event(defines.events.on_surface_cleared, onSurfaceCleared)
-- 注册表面创建事件
script.on_event(defines.events.on_surface_created, onSurfaceCreated)

-- 注册初始化事件
script.on_init(onInit)
-- 注册加载事件
script.on_load(onLoad)
-- 注册运行时模组设置更改事件
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChange)
-- 注册配置更改事件
script.on_configuration_changed(onConfigChanged)

-- 注册资源耗尽事件
script.on_event(defines.events.on_resource_depleted, onResourceDepleted)
-- 注册玩家建造/机器人建造/脚本设置地砖事件
script.on_event({defines.events.on_player_built_tile,
                 defines.events.on_robot_built_tile,
                 defines.events.script_raised_set_tiles}, onSurfaceTileChange)

-- 注册玩家使用胶囊事件
script.on_event(defines.events.on_player_used_capsule, onUsedCapsule)

-- 注册脚本触发效果事件
script.on_event(defines.events.on_script_trigger_effect, onTriggerEntityCreated)

-- 注册机器人爆破悬崖前事件
script.on_event(defines.events.on_pre_robot_exploded_cliff, onRobotCliff)

-- 注册玩家/机器人采矿实体事件
script.on_event({defines.events.on_player_mined_entity,
                 defines.events.on_robot_mined_entity}, onMine)

-- 注册火箭发射事件
script.on_event(defines.events.on_rocket_launched, onRocketLaunch)
-- 注册实体死亡/脚本销毁事件
script.on_event({ defines.events.on_entity_died,
                  defines.events.script_raised_destroy }, onDeath)
-- 注册区块生成事件
script.on_event(defines.events.on_chunk_generated, onChunkGenerated)
-- 注册单位组创建事件
script.on_event(defines.events.on_unit_group_created, onUnitGroupCreated)
-- 注册势力创建事件
script.on_event(defines.events.on_force_created, onForceCreated)
-- 注册势力合并事件
script.on_event(defines.events.on_forces_merged, onForceMerged)
-- 注册单位组完成集结事件
script.on_event(defines.events.on_unit_group_finished_gathering, onGroupFinishedGathering)

-- 注册建造者到达基地事件
script.on_event(defines.events.on_build_base_arrived, onBuilderArrived)


script.on_event(defines.events.on_trigger_created_entity, onTriggerEntityCreated)
script.on_event(defines.events.on_biter_base_built, onEnemyBaseBuild)

script.on_event(defines.events.on_sector_scanned, onSectorScanned)
script.on_event(defines.events.on_script_trigger_effect, onScriptTriggerEffect)
script.on_event(defines.events.on_player_respawned, onPlayerRespawned)

script.on_event(defines.events.on_force_cease_fire_changed, onForceDiplomacyChanged)
script.on_event(defines.events.on_force_friends_changed, onForceDiplomacyChanged)

script.on_event(defines.events.on_sector_scanned, onSectorScanned)
script.on_event(defines.events.on_script_trigger_effect, onScriptTriggerEffect)
script.on_event(defines.events.on_player_respawned, onPlayerRespawned)
script.on_event(defines.events.on_entity_spawned, onPlayerRespawned)

script.on_event(defines.events.on_entity_damaged, onEntityDamaged, {
    { filter = "type", type = "unit" },
    { mode = "and", invert = true, filter = "damage-type", type = "fire" },
    { mode = "and", invert = true, filter = "damage-type", type = "acid" },
    { mode = "or", filter = "original-damage-amount", value = 200, comparison = ">" },
    { mode = "and", filter = "type", type = "unit" },
})

--on_entity_spawned

