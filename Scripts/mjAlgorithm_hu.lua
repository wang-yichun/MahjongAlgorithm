-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

function mjAlgorithm.hu(myCard, otherCard, lastCard, laizi, configJson)

    mjAlgorithm.check_hu_loop_id = 0

    if lastCard <= 0 then
        return { }
    end
    local result = { out = { }, ting = { } }
    local res_group = { }
    local laiziCard = { }
    local cards = { }
    local zu
    local zu1
    local lzCount
    local temp
    laizi = laizi or { }

    local cc = { }
    table.insertto(cc, myCard)
    table.insert(cc, lastCard)
    table.sort(cc, comp)

    for k, v in pairs(cc) do
        if table.keyof(laizi, v) ~= nil then
            table.insert(laiziCard, v)
        else
            table.insert(cards, v)
        end
    end

    -- 4癞子
    local laiziCount = #laiziCard
    if #laiziCard >= 4 then
        if #laiziCard >= 7 then
            result.laizi4 = true
        else
            table.sort(laiziCard)
            local tmp = 0
            for key, var in pairs(laiziCard) do
                if var == laiziCard[key + 1] then
                    tmp = tmp + 1
                else
                    tmp = 0
                end
                if tmp >= 3 then
                    result.laizi4 = true
                end
            end
        end
        -- table.insert(result,{laizi4=true})
    elseif #laiziCard == 3 then
    end

    zu = mjAlgorithm.analysis(cards)
    if ((#otherCard == 0) and(configJson.HuQiDui > 0)) then
        -- 七小对
        local item1 = { }
        local laiziZu = { }
        zu1 = table.cloneq(zu)

        laiziCount = #laiziCard
        if (configJson.HuQiDui == 1) then
            table.insertto(cards, laiziCard)
            zu1 = mjAlgorithm.analysis(cards)
            laiziCount = 0
        elseif (configJson.HuQiDui == 3) then
            if laiziCount > 2 then
                table.insertto(cards, laiziCard)
                zu1 = mjAlgorithm.analysis(cards)
                laiziCount = 0
            end
        end
        local duiziCount = 0
        while #zu1 > 0 do
            if table.getn(zu1[1]) > 1 then
                removeCard(zu1, 1)
                removeCard(zu1, 1)
                duiziCount = duiziCount + 1
            else
                if laiziCount > 0 then
                    table.insert(laiziZu, zu1[1].value)
                    removeCard(zu1, 1)
                    laiziCount = laiziCount - 1
                    duiziCount = duiziCount + 1
                else
                    insertCard(item1, getCard(zu1, 1))
                    removeCard(zu1, 1)
                end
            end
        end

        if (#item1 == 0) then
            result.qidui = true
            -- table.insert(result,{qidui=true})
        else
            if duiziCount == 6 then
                for key, var in pairs(item1) do
                    table.insert(laiziZu, var.value)
                end
                for key, var in pairs(laiziZu) do
                    for k, v in pairs(laiziZu) do
                        if v ~= var then
                            result.data = result.data or { }
                            result.data[var] = result.data[var] or { }
                            result.data[var][v] = 1
                        end
                    end
                end
            end
        end
    end

    laiziCount = #laiziCard + 1
    local count
    local cardValue
    local tingJiang = { }

    if configJson.MagicNeedBaotou == 1 then
        if laiziCount > 0 then
            result['need_baotou'] = true
        end
    end

    for k, v in pairs(zu) do
        print('  ' .. v.value .. ' ---- ')
        -- 第一部分: 除去两张已有的牌做对子
        zu1 = table.cloneq(zu)

        lzCount = laiziCount

        local need_baotou = false
        if lzCount > 0 then
            need_baotou = true
        end

        if need_baotou == false then
            count = table.getn(zu1[k])
            if count > 1 then
                logzu(zu1, '       --', '')
                removeCard(zu1, k)
                removeCard(zu1, k)

                res_g = table.cloneq(res_group)
                local g = { v.value, v.value }
                table.insert(res_g, g)

                mjAlgorithm.analyseHu(zu1, lzCount, result, res_g)
            end

        end

        -- 第二部分: 除去一张已有的牌,配上一个混子做对子
        if lzCount > 0 then
            zu1 = table.cloneq(zu)
            logzu(zu1, '        -', '')
            lzCount = laiziCount
            temp = zu1[k].value
            removeCard(zu1, k)

            res_g = table.cloneq(res_group)
            local g = { v.value, 0 }
            table.insert(res_g, g)

            if need_baotou == false then result.ting[temp] =(result.ting[temp] or 0) + 1 end
            mjAlgorithm.analyseHu(zu1, lzCount - 1, result, res_g)
            if need_baotou == false then result.ting[temp] = result.ting[temp] -1 end
        end


    end

    -- 第三部分: 两个混子做对子
    lzCount = laiziCount
    if lzCount > 0 then
        zu1 = table.cloneq(zu)
        logzu(zu1, '        *', '')

        res_g = table.cloneq(res_group)
        local g = { 0, 0 }
        table.insert(res_g, g)

        mjAlgorithm.analyseHu(zu1, lzCount - 2, result, res_g)
    end

    result.ting = nil

    return result
end

-- endregion
