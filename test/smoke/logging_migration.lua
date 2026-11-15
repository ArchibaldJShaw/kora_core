-- Behavioural proof that migrated error/warn paths emit Kora.logging calls (spy in test/mocks.lua)
-- instead of raw print, with the error carried in `fields` and a static event name/message.
local h = dofile('test/harness.lua')
local mocks = dofile('test/mocks.lua'); local handle = mocks.install()
dofile('config.lua')
dofile('shared/items.lua'); dofile('shared/jobs.lua'); dofile('shared/gangs.lua')
dofile('shared/vehicles.lua'); dofile('shared/weapons.lua'); dofile('shared/locations.lua')
dofile('modules/util/shared.lua')
dofile('modules/registry/shared.lua'); dofile('modules/registry/server.lua')
dofile('modules/player/shared.lua')
dofile('modules/replication/server.lua'); dofile('modules/persistence/server.lua')
dofile('modules/player/server.lua'); dofile('modules/money/server.lua')

local bank = { reject = true }
exports['qb-banking'] = {
    GetAccount = function() return { account_name = 'government' } end,
    CreateJobAccount = function() return 1 end,
    AddMoney = function() if bank.reject then return false end return 1 end,
}
handle.resourceStates['qb-banking'] = 'started'

local pending = {}
_G.CreateThread = function(fn) pending[#pending + 1] = fn end
local function settle()
    local queued = pending; pending = {}
    for _, fn in ipairs(queued) do fn() end
end

-- Fail the test if anything still reaches raw print from the migrated paths.
local printed = {}
local realPrint = print
_G.print = function(...) printed[#printed + 1] = table.concat({ ... }, ' ') end

local function find(event)
    for _, entry in ipairs(handle.logs) do
        if entry.event == event then return entry end
    end
end

Config.money.tax.enabled = true
local data = CoreInternal.player.freshData('CID1', 'license:abc', 1, { firstname = 'A', lastname = 'B' })
assert(Core.player.login(1, 'CID1', data))

h.test('rejected tax deposit logs money.tax_deposit_failed at error with the error in fields', function()
    Core.money.setMoney(1, 'bank', 0)
    Core.money.addMoney(1, 'bank', 100, 'paycheck')
    settle()
    local entry = find('money.tax_deposit_failed')
    h.assertTrue(entry ~= nil, 'expected a money.tax_deposit_failed log call')
    h.assertEqual(entry.level, 'error')
    h.assertTrue(type(entry.fields) == 'table' and type(entry.fields.error) == 'string' and entry.fields.error ~= '',
        'fields.error carries the failure')
    h.assertEqual(entry.fields.amount, 5)
    h.assertFalse(entry.message:find('%^%d') or entry.message:find('%[kora_core'), 'message has no colour codes or resource prefix')
end)

h.test('provider unavailable logs money.tax_skipped at warn', function()
    handle.resourceStates['qb-banking'] = 'stopped'
    Core.money.setMoney(1, 'bank', 0)
    Core.money.addMoney(1, 'bank', 100, 'paycheck')
    settle()
    local entry = find('money.tax_skipped')
    h.assertTrue(entry ~= nil, 'expected a money.tax_skipped log call')
    h.assertEqual(entry.level, 'warn')
    h.assertTrue(entry.fields and entry.fields.reason ~= nil, 'reason is in fields, not the message')
    handle.resourceStates['qb-banking'] = 'started'
end)

h.test('migrated paths do not use raw print', function()
    h.assertEqual(#printed, 0, 'unexpected raw print: ' .. tostring(printed[1]))
end)

_G.print = realPrint
h.report('logging_migration')
