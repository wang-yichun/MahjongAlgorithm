-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成


function removeCard(arr, index)
    local s = table.getn(arr[index])
    if s > 0 then
        table.remove(arr[index], s)
        if s == 1 then
            table.remove(arr, index)
        end
    end
end

mjAlgorithm = { }

function mjAlgorithm.analysis(cards)
    local zu = { }
    local cv = { }
    for k, v in pairs(cards) do
        if cv.value ~= v then
            if #cv > 0 then
                table.insert(zu, cv)
                cv = { }
            end
            cv.value = v
        end
        table.insert(cv, k)
    end
    if #cv > 0 then
        table.insert(zu, cv)
    end
    return zu
end

mjAlgorithm.laizi = { }

function logt(table)
    local str = '';
    for i = 1, #table do
        if mjAlgorithm.isLaizi(mjAlgorithm.laizi, table[i]) then
            str = str .. ' *' .. string.toleft(table[i], 2)
        else
            str = str .. '  ' .. string.toleft(table[i], 2)
        end

    end
    return str
end

function logzut(zu)
    for i = 1, #zu do
        print(zu[i].value .. " | " .. #(zu[i]))
    end
end

function logzu(zu)
    
end

function logcur(cards, result)
    local str2 = '{';
    for i = 1, #result do
        str2 = str2 .. '{'
        for j = 1, #result[i] do
            if mjAlgorithm.isLaizi(mjAlgorithm.laizi, result[i][j]) then
                str2 = str2 .. ' *' .. string.toleft(result[i][j], 2)
            else
                str2 = str2 .. '  ' .. string.toleft(result[i][j], 2)
            end
        end
        str2 = str2 .. '}'
    end
    str2 = str2 .. '}'

    for k,v in pairs(result.lz) do
        if k == 'win' then
            str2 = str2 .. ' w' .. v
        else
            str2 = str2 .. ' ' .. k
        end
    end

    local str = logt(cards)
    print("(" .. string.toright(mjAlgorithm.check_hu_loop_id, 3) .. ")" .. str .. " | " .. str2)
end

function log_result2(result2)
    print '-------------- result2 --------------'
    mjAlgorithm.check_hu_loop_id = 0
    for i = 1, #result2 do
        mjAlgorithm.check_hu_loop_id = mjAlgorithm.check_hu_loop_id + 1
        logcur({ }, result2[i])
    end
    print '---------------- end ----------------'
end

require 'mjAlgorithm_analyseHu'
require 'mjAlgorithm_hu'

require 'mjAlgorithm_hu2' 