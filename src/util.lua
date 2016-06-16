if _G.file == nil then
    _G.file = {};
end

--- splits the a
-- @param filePath into
-- @return direcotry, filename, fileExtention
-- filename does include fileExtention
_G.file.splitPath = function(filePath)
    return filePath:match("(.-)([^\\/]-%.?([^%.\\/]*))$");
end;

_G.file.getExtention = function(fileName)
    local _, _, extention = _G.file.splitPath(fileName)
    return extention;
end;

_G.file.getPath = function(filePath)
    local path, _, _ = _G.file.splitPath(filePath);
    return path;
end

_G.file.getFilename = function(filePath)
    local _, fileName, _ = _G.file.splitPath(filePath);
    return fileName;
end

---
-- @param fileName
-- @retun fileName without fileExtention
_G.file.getName = function(fileName)
    local _, fileName, _ = _G.file.splitPath(fileName)
    return fileName:match("(.+)%..+");
end;
