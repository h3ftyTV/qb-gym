QBCore = exports['qb-core']:GetCoreObject()

-- Events

RegisterServerEvent('qb-gym:server:update')
AddEventHandler('qb-gym:server:update', function(data)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if ply then
        exports['oxmysql']:execute('UPDATE players SET skills = @skills WHERE citizenid = @citizenid', {
            ['@skills'] = json.encode(data),
            ['@citizenid'] = ply.PlayerData.citizenid
        })
    end
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-gym:server:fetch', function(source, cb)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if ply then
        exports['oxmysql']:execute('SELECT skills FROM players WHERE citizenid = @citizenid', {
            ['@citizenid'] = ply.PlayerData.citizenid
        }, function(status)
            if status ~= nil then
                local decode = json.decode(status)
                return cb(decode)
            else
                return cb(nil)
            end
        end)
    end
end)

-- Command

