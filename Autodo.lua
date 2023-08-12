warn("!Started!")

local Enabled = true

local set_thread_identity = (setthreadcontext or set_thread_identity or function()
    return print("Your exploit doesnt support this function")
end)

local Client = game.Players.LocalPlayer
local States = workspace:WaitForChild("States")
local Effect = require(game:GetService("ReplicatedStorage").Modules.EffectHelper)

local VIM = game:service("VirtualInputManager")

local function hold(keyCode, time)
    set_thread_identity(7)
    VIM:SendKeyEvent(true, keyCode, false, game)
    task.wait(time)
    VIM:SendKeyEvent(false, keyCode, false, game)
    set_thread_identity(2)
end

function get(n, s)
    return States[n.Name]:FindFirstChild(s, true).Value
end
function get_root(chr)
    return chr.HumanoidRootPart
end

function notif(str, str2)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = str,
        Text = str2,
    })
end

function dash()
    hold(0x20, 0.1)
end
function random()
    return math.random(1, 100) / 100
end
local waiting = {}
function waitValid(name, func)
    if not waiting[name] then
        waiting[name] = {}
    end
    table.insert(waiting[name], func)
    warn("Added Queue :", name)
end
function valid(name, ...)
    for i = 1, #waiting[name] do
        task.spawn(waiting[name][i], ...)
    end
    waiting[name] = nil
    warn("Cleared Queue :", name)
end

shared.BaseEffectFunction = shared.BaseEffectFunction or {}
for i, v in pairs(Effect) do
    shared.BaseEffectFunction[i] = shared.BaseEffectFunction[i] or v
    Effect[i] = function(d, ...)
        task.spawn(function()
            if not Enabled then
                return
            end
            if type(d) == "table" and typeof(d[2]) == "Instance" then
                local Target = get(Client, "LockedOn")
                local Distance = Client:DistanceFromCharacter(get_root(d[2]).Position)

                if States[Client.Name]:FindFirstChild("Blocking", true).Value or
                not States[Client.Name]:FindFirstChild("Equipped", true).Value or
                States[Client.Name]:FindFirstChild("Punching", true).Value then
                    return
                end

                if Distance > 10.8 then
                    return
                end
                if (d[1] == "AttackTrail" or d[1] == "StartupHighlight" or d[1] == "UltimateHighlight") and d[2] ~= Client.Character and type(d[5]) == 'number' then
                    waitValid(d[2].Name , function(LightAttack)
                        local delay = d[5] * Random.new():NextNumber(0.4, 0.6)
                        local formattedResult = string.format("%.2f", delay)
                        task.wait(tonumber(formattedResult))
                        coroutine.wrap(dash)()
                        notif("dodged!", "truly master at work")
                    end)
                end
                if d[1] == "StartupHighlight" then
                    valid(d[2].Name, not (d[3] or d[4] or d[5]))
                end
            end
        end)
        return shared.BaseEffectFunction[i](d, ...)
    end
end
