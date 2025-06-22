LoadIdentities()
LoadPlayers()
LoadSocieties()
LoadSocietyRoles()
LoadSocietyMembers()

Wait(1000)



for k,v in pairs(Societies) do
  v.lazyLoading()
  v.generateEventHandler()
end

function onRessourceStop(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  StoreDatabase()
end
AddEventHandler('onResourceStop', onRessourceStop)


for _, playerId in ipairs(GetPlayers()) do
  local name = GetPlayerName(playerId)
  local steamIdentifier = nil
  local identifiers = GetPlayerIdentifiers(playerId)
  for _, v in pairs(identifiers) do
    if string.find(v, "steam") then
      steamIdentifier = v
      break
    end
  end
  if steamIdentifier then
    local playerObject = nil
    for _, v in pairs(Players) do
      if v.getIdentifier() == steamIdentifier then
        playerObject = v
        break
      end
    end

    if not playerObject then
      playerObject = CreatePlayerWithInfo(steamIdentifier)
    end

    playerObject.setOnline(true)
    playerObject.setSource(playerId) -- Set the source to the player itself

    print(string.format("Player %s with Steam ID %s is online.", name, steamIdentifier))
  else
    print(string.format("Player %s does not have a valid Steam ID.", name))
  end
  -- ('%s'):format('text') is same as string.format('%s', 'text)
end

function OneSecondTick()
    StoreDatabase()
end

Citizen.CreateThread(function()
  local tick = 0
  while true do
    Citizen.Wait(60000) -- Save every minute
    OneSecondTick()
    tick = tick + 1
    if tick >= 30 then -- Reset every hour
      for k,v in pairs(Societies) do
        v.sendMoneyToActiveMembers()
      end
    end
  end

end)