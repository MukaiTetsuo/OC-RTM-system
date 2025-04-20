local component = require("component")
local computer = require("computer")
local keyboard = require("keyboard")
local thread = require("thread")
local event = require("event")
local term = require("term")
local unicode = require("unicode")

local gpuAddr1 = "3df00858-54fe-4b8d-893b-7fa9862f42c2"
local gpuAddr2 = "2a242156-f66a-4a86-8931-4f8f04a71048"
local displayAddr1 = "96bb6cf7-6af8-4961-9dc8-b892300ab353"
local displayAddr2 = "a666ca6a-0a17-45d1-b5a3-9fbedc411641"

local gpu1 = component.proxy(gpuAddr1)
local gpu2 = component.proxy(gpuAddr2)
gpu1.bind(displayAddr1,false)
gpu2.bind(displayAddr2,false)

--起動ロゴ
gpu1.setResolution(48, 15)
gpu2.setResolution(48, 15)
os.sleep(2)
gpu1.setBackground(0x003F8E)
gpu2.setBackground(0x003F8E)
gpu1.fill(1, 1, 48, 15, " ")
gpu2.fill(1, 1, 48, 15, " ")
local w, h = 48, 15
local logo = {
    "██╦══██╦████████╗ ██████▄╗███████╗",
    "██║ ██╔╝   ██╔══╝██╔═════╝██╔════╝",
    "█████╔╩════██╣═══██║      ███████╗",
    "██╔═██╗    ██║   ██║      ╚════██║",
    "██║ ╚██╗   ██║   ╚██████▀ ███████║",
    "╚═╝  ╚═╝   ╚═╩════╩═════╝ ╚══════╝",
}

-- ロゴの中央表示用y座標
local startY = math.floor((h - #logo) / 2)

term.clear()

for i, line in ipairs(logo) do
  local x = math.floor((w - unicode.len(line)) / 2)
  local targetY = startY + i - 1
  local prevY = nil
  for y = 1, targetY do
    -- 消す：前の位置の文字を空白で上書き
    if prevY then
      gpu1.set(x, prevY, string.rep(" ", unicode.len(line)))
      gpu2.set(x, prevY, string.rep(" ", unicode.len(line)))
    end
    -- 描く：確定済みの行を表示
    for j = 1, i - 1 do
      local lineY = startY + j - 1
      local lineX = math.floor((w - unicode.len(logo[j])) / 2)
      gpu1.set(lineX, lineY, logo[j])
      gpu2.set(lineX, lineY, logo[j])
    end
    -- 描く：現在降下中の行
    gpu1.set(x, y, line)
    gpu2.set(x, y, line)
    os.sleep(0.05)
    prevY = y
  end
end

gpu1.set(10,12,"KiriumiTrainCentralSystem v1.0β")
gpu2.set(10,12,"KiriumiTrainCentralSystem v1.0β")
gpu1.set(16,13,"Now Starting...")
gpu2.set(16,13,"Now Starting...")

-- 5秒待機
os.sleep(4)
term.clear()

gpu1.setResolution(32, 10)
gpu2.setResolution(32, 10)
gpu1.setBackground(0xFFFFFF)
gpu2.setBackground(0xFFFFFF)
gpu1.setForeground(0x000000)
gpu2.setForeground(0x000000)
gpu1.fill(1, 1, 32, 10, " ")
gpu2.fill(1, 1, 32, 10, " ")
gpu2.set(9, 2, "第10閉塞在線監視")
gpu2.set(9, 7, "第10閉塞信号現示")
gpu1.setForeground(0xFF0000)
gpu1.set(9, 7, "████")
gpu1.set(9, 8, "████")
gpu1.setForeground(0xFFC800)
gpu1.set(13, 7, "████")
gpu1.set(13, 8, "████")
gpu1.setForeground(0xF58220)
gpu1.set(17, 7, "████")
gpu1.set(17, 8, "████")
gpu1.setForeground(0x000000)
gpu1.set(21, 7, "＼／")
gpu1.set(21, 8, "／＼")
gpu1.set(9, 9, "停止")
gpu1.set(13, 9, "注意")
gpu1.set(17, 9, "警戒")
gpu1.set(21, 9, "取消")
gpu1.set(1, 1, "☓")



-- 対象のRedstone I/OのUUID（例）
local rsb1 = component.proxy("c4ff566c-91b5-4a05-82e7-60634e70ecae")

-- タッチイベント監視スレッド
local function touchWatcher()
    while true do
        local _, screenAddr, x, y, button, player = event.pull("touch")
        --gpu1.set(1,10,"タッチ: " .. x .. " ".. y .. " " .. player or "不明")
        if screenAddr == displayAddr1 and y >= 7 and y <= 8 then
            if x >= 9 and x <= 12 then
                gpu1.setForeground(0xFF0000)
                gpu1.set(11, 3,"停止現示指示")
                rsb1.setOutput(3,15)
                rsb1.setOutput(4,15)
            elseif x >= 13 and x <= 16 then
                gpu1.setForeground(0xFFC800)
                gpu1.set(11, 3,"注意現示指示")
                rsb1.setOutput(3,15)
                rsb1.setOutput(4,0)
            elseif x >= 17 and x <= 20 then
                gpu1.setForeground(0xF58220)
                gpu1.set(11, 3,"警戒現示指示")
                rsb1.setOutput(3,0)
                rsb1.setOutput(4,15)
            elseif x >= 21 and x <= 24 then
                gpu1.setForeground(0x00FF00)
                gpu1.set(11, 3,"現示指示無し")
                rsb1.setOutput(3,0)
                rsb1.setOutput(4,0)
            elseif x == 1 and y == 1 then
                running = false
                return
            end
        end
    end
end

local function direction(d)
    if d == 1 then
    end
end

-- スレッドとして起動
local thread1 = thread.create(touchWatcher)

-- イベントループ
local running = true
local x1, y1 = 13,4
local x2, y2 = 15,9
local oldValue1 = 99
local oldValue2 = 99

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
        thread1:kill()
        return
    end

    local newValue1 = rsb1.getInput(1)
    if newValue1 ~= oldValue1 then
        if newValue1 ~= 0 then
            gpu2.setForeground(0xFF0000)
            gpu2.set(x1, y1, "　　　　")
            gpu2.set(x1, y1, " 在線中 ")
        else
            gpu2.setForeground(0x00FF00)
            gpu2.set(x1, y1, "　　　　")
            gpu2.set(x1, y1, "区間離脱")
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
            gpu2.setForeground(0xF58220)
            gpu2.set(x2, y2, "　　")
            gpu2.set(x2, y2, "警戒")
        elseif newValue2 == 1 then
            gpu2.setForeground(0xFFC800)
            gpu2.set(x2, y2, "　　")
            gpu2.set(x2, y2, "注意")
        else
            gpu2.setForeground(0xFF0000)
            gpu2.set(x2, y2, "　　")
            gpu2.set(x2, y2, "停止")
        end
        oldValue2 = newValue2
    end
    os.sleep(0.5)
end