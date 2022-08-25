--########################################--
--                GATE SENSOR          
--            Created By: dior.💎      
--               //client.lua\\
--########################################--


--- ######################
--- ####### CONFIG #######
--- ######################

-- [[Input the coords of the gate. When an aircraft's front wheel reaches the coords inputed, the pilot will get an option to turn on their parking brake.]]
-- Input coords like this: {{x, y, z, heading}}
-- Heading should be 0  

gates = {
    {{-1257.69, -2721.3, 13.0, 0}}, -- LSIA Gate 1
    {{-1335.63, -2675.98, 13.0, 0}}, -- LSIA Gate 2 
    {{-1411.37, -2679.98, 13.0, 0}}, -- LSIA Gate 3 
    {{-1374.46, -2615.81, 13.0, 0}}, -- LSIA Gate 4 
    {{-1337.5, -2551.87, 13.0, 0}}, -- LSIA Gate 5 
    {{-1296.04, -2607.08, 13.0, 0}}, -- LSIA Gate 7 
    {{-1217.82, -2652.18, 13.0, 0}}, -- LSIA Gate 8 
    {{-1148.0, -2531.13, 13.0, 0}}, -- LSIA Gate 9 
    {{-1226.05, -2485.97, 13.0, 0}}, -- LSIA Gate 10 
    {{-1559.92, -3198.67, 13.0, 0}}, -- LSIA Gate 11 Next to pegasus hanger  
    {{-1493.22, -3237.23, 13.0, 0}}, -- LSIA Gate 12 Next to pegasus hanger  
    {{-1447.81, -2742.98, 13.0, 0}}, -- LSIA Cargo Gate
    {{-1111.68, -2937.32, 13.0, 0}}, -- LSIA Stand 1 (starting from right next to devin weston hanger)
    {{-1149.15, -2915.6, 13.0, 0}}, -- LSIA Stand 2
    {{-1186.8, -2893.96, 13.0, 0}}, -- LSIA Stand 3
    {{-1226.08, -2871.09, 13.0, 0}}, -- LSIA Stand 4
    {{-1261.77, -2850.58, 13.0, 0}}, -- LSIA Stand 5
}



--- ####################
--- ####### MAIN #######
--- ####################
--    [[DON'T TOUCH]]

local pBreak = false
local gsEnabled = true

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1)
        
        ped = GetPlayerPed(-1)

        if gsEnabled then
            if IsPedInAnyPlane(ped, true) then
                local veh = GetVehiclePedIsIn(ped)
                local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wheel_lf"))

                for _,location in ipairs(gates) do
                    gatePos = {
                        x=location[1][1],
                        y=location[1][2],
                        z=location[1][3],
                        heading=location[1][4]
                    }

                    if CheckPos(coords.x, coords.y, coords.z, gatePos.x, gatePos.y, gatePos.z, 2) then 
                        if pBreak then
                            alert("Press [E] To ~r~Disable~w~ Parking Brake")
                        else 
                            alert("Press [E] To ~g~Enable~w~ Parking Brake")
                        end
                
                        if IsControlJustReleased(1, 38) then
                            if pBreak then
                                pBreak = false 
                                SendNUIMessage({
                                    transactionType     = 'playSound',
                                    transactionFile     = 'switch',
                                    transactionVolume   = 0.3
                                })     
                            else 
                                pBreak = true
                                SendNUIMessage({
                                    transactionType     = 'playSound',
                                    transactionFile     = 'switch',
                                    transactionVolume   = 0.3
                                })     
                            end
                        end
                    end

                    if pBreak then 
                        SetVehicleForwardSpeed(veh, 0)
                    end
                end
            end            
        end
    end
end)





--- ########################
--- ####### COMMANDS #######
--- ########################

RegisterCommand('gatesensor', function()
    if gsEnabled then
        gsEnabled = false
        pBreak = false
        notify({255,0,0}, "Disabled")
    else
        gsEnabled = true
        notify({0,255,0}, "Enabled") 
    end
end, false)

TriggerEvent( "chat:addSuggestion", "/gatesensor", "Toggles the gate sensor / gate parking brake on and off." )


  
  



--- #####################
--- ##### FUNCTIONS #####
--- #####################


function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString("~b~[Gate Sensor]: ~w~".. msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function notify(color, text)
    TriggerEvent("chatMessage",  "[Gate Sensor]", color, text)
end

