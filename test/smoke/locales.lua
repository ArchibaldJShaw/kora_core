local scriptDir = debug.getinfo(1, 'S').source:match('@?(.*/)') or './'
local testDir = scriptDir .. '../'
local repoRoot = testDir .. '../'
package.path = testDir .. '?.lua;' .. package.path

local H = require('harness')
local mocks = require('mocks')
local runtime = mocks.install({ client = true })

dofile(repoRoot .. 'config.lua')

local commands, notices, keyMappings = {}, {}, {}
local selected = 'en'
Kora.locale = {
    translate = Kora.locale.translate,
    getLanguage = function() return selected end,
    getLanguages = function() return { 'de', 'en' } end,
    setLanguage = function(language) selected = language; return true end,
}
Kora.nui = {
    openMenu = function(items, title)
        return { selectedId = items[1].id, title = title }
    end,
}
Kora.notify = { send = function(payload) notices[#notices + 1] = payload end }
_G.RegisterCommand = function(name, handler) commands[name] = handler end
_G.RegisterKeyMapping = function(command, _, _, key) keyMappings[command] = key end

dofile(repoRoot .. 'modules/locales/client.lua')

H.test('registers the player language command', function()
    H.assertTrue(type(commands.language) == 'function')
end)

H.test('selector saves a language through kora_lib rather than PlayerData', function()
    commands.language()
    H.assertEqual(selected, 'de')
    H.assertEqual(notices[#notices].type, 'success')
    H.assertEqual(notices[#notices].title, 'Language')
    H.assertEqual(notices[#notices].message, 'Language set to Deutsch.')
end)

H.test('the press-only keybind uses the configured default key', function()
    H.assertTrue(type(commands['+language']) == 'function')
    H.assertTrue(type(commands['-language']) == 'function')
    H.assertEqual(keyMappings['+language'], Config.locales.defaultKey)
end)

H.test('inventory notifications keep their count, label and severity', function()
    dofile(repoRoot .. 'modules/inventory/client.lua')
    runtime.fireEvent('kora_core:client:itemBox', 0, { label = 'Water' }, 'add', 2)
    H.assertEqual(notices[#notices].message, 'Received 2x Water')
    H.assertEqual(notices[#notices].type, 'success')
    runtime.fireEvent('kora_core:client:itemBox', 0, nil, 'remove')
    H.assertEqual(notices[#notices].message, 'Removed 1x item')
    H.assertEqual(notices[#notices].type, 'error')
end)

H.test('jail notifications format the duration and confirm release', function()
    _G.PlayerPedId = function() return 1 end
    _G.SetEntityCoords = function() end
    Kora.zones = { sphere = function() return { remove = function() end } end }
    dofile(repoRoot .. 'modules/jail/client.lua')
    runtime.fireEvent('kora_core:client:jailTeleport', 0, { x = 1, y = 2, z = 3 }, 61)
    H.assertEqual(notices[#notices].message, 'You have been jailed for 2 minutes.')
    runtime.fireEvent('kora_core:client:jailRelease', 0)
    H.assertEqual(notices[#notices].message, 'You have been released.')
end)

H.report('locales')
