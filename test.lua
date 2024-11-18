local function show_command_output_and_clear(command)
    local handle = io.popen(command)
    if not handle then
        print("Failed to execute the command!")
        return
    end

    local lines = {}
    local total_lines = 0

    -- Display each line of output
    for line in handle:lines() do
        print(line) -- Show the output
        table.insert(lines, line)
        total_lines = total_lines + 1
    end
    handle:close()

    -- Remove all printed lines from the console
    for _ = 1, total_lines do
        io.write("\27[1A") -- Move the cursor up by one line
        io.write("\r" .. string.rep(" ", 80) .. "\r") -- Clear the line
    end
end

-- Example Usage
show_command_output_and_clear("ping www.google.com")
