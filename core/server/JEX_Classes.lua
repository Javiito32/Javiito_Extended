function CreateJEXPlayer(identifier)
    local self = {}

    self.steam64 = identifier

    local data = MySQL.Sync.fetchAll("SELECT * FROM jex_users WHERE identifier = @steam64_hex", {
        ['@steam64_hex'] = identifier
    })

    self.xp = json.decode(data[1].xp)
    self.levelsxp = json.decode(data[1].levelsxp)

    data = nil
    -- No data usage below this line

    self.save = function()
        MySQL.Async.execute('UPDATE jex_users SET xp = @_xp, levelsxp = @_levelsxp WHERE identifier = @steam64_hex',
        { 
            ['@_xp'] = json.encode(self.xp),
            ['@_levelsxp'] = json.encode(self.levelsxp),
            ['@steam64_hex'] = self.steam64
        })
    end

    self.getXPLevel = function(work)
        return self.levelsxp[work]
    end

    self.upgradeXPLevel = function(work)
        self.levelsxp[work] = self.levelsxp[work] + 1
        self.save()
    end

    self.getXP = function(work)
        return self.xp[work]
    end

    self.addXP = function(work, xptoadd)
        self.xp[work] = self.xp[work] + xptoadd
        self.save()

        for i = #WorkLevels[work], 1, -1 do
            if self.getXP(work) >= WorkLevels[work][i] then
                if self.getXPLevel(work) < i then
                    self.upgradeXPLevel(work)
                    TriggerEvent('JEX:LevelUpgrade', self.steam64, i, work)
                end
            end
        end
    end

    self.getXPmultiplier = function(work, grade)
        if grade then
            return WorkMultiplier[work][grade]
        else
            local level = self.getXPLevel(work)
            if level == 0 then
                return 1.0
            else
                return WorkMultiplier[work][level]
            end
        end
    end

    self.getAllXP = function()
        return self.xp
    end

    self.getAllLevels = function()
        return self.levelsxp
    end

    return self
end