-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

print 'start'

require 'functions'
require 'StringFunc'
require 'mjAlgorithm'

-- local zu = {}
-- zu[1] = {[1]=1, [2]=2,value=3}
-- zu[2] = {[1]=4, [2]=5, [3]=6, value=5}
-- zu[3] = {[1]=7, [2]=8, [3]=9, value=7}
-- zu[4] = {[1]=10, value=49}
-- zu[5] = {[1]=11, [2]=12, [3]=13, value=51}
-- zu[6] = {[1]=14, value=52}

-- local laiziCount = 1

-- local result = {ting={}, out={}}

-- mjAlgorithm.analyseHu(zu,laiziCount,result)

--local myCard = { 5, 3, 4, 4, 7, 7, 7, 9, 9, 9, 3, 3, 3 }
--local myCard = { 1, 5, 1, 4, 7, 7, 7, 9, 9, 9, 3, 3, 3 }

--local myCard = { 1, 3, 3, 3, 5, 5, 4, 7, 7, 7, 9, 9, 9 }

local myCard = { 1, 1, 1, 1, 2, 5, 4, 7, 8, 7, 9, 9, 9 }
local otherCard = { }
local lastCard = 2
local laizi = { 1, 56 }
local configjson = { HuQiDui = 0, MagicNeedBaotou = 1 }

hu = mjAlgorithm.hu2(myCard, otherCard, lastCard, laizi, configjson)

print 'end'

os.execute('pause')

-- endregion
