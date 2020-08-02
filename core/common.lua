function getLabelFromWork(work)
    local workLabel = work
    if Config.WorkLabels[work] then
        workLabel = Config.WorkLabels[work]
    end
    return workLabel
end