local M = {}

wesnoth.effects.increment_attack = setmetatable({}, {
    __call = function(_, u, cfg)
        local attack = u:find_attack(cfg)
        if attack ~= nil then
            attack.damage = attack.damage - attack.number
            attack.number = attack.number + 1
        end
    end,

    __descr = function(_, u, cfg)
        local attack = u:find_attack(cfg)
        if attack ~= nil then
            local damage = attack.damage - attack.number
            local number = attack.number + 1
            return string.format("%d x %d", damage, number)
        end
        return ""
    end
})

wesnoth.effects.variable = function(u, cfg)
    if cfg.name == nil then
        wesnoth.log("error", "variable: hiányzik egy vagy több kötelező paraméter: name.")
        return
    end
    if cfg.add then
        if u.variables[cfg.name] == nil then
            u.variables[cfg.name] = 0
        end
        u.variables[cfg.name] = u.variables[cfg.name] + cfg.add
    elseif cfg.set then
        u.variables[cfg.name] = cfg.set
    end
end

return M