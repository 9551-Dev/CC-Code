local path = fs.getDir(select(2,...) or "")
local oldpath = package.path
package.path = string.format("%s;/%s/?.lua;/%s/?/init.lua", package.path, path, path)
local base = require("main")
package.path = oldpath

return function(tbl, fileout)
    -- fileout will be a file handle, make sure to close it when your done
    -- tbl will just be a regular table with the data to be encoded
    -- the function should take the table and write the correct format to the file
    -- intermediate format is map[layer][y][x] = { background, foreground, text }
    -- background and foreground are both blit values
end