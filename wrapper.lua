local basexx = require "basexx"

local M = {}

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function first_values(a)
  r = {}
  for k,v in pairs(a) do
    if type(v) == "table" then
      r[k] = v[1]
    else
      r[k] = v
    end
  end
  return r
end

function get_auth_params(where, method)
  local params = {}
  if where == "headers" then
    params = ngx.req.get_headers()

  elseif where == "basicauth" then
    params = ngx.req.get_headers()
    if params["Authorization"] then
      local m = ngx.re.match(params["Authorization"], "Basic\\s(.+)")
      if m then
        params.user_key = m[1]
      end
    end

  elseif method == "HTTP_GET" then
    params = ngx.req.get_uri_args()
  else
    ngx.req.read_body()
    params = ngx.req.get_post_args()
  end

   return first_values(params)
end


function M.get_token()
  if ngx.var.http_Authorization ~= nil then
    local bauth = get_auth_params("basicauth", ngx.var.request_method).user_key
    bauth = basexx.from_base64(bauth)

    if split(bauth, ":")[1] == "gygdev-token" then
      local token = split(bauth, ":")[2]
      ngx.req.set_header('AUTHORIZATION', "Bearer " .. token)
    end
  end
end

return M
