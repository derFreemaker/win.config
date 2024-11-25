-- local install = "winget install --disable-interactivity --accept-source-agreements --accept-package-agreements --id \"%s\" -e"
-- local uninstall = "winget uninstall --disable-interactivity --id \"%s\" -e"
-- local id = "9p8ltpgcbzxd"

-- local command = uninstall:format(id)
-- local handle = io.popen(command)
-- if not handle then
--     error("lol")
-- end

-- for line in handle:lines() do
--     print(">" .. line)
-- end
-- handle:close()

-- Function to interpret ANSI escape codes and modify the terminal state.
local function execute_ansi_escape(buffer)
    local cursor_x, cursor_y = 1, 1 -- Initialize cursor position (1-based indexing)
    local screen = {}               -- Terminal buffer (2D array for content)

    -- Helper function to set the character at the cursor's position.
    local function write_char(char)
        if not screen[cursor_y] then screen[cursor_y] = {} end
        screen[cursor_y][cursor_x] = char
        cursor_x = cursor_x + 1 -- Move cursor forward after writing
    end

    -- Helper function to move the cursor.
    local function move_cursor(dx, dy)
        cursor_x = math.max(1, cursor_x + dx)
        cursor_y = math.max(1, cursor_y + dy)
    end

    -- Helper function to parse numeric parameters from the sequence.
    local function parse_params(seq)
        local params = {}
        for param in seq:gmatch("%d+") do
            table.insert(params, tonumber(param))
        end
        return params
    end

    local i = 1

    ---@return boolean success
    local function execute_escape_seq()
        -- Found an ANSI escape sequence
        local end_pos = buffer:find("[A-Za-z]", i + 2)
        if not end_pos then
            return false
        end

        local esc_seq = buffer:sub(i + 2, end_pos)
        local command = esc_seq:sub(-1)                 -- Get the command character
        local params = parse_params(esc_seq:sub(1, -2)) -- Extract parameters

        -- Process the command
        if command == "A" then
            -- Cursor Up (CSI n A)
            move_cursor(0, -(params[1] or 1))
        elseif command == "B" then
            -- Cursor Down (CSI n B)
            move_cursor(0, params[1] or 1)
        elseif command == "C" then
            -- Cursor Forward (CSI n C)
            move_cursor(params[1] or 1, 0)
        elseif command == "D" then
            -- Cursor Back (CSI n D)
            move_cursor(-(params[1] or 1), 0)
        elseif command == "H" or command == "f" then
            -- Cursor Position (CSI n;m H or CSI n;m f)
            cursor_y = params[1] or 1
            cursor_x = params[2] or 1
        elseif command == "J" then
            -- Erase in Display (CSI n J)
            if params[1] == 2 or not params[1] then
                screen = {}
            end
        elseif command == "K" then
            -- Erase in Line (CSI n K)
            if not screen[cursor_y] then screen[cursor_y] = {} end
            for x = cursor_x, #screen[cursor_y] do
                screen[cursor_y][x] = nil
            end
        else
            return false
        end

        -- Advance index past the escape sequence
        i = end_pos
        return true
    end

    ---@param char string
    local function process_char(char)
        if char == "\27" and buffer:sub(i + 1, i + 1) == "[" then
            if not execute_escape_seq() then
                write_char("\27")
                write_char("[")
            end
        elseif char == "\r" then
            -- Handle carriage return
            cursor_x = 1
        elseif char == "\n" then
            -- Handle newline (move to the next line, cursor at beginning)
            cursor_x = 1
            cursor_y = cursor_y + 1
        else
            -- Regular character, write to the screen
            write_char(char)
        end
    end

    while i <= #buffer do
        local char = buffer:sub(i, i)
        process_char(char)
        i = i + 1
    end

    -- Convert screen to string format for easier debugging (optional)
    local function screen_to_string()
        local pos_y = 0
        local result = {}
        for y, row in pairs(screen) do
            while pos_y < y do
                pos_y = pos_y + 1
                if not result[pos_y] then
                    result[pos_y] = ""
                end
            end

            local pos_x = 0
            local line = {}
            for x, char in pairs(row) do
                while pos_x < x do
                    pos_x = pos_x + 1
                    if not line[pos_x] then
                        line[pos_x] = " "
                    end
                end

                line[x] = char or " "
            end
            result[y] = table.concat(line)
        end
        return table.concat(result, "\n")
    end

    return cursor_x, cursor_y, screen, screen_to_string()
end

-- Example usage:
local test_buffer = "\27[4;5HHello\27[2A\27[5CWorld!"
local x, y, screen, screen_str = execute_ansi_escape(test_buffer)

print("Cursor Position:", x, y)
print("Screen State:\n" .. screen_str)
