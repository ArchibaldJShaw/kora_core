RegisterNetEvent('kora_core:client:vehicleCondition', function(netId, fuel, engineHealth)
    if source ~= 65535 then return end
    if
        not Kora.util.isFiniteNumber(netId)
        or netId <= 0
        or netId % 1 ~= 0
        or not Kora.util.isFiniteNumber(fuel)
        or not Kora.util.isFiniteNumber(engineHealth)
    then
        return
    end

    CreateThread(function()
        local deadline = GetGameTimer() + 5000
        local vehicle
        repeat
            vehicle = NetworkGetEntityFromNetworkId(netId)
            if vehicle ~= 0 and DoesEntityExist(vehicle) then
                break
            end
            Wait(50)
        until GetGameTimer() >= deadline

        if
            not vehicle
            or vehicle == 0
            or not DoesEntityExist(vehicle)
            or GetEntityType(vehicle) ~= 2
        then
            Kora.logging.warn('garage.vehicle_stream_failed', 'Could not stream the garage vehicle to restore its condition')
            return
        end
        local controlled, reason = Kora.entities.requestControl(vehicle, 1000)
        if not controlled then
            Kora.logging.warn('garage.condition_restore_failed', 'Could not restore garage vehicle condition', { reason = reason or 'no entity control' })
            return
        end
        SetVehicleFuelLevel(vehicle, fuel)
        SetVehicleEngineHealth(vehicle, engineHealth)
    end)
end)
