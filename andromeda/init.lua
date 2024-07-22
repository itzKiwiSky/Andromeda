Andromedapath = ...

local Andromeda = {}
Andromeda.__index = Andromeda

local function _contains(_table, _value)
    for _, v in ipairs(_table) do
        if v == _value then
            return true
        end
    end
    return false
end

local function _normalizeProgress(current, total)
    if total == 0 then
        return 0
    end
    return math.floor((current / total) * 100 + 0.5)
end

local function _doScanFolder(_folder, _ext)
    local files = {}
    local function _scan(_path)
        local items = love.filesystem.getDirectoryItems(_path)

        for _, item in ipairs(items) do
            local iPath = _path .. "/" .. item
            if love.filesystem.getInfo(iPath).type == "file" then
                table.insert(files, iPath)
            elseif love.filesystem.getInfo(iPath).type == "directory" then
                _scan(iPath)
            end 
        end
    end

    _scan(_folder)
    return files
end

local function _countItems(this)
    for _, queue in ipairs(this.queue) do
        for _, item in ipairs(queue) do
            this.max = this.max + 1
        end
    end
end

function Andromeda.newDB()
    local err
    local self = setmetatable({}, Andromeda)
    self.poll = {
        image = {},
        audio = {},
        video = {}
    }
    self.loadScreenAssets = {}  -- is used internally for asset management only for the loading screen
    self.queue = {}
    self.screen, err = love.filesystem.load(Andromedapath .. "/LoadingScreen.lua")
    self.max = 0
    self.progress = 0

    if err then
        error(err)
    end

    self.env = {}
    setmetatable(self.env, { __index = _G })

    return self
end

function Andromeda:setPreloadScreen(_path)
    local err
    self.screen, err = love.filesystem.load(_path)
    if err then
        error(err)
    end
end

function Andromeda:queueLoad(_folder)
    local data = _doScanFolder(_folder)
    table.insert(self.queue, data)
end

function Andromeda:initialize()
    local imgExt = { "png", "jpg", "gif", "jpeg", "tga", "bmp" }
    local audioExt = { "mp3", "wav", "midi", "ogg" }
    local videoExt = { "ogv" }
    local coolTypes = { "nil", "boolean", "number", "string", "table" }

    _countItems(self)

    local _create = setfenv(self.screen().create, self.env)
    local _present = setfenv(self.screen().present, self.env)

    _create(Andromedapath)

    for q = 1, #self.queue, 1 do
        for p = 1, #self.queue[q], 1 do
            local curPath = self.queue[q][p]
            local ext = curPath:match("[^.]+$")

            local rawFilename = (curPath:match("[^/]+")):gsub("%.[^.]+$", "")
            local filename = rawFilename:gsub(" ", "_")
            if _contains(imgExt, ext) then
                self.poll.image[filename] = love.graphics.newImage(curPath)
            end
            if _contains(audioExt, ext) then
                self.poll.audio[filename] = love.audio.newSource(curPath, "static")
            end
            if _contains(videoExt, ext) then
                self.poll.video[filename] = love.graphics.newVideo(curPath)
            end
            love.graphics.clear(0, 0, 0)
                _present(self.progress, self.max)
                self.progress = self.progress + 1
            love.graphics.present()
        end
    end

    -- clear the mess --
    for k, v in pairs(self.env) do
        if not _contains(coolTypes, type(v)) then
            self.env[k]:release()
        end
    end
end

return Andromeda