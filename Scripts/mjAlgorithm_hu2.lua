-- ethan created

-- 在cards 中存在target 中全部元素 返回true, 否则返回 false
function mjAlgorithm.cardsContainsTarget(_cards, _target)

    local cards = table.cloneq(_cards)
    local target = table.cloneq(_target)
    local result = { empty_index = { } }

    for i = 1, #target do
        local target_value = target[i]

        local empty = true;
        for j = 1, #cards do
            if target_value == cards[j] then
                table.removebyvalue(cards, target_value, false)
                table.insert(result, target_value)
                empty = false;
                break;
            end
        end

        if empty then
            table.insert(result.empty_index, { idx = i, value = target_value })
        end

    end
    return result
end

-- 从cards 里面得到一个赖子返回出来, 并不改变原cards
function mjAlgorithm.getLaiziFromCards(cards, laizi)
    for i = 1, #cards do
        for j = 1, #laizi do
            if cards[i] == laizi[j] then
                return cards[i]
            end
        end
    end
    return nil
end

function mjAlgorithm.isLaizi(laizi, card)
    return table.indexof(laizi, card) ~= false;
end

function mjAlgorithm.laiziCountInCards(cards, laizi)
    local count = 0
    for i = 1, #cards do
        for j = 1, #laizi do
            if cards[i] == laizi[j] then
                count = count + 1
            end
        end
    end
    return count
end

-- ret: 2牌数可胡, 1牌数可听, 0非法(缺张牌)
function mjAlgorithm.isCheckHu(card_num)
    return card_num % 3
end

function mjAlgorithm.Result2ContainResult(result2, result)

    for i = 1, #result2 do
        local match = true

        local r2 = result2[i]
        if #r2 == #result then
            for idx = 1, #r2 do
                if #r2[idx] ~= #result[idx] then
                    match = false
                    break
                elseif #r2[idx] == 2 then
                    if (r2[idx][1] ~= result[idx][1] or r2[idx][2] ~= result[idx][2]) then
                        match = false
                    end
                elseif r2[idx][1] ~= result[idx][1] or r2[idx][2] ~= result[idx][2] or r2[idx][3] ~= result[idx][3] then
                    match = false
                    break;
                end
            end
        else
            match = false
        end

        if match then
            return true
        end
    end

    return false
end

