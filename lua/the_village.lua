local M = {}

-- Ez a függvény ellenőrzi, hogy egy szűrőnek megfelelő egységen van-e egy adott ID-jű object.
-- Ha igen, akkor egy megadott helyen megváltoztatja a terepet.
-- Arra tervezték, hogy WML-ből hívják meg egyéni akcióként.
function wesnoth.wml_actions.build_the_village(cfg)
    -- Paraméterek beolvasása a WML tag-ből
    local object_id = cfg.object_id
    local x = cfg.x
    local y = cfg.y
    local terrain = cfg.terrain
    local filter_wml = wml.get_child(cfg, "filter")

    -- Szükséges paraméterek ellenőrzése
    if not (object_id and x and y and terrain and filter_wml) then
        wesnoth.log("error", "build_the_village: hiányzik egy vagy több kötelező paraméter: object_id, x, y, terrain, [filter].")
        return
    end

    -- A szűrőnek megfelelő összes egység lekérdezése
    local units_to_check = wesnoth.units.find_on_map(filter_wml)

    local found_object = false
    for _, unit in ipairs(units_to_check) do
        local modifications = wml.get_child(unit.__cfg, "modifications")
        if modifications then
            for object in wml.child_range(modifications, "object") do
                if object.id == object_id then
                    found_object = true
                    break
                end
            end
        end
        if found_object then
            break
        end
    end

    -- Ha az object-et megtaláltuk bármelyik megadott egységen...
    if found_object then
        -- ...akkor megváltoztatjuk a terepet a megadott koordinátákon.
        for _, loc in ipairs(wesnoth.map.find({ x = x, y = y })) do
            wesnoth.set_terrain(loc[1], loc[2], terrain)
        end
    end
end

return M