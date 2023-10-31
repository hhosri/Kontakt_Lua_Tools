--USED FOR SPECIAL CHARACTER REPLACEMENT ISSUES CAUSE BY E-INSTRUMENT PATH NAME
local pattern       = "(e%-instruments)"
local replacement   = "e%%-%1"

local kt            = Kontakt

--index of the loaded instrument
local inst_idx 
     = 0
--instrument name (nki name)
local inst_name     = kt.get_instrument_name(inst_idx)

--path of the existing nksn files
local src_path      = kt.snapshot_path .. 'Kontakt/' .. inst_name

-----------------------------------------------CHANGE THIS-------------------------------------------------------
--2 available modes:
--safe: will save the nksn file in dest_path folder
--overwrite: will overwrite the existing nksn at source
mode                = 'overwrite'

--destination of the nksn files in case used in 'safe' mode
local dest_path     = "/Users/e-instruments/Desktop/test"
------------------------------------------------------------------------------------------------------------------

function get_all_nksn()
    local snapshots_table = {}
    for _, snapshot in Filesystem.recursive_directory(src_path) do
        if #snapshot >= 5 and snapshot:sub(-5) == ".nksn" then
            table.insert(snapshots_table, snapshot)
        end
    end
    return (snapshots_table)
end

function is_dir_exist(path)
    local file = io.open(path:match(("^(.*/)")), "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function load_save_nksn(snapshots_table)
    for _, snapshot in ipairs(snapshots_table) do
        kt.load_snapshot(inst_idx, snapshot)
        if mode == 'safe' then
            new_src_path = src_path:gsub(pattern, replacement)
            new_dest_path = snapshot:gsub(new_src_path, dest_path)
            if is_dir_exist(new_dest_path) == true then
                kt.save_snapshot(inst_idx, new_dest_path)
            else
                os.execute("mkdir " .. new_dest_path:match(("^(.*/)")))
                kt.save_snapshot(inst_idx, new_dest_path)
            end
        elseif mode == 'overwrite' then
            kt.save_snapshot(inst_idx, snapshot)
        else
            print("INVALID MODE")
            os.exit(1)
        end
    end
end

function main()
    local snapshots_table = {}
    snapshots_table = get_all_nksn()
    load_save_nksn(snapshots_table)
end

main()