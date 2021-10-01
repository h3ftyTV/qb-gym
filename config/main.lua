Config = Config or {}

Config.Framework = {
    Name = 'QBCore',
    Trigger = 'QBCore:GetObject'
}

Config.Abilities = {
    ['Stamina'] = {
        ['current'] = 15,
        ['label'] = 'Stamina',
        ['removeSec'] = -0.2,
        ['stat'] = 'MP0_STAMINA'
    },
    ['Strength'] = {
        ['current'] = 10,
        ['label'] = 'Strength',
        ['removeSec'] = -0.3,
        ['stat'] = 'MP0_STRENGTH'
    },
    ['Lung Capacity'] = {
        ['current'] = 10,
        ['label'] = 'Lung capacity',
        ['removeSec'] = -0.1,
        ['stat'] = "MP0_LUNG_CAPACITY"
    },
}

Config.Points = {
    [1] = {
        ['coords'] = { ['x'] = -1200.02, ['y'] = -1571.15, ['z'] = 4.59, ['h'] = 215.53 },
        ['type'] = 'Arms', 
    },
    [2] = {
        ['coords'] = { ['x'] = -1203.18, ['y'] = -1570.37, ['z'] = 4.61, ['h'] = 214.07 },
        ['type'] = 'Pushups', 
    },
    [3] = {
        ['coords'] = { ['x'] = -1201.08, ['y'] = -1564.94, ['z'] = 4.62, ['h'] = 214.07 },
        ['type'] = 'Situps', 
    },
    [4] = {
        ['coords'] = { ['x'] = -1194.06, ['y'] = -1570.68, ['z'] = 4.62, ['h'] = 214.07 },
        ['type'] = 'Yoga', 
    }
}

-- Exercise time miliseconds
Config.PullUp = 20000 -- Pullups
Config.PushUp = 15000 -- Pushups
Config.Situps = 20000 -- Situps
Config.Yoga = 20000 -- Yoga

Config.GymWait = 10000 -- Relaxing before next exercise

-- GAIN IN THE GYN --
Config.GymStrength = 0.1 -- Strength
Config.GymStamina = 0.2 -- Strength

-- GAIN OUTSIDE THE GYM --
Config.Stamina = true -- false if you dont want to gain while running
Config.StaminaX = 0.1 -- The amount you want to gain
Config.Melee = true -- false if you dont want to gain while fighting // Melee
Config.MeleeX = 0.1 -- The amount you want to gain
Config.Swim = true -- false if you dont want to gain while swimming
Config.SwinX = 0.2 -- The amount you want to gain
Config.Lungs = true -- false if you dont want to gain while swimming under water
Config.LungsX = 0.3 -- The amount you want to gain
Config.WaitNoGym = 25000 -- Time to be active outside the gym to gain

-- Complete Translation
Config.T = {
    ["1"] = "Ability of ",
    ["2"] = " has risen +",
    ["3"] = "You need to wait 10 seconds to do another exercise again",
    ["4"] = "You can now exercise again",
    ["5"] = "~g~E~w~ - To workout"
}