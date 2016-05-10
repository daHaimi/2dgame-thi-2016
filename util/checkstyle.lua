require "lfs"

local checks = {
    lineLength = 80,
    tabChars = 4,
    allowTabs = false,
    encoding = "utf8",
    operatorSpaces = true, -- false = no spaces, true = both
    lineEnding = "\n",
    variables = "_?[a-z]+([A-Z]+[a-z]?)+", -- Lower Camel case
    variables = "_?[a-z]+([A-Z]+[a-z]?)+", -- Lower Camel case
    classNames = "([A-Z]+[a-z]?)+", --Upper Camel case
    linesBetweenFunctions = 1,
    docBlock = true,
    functionLen = 20
};

local operatorsWsp = {
    "==", "~=", "<=", ">=", "<", ">", "=",
    "+", "-", "*", "/", "%", ".."
};
local operatorsWspBefore = {"#"};
local operatorsWspAfter = {","};

local indentKeywords = {"for", "if", "function", "do", "while"};

function dirtree(dir)
  assert(dir and dir ~= "", "directory parameter is missing or empty")
  if string.sub(dir, -1) == "/" then
    dir=string.sub(dir, 1, -2)
  end

  local function yieldtree(dir)
    for entry in lfs.dir(dir) do
      if entry ~= "." and entry ~= ".." then
        entry=dir.."/"..entry
    local attr=lfs.attributes(entry)
    coroutine.yield(entry,attr)
    if attr.mode == "directory" then
    yieldtree(entry)
    end
      end
    end
  end

  return coroutine.wrap(function() yieldtree(dir) end)
end

function checkEncoding(content)
    return pcall(content.decode(checks.encoding)); 
end

function checkLineLength(line)
    return line:len() <= checks.lineLength;
end

function checkstyle(filename)
    local fileProblems = {};
    local content = readAll(filename);
    -- File checks
    fileProblems["encoding"] = checkEncoding(content);
    
    local lineNum = 0;
    fileProblems["lineLength"] = {};
    for line in string.gmatch(foo, ".*$")
        -- Line checks
        fileProblems["lineLength"][lineNum] = checkLineLength(line);
        
        lineNum = lineNum + 1;
    end
end

function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

problems = {};
for filename, attr in dirtree(arg[1]) do
    if attr.mode == file then
        problems[filename] = checkstyle(filename);
    end
end