function mjAlgorithm.hu2(myCard, otherCard, lastCard, laizi, configJson)

    local ret = { data = { } }

    mjAlgorithm.laizi = laizi

    if lastCard <= 0 then return { } end

    local cards = { }

    table.insertto(cards, myCard);
    table.insert(cards, lastCard);

    table.sort(cards, function(a, b) return a > b end)
    --    logt(cards)

    local check_res = mjAlgorithm.isCheckHu(#cards)

    if check_res == 2 then
        -- 牌数可胡
        -- 1.检查当前是否胡牌
        -- 2.检查打出任意一张牌后是否可听, 听哪些牌
        mjAlgorithm.check_hu_loop_id = 0
        result = { lz = { } }
        result2 = { }

        local need_baotou = false

        if configJson.MagicNeedBaotou == 1 then
            local laizi_count = mjAlgorithm.laiziCountInCards(cards, laizi)
            if laizi_count > 0 then
                need_baotou = true
            end
        end

        local param = { need_baotou = need_baotou }

        mjAlgorithm.analyseHu2(cards, laizi, result, result2, param)

        --        for i = 1, #result2 do
        --            if result2[i].lz.win > 0 then
        --               ret['hu_all'] = true
        --               break;
        --            end
        --        end

        log_result2(result2)

        -- 找各种听牌

        ret['data'], ret['hu_all'] = mjAlgorithm.analyseTing2(cards, laizi, result, result2, param)

    elseif check_res == 1 then
        -- 牌数可听
        -- 1.是否可听, 听哪些牌


        -- mjAlgorithm.analyseTing2(cards, laizi, result, result2, param)
    else
        print 'wrong cards num'
    end

    return ret
end

function sort_result(a, b)

    local a_type = 0
    local b_type = 0

    if #a == 2 then
        a_type = 3
    elseif a[1] == a[2] then
        a_type = 1
    else
        a_type = 2
    end

    if #b == 2 then
        b_type = 3
    elseif b[1] == b[2] then
        b_type = 1
    else
        b_type = 2
    end

    if a_type ~= b_type then
        return a_type > b_type
    end

    -- a_type == b_type

    return a[1] > b[1]
end

mjAlgorithm.tb_chi = {
    [0x01] = { 0x01, 0x02, 0x03 },
    [0x02] = { 0x02, 0x03, 0x04 },
    [0x03] = { 0x03, 0x04, 0x05 },
    [0x04] = { 0x04, 0x05, 0x06 },
    [0x05] = { 0x05, 0x06, 0x07 },
    [0x06] = { 0x06, 0x07, 0x08 },
    [0x07] = { 0x07, 0x08, 0x09 },
    [0x11] = { 0x11, 0x12, 0x13 },
    [0x12] = { 0x12, 0x13, 0x14 },
    [0x13] = { 0x13, 0x14, 0x15 },
    [0x14] = { 0x14, 0x15, 0x16 },
    [0x15] = { 0x15, 0x16, 0x17 },
    [0x16] = { 0x16, 0x17, 0x18 },
    [0x17] = { 0x17, 0x18, 0x19 },
    [0x21] = { 0x21, 0x22, 0x23 },
    [0x22] = { 0x22, 0x23, 0x24 },
    [0x23] = { 0x23, 0x24, 0x25 },
    [0x24] = { 0x24, 0x25, 0x26 },
    [0x25] = { 0x25, 0x26, 0x27 },
    [0x26] = { 0x26, 0x27, 0x28 },
    [0x27] = { 0x27, 0x28, 0x29 }
}

function mjAlgorithm.analyseHu2(cards, laizi, result, result2, param)

    if param.single_result then
        if #result2 > 0 then return end
    end

    mjAlgorithm.check_hu_loop_id = mjAlgorithm.check_hu_loop_id + 1

    local laizi_count = mjAlgorithm.laiziCountInCards(cards, laizi)

    --    logcur(cards, result)

    --    if mjAlgorithm.check_hu_loop_id == 7 then
    --        print('id:' .. mjAlgorithm.check_hu_loop_id)
    --    end


    if #cards == 2 then
        -- 判定胜利
        local is_win = -1;
        if laizi_count >= 2 then
            is_win = 3
        elseif laizi_count == 1 then
            is_win = 2
        else

            if cards[1] == cards[2] then
                if param.need_baotou then
                    if mjAlgorithm.isLaizi(laizi, cards[1]) then
                        is_win = 1
                    end
                else
                    is_win = 1
                end
            else
                is_win = 0
            end

        end

        if (is_win >= 0 and param.need_baotou == false) or (param.need_baotou and is_win >= 2) then
            local re = table.cloneq(result)
            local temp = { cards[1], cards[2] }
            table.insert(re, temp)
            table.sort(re, sort_result)

            if is_win == 2 then
                if mjAlgorithm.isLaizi(laizi, cards[1]) then
                    re.lz[cards[2]] = 1
                else
                    re.lz[cards[1]] = 1
                end
            end

            re.lz['win'] = is_win

            if mjAlgorithm.Result2ContainResult(result2, re) == false then
                table.insert(result2, re)
            end

            return
        end

    elseif #cards == 1 or #cards == 0 then
        print('wrong remain cards number')
    end

    local zu = mjAlgorithm.analysis(cards)

    --    logzut(zu)

    local chi_group_idxs = { }

    for i = 1, #zu do
        local z = zu[i]
        if #z >= 3 then
            local ca = table.cloneq(cards)
            local re = table.cloneq(result)
            table.removebyvalue(ca, z.value, false)
            table.removebyvalue(ca, z.value, false)
            table.removebyvalue(ca, z.value, false)
            local temp = { z.value, z.value, z.value }
            table.insert(re, temp)
            mjAlgorithm.analyseHu2(ca, laizi, re, result2, param)
        end
        if #z >= 2 and laizi_count >= 1 then
            local ca = table.cloneq(cards)
            local re = table.cloneq(result)
            table.removebyvalue(ca, z.value, false)
            table.removebyvalue(ca, z.value, false)
            local lz = mjAlgorithm.getLaiziFromCards(ca, laizi)
            table.removebyvalue(ca, lz, false)
            if lz ~= nil then
                local temp = { z.value, z.value, - z.value }
                re.lz[z.value] = 1
                table.insert(re, temp)
                mjAlgorithm.analyseHu2(ca, laizi, re, result2, param)
            end
        end
        if #z >= 1 and laizi_count >= 2 then
            local ca = table.cloneq(cards)
            local re = table.cloneq(result)
            table.removebyvalue(ca, z.value, false)
            local lz = mjAlgorithm.getLaiziFromCards(ca, laizi)
            table.removebyvalue(ca, lz, false)
            local lz2 = mjAlgorithm.getLaiziFromCards(ca, laizi)
            table.removebyvalue(ca, lz2, false)
            if lz ~= nil and lz2 ~= nil then
                local temp = { z.value, - z.value, - z.value }
                re.lz[z.value] = 1
                table.insert(re, temp)
                mjAlgorithm.analyseHu2(ca, laizi, re, result2, param)
            end
        end

        if 0x01 <= z.value and z.value <= 0x09 then
            if z.value - 2 >= 0x01 and z.value - 2 <= 0x07 then chi_group_idxs[z.value - 2] = 1 end
            if z.value - 1 >= 0x01 and z.value - 1 <= 0x07 then chi_group_idxs[z.value - 1] = 1 end
            if z.value >= 0x01 and z.value <= 0x07 then chi_group_idxs[z.value] = 1 end
        elseif 0x11 <= z.value and z.value <= 0x19 then
            if z.value - 2 >= 0x11 and z.value - 2 <= 0x17 then chi_group_idxs[z.value - 2] = 1 end
            if z.value - 1 >= 0x11 and z.value - 1 <= 0x17 then chi_group_idxs[z.value - 1] = 1 end
            if z.value >= 0x11 and z.value <= 0x17 then chi_group_idxs[z.value] = 1 end
        elseif 0x21 <= z.value and z.value <= 0x29 then
            if z.value - 2 >= 0x21 and z.value - 2 <= 0x27 then chi_group_idxs[z.value - 2] = 1 end
            if z.value - 1 >= 0x21 and z.value - 1 <= 0x27 then chi_group_idxs[z.value - 1] = 1 end
            if z.value >= 0x21 and z.value <= 0x27 then chi_group_idxs[z.value] = 1 end
        end
    end

    for k, v in pairs(chi_group_idxs) do
        local tb_chi_item = mjAlgorithm.tb_chi[k]
        local target = { tb_chi_item[1], tb_chi_item[2], tb_chi_item[3] }
        local res = mjAlgorithm.cardsContainsTarget(cards, target)

        if #res >= 3 then
            local ca = table.cloneq(cards)
            local re = table.cloneq(result)
            table.removebyvalue(ca, res[1], false)
            table.removebyvalue(ca, res[2], false)
            table.removebyvalue(ca, res[3], false)
            local temp = { res[1], res[2], res[3] }
            table.insert(re, temp)
            mjAlgorithm.analyseHu2(ca, laizi, re, result2, param)
        elseif #res >= 2 and laizi_count >= 1 then
            local ca = table.cloneq(cards)
            local re = table.cloneq(result)
            table.removebyvalue(ca, res[1], false)
            table.removebyvalue(ca, res[2], false)
            local lz = mjAlgorithm.getLaiziFromCards(ca, laizi)
            table.removebyvalue(ca, lz, false)
            if lz ~= nil then

                local temp = { }
                local idx = 1
                for i = 1, 3 do
                    if res.empty_index[1].idx == i then
                        temp[i] = - res.empty_index[1].value
                        re.lz[res.empty_index[1].value] = 1
                    else
                        temp[i] = res[idx]
                        idx = idx + 1
                    end
                end

                table.insert(re, temp)
                mjAlgorithm.analyseHu2(ca, laizi, re, result2, param)
            end
        end
    end
end

function add_hu_data(data, key, value, laizi)
    if mjAlgorithm.isLaizi(laizi, value) then return end
    if data[key] == nil then
        data[key] = { }
        data[key][value] = 1
    elseif data[key].hu_all == nil then
        data[key][value] = 1
    end
end 

function mjAlgorithm.isZiCard(value)
    return(value >= 0x01 and value <= 0x09) or(value >= 0x11 and value <= 0x19) or(value >= 0x21 and value <= 0x29)
end

function mjAlgorithm.add_hu_data_by_group(data, group, laizi)
    if math.abs(group[1]) == math.abs(group[2]) then
        -- 刻子
        for i = 1, 3 do
            if group[i] < 0 then
                add_hu_data(data, laizi[1], - group[i], laizi)
            else
                add_hu_data(data, group[i], group[i], laizi)
            end
        end
    else
        -- 顺子
        if group[1] < 0 then
            add_hu_data(data, laizi[1], - group[1], laizi)
            if mjAlgorithm.isZiCard(- group[1] + 3) then
                add_hu_data(data, laizi[1], - group[1] + 3, laizi)
            end
        else
            add_hu_data(data, group[1], group[1], laizi)
            if mjAlgorithm.isZiCard(group[1] + 3) then
                add_hu_data(data, group[1] + 3, group[1] + 3, laizi)
            end
        end

        if group[2] < 0 then
            add_hu_data(data, laizi[1], - group[2], laizi)
        else
            add_hu_data(data, group[2], group[2], laizi)
        end

        if group[3] < 0 then
            add_hu_data(data, laizi[1], - group[3], laizi)
            if mjAlgorithm.isZiCard(- group[3] -3) then
                add_hu_data(data, laizi[1], - group[3] -3, laizi)
            end
        else
            add_hu_data(data, group[3], group[3], laizi)
            if mjAlgorithm.isZiCard(group[3] -3) then
                add_hu_data(data, group[3] -3, group[3] -3, laizi)
            end
        end
    end
end

function mjAlgorithm.analyseTing2(cards, laizi, result, result2, param)

    -- 希望获取听哪张牌,就是补一张混子牌,然后看里面的混子牌都补充为什么牌
    local data = { }
    local hu_all = nil

    local laizi_count = mjAlgorithm.laiziCountInCards(cards, laizi)

    for i = 1, #result2 do
        local r = result2[i]

        if r.lz.win > 0 then
            hu_all = true
        end

        if r.lz.win == 3 then
            for j = 1, #cards do
                if mjAlgorithm.isLaizi(laizi, cards[j]) == false then
                    data[cards[j]] = { hu_all = true }
                end
            end
        elseif r.lz.win == 2 then
            for j = 1, #r[1] do
                if mjAlgorithm.isLaizi(laizi, r[1][j]) == false then
                    data[r[1][j]] = { hu_all = true }
                else
                    -- 有龙必须爆头则不应有此处的胡牌
                    -- add_hu_data(data, laizi[1], r[1][3 - j], laizi)
                end
            end
            for j = 2, #r do
                mjAlgorithm.add_hu_data_by_group(data, r[j], laizi)
            end
        elseif r.lz.win == 1 then
            for j = 1, #cards do
                if mjAlgorithm.isLaizi(laizi, cards[j]) == false then
                    add_hu_data(data, cards[j], cards[j], laizi)
                end
            end
        else
            if laizi_count == 0 then
                for j = 1, #r[1] do
                    add_hu_data(data, r[1][1], r[1][2], laizi)
                    add_hu_data(data, r[1][2], r[1][1], laizi)
                end
            end
        end
    end

    return data, hu_all
end