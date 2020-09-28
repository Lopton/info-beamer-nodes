gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

--local raw = sys.get_ext "raw_video"
local loop = resource.load_video{file="loop.mp4", audio = true, looped = true, raw = true}

local function pause_loop()
    loop:place(-1, -1, -1, -1):stop()
end

local function play_loop()
    loop:place(0, 0, WIDTH, HEIGHT):layer(-2):start()
end

local intermission
local next_intermission

node.alias "looper"

util.data_mapper{
    stop = function()
        loop:stop()
    end;
    play = function(msg)
        if intermission == nil then
            -- load the next intermission. If there is already one
            -- loading, abort loading now and replace it with the
            -- new video.
            if next_intermission then
                next_intermission:dispose()
            end
            --I have no idea why, but the passed variable adds a new character line, I use this trick to remove it
            newFileName = tonumber(msg) .. ".mp4"
               	
            next_intermission = resource.load_video{file = newFileName ; raw = true ; audio = true}
        end
    end;
}

function node.render()
    --removed and no detrimental effects noticed
    --gl.clear(0,0,0,0)
    --loop:draw(0, 0, WIDTH, HEIGHT)
    play_loop()
    if next_intermission and next_intermission:state() == "loaded" then
        -- next intermission finished loading? Then stop any
        -- intermission that is currently running and replace
        -- it with the next one.
        if intermission then
            intermission:dispose()
        end
        next_intermission:place(0,0, WIDTH, HEIGHT):layer(-3)
        intermission = next_intermission
        intermission:layer(-1):start()
        next_intermission = nil
        pause_loop()
    end

    if intermission and intermission:state() ~= "loaded" then
        -- intermission running and it ended? Then get rid of
        -- the intermission video and resume playing the main
        -- loop.
        intermission:dispose()
        intermission = nil
	play_loop()
    end
end
