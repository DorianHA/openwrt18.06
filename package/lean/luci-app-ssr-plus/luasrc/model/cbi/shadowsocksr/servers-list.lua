-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local shadowsocksr = "shadowsocksr"

local uci = luci.model.uci.cursor()
local server_count = 0
uci:foreach("shadowsocksr", "servers", function(s)
  server_count = server_count + 1
end)

local fs  = require "nixio.fs"
local sys = require "luci.sys"

m = Map(shadowsocksr)
m:section(SimpleSection).template  = "shadowsocksr/status2"


-- [[ Servers Manage ]]--
s = m:section(TypedSection, "servers")
s.anonymous = true
s.addremove = true
s.description = string.format(translate("Server Count") ..  ": %d", server_count)
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = luci.dispatcher.build_url("admin/Internet/shadowsocksr/servers/%s")
function s.create(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(s.extedit % sid)
		return
	end
end

o = s:option(DummyValue, "alias", translate("Alias"))
o.width="10%"
o = s:option(DummyValue, "type", translate("Type"))
o.width="15%"

o = s:option(DummyValue, "server", translate("Server Address"))
o.width="10%"

o = s:option(DummyValue, "server_port", translate("Server Port"))
o.width="10%"

o = s:option(DummyValue, "encrypt_method", translate("Encrypt Method"))
o.width="10%"

o = s:option(DummyValue, "protocol", translate("Protocol"))
o.width="10%"
o = s:option(DummyValue, "obfs", translate("Obfs"))
o.width="10%"

o = s:option(Flag, "switch_enable", translate("Enable Auto Switch"))
o.width="10%"

if nixio.fs.access("/usr/bin/kcptun-client") then

o = s:option(Flag, "kcp_enable", translate("KcpTun"))
o.width="10%"
end

o = s:option(DummyValue, "server_port", translate("Socket Connected"))
o.template="shadowsocksr/socket"
o.width="10%"

o = s:option(DummyValue,"server",translate("Ping Latency"))
o.template="shadowsocksr/ping"
o.width="10%"

m:append(Template("shadowsocksr/server_list"))

return m
