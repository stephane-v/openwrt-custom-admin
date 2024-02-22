package.path = package.path .. ";/www/custom/function/?.lua;"
    require "parameter"
ngx.req.read_body()
local args, err = ngx.req.get_uri_args()

if not args then
    ngx.say("failed to get post args: ", err)
    return
end
--     location = /api {
--        content_by_lua_file /www/custom/api.lua;
--    }


local menu = args['menu']
if not menu  then
    menu = ''
end

switch = function (choice)

    choice = choice and tonumber(choice) or choice     -- returns a number if the choic is a number or string. 
  
    -- Define your cases
    case =
    {
        wol = function ( )
            ngx.header["Content-type"] = 'text/xml'

            ngx.print("<wol>"..wakeonlan (arp).."</wol>" )
        end,
        sleep = function ( )
            ngx.header["Content-type"] = 'text/xml'
            --ngx.print("<ip>"..ipfromarp (arp).."</ip>"  )
            local ip = ipfromarp (arp)
            ngx.print("<sleep>"..sshcommand( ip , "/usr/bin/standby") .. "</sleep>")

        end,
        host = function ( )
        
        end,
        video = function ( )
            ngx.header["Content-type"] = 'text/xml'
            -- 0 * * * * /usr/sbin/tree -X /mnt/video/ > /tmp/video.xml
            -- (inside /tmp/video.xml in case of power loose during write on sdcard can )
            ngx.print(read_file('/tmp/video.xml'))
        end,
        default = function ( )   
            ngx.header["Content-type"] = 'text/xml'
            ngx.print('<numbers>')
            ngx.print('<number>'..'numbers'..'</number>')
            ngx.print('<number>'..'numbers'..'</number>')
            ngx.print('</numbers>')
       end,
     }

    -- execution section
    if case[choice] then
       case[choice]()
    else
       case["default"]()
    end
end

switch( menu )
