local playerStatus = {}

-- Comando /stato
RegisterCommand('stato', function(source, args, rawCommand)
    local message = table.concat(args, ' ')
    playerStatus[source] = message
    TriggerClientEvent('status:show', -1, source, message)
end, false)

-- Comando /statooff per nascondere lo stato
RegisterCommand('statooff', function(source, args, rawCommand)
    playerStatus[source] = nil
    TriggerClientEvent('status:hide', -1, source)
end, false)

--Funzione per gestire le richieste degli altri giocatori
RegisterServerEvent('status:requestStatus')
AddEventHandler('status:requestStatus', function(targetPlayerId)
    local sourcePlayerId = source
    local statusMessage = playerStatus[sourcePlayerId]

    if statusMessage then
        TriggerClientEvent('status:showOtherPlayerStatus', targetPlayerId, statusMessage)
    end
end)
