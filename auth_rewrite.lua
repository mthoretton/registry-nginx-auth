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

function get_auth_params()
  local params = {}

  params = ngx.req.get_headers()
  if params["Authorization"] then
    local m = ngx.re.match(params["Authorization"], "Basic\\s(.+)")
    if m then
      params.user_key = m[1]
    end
  end

  return first_values(params)
end


function M.get_token()
  if ngx.var.http_Authorization ~= nil then
    local bauth = get_auth_params().user_key
    bauth = basexx.from_base64(bauth)

    if split(bauth, ":")[1] == "gygdev-token" then
      local token = split(bauth, ":")[2]
      ngx.req.set_header('AUTHORIZATION', "Bearer " .. token)
    end
  else
    ngx.req.set_header("WWW-Authenticate", "Basic realm=\"gyg docker registry\"")
    ngx.status = 401
    ngx.exit(ngx.OK)
  end
end

return M
