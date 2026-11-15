local lastRestartAt = {}

AddEventHandler('onResourceStart', function(resourceName)
    local cfg = Config.dependencySupervisor
    if not cfg or not cfg.enabled then return end

    local dependents = cfg.map and cfg.map[resourceName]
    if not dependents then return end

    local cooldownMs = cfg.cooldownMs or 15000
    local now = GetGameTimer()

    for _, dependent in ipairs(dependents) do
        if dependent ~= resourceName then
            if GetResourceState(dependent) == 'started' then
                local last = lastRestartAt[dependent]
                if not last or (now - last) >= cooldownMs then
                    lastRestartAt[dependent] = now
                    Kora.logging.info('dependency_supervisor.restarting_dependent', 'Restarting dependent resource because its dependency started', { dependent = dependent, dependency = resourceName })
                    ExecuteCommand(('restart %s'):format(dependent))
                else
                    Kora.logging.info('dependency_supervisor.restart_skipped', 'Skipping dependent restart; cooldown active', {
                        dependent = dependent, remainingMs = cooldownMs - (now - last) })
                end
            end
        end
    end
end)
