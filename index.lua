
package.path = package.path .. ";/www/custom/function/?.lua;"
require "parameter"
--if not string.match(ngx.var.remote_addr , "192.168.8.") then
--    ngx.exit(ngx.HTTP_FORBIDDEN)
--end
 local args, err = ngx.req.get_uri_args()
 local menu = args['menu']
 if not menu  then
     menu = 'home'
 end

 ngx.header["Content-type"] = 'text/html'
 ngx.print(read_file('/www/custom/template/header.html'))
  dirLookup('/www/custom/content/')

 ngx.print("<div class=''>"..read_file('/www/custom/content/' .. string.match(menu,"[a-zA-Z0-9]+") .. '.html').."</div>")
 ngx.print('<br/>Your IP : '..ngx.var.remote_addr)
 ngx.print(read_file('/www/custom/template/footer.html'))
