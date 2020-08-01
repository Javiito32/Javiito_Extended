function getLabelFromWork(work)
    local workLabel = work
    for k, v in pairs(Config.WorkLabel) do
        if k == work then
            workLabel = v
        end
    end
    return workLabel
end