local give = false
local usedRope = false

RegisterServerEvent('esx_barbie_lyftupp:checkRope')
AddEventHandler('esx_barbie_lyftupp:checkRope', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('esx_barbie_lyftupp:falseRope', source) -- ปิด
end)

RegisterServerEvent('esx_barbie_lyftupp:removeRope')
AddEventHandler('esx_barbie_lyftupp:removeRope', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.removeInventoryItem('Rope', 1)
	TriggerClientEvent('esx_barbie_lyftupp:trueUsedRope', source)
	
end)

RegisterServerEvent('cmg3_animations:sync')
AddEventHandler('cmg3_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg3_animations:stop')
AddEventHandler('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)

RegisterServerEvent('esx_barbie_lyftupp:lyfter')
AddEventHandler('esx_barbie_lyftupp:lyfter', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('esx_barbie_lyftupp:upplyft', targetPlayer.source, source)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)

RegisterServerEvent('esx_barbie_lyftupp:sync')
AddEventHandler('esx_barbie_lyftupp:sync', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	
	TriggerClientEvent('esx_barbie_lyftupp:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)

	TriggerClientEvent('esx_barbie_lyftupp:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)

	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)

	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('esx_barbie_lyftupp:stop')
AddEventHandler('esx_barbie_lyftupp:stop', function(targetSrc)
	TriggerClientEvent('esx_barbie_lyftupp:cl_stop', targetSrc)
end)

