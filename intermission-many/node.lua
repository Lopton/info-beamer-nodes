gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local loop = resource.load_video{file="loop.mp4"; audio = true; looped = true; raw = true; paused = true }

local function pause_loop()
    loop:stop()
end

local function play_loop()
    
    loop:start()
    loop:place(0, 0, WIDTH, HEIGHT):layer(-2)
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
            newFileName = tonumber(msg) .. ".mp4"
               	
            next_intermission = resource.load_video{file = newFileName ; raw = true ; audio = true ; pause = true }
        end
    end;
}

function node.render()
    --gl.clear(0,0,0,0)
    --loop:draw(0, 0, WIDTH, HEIGHT)
    

    if next_intermission and ( next_intermission:state() == "loaded" or next_intermission:state() == "paused" ) then
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
    if intermission == nil and loop:state() == "paused" then
        play_loop()
    end
end
