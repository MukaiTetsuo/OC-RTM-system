local component = require("component")
local computer = require("computer")
local keyboard = require("keyboard")
local gpu1 = component.proxy("3df00858-54fe-4b8d-893b-7fa9862f42c2")
local gpu2 = component.proxy("2a242156-f66a-4a86-8931-4f8f04a71048")
gpu1.bind("96bb6cf7-6af8-4961-9dc8-b892300ab353",false)
gpu2.bind("a666ca6a-0a17-45d1-b5a3-9fbedc411641",false)
gpu1.setResolution(160, 50)
gpu1.fill(1, 1, 160 ,50 , " ")

-- 対象のRedstone I/OのUUID（例）
local rsb1 = component.proxy("c4ff566c-91b5-4a05-82e7-60634e70ecae")

-- イベントループ
local running = true
    for i = 1, 160 do
        gpu1.set(i ,25, "█")
    end

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
    os.sleep(0.5)
end