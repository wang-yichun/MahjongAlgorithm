-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

function mjAlgorithm.analyseHu(zu, laiziCount, result)

    mjAlgorithm.check_hu_loop_id = mjAlgorithm.check_hu_loop_id + 1
    print ('loop'.. mjAlgorithm.check_hu_loop_id)

    if #zu == 0 then
        -- 胡
        if #result.out > 0 then
            result.data = result.data or { }
            result.data[result.out[1]] = result.data[result.out[1]] or { }
            for k, v in pairs(result.ting) do
                if v > 0 then
                    result.data[result.out[1]][k] = 1
                end
            end
            if laiziCount > 0 then
                result.data[result.out[1]].hu_all = true
            end
            if laiziCount > 2 then
                result.hu_all = true
            end
            return true
        end
        if laiziCount > 0 then
            -- 全部
            result.hu_all = true
        end
        return false
    end
    if (#zu == 1) and(table.getn(zu[1]) == 1) then
        if #result.out == 0 then
            result.data = result.data or { }
            result.data[zu[1].value] = result.data[zu[1].value] or { }
            for k, v in pairs(result.ting) do
                if v > 0 then
                    result.data[zu[1].value][k] = 1
                end
            end
            if laiziCount > 0 then
                result.data[zu[1].value].hu_all = true
            end
            if laiziCount > 2 then
                -- 全部
                result.hu_all = true
            end
            -- print_lua_table(result.data)
            return true
        end
    end

    local cache
    local count
    local lzCount

    -- 牌,牌,牌
    cache = table.cloneq(zu)
    local v = cache[1].value
    if v < 0x30 then
        local v1 =(cache[2]) and(cache[2].value - 1) or -1
        local v2 =(cache[3]) and(cache[3].value - 2) or -1
        if (v == v1) and(v == v2) then
            removeCard(cache, 3)
            removeCard(cache, 2)
            removeCard(cache, 1)
            mjAlgorithm.analyseHu(cache, laiziCount, result)
        end
    end

    -- 牌,牌,癞子
    if (laiziCount > 0) then
        local v = zu[1].value
        if v < 0x30 then
            cache = table.cloneq(zu)
            local v1 =(cache[2]) and(cache[2].value) or -1
            if (v ==(v1 - 1)) then
                removeCard(cache, 2)
                removeCard(cache, 1)
                result.ting[v - 1] =(result.ting[v - 1] or 0) + 1
                result.ting[v + 2] =(result.ting[v + 2] or 0) + 1
                mjAlgorithm.analyseHu(cache, laiziCount - 1, result)
                result.ting[v - 1] = result.ting[v - 1] -1
                result.ting[v + 2] = result.ting[v + 2] -1
            end
            if (v ==(v1 - 2)) then
                removeCard(cache, 2)
                removeCard(cache, 1)
                result.ting[v + 1] =(result.ting[v + 1] or 0) + 1
                mjAlgorithm.analyseHu(cache, laiziCount - 1, result)
                result.ting[v + 1] = result.ting[v + 1] -1
            end

            cache = table.cloneq(zu)
            local v1 =(cache[3]) and(cache[3].value) or -1
            if (v ==(v1 - 2)) then
                removeCard(cache, 3)
                removeCard(cache, 1)
                result.ting[v + 1] =(result.ting[v + 1] or 0) + 1
                mjAlgorithm.analyseHu(cache, laiziCount - 1, result)
                result.ting[v + 1] = result.ting[v + 1] -1
            end
        end
    end

    -- 牌,癞子,癞子
    if (laiziCount > 1) then
        local v = zu[1].value
        if v < 0x30 then
            cache = table.cloneq(zu)
            removeCard(cache, 1)

            result.ting[v - 2] =(result.ting[v - 2] or 0) + 1
            result.ting[v - 1] =(result.ting[v - 1] or 0) + 1
            result.ting[v] =(result.ting[v] or 0) + 1
            result.ting[v + 1] =(result.ting[v + 1] or 0) + 1
            result.ting[v + 2] =(result.ting[v + 2] or 0) + 1
            mjAlgorithm.analyseHu(cache, laiziCount - 2, result)
            result.ting[v - 2] = result.ting[v - 2] -1
            result.ting[v - 1] = result.ting[v - 1] -1
            result.ting[v] = result.ting[v] -1
            result.ting[v + 1] = result.ting[v + 1] -1
            result.ting[v + 2] = result.ting[v + 2] -1
        end
    end

    -- 牌牌牌
    count = #zu[1]
    if count >= 3 then
        cache = table.cloneq(zu)
        for i = 1, 3 do
            removeCard(cache, 1)
        end
        mjAlgorithm.analyseHu(cache, laiziCount, result)
    end

    -- 牌牌癞子(刻)
    if (laiziCount > 0) then
        count = #zu[1]
        if (count >= 2) then
            cache = table.cloneq(zu)
            local v = cache[1].value
            for i = 1, 2 do
                removeCard(cache, 1)
            end
            result.ting[v] =(result.ting[v] or 0) + 1
            mjAlgorithm.analyseHu(cache, laiziCount - 1, result)
            result.ting[v] = result.ting[v] -1
        end
    end

    -- 牌 癞子 癞子(刻)
    if (laiziCount > 1) then
        count = #zu[1]
        if (count >= 1) then
            cache = table.cloneq(zu)
            local v = cache[1].value
            removeCard(cache, 1)
            result.ting[v] =(result.ting[v] or 0) + 1
            mjAlgorithm.analyseHu(cache, laiziCount - 2, result)
            result.ting[v] = result.ting[v] -1
        end
    end


    if #result.out == 0 then
        cache = table.cloneq(zu)
        table.insert(result.out, cache[1].value)
        removeCard(cache, 1)
        mjAlgorithm.analyseHu(cache, laiziCount, result)
        result.out = { }
    end

    return(#zu == lzCount)
end

-- endregion
