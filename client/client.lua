QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent(Config.Framework.Trigger, function(gym)
            QBCore = gym
        end)
        Citizen.Wait(0)
    end

	while true do
		local seconds = 300 * 1000
		Citizen.Wait(seconds)
		for skill, value in pairs(Config.Abilities) do
			Functions.UpdateSkill(skill, value.removeSec)
		end
		TriggerServerEvent("qb-gym:server:update", Config.Abilities)
	end

    Functions.Fetch()
end)

-- Variables

Vars = {
    DoingWork = false,
}

-- Functions

function round(num) 
    return math.floor(num+.5) 
end

Functions = {
    Text = function(text)
        SetTextComponentFormat("STRING")
        AddTextComponentString(text)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end,
    
    UpdateSkill = function(skill, quantity)
        local amount = Config.Abilities[skill].current

        if amount + tonumber(quantity) < 0 then
            Config.Abilities[skill].current = 0
        elseif amount + tonumber(quantity) > 100 then
            Config.Abilities[skill].current = 100
        else
            Config.Abilities[skill].current = Config.Abilities[skill].current + tonumber(quantity)
        end
        Functions.Refresh()
        QBCore.Functions.Notify(''..Config.T["1"]..' '..Config.Abilities[skill].label..''..Config.T["2"]..''..quantity)
        TriggerServerEvent('qb-gym:server:update', Config.Abilities)
    end,

    Fetch = function()
        QBCore.Functions.TriggerCallback("qb-gym:server:fetch", function(data)
            if data then
                for status, value in pairs(data) do
                    if Config.Abilities[status] then
                        Config.Abilities[status].current = value.current
                    end
                end
            end
            Functions.Refresh()
        end)
    end,

    Refresh = function()
        for b,c in pairs(Config.Abilities) do
            StatSetInt(c.stat, round(c.current), true)
        end
    end,

    DoAction = function(point)
        if Config.Points[point].type == 'Arms' then
            local ply = PlayerPedId()

            SetEntityCoords(ply, vector3(Config.Points[point].coords.x, Config.Points[point].coords.y, Config.Points[point].coords.z - 1.0))
            SetEntityHeading(ply, Config.Points[point].coords.h)
            TaskStartScenarioInPlace(ply, "prop_human_muscle_chin_ups", 0, true)
            Citizen.Wait(Config.PullUp)
            Functions.UpdateSkill('Strength', 0.1)
            ClearPedTasksImmediately(ply)

            QBCore.Functions.Notify(''..Config.T["3"]..'')
                Vars.DoingWork = true
            Citizen.SetTimeout(Config.GymWait, function()
                Vars.DoingWork = false
                QBCore.Functions.Notify(''..Config.T["3"]..'')
            end)
        elseif Config.Points[point].type == 'Pushups' then
            local ply = PlayerPedId()

            SetEntityCoords(ply, vector3(Config.Points[point].coords.x, Config.Points[point].coords.y, Config.Points[point].coords.z - 1.0))
            SetEntityHeading(ply, Config.Points[point].coords.h)
            TaskStartScenarioInPlace(ply, "world_human_push_ups", 0, true)
            Citizen.Wait(Config.PushUp)
            Functions.UpdateSkill('Strength', Config.GymStrength)
            ClearPedTasksImmediately(ply)

            QBCore.Functions.Notify(''..Config.T["3"]..'')
                Vars.DoingWork = true
            Citizen.SetTimeout(Config.GymWait, function()
                Vars.DoingWork = false
                QBCore.Functions.Notify(''..Config.T["3"]..'')
            end)
        elseif Config.Points[point].type == 'Situps' then
            local ply = PlayerPedId()

            SetEntityCoords(ply, vector3(Config.Points[point].coords.x, Config.Points[point].coords.y, Config.Points[point].coords.z - 1.0))
            SetEntityHeading(ply, Config.Points[point].coords.h)
            TaskStartScenarioInPlace(ply, "world_human_sit_ups", 0, true)
            Citizen.Wait(Config.Situps)
            Functions.UpdateSkill('Strength', Config.GymStrength)
            ClearPedTasksImmediately(ply)

            QBCore.Functions.Notify(''..Config.T["3"]..'')
                Vars.DoingWork = true
            Citizen.SetTimeout(Config.GymWait, function()
                Vars.DoingWork = false
                QBCore.Functions.Notify(''..Config.T["3"]..'')
            end)
        elseif Config.Points[point].type == 'Yoga' then
            local ply = PlayerPedId()

            SetEntityCoords(ply, vector3(Config.Points[point].coords.x, Config.Points[point].coords.y, Config.Points[point].coords.z - 1.0))
            SetEntityHeading(ply, Config.Points[point].coords.h)
            TaskStartScenarioInPlace(ply, "world_human_yoga", 0, true)
            Citizen.Wait(Config.Yoga)
            Functions.UpdateSkill('Stamina', Config.GymStamina)
            ClearPedTasksImmediately(ply)
            QBCore.Functions.Notify(''..Config.T["3"]..'')
            Vars.DoingWork = true
            Citizen.SetTimeout(Config.GymWait, function()
                Vars.DoingWork = false
                QBCore.Functions.Notify(''..Config.T["3"]..'')
            end)
        end
    end
}

-- Threads

Citizen.CreateThread(function()
    while true do
        local wait = 500
        local ply = PlayerPedId()
        local plyc = GetEntityCoords(ply)

        if ply and plyc and QBCore ~= nil then
            for b,c in pairs(Config.Points) do
                local dist = #(plyc - vector3(Config.Points[b].coords.x, Config.Points[b].coords.y, Config.Points[b].coords.z))

                if dist < 15 and not Vars.DoingWork then
                    wait = 0
                    if dist < 1.5 then
                        QBCore.Functions.DrawText3D(Config.Points[b].coords.x, Config.Points[b].coords.y, Config.Points[b].coords.z, ''..Config.T["5"]..'')
                        if IsControlJustPressed(0, 38) then
                            Functions.DoAction(b)
                        end
                    end
                end
            end
        end

        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
	while true do
        --local wait = 25000
        local ply = PlayerPedId()
        local plyc = GetEntityCoords(ply)
        if ply and plyc and QBCore ~= nil then
            if IsPedRunning(ply) and Config.Stamina == true then
                Functions.UpdateSkill('Stamina', Config.StaminaX)
            elseif IsPedInMeleeCombat(ply) and Config.Melee == true then
                Functions.UpdateSkill('Strength', Config.MeleeX)
            elseif IsPedSwimming(ply) and Config.Swim == true then
                Functions.UpdateSkill('Strength', Config.SwimX)
            elseif IsPedSwimmingUnderWater(ply) and Config.Lungs == true then
                Functions.UpdateSkill('Lung Capacity', Config.Lungs)
            end
        end
        Citizen.Wait(Config.WaitNoGym)
	end
end)