local robot = require('robot')
local event = require('event')
local cmp = require('component')
local ic = cmp.inventory_controller
local x = 0

print('The robot is ready to work!')

function label(item)
    names = {'Butchery Knife', 'gt.metatool.01.36.name'}
    if item then
        for _, name in pairs(names) do
            if item.label == name then
                return true
            end
        end
    end
end

while true do
    if event.pull(.1, 'interrupted') then
        break
    end

    if robot.durability() then
        robot.swing()
    else
        if x % 1000 == 0 then
            print(x / 1000 + 1, 'waiting, no tools')
        end

        x = x + 1

        if label(ic.getStackInInternalSlot(1)) then
            if ic.equip()
                x = 0
                print('back in business')
            end
        else
            robot.dropDown()
            ic.suckFromSlot(0, 9)
        end
    end
end

print('The robot has completed its work')
