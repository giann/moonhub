local function a(b,c,d)if c==nil then return b elseif type(c)~='table'then return c elseif d[c]then return d[c]end;d[c]=b;for e,f in pairs(c)do e=a({},e,d)if b[e]==nil then b[e]=a({},f,d)end end;return b end;local function g(h,i)return a(h,i,{})end;local function j(i)return setmetatable(g({},i),getmetatable(i))end;local function k(h)h=h or{}local l=h.__includes or{}if getmetatable(l)then l={l}end;for m,i in ipairs(l)do if type(i)=="string"then i=_G[i]end;g(h,i)end;h.__index=h;h.init=h.init or h[1]or function()end;h.include=h.include or g;h.clone=h.clone or j;return setmetatable(h,{__call=function(n,...)local o=setmetatable({},n)o:init(...)return o end})end;if class_commons~=false and not common then common={}function common.class(p,q,r)return k{__includes={q,r}}end;function common.instance(h,...)return h(...)end end;return setmetatable({new=k,include=g,clone=j},{__call=function(m,...)return k(...)end})