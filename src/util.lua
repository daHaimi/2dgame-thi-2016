if _G.love.file == nil then
    _G.love.file = {};
end

--- splits the a
-- @param filePath into
-- @return direcotry, filename, fileExtention
-- filename does include fileExtention
_G.love.file.splitPath = function(filePath)
    return filePath:match("(.-)([^\\/]-%.?([^%.\\/]*))$");
end;

_G.love.file.getExtention = function(fileName)
    local _, _, extention = _G.love.file.splitPath(fileName)
    return extention;
end;

_G.love.file.getPath = function(filePath)
    local path, _, _ = _G.love.file.splitPath(filePath);
    return path;
end

_G.love.file.getFilename = function(filePath)
    local _, fileName, _ = _G.love.file.splitPath(filePath);
    return fileName;
end

---
-- @param fileName
-- @retun fileName without fileExtention
_G.love.file.getName = function(fileName)
    local _, fileName, _ = _G.love.file.splitPath(fileName)
    return fileName:match("(.+)%..+");
end;
