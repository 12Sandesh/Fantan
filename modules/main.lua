local M = {}

-- Import dropzones module for snap positioning
local dropzones = require "modules.dropzones"

M.game_state = {
    hands = { {}, {}, {} }, -- Data representation of player hands
    table_cards = {
        C = { min = 7, max = 7, active = false },
        D = { min = 7, max = 7, active = false },
        H = { min = 7, max = 7, active = false },
        S = { min = 7, max = 7, active = false }
    },
    current_turn = 1,
    pot = 0
}

-- Convert string "7H" to data {rank = 7, suit = "H"}
function M.parse_card(card_str)
    local r_char = string.sub(card_str, 1, 1)
    local suit = string.sub(card_str, 2, 2)
    local rank

    if r_char == "A" then
        rank = 1
    elseif r_char == "T" then
        rank = 10
    elseif r_char == "J" then
        rank = 11
    elseif r_char == "Q" then
        rank = 12
    elseif r_char == "K" then
        rank = 13
    else
        rank = tonumber(r_char)
    end

    return rank, suit
end

-- Initialize logic with hands from the dealer
function M.start_game(player_hands)
    M.game_state.hands = player_hands
    M.game_state.current_turn = 1
    -- Reset table
    for _, suit in pairs({ "C", "D", "H", "S" }) do
        M.game_state.table_cards[suit] = { min = 7, max = 7, active = false }
    end
end

-- Check if a card is legally playable
function M.can_play(card_str)
    local rank, suit = M.parse_card(card_str)
    local suit_data = M.game_state.table_cards[suit]

    if rank == 7 then
        return true
    end

    if suit_data.active then
        if rank == suit_data.min - 1 or rank == suit_data.max + 1 then
            return true
        end
    end

    return false
end

function M.get_player_hand(player_id)
    if player_id >= 1 and player_id <= #M.game_state.hands then
        return M.game_state.hands[player_id]
    end
    return {}
end

function M.player_has_playable_cards(player_id)
    local hand = M.get_player_hand(player_id)
    for _, card_str in ipairs(hand) do
        if M.can_play(card_str) then
            return true
        end
    end
    return false
end

function M.remove_card_from_hand(player_id, card_str)
    local hand = M.game_state.hands[player_id]
    if not hand then return false end

    for i, card in ipairs(hand) do
        if card == card_str then
            table.remove(hand, i)
            print("Card removed:", card_str, "from player", player_id)
            return true
        end
    end
    return false
end

function M.request_move(player_id, card_str)
    -- Verify it's this player's turn
    if player_id ~= M.game_state.current_turn then
        print("ERROR: Not player " .. player_id .. "'s turn")
        return false, nil
    end

    -- Verify the move is legal
    if not M.can_play(card_str) then
        print("ERROR: Illegal move - " .. card_str)
        return false, nil
    end

    -- Parse the card
    local rank, suit = M.parse_card(card_str)

    -- Register the play
    M.register_play(player_id, card_str)

    -- Remove from player's hand
    M.remove_card_from_hand(player_id, card_str)

    -- Advance turn
    -- M.next_turn()

    -- Calculate snap position using dropzones module
    local snap_pos = dropzones.get_snap_position(rank, suit)

    print("✓ Move registered: " .. card_str .. " by player " .. player_id)
    return true, snap_pos
end

-- Update the state after a play
function M.register_play(player_id, card_str)
    local rank, suit = M.parse_card(card_str)
    local suit_data = M.game_state.table_cards[suit]

    if rank == 7 then
        suit_data.active = true
    elseif rank < suit_data.min then
        suit_data.min = rank
    elseif rank > suit_data.max then
        suit_data.max = rank
    end

    -- Remove card from player's hand (if you're tracking it)
    -- This would require knowing which card in hands[player_id] to remove

    print("Table state for " ..
    suit .. ": min=" .. suit_data.min .. " max=" .. suit_data.max .. " active=" .. tostring(suit_data.active))
end

function M.next_turn()
    M.game_state.current_turn = (M.game_state.current_turn % 3) + 1
    print("Turn advanced to player " .. M.game_state.current_turn)
end

-- Helper: Get current turn
function M.get_current_turn()
    return M.game_state.current_turn
end

-- Helper: Check if player can pass (has no playable cards)
function M.can_pass(player_id)
    local hand = M.game_state.hands[player_id]
    if not hand then return false end

    for _, card_str in ipairs(hand) do
        if M.can_play(card_str) then
            return false -- Has at least one playable card
        end
    end
    return true -- No playable cards
end

return M
