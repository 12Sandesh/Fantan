local M = {}

-- 1. All zones share the same vertical line (Y) 
-- but have different horizontal starting points (X)
local TABLE_Y = 320 -- Adjust this to match the vertical center of those blue boxes

M.zones = {
    H = { x = 270, name = "hearts"   }, -- Left-most box
    D = { x = 410, name = "diamonds" }, -- Mid-left
    S = { x = 550, name = "spades"   }, -- Mid-right
    C = { x = 690, name = "clubs"    }  -- Right-most box
}

-- 2. Dimensions based on your image
local ZONE_WIDTH = 100  -- How wide each blue box "hit area" is
local ZONE_HEIGHT = 140 -- How tall each blue box "hit area" is
local CARD_STACK_OFFSET = 35 -- Pixels between cards as they build out (increased for visibility)

-- 3. Function: Find which blue box the card was dropped on
function M.get_suit_at_pos(pos)
    print("\n=== Checking drop position ===")
    print("Card position: x=" .. pos.x .. " y=" .. pos.y)
    
    for suit_code, data in pairs(M.zones) do
        local left = data.x - (ZONE_WIDTH / 2)
        local right = data.x + (ZONE_WIDTH / 2)
        local top = TABLE_Y + (ZONE_HEIGHT / 2)
        local bottom = TABLE_Y - (ZONE_HEIGHT / 2)
        
        print(suit_code .. " zone bounds: x[" .. left .. "-" .. right .. "] y[" .. bottom .. "-" .. top .. "]")
        
        if pos.x >= left and pos.x <= right and pos.y >= bottom and pos.y <= top then
            print("✓ MATCH: Card is in " .. suit_code .. " zone")
            return suit_code
        end
    end
    
    print("✗ NO MATCH: Card not in any zone")
    return nil 
end
-- 4. Function: Calculate snap position (Building vertically from the 7)
-- In Fan-Tan, cards build UP from 7 (8,9,10...) and DOWN from 7 (6,5,4...)
function M.get_snap_position(rank, suit_code)
    if not M.zones[suit_code] then
        print("ERROR: Invalid suit code: " .. tostring(suit_code))
        return vmath.vector3(0, 0, 0)
    end
    
    -- Cards build vertically from the center (where 7 sits)
    -- 7 is at TABLE_Y
    -- 8,9,10,J,Q,K build upward (+y)
    -- 6,5,4,3,2,A build downward (-y)
    local y_offset = (rank - 7) * CARD_STACK_OFFSET
    
    local final_x = M.zones[suit_code].x
    local final_y = TABLE_Y + y_offset
    
    print("Snap position for " .. rank .. suit_code .. ": x=" .. final_x .. " y=" .. final_y)
    
    -- Z will be set by cursor_controller based on game_manager's zPosition
    return vmath.vector3(final_x, final_y, 0)
end

-- 5. Helper: Get zone center (useful for initial 7 placement)
function M.get_zone_center(suit_code)
    if not M.zones[suit_code] then
        return vmath.vector3(0, 0, 0)
    end
    
    return vmath.vector3(M.zones[suit_code].x, TABLE_Y, 0)
end

return M