package.path = package.path .. ";/www/custom/function/?.lua;"
    require "parameter"
    --local subnet =  "192.168.8." 

ngx.header["Content-type"] = 'text/html'
ngx.req.read_body()
local args, err = ngx.req.get_uri_args()
--local args, err = ngx.req.get_post_args()
if not args then
    ngx.say("failed to get post args: ", err)
    return
end



local menu = args['menu']
if not menu  then
    menu = ''
end

switch = function (choice)
    -- accepts both number as well as string
    choice = choice and tonumber(choice) or choice     -- returns a number if the choic is a number or string. 
  
    -- Define your cases
    case =
     {
        dns = function ( )                              
            --open(read_file('/etc/config/dhcp'))
            local file = io.open( "/etc/config/dhcp", "a" )
            local ip = string.match(args['ip'],"[0-9]+")
            local domain = string.match(args['sub'],"[a-zA-Z0-9]+") .. "." .. string.match(args['domain'],"[a-zA-Z0-9]+")
            file:write( "config domain\n        option ip '".. subnet .."".. ip .."'\n        option name '".. domain ..".nuc.lan'\n" )
            file:close()
            io.popen("/etc/init.d/dnsmasq restart")
            io.close()
            ngx.print(read_file('/www/custom/content/' .. string.match(menu,"[a-zA-Z0-9]+") .. '.html'))
        end,
  
        dhcp = function ( )   
            
            file = io.open("/tmp/dhcp.leases","r")
            for line in file:lines() do

                local match = string.match(line , " [0-9.]+ [a-zA-Z0-9\-\*]+")

                local ip =  string.match(match, "[0-9]+ ")

                local domain = string.match( all_trim(match)  , " [a-zA-Z0-9\-\*]+")
                ngx.print("<option value="..ip..">"..domain.." ( 192.168.8.".. ip .." )</option>" ) 
                end
            file:close()
       end, 
    
       host = function ( )   
            
        file = io.open("/tmp/dhcp.leases","r")
        for line in file:lines() do

            local match = string.match(line , " [0-9.]+ [a-zA-Z0-9\-\*]+")

            local ip =  string.match(match, "[0-9]+ ")

            local domain = string.match( all_trim(match)  , " [a-zA-Z0-9\-\*]+")
            ngx.print("<option value="..domain..">."..all_trim(domain)..".nuc.lan ( 192.168.8.".. ip .." )</option>" ) 
            end
        file:close()
        
        end,                                              
       video = function ( ) 
            ngx.print(read_file('/tmp/video.json'))
       end,                                            -- break statement

       default = function ( )                          -- default case
               ngx.print(" your choice is din't match any of those specified cases")   
       end,                                            -- u cant exclude end hear :-P
     }
  
    -- execution section
    if case[choice] then
       case[choice]()
    else
       case["default"]()
    end
end

switch( menu )