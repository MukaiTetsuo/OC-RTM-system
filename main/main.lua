local component = require("component")
local computer = require("computer")
local keyboard = require("keyboard")
local gpu1 = component.proxy("3df00858-54fe-4b8d-893b-7fa9862f42c2")
local gpu2 = component.proxy("2a242156-f66a-4a86-8931-4f8f04a71048")
gpu1.bind("96bb6cf7-6af8-4961-9dc8-b892300ab353",false)
gpu2.bind("a666ca6a-0a17-45d1-b5a3-9fbedc411641",false)
gpu1.setResolution(16, 5)
gpu2.setResolution(16, 5)
gpu1.setBackground(0xFFFFFF)
gpu2.setBackground(0xFFFFFF)
gpu1.setForeground(0x000000)
gpu2.setForeground(0x000000)
gpu1.fill(1, 1, 16 ,5 , " ")
gpu2.fill(1, 1, 16, 5, " ")
gpu1.set(1, 1, "第10閉塞在線監視")
gpu2.set(1, 1, "第10閉塞信号現示")

-- 対象のRedstone I/OのUUID（例）
local rsb1 = component.proxy("c4ff566c-91b5-4a05-82e7-60634e70ecae")

-- イベントループ
local running = true
local x1, y1 = 5,3
local x2, y2 = 6,3

while running do
    if keyboard.isKeyDown(keyboard.keys.e) then
        print("終了します")
        running = false
        gpu1.setResolution(160, 50)
        gpu2.setResolution(160, 50)
        gpu1.setBackground(0x000000)
        gpu2.setBackground(0x000000)
        gpu1.setForeground(0xFFFFFF)
        gpu2.setForeground(0xFFFFFF)
    end

    local newValue1 = rsb1.getInput(1)
    if newValue1 ~= oldValue1 then
        if oldValue1 == 0 then
            gpu1.setForeground(0xFF0000)
            gpu1.set(x1, y1, "　　　　")
            gpu1.set(x1, y1, " 在線中 ")
        else
            gpu1.setForeground(0x00FF00)
            gpu1.set(x1, y1, "　　　　")
            gpu1.set(x1, y1, "区間離脱")
        end
    end
    oldValue1 = newValue1

    local newValue2 = rsb1.getInput(2)*2/15 + rsb1.getInput(5)/15
    if newValue2 ~= oldValue2 then
        if newValue2 == 3 then
            gpu2.setForeground(0x00FF00)
            gpu2.set(x2, y2, "　　")
            gpu2.set(x2, y2, "進行")
        elseif newValue2 == 2 then
            gpu2.setForeground(0xFFFF00)
            gpu2.set(x2, y2, "　　")
            gpu2.set(x2, y2, "警戒")
        elseif newValue2 == 1 then
            gpu2.setForeground(0xFFFF00)
            gpu2.set(x2, y2, "　　")
            gpu2.set(x2, y2, "注意")
        else
            gpu2.setForeground(0xFF0000)
            gpu2.set(x2, y2, "　　")
            gpu2.set(x2, y2, "停止")
        end
        oldValue2 = newValue2
    end
    os.sleep(0.2)
end