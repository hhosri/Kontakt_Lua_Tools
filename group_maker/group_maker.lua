
--General vars------------------

BLACK = "\27[30m"
RED = "\27[31m"
GREEN = "\27[32m"
YELLOW = "\27[33m"
BLUE = "\27[34m"
MAGENTA = "\27[35m"
CYAN = "\27[36m"
WHITE = "\27[37m"

k = Kontakt
------------------------------------------------------------------------------------------------

function def_create_grps(inst_idx, num, names)
    for i = 1, num do
        local curr_idx = k.add_group(inst_idx)
        k.set_group_name(inst_idx, curr_idx, names[i])
        print(BLUE.."Created group: "..names[i].." at index: "..curr_idx..WHITE)
    end
    return 1
end

function copy_create_grps(inst_idx, num, names, values)
    if (type(values) ~= "number")then
        error("type", "Wrong type of argument 'values' - type should be a number representing the reference group index")
        return 0;
    end
    local pan = k.get_group_pan(inst_idx, values)
    local playback = k.get_group_playback_mode(inst_idx, values)
    --start = k.get_group_start_options(inst_idx, values)
    local tune = k.get_group_tune(inst_idx, values)
    local volume = k.get_group_volume(inst_idx, values)

    for i = 1, num do
        local curr_idx = k.add_group(inst_idx)
        k.set_group_name(inst_idx, curr_idx, names[i])
        k.set_group_pan(inst_idx, curr_idx, pan)
        k.set_group_playback_mode(inst_idx, curr_idx, playback)
        k.set_group_tune(inst_idx, curr_idx, tune)
        k.set_group_volume(inst_idx, curr_idx, volume)
        print(BLUE.."Created group: "..names[i].." at index: "..curr_idx..WHITE)
    end
    return 1
end

function custom_create_grps(inst_idx, num, names, values)
    if (type(values) ~= "table")then
        error("type", "Wrong type of argument 'values' - type should be a table holding the value of 4 parameters:volume - pan - tune - playback mode")
        return 0;
    end
    for i = 1, num do
        local curr_idx = k.add_group(inst_idx)
        k.set_group_name(inst_idx, curr_idx, names[i])

        k.set_group_volume(inst_idx, curr_idx, values.volume)
        k.set_group_pan(inst_idx, curr_idx, values.pan)
        k.set_group_tune(inst_idx, curr_idx, values.tune)
        k.set_group_playback_mode(inst_idx, curr_idx, values.playback)
        
        
        print(BLUE.."Created group: "..names[i].." at index: "..curr_idx..WHITE)
    end
    return 1
end

function error(error, msg)
    if  error == "mode" then
        print(RED..msg..WHITE)
        print(GREEN.."1 - default"..WHITE)
        print(GREEN.."2 - copy"..WHITE)
        print(GREEN.."3 - custom"..WHITE)
    else
        print(RED..msg..WHITE)
    end

end

function func_validation(mode, inst_idx, num, names, values)
    if (mode == nil or inst_idx == nil or num == nil or names == nil)then
        error("args", "Missing arguments")
        return 0
    end
    if not (mode == "default" or mode == "copy" or mode == "custom")then
        error("mode", "Invalid mode. Please select one of the following modes:")
        return 0
    end
    if (mode == "default" and (values ~= nil))then
        error("args", "Too many arguments for mode 'default'")
        return 0
    end
    if ((mode == "copy" or mode == "custom") and values == nil)then
        error("args", "Argument 'values' needed for modes 'copy' and 'custom' ")
        return 0
    end
    if (num ~= #names)then
        error("names", "Could not create groups. Number of groups should match the number of group names")
        return 0
    end
    return 1
end
--------------------------------
function create_groups(mode, inst_idx, num, names, values)

    local status = 0
    if (func_validation(mode, inst_idx, num, names, values) == 0)then
        return 0
    end
    if (mode == "default") then
        status = def_create_grps(inst_idx, num, names)
    elseif (mode == "copy") then
        status = copy_create_grps(inst_idx, num, names, values)
    elseif (mode == "custom")then
        status = custom_create_grps(inst_idx, num, names, values)
    end
    if (status == 1)then
        print(GREEN..num.." Groups successfully created"..WHITE)
    end
    return(status)
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-------------------------------DOCUMENTATION---------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--[[
PROTOTYPE:
create_groups(mode, inst_idx, num, names, values)

DESCRIPTION:
-This function is used to create groups in the Kontakt instance based on the specified mode.
-It can create groups in three different modes: "default," "copy," and "custom."
-The function performs validation on the provided arguments
and ensures that the required arguments are present for each mode.

PARAMETERS:
-mode (string): The mode in which the groups should be created. Valid values are:
    -"default": Create groups using the default settings.
    -"copy": Copy properties from a reference group to the newly created groups.
    -"custom": Create groups with custom properties provided in the values parameter.
-inst_idx (number): The index of the instrument in which the groups should be created.
-num (number): The number of groups to create.
-names (table): A table containing the names for each group. The table should have num elements, each representing the name of a group.
-values (number or table, optional): The value depends on the selected mode:
    -For "copy" mode: The values should be a number representing the reference group index from which properties will be copied.
    -For "custom" mode: The values should be a table with the following fields:
        -volume (number): The volume value for the newly created groups.
        -pan (number): The pan value for the newly created groups.
        -tune (number): The tune value for the newly created groups.
        -playback (string): The playback mode for the newly created groups.

RETURNS:
If successful, the function returns 1 and prints the number of groups successfully created.
If there is an error, the function returns 0 and prints an error message.
]]
-------------------------------EXAMPLES--------------------------------
-- create_groups("default", 0, 4, {"piano", "guitar", "drums", "bass"})
-- create_groups("copy", 0, 2, {"piano", "guitar"},0)
-- create_groups("custom", 0, 2, {"piano", "guitar"},{volume = -10, pan = -50, tune = 8, playback = "dfd"})
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
----------------Call the function create_groups() below----------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

