class 'TextChatModeration'

function TextChatModeration:__init()
	print("Initializing TextChatModeration")
	self:RegisterVars()
	self:RegisterEvents()
	self:RegisterCommands()
end
function TextChatModeration:RegisterVars()
	self.textChatModerationList = { }
	self.playerFound = false
	self.playerAlreadyMuted = false
	self.playerAlreadyAdmin = false
	self.playerAlreadyVoice = false
	self.playerAlreadyInList = false
	self.playerName = nil
	self.textChatModerationMode = "free"
	self.index = nil
	self.chatSettings = nil
end
function TextChatModeration:RegisterCommands()
	RCON:RegisterCommand("textChatModerationList.addPlayer", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.playerName = nil
		self.playerAlreadyInList = false
		self.playerAlreadyAdmin = false
		self.playerAlreadyMuted = false
		self.playerAlreadyVoice = false
		self.index = nil
		self.playerFound = false
		if args[1] == "muted" then	
			if args[2] ~= nil then	
				self.playerName = args[2]	
				for index,mutedPlayer in pairs(self.textChatModerationList) do
					if mutedPlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
						if mutedPlayer:gsub("(.*):.*$","%1") == "muted" then
							self.playerAlreadyMuted = true
						else
							self.playerAlreadyMuted = false
						end
					end
					
				end
				if self.playerAlreadyInList == false then
					table.insert(self.textChatModerationList, "muted:"..self.playerName)
					local sendMuted = {}
					sendMuted[1] = "muted:"..self.playerName
					NetEvents:Broadcast("Server:AddPlayer", sendMuted)
					return {'OK',args[1], args[2]}
				elseif self.playerAlreadyInList == true then
					if self.playerAlreadyMuted == true then
						return {'PlayerAlreadyMuted'}
					elseif self.playerAlreadyMuted == false then
						self.textChatModerationList[self.index] = "muted:"..self.playerName
						local sendMuted = {}
						sendMuted[1] = self.index
						sendMuted[2] = "muted:"..self.playerName
						NetEvents:Broadcast("Server:OverWritePlayer", sendMuted)
						return {'OK'}
					end
				end
			else
				return {'InvalidArguments'}
			end
		elseif args[1] == "admin" then	
			if args[2] ~= nil then	
				self.playerName = args[2]	
				for index,adminPlayer in pairs(self.textChatModerationList) do
					if adminPlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
						if adminPlayer:gsub("(.*):.*$","%1") == "admin" then
							self.playerAlreadyAdmin = true
						else
							self.playerAlreadyAdmin = false
						end
					end
					
				end
				if self.playerAlreadyInList == false then
					table.insert(self.textChatModerationList, "admin:"..self.playerName)
					local sendAdmin = {}
					sendAdmin[1] = "admin:"..self.playerName
					NetEvents:Broadcast("Server:AddPlayer", sendAdmin)
					return {'OK',args[1], args[2]}
				elseif self.playerAlreadyInList == true then
					if self.playerAlreadyAdmin == true then
						return {'PlayerAlreadyAdmin'}
					elseif self.playerAlreadyAdmin == false then
						self.textChatModerationList[self.index] = "admin:"..self.playerName
						local sendAdmin = {}
						sendAdmin[1] = self.index
						sendAdmin[2] = "admin:"..self.playerName
						NetEvents:Broadcast("Server:OverWritePlayer", sendAdmin)
						return {'OK'}
					end
				end
			else
				return {'InvalidArguments'}
			end
		elseif args[1] == "voice" then	
			if args[2] ~= nil then	
				self.playerName = args[2]
				for index,voicePlayer in pairs(self.textChatModerationList) do
					if voicePlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
						if voicePlayer:gsub("(.*):.*$","%1") == "voice" then
							self.playerAlreadyVoice = true
						else
							self.playerAlreadyVoice = false
						end
					end
					
				end
				if self.playerAlreadyInList == false then
					table.insert(self.textChatModerationList, "voice:"..self.playerName)
					local sendVoice = {}
					sendVoice[1] = "voice:"..self.playerName
					NetEvents:Broadcast("Server:AddPlayer", sendVoice)
					return {'OK',args[1], args[2]}
				elseif self.playerAlreadyInList == true then
					if self.playerAlreadyVoice == true then
						return {'PlayerAlreadyVoice'}
					elseif self.playerAlreadyVoice == false then
						self.textChatModerationList[self.index] = "voice:"..self.playerName
						local sendVoice = {}
						sendVoice[1] = self.index
						sendVoice[2] = "voice:"..self.playerName
						NetEvents:Broadcast("Server:OverWritePlayer", sendVoice)
						return {'OK'}
					end
				end
			else
				return {'InvalidArguments'}
			end
		elseif args[1] == "normal" then	
			if args[2] ~= nil then	
				self.playerName = args[2]
				for index,normalPlayer in pairs(self.textChatModerationList) do
					if normalPlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
					end	
				end
				if self.playerAlreadyInList == true then
					table.remove(self.textChatModerationList, self.index)
					local sendNormal = {}
					sendNormal[1] = self.index
					NetEvents:Broadcast("Server:RemovePlayer", sendNormal)
					return {'OK'}
				else
					return {'OK'}
				end
			end
		else
			return {'InvalidArguments'}
		end
	end)
	RCON:RegisterCommand("textChatModerationList.removePlayer", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.playerName = nil
		self.index = nil
		self.playerFound = false
		self.playerAlreadyInList = false
		self.playerName = args[1]
		for index,textChatPlayer in pairs(self.textChatModerationList) do
			if textChatPlayer:gsub(".+:","") == self.playerName then	
				self.playerAlreadyInList = true
				self.index = index
			end
		end
		if self.playerAlreadyInList == true then
			table.remove(self.textChatModerationList, self.index)
			local sendTextChatPlayer = {}
			sendTextChatPlayer[1] = self.index
			sendTextChatPlayer[2] = self.playerName
			NetEvents:Broadcast("Server:RemovePlayer", sendTextChatPlayer)
			return {'OK', args[2]}
		elseif self.playerAlreadyInList == false then
			return {'PlayerNotInList'}
		end
	end)
	local skipNext = false
	RCON:RegisterCommand("textChatModerationList.list", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if skipNext == false then
			listMutedPlayers = {'OK', 0}
			length = 0
			local parts = nil
			for _,mutedPlayer in pairs(self.textChatModerationList) do
				parts = mutedPlayer:split(':')
				table.insert(listMutedPlayers, parts[1])
				table.insert(listMutedPlayers, parts[2])
				length = length + 1
			end
			listMutedPlayers[2] = tostring(length)
			if length > 0 then
				skipNext = true
			end
			return listMutedPlayers
		else
			skipNext = false
			return {'OK', '0'}
		end
	end)
	RCON:RegisterCommand("textChatModerationList.clear", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.textChatModerationList = { }
		NetEvents:Broadcast("Server:ClearList")
		return {'OK'}
	end)
	RCON:RegisterCommand('textChatModerationList.save', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if not SQL:Open() then
			return
		end
		local query = [[DROP TABLE IF EXISTS test_table]]
		if not SQL:Query(query) then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end
		query = [[
		  CREATE TABLE IF NOT EXISTS test_table (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			text_value TEXT
		  )
		]]
		if not SQL:Query(query) then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end
		query = 'INSERT INTO test_table (text_value) VALUES (?)'
		for _,textChatModerationListItem in pairs(self.textChatModerationList) do
			if not SQL:Query(query, textChatModerationListItem) then
			  print('Failed to execute query: ' .. SQL:Error())
			  return
			end
		end
		
		-- Fetch all rows from the table.
		results = SQL:Query('SELECT * FROM test_table')

		if not results then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end

		SQL:Close()
		return {'OK'}
	end)
	RCON:RegisterCommand('textChatModerationList.load', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if not SQL:Open() then
			return
		end
		
		local query = [[
		  CREATE TABLE IF NOT EXISTS test_table (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			text_value TEXT
		  )
		]]
		if not SQL:Query(query) then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end
		
		-- Fetch all rows from the table.
		results = SQL:Query('SELECT * FROM test_table')

		if not results then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end

		self.textChatModerationList = {}
		-- Print the fetched rows.
		for _, row in pairs(results) do
			table.insert(self.textChatModerationList, row["text_value"])
		end
		NetEvents:Broadcast("Server:LoadList", self.textChatModerationList)
		SQL:Close()
		return {'OK'}
	end)
	RCON:RegisterCommand("vars.textChatModerationMode", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then
			if args[1] == "free" then
				self.textChatModerationMode = "free"
				sendMode = {}
				sendMode[1] = "free"
				NetEvents:Broadcast("Server:TextChatModerationMode", sendMode)
				return {'OK', self.textChatModerationMode}
			elseif args[1] == "moderated" then
				self.textChatModerationMode = "moderated"
				sendMode = {}
				sendMode[1] = "moderated"
				NetEvents:Broadcast("Server:TextChatModerationMode", sendMode)
				return {'OK', self.textChatModerationMode}
			elseif args[1] == "muted" then
				self.textChatModerationMode = "muted"
				sendMode = {}
				sendMode[1] = "muted"
				NetEvents:Broadcast("Server:TextChatModerationMode", sendMode)
				return {'OK', self.textChatModerationMode}
			else
				return {'InvalidArguments'}
			end
		else
			return {'OK', self.textChatModerationMode}
		end
	end)
	RCON:RegisterCommand("vars.textChatSpamTriggerCount", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then
			if tonumber(args[1]) == math.floor(tonumber(args[1])) and tonumber(args[1])>= 0 then
				AntiSpamConfig(self.chatSettings.antiSpam).detectionIntervalMaxMessageCount = tonumber(args[1])
				return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionIntervalMaxMessageCount)}
			else
				return {'InvalidArguments'}
			end
		else
			return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionIntervalMaxMessageCount)}
		end
	end)
	RCON:RegisterCommand("vars.textChatSpamDetectionTime", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then	
			if tonumber(args[1]) ~= nil and tonumber(args[1])>= 0 then
				AntiSpamConfig(self.chatSettings.antiSpam).detectionInterval = tonumber(args[1])
				return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionInterval):gsub("(.*)%..*$","%1")}
			else
				return {'InvalidArguments'}
			end	
		else
			return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionInterval):gsub("(.*)%..*$","%1")}
		end
	end)
	RCON:RegisterCommand("vars.textChatSpamCoolDownTime", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then
			if tonumber(args[1]) == math.floor(tonumber(args[1])) and tonumber(args[1])>= 0 then
				AntiSpamConfig(self.chatSettings.antiSpam).secondsBlocked = tonumber(args[1])
				return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).secondsBlocked)}
			else
				return {'InvalidArguments'}
			end
		else
			return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).secondsBlocked)}
		end	
	end)
end
function TextChatModeration:RegisterEvents()
	partitionLoaded = Events:Subscribe('Partition:Loaded', function(partition)
		for _,instance in pairs(partition.instances) do
			if instance.instanceGuid ==  Guid("EF70882D-F9A1-4E43-A09D-120B6BAA7502") then 
				self.chatSettings = ChatSettings(instance)
				self.chatSettings:MakeWritable()
				break
			end
		end
	--	partitionLoaded:Unsubscribe()
	end)
	Events:Subscribe('Player:Authenticated', function(player)
		NetEvents:SendTo("Server:GetTextChatModerationList", player, self.textChatModerationList)
	end)
end

g_TextChatModeration = TextChatModeration()