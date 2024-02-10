subnet =  "192.168.8." 
if not string.match(ngx.var.remote_addr , "192.168.8." ) then
    ngx.exit(ngx.HTTP_FORBIDDEN)
    
end
function read_file(path)
    local open = io.open
    local file = open(path, "r") -- r read mode and b binary mode
    if not file then return 'not found '.. path end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end
function all_trim(s)
    return s:match( "^%s*(.-)%s*$" )
end
function dirLookup(dir)
    ngx.print("<div class='menu left'><ul>")
    local p = io.popen('ls "'..dir..'" | sed \'s/\.[^.]*$//\'')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.     
    for file in p:lines() do                         --Loop through all files
        ngx.print("<li><a href=?menu="..file.."> "..file.."</a></li>")       
    end
    ngx.print("</ul></div>")
 end
 function dirLookupdb(dir, menu)
    local p = io.popen('ls "'..dir..'" | sed \'s/\.[^.]*$//\'')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.     
    for file in p:lines() do                         --Loop through all files
        ngx.print("<option value="..file.."> "..file.."</option>")       
    end
end
function listingtable(dir)
    local p = io.popen('ls "'..dir..'" | sed \'s/\.[^.]*$//\'')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.     
    for file in p:lines() do                         --Loop through all files
        ngx.print("<option value="..file.."> "..file.."</option>")       
    end
end