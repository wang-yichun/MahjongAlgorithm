-- 功能：分割字符串
-- 参数：带分割字符串，分隔符
-- 返回：字符串表
function string.split(str, delimiter)
    str = tostring(str)
    delimiter = tostring(delimiter)
    if (delimiter == '') then return false end
    local pos, arr = 0, { }
    -- for each divider found
    for st, sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

-- 功能：统计字符串中字符的个数
-- 返回：总字符个数、英文字符数、中文字符数
function string.count(str)
    local tmpStr = str
    local _, sum = string.gsub(str, "[^\128-\193]", "")
    local _, countEn = string.gsub(tmpStr, "[%z\1-\127]", "")
    return sum, countEn, sum - countEn
end
-- 功能：计算字符串的宽度，这里一个中文等于两个英文
function string.width(str)
    local _, en, cn = string.count(str)
    return cn * 2 + en
end

-- 功能: 把字符串扩展为长度为len,居中对齐, 其他地方以filledChar补齐
-- 参数: str 需要被扩展的字符、数字、字符串表，len 被扩展成的长度，
--       filledChar填充字符，可以为空
function string.tocenter(str, len, filledChar)
    local function tocenter(str, len, filledChar)
        str = tostring(str);
        filledChar = filledChar or " ";
        local nRestLen = len - string.width(str);
        -- 剩余长度
        local nNeedCharNum = math.floor(nRestLen / string.width(filledChar));
        -- 需要的填充字符的数量
        local nLeftCharNum = math.floor(nNeedCharNum / 2);
        -- 左边需要的填充字符的数量
        local nRightCharNum = nNeedCharNum - nLeftCharNum;
        -- 右边需要的填充字符的数量

        str = string.rep(filledChar, nLeftCharNum) .. str .. string.rep(filledChar, nRightCharNum);
        -- 补齐
        return str
    end
    if type(str) == "number" or type(str) == "string" then
        if not string.find(tostring(str), "\n") then
            return tocenter(str, len, filledChar)
        else
            str = string.split(str, "\n")
        end
    end
    if type(str) == "table" then
        local tmpStr = tocenter(str[1], len, filledChar)
        for i = 2, #str do
            tmpStr = tmpStr .. "\n" .. tocenter(str[i], len, filledChar)
        end
        return tmpStr
    end

end
-- 功能: 把字符串扩展为长度为len,左对齐, 其他地方用filledChar补齐
function string.toleft(str, len, filledChar)
    local function toleft(str, len, filledChar)
        str = tostring(str);
        filledChar = filledChar or " ";
        local nRestLen = len - string.width(str);
        -- 剩余长度
        local nNeedCharNum = math.floor(nRestLen / string.width(filledChar));
        -- 需要的填充字符的数量

        str = str .. string.rep(filledChar, nNeedCharNum);
        -- 补齐
        return str;
    end
    if type(str) == "number" or type(str) == "string" then
        if not string.find(tostring(str), "\n") then
            return toleft(str, len, filledChar)
        else
            str = string.split(str, "\n")
        end
    end
    if type(str) == "table" then
        local tmpStr = toleft(str[1], len, filledChar)
        for i = 2, #str do
            tmpStr = tmpStr .. "\n" .. toleft(str[i], len, filledChar)
        end
        return tmpStr
    end
end
-- 功能: 把字符串扩展为长度为len,右对齐, 其他地方用filledChar补齐
function string.toright(str, len, filledChar)
    local function toright(str, len, filledChar)
        str = tostring(str);
        filledChar = filledChar or " ";
        local nRestLen = len - string.width(str);
        -- 剩余长度
        local nNeedCharNum = math.floor(nRestLen / string.width(filledChar));
        -- 需要的填充字符的数量

        str = string.rep(filledChar, nNeedCharNum) .. str;
        -- 补齐
        return str;
    end
    if type(str) == "number" or type(str) == "string" then
        if not string.find(tostring(str), "\n") then
            return toright(str, len, filledChar)
        else
            str = string.split(str, "\n")
        end
    end
    if type(str) == "table" then
        local tmpStr = toright(str[1], len, filledChar)
        for i = 2, #str do
            tmpStr = tmpStr .. "\n" .. toright(str[i], len, filledChar)
        end
        return tmpStr
    end
end

-- 测试代码
--print("对齐测试\n")
--print(string.tocenter(string.split("居中cc\n居中", "\n"), 4 * 2, "*"))
--print(string.tocenter("居中cc\n居中", 4 * 2))
--print("\n")
--print(string.toright(string.split("居右rr\n居右", "\n"), 4 * 2, "*"))
--print(string.toright("居右rr\n居右", 4 * 2))
--print("\n")
--print(string.toleft(string.split("居左ll\n居左", "\n"), 4 * 2, "*"))
--print(string.toleft("居左ll\n居左", 4 * 2))