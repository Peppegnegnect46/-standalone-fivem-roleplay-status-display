-- ## Variables
local playerStatus = {}


local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Calcolo sperimentale per ridimensionare il testo
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Formatta il testo
    local c = { r = 255, g = 255, b = 0, a = 255 }  -- Colore giallo per /stato
    SetTextColour(c.r, c.g, c.b, c.a)
    SetTextScale(0.0, Config.statoScale * scale)
    SetTextFont(Config.statoFont)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Mostra il testo
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end



-- Mostra il testo 3D per /stato
RegisterNetEvent('status:show')
AddEventHandler('status:show', function(playerId, message)
    playerStatus[playerId] = message
end)

-- Nascondi il testo per /statooff
RegisterNetEvent('status:hide')
AddEventHandler('status:hide', function(playerId)
    playerStatus[playerId] = nil
end)

--Funzione per gestire la richiesta del proprio stato da parte degli altri giocatori
RegisterNetEvent('status:requestMyStatus')
AddEventHandler('status:requestMyStatus', function()
    local myPlayerId = GetPlayerServerId(PlayerId())

    TriggerServerEvent('status:requestStatus', myPlayerId)
end)

--Funzione per mostrare lo status degli altri giocatori
RegisterNetEvent('status:showOtherPlayerStatus')
AddEventHandler('status:showOtherPlayerStatus', function(targetPlayerId, statusMessage)
    playerStatus[targetPlayerId] = statusMessage
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Ottieni l'entità del giocatore
        local playerPed = PlayerPedId()

        -- Verifica se c'è un testo da mostrare
        for playerId, displayingText in pairs(playerStatus) do
            -- Ottieni le coordinate del giocatore
            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId))))

            -- Calcola le coordinate a metà altezza del giocatore
            local _, _, height = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), true))
            local midHeight = height + 0.5  -- Modifica il valore 0.5 a seconda della tua preferenza

            -- Mostra il testo 3D
            DrawText3D(vector3(x, y, midHeight), displayingText)
        end
    end
end)
