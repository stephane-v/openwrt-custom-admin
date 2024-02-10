package.path = package.path .. ";/www/custom/function/?.lua;"
    require "parameter"



ngx.req.read_body()

local args, err = ngx.req.get_post_args()
if not args then
    ngx.say("failed to get post args: ", err)
    return
end
ngx.header["Content-type"] = 'text/html'

local menu = string.match(args['menu'],"[a-zA-Z0-9]+")

if menu  == 'sqlite' then
    local dbname = string.match(args['db'],"[a-zA-Z0-9]+")
    if not dbname  then
        dbname = 'default'
    end
    local action = string.match(args['action'],"[a-zA-Z0-9]+")
    if not action  then
        action = 'read'
    end
    local table = string.match(args['table'],"[a-zA-Z0-9]+")
    if not table  then
        table = 'default'
    end
    local data = args['data']
    if not data  then
        data = ''
    end

    local db = sqlite3.open('/www/custom/db/'..dbname..'.db', sqlite3.OPEN_READWRITE + sqlite3.OPEN_CREATE + sqlite3.OPEN_SHAREDCACHE)
    if action == 'list' then

        dirLookupdb('/www/custom/db' , 'sqlite')
    end
    if action == 'listtable' then


        
        for a in db:nrows("SELECT * FROM sqlite_schema WHERE type ='table' AND name NOT LIKE 'sqlite_%'") do 

            if a then
                ngx.print('<option value="'..a.name..'">')
                ngx.print( a.name)
                ngx.print('</options>') 
            end
        end   
    end
    if action == 'read' then
        for a in db:rows('SELECT * FROM '.. table) do ngx.print( a)
            ngx.print('<br/>') end     
    end
    if action == 'insert' then
        ngx.print('<done/>')
        db:exec('INSERT INTO '.. table .. ' VALUES ('..data..');')
    end
    if action == 'update' then
        ngx.print('<done/>')
        db:exec('UPDATE INTO '..table..' VALUES ('..data..');')
    end
    if action == 'create' then
        db:exec('CREATE TABLE '..table..' ('..data..');')
    end
    
end
