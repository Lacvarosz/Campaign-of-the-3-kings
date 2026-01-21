local M = {}

wesnoth.effects.increment_attack = setmetatable({}, {
    __call = function(cfg, u)
        local attack = u:find_attack(cfg)
        if attack ~= nil then
            attack.damage = attack.damage - attack.number
            attack.number = attack.number + 1
        end
    end,

    __descr = function(cfg, u)
        local attack = u:find_attack(cfg)
        if attack ~= nil then
            local damage = attack.damage - attack.number
            local number = attack.number + 1
            return string.format("%d x %d", damage, number)
        end
        return ""
    end
})

return M