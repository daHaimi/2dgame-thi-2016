--[[
  Save Table to File
  Load Table from File
  v 1.0

  Lua 5.2 compatible

  Only Saves Tables, Numbers and Strings
  Insides Table References are saved
  Does not save Userdata, Metatables, Functions and indices of these
  ----------------------------------------------------
  table.save( table , filename )

  on failure: returns an error msg

  ----------------------------------------------------
  table.load( filename or stringtable )

  Loads a table that has been saved via the table.save function

  on success: returns a previously saved table
  on failure: returns as second argument an error msg
  ----------------------------------------------------

  Licensed under the same terms as Lua itself.

  v 1.1 (Mathias Haimerl)
  Removed file saving, only exporting as string
  Added LuaDoc compatible comments
]]--
do
  --- Escapes a String and puts quotes around
  -- @param s String to escape
  -- @return A "Lua" portable version of the string
  local function exportstring( s )
    return string.format("%q", s)
  end

  --- The serialize Function
  -- @param tbl The Table to be exported
  -- @return a "return"-prefixed string repesentation of the input table
  function table.serialize( tbl )
    local charS,charE = "   ","\n"
    local retStr = "";

    -- initiate variables for save procedure
    local tables,lookup = { tbl },{ [tbl] = 1 }
    retStr = retStr .. "return {"..charE;

    for idx,t in ipairs( tables ) do
      retStr = retStr .. "-- Table: {"..idx.."}"..charE;
      retStr = retStr .. "{"..charE;
      local thandled = {}

      for i,v in ipairs( t ) do
        thandled[i] = true
        local stype = type( v )
        -- only handle value
        if stype == "table" then
          if not lookup[v] then
            table.insert( tables, v )
            lookup[v] = #tables
          end
          retStr = retStr .. charS.."{"..lookup[v].."},"..charE;
        elseif stype == "string" then
          retStr = retStr .. charS..exportstring( v )..","..charE;
        elseif stype == "number" then
          retStr = retStr .. charS..tostring( v )..","..charE;
        elseif stype == "boolean" then
          retStr = retStr .. charS..tostring( v )..","..charE;
        end
      end

      for i,v in pairs( t ) do
        -- escape handled values
        if (not thandled[i]) then

          local str = ""
          local stype = type( i )
          -- handle index
          if stype == "table" then
            if not lookup[i] then
              table.insert( tables,i )
              lookup[i] = #tables
            end
            str = charS.."[{"..lookup[i].."}]="
          elseif stype == "string" then
            str = charS.."["..exportstring( i ).."]="
          elseif stype == "number" then
            str = charS.."["..tostring( i ).."]="
          elseif stype == "boolean" then
            str = charS.."["..tostring( i ).."]="
          end

          if str ~= "" then
            stype = type( v )
            -- handle value
            if stype == "table" then
              if not lookup[v] then
                table.insert( tables,v )
                lookup[v] = #tables
              end
              retStr = retStr .. str.."{"..lookup[v].."},"..charE;
            elseif stype == "string" then
              retStr = retStr .. str..exportstring( v )..","..charE;
            elseif stype == "number" then
              retStr = retStr .. str..tostring( v )..","..charE;
            elseif stype == "boolean" then
              retStr = retStr .. str..tostring( v )..","..charE;
            end
          end
        end
      end
      retStr = retStr .. "},"..charE;
    end
    retStr = retStr .. "}";
    return retStr;
  end

  --- The deserialize Function
  -- @param str The Table serialized to string
  -- @return a table
   function table.deserialize(str)
      local ftables = loadstring( str )
      local tables = ftables()
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] = tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end

end