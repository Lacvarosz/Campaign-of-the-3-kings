local M = {}

function wesnoth.wml_actions.quick_on_my_feet(cfg)
    local mode = cfg.mode
    local unit_id = cfg.unit_id

    if not unit_id then
        wesnoth.log("error", "quick_on_my_feet: hiányzik a unit_id paraméter.")
        return
    end

    if mode == "reset" then
        local units = wesnoth.units.find_on_map({ ability = "quick_on_my_feet", side = wesnoth.current.side })
        for i, u in ipairs(units) do
            u.variables['qomf_distance'] = 0
            u.variables['qomf_start_x'] = u.x
            u.variables['qomf_start_y'] = u.y
        end
    elseif mode == "moved" then
        local unit = wesnoth.units.get(unit_id)
        if not unit then
            wesnoth.log("warning", "quick_on_my_feet: nem található egység ezzel az ID-vel: " .. tostring(unit_id))
            return
        end

        local start_x = unit.variables['qomf_start_x'] or unit.x
        local start_y = unit.variables['qomf_start_y'] or unit.y

        local old_dist = unit.variables['qomf_distance'] or 0
        local dist = wesnoth.map.distance_between(unit.x, unit.y, start_x, start_y) + old_dist
        if dist > 4 then
            dist = 4
        end
        local diff = dist - old_dist

        -- wesnoth.log('warning', string.format("old: %d\ndist: %d\ndiff: %d", old_dist, dist, diff))

        unit.variables['qomf_distance'] = dist

        if diff > 0 then

            for i = 1, diff do
                unit:add_modification("object", {
                    duration = "turn",
                    silent = "yes",
                    { "effect", {
                        apply_to = "defense",
                        replace = "no",
                        { "defense", {
                            deep_water = -5,
                            shallow_water = -5,
                            reef = -5,
                            swamp_water = -5,
                            flat = -5,
                            sand = -5,
                            forest = -5,
                            hills = -5,
                            mountains = -5,
                            village = -5,
                            castle = -5,
                            cave = -5,
                            frozen = -5,
                            unwalkable = -5,
                            impassable = -5,
                            fungus = -5
                        }}
                    }},
                    { "effect", {
                        apply_to = "attack",
                        increase_damage = 1
                    }}
                })
            end
        end
        unit.variables['qomf_start_x'] = unit.x
        unit.variables['qomf_start_y'] = unit.y
    end
end

return M