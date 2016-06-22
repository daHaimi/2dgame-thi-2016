if _G.file == nil then
    _G.file = {};
end

--- splits filePath into directory, filename and fileExtention
-- filename does include fileExtention
-- @param filePath the source file path
-- @return the directory without filename
-- @return the filename including fileExtention
-- @return the extension of the filename
_G.file.splitPath = function(filePath)
    return filePath:match("(.-)([^\\/]-%.?([^%.\\/]*))$");
end;

--- returns the file extension from fileName
-- @param fileName the file name optionally with path
-- @return the extension of the file
_G.file.getExtention = function(fileName)
    local _, _, extention = _G.file.splitPath(fileName);
    return extention;
end;

--- returns only the path from filePath
-- @param filePath the path to the file
-- @return the path without the filename
_G.file.getPath = function(filePath)
    local path, _, _ = _G.file.splitPath(filePath);
    return path;
end

--- returns only the filename from filePath
-- @param filePath the path to the file
-- @return the filename with extension
_G.file.getFilename = function(filePath)
    local _, fileName, _ = _G.file.splitPath(filePath);
    return fileName;
end

--- returns only the filename without extension from filePath
-- @param filePath the filename optionally with path
-- @return the filename without extension
_G.file.getName = function(filePath)
    local _, fileName, _ = _G.file.splitPath(filePath);
    return fileName:match("(.+)%..+");
end;
