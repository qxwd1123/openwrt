module("luci.controller.new_log", package.seeall)


function index()

	local page

	page = entry({"admin", "status", "read_log"}, call("read_log"),nil)

	page = entry({"admin", "status", "new_log"}, template("new_log"),_("LOG"),30)


end



function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


-- read_log & read_raw_log is for LOG page
function read_log()
	local re =""
	local path = luci.dispatcher.context.requestpath
	local rv   = { }
	
	
	rv[#rv+1]=read_raw_log("default");

	if #rv > 0 then
		luci.http.prepare_content("application/json")
		luci.http.write_json(rv)
				return
	end

	luci.http.status(404, "No such device")
end

function read_raw_log(s)
	re = {}
	count=0;

	if (s == "default") then
		os.execute("logread> /tmp/raw_log")
	end
	local f = io.open("/tmp/raw_log","r")
	if f~=nil then 
		for line in f:lines() do 
			re[#re+1]=line 
		end
		f:close()
	end
	
	if #re>1 then 
		os.execute("rm -f /tmp/raw_log &") 
		return table.concat(re,"\r\n")
	end
	return ""
end