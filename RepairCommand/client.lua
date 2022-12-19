-- Declare variables
local targetPlayer -- variable to store the target player
local webhookURL = "YOUR_WEBHOOK_URL_HERE" -- URL of the Discord webhook
local commandUses = {} -- table to store the number of times the command has been used by each player

-- Create a command to repair a player's vehicle
RegisterCommand(function(source, args, rawCommand)
  -- Get the player executing the command
  local player = GetPlayerFromServerId(source)

  -- Check if the player has admin permissions
  if IsPlayerAceAllowed(source, "admin") then
    -- Get the target player by name
    targetPlayer = GetPlayerFromName(args[1])

    -- Check if the target player exists
    if targetPlayer then
      -- Get the target player's vehicle
      local vehicle = GetPlayerVehicle(targetPlayer)

      -- Check if the target player has a vehicle
      if vehicle then
        -- Repair the vehicle
        SetVehicleFixed(vehicle)

        -- Increment the number of times the command has been used by the player
        commandUses[player] = (commandUses[player] or 0) + 1

        -- Check if the player has used the command more than 10 times in the past 5 minutes
        if commandUses[player] > 10 and GetGameTimer() - commandUses[player + 1] < 300000 then
          -- Send a message to the Discord webhook tagging the owner group
          PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Repair System", content = "@Ejer please check player " .. GetPlayerName(player) .. " for spamming the repair command."}), { ['Content-Type'] = 'application/json' })
        else
          -- Send a normal, "fix"