class 'UnlockList'

function UnlockList:__init()
	print("Initializing UnlockList")
	self:RegisterVars()
	self:RegisterEvents()
end
function UnlockList:RegisterVars()
	self.unlockList = {}
	self.mode = "all"
end
function UnlockList:RegisterEvents()
	RCON:RegisterCommand("vars.unlockMode", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args ~= nil then
			if args[1] == "all" then
				self.mode = "all"
				local sendMode = {}
				sendMode[1] = "all"
				NetEvents:Broadcast("Server:UnlockMode", sendMode)
				return {'OK', self.mode}
			elseif args[1] == "whitelist" then
				self.mode = "whitelist"
				local sendMode = {}
				sendMode[1] = "whitelist"
				NetEvents:Broadcast("Server:UnlockMode", sendMode)
				return {'OK', self.mode}
			elseif args[1] == "blacklist" then
				self.mode = "blacklist"
				local sendMode = {}
				sendMode[1] = "blacklist"
				NetEvents:Broadcast("Server:UnlockMode", sendMode)
				return {'OK', self.mode}
			else
				return {'OK', self.mode}
			end
		else
			return {'OK', self.mode}
		end
	end)
	RCON:RegisterCommand("unlockList.add", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args ~= nil then
			local sendAdd = {}
			sendAdd[1] = args[1]
			table.insert(self.unlockList, args[1])
			NetEvents:Broadcast("Server:UnlockListAdd", sendAdd)
			return {'OK'}
		else
			return {'InvalidArguments'}
		end
	end)
	RCON:RegisterCommand("unlockList.remove", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		local weaponAlreadyInList = false
		if args ~= nil then
			local sendRemove = {}
			sendRemove[2] = args[1]
			for index,weapon in pairs(self.unlockList) do
				if weapon == args[1] then	
					weaponAlreadyInList = true
					sendRemove[1] = index
				end
			end
			if weaponAlreadyInList == true then
				table.remove(self.unlockList, sendRemove[1])
				NetEvents:Broadcast("Server:UnlockListRemove", sendRemove)
				return {'OK'}
			else
				return {'NotInList'}
			end
		else
			return {'InvalidArguments'}
		end
	end)
	RCON:RegisterCommand("unlockList.clear", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.unlockList = {}
		NetEvents:Broadcast("Server:UnlockListClear")
		return {'OK'}
	end)
	RCON:RegisterCommand("unlockList.set", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args ~= nil then
			self.unlockList = args
			NetEvents:Broadcast("Server:UnlockListSet", self.unlockList)
			return {'OK'}
		else
			return {'InvalidArguments'}
		end
	end)
	RCON:RegisterCommand("unlockList.list", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		local listUnlockList = {'OK'}
		for _,item in pairs(self.unlockList) do
			table.insert(listUnlockList, item)
		end
		return listUnlockList
	end)
	RCON:RegisterCommand('unlockList.save', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if not SQL:Open() then
			return
		end
		local query = [[DROP TABLE IF EXISTS unlock_table]]
		if not SQL:Query(query) then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end
		query = [[
		  CREATE TABLE IF NOT EXISTS unlock_table (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			text_value TEXT
		  )
		]]
		if not SQL:Query(query) then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end
		query = 'INSERT INTO unlock_table (text_value) VALUES (?)'
		for _,unlockListItem in pairs(self.unlockList) do
			if not SQL:Query(query, unlockListItem) then
			  print('Failed to execute query: ' .. SQL:Error())
			  return
			end
		end
		
		-- Fetch all rows from the table.
		results = SQL:Query('SELECT * FROM unlock_table')

		if not results then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end

		SQL:Close()
		return {'OK'}
	end)
	RCON:RegisterCommand('unlockList.load', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if not SQL:Open() then
			return
		end
		
		local query = [[
		  CREATE TABLE IF NOT EXISTS unlock_table (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			text_value TEXT
		  )
		]]
		if not SQL:Query(query) then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end
		
		-- Fetch all rows from the table.
		results = SQL:Query('SELECT * FROM unlock_table')

		if not results then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end

		self.unlockList = {}
		-- Print the fetched rows.
		for _, row in pairs(results) do
			table.insert(self.unlockList, row["text_value"])
		end
		NetEvents:Broadcast("Server:UnlockListSet", self.unlockList)
		SQL:Close()
		return {'OK'}
	end)
	Events:Subscribe('Player:Authenticated', function(player)
		local sendMode = {}
		sendMode[1] = self.mode
		NetEvents:SendTo("Server:GetUnlockMode", player, sendMode)
		NetEvents:SendTo("Server:GetUnlockList", player, self.unlockList)
	end)
end

g_UnlockList = UnlockList()