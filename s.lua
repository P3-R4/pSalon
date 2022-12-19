ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
	function(result)
		cb(result ~= nil)
	end)
end)

ESX.RegisterServerCallback('getajvozila', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM salon", {}, function(rezultat)
        local vozila = {}
        if rezultat then
            for i = 1, #rezultat, 1 do
                table.insert(vozila, {ime = rezultat[i].imevozila, vozilo = rezultat[i].model, cena = rezultat[i].cena, stanje = rezultat[i].stanje, slika = rezultat[i].slika})
            end
            cb(vozila)
        end
    end)
end)

ESX.RegisterServerCallback('proveristanje', function(source, cb, model)
	local xPlayer = ESX.GetPlayerFromId(source)

	--local stanje = MySQL.scalar.await('SELECT stanje FROM salon WHERE model = ?', {model})

	local cena = MySQL.scalar.await('SELECT cena FROM salon WHERE model = ?', {model})

	if xPlayer.getMoney() >= cena then 
	cb(true)
	else 
	cb(false)
	end
end)

RegisterNetEvent('setajvozilo', function(args,props) 
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local stanje = MySQL.scalar.await('SELECT stanje FROM salon WHERE model = ?', {args})
	--print(json.encode(props))

	if stanje >= 1 then 
		if args and props then 
			local cena = MySQL.scalar.await('SELECT cena FROM salon WHERE model = ?', {args})

			if xPlayer.getMoney() >= cena then 
				local result = MySQL.insert.await('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?,?,?)', {
					xPlayer.identifier,
					props.plate,
					json.encode(props)
				})
				print('kupio')
				xPlayer.removeMoney(cena)

				MySQL.Async.execute('UPDATE salon SET stanje = @stanje WHERE model = @model', {
					['@model'] = args,
					['@stanje'] = stanje - 1,
				})
			else 
				TriggerClientEvent('pSalon:notif', source, 'Nemate dovoljno novca','error')
			end
		end
	end
end)

--[[RegisterNetEvent('setajvozilomafija', function(args,props) ------------- WIP -------------
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local stanje = MySQL.scalar.await('SELECT stanje FROM salon WHERE model = ?', {args})


	if stanje >= 1 then 
		if args and props then 
			local cena = MySQL.scalar.await('SELECT cena FROM salon WHERE model = ?', {args})

			if xPlayer.getMoney() >= cena then 

				MySQL.Async.execute('INSERT INTO mafije_vozila (owner, vehicle) VALUES (@owner, @vehicle)', {
					['@owner']   = xPlayer.job.name,
					['@vehicle'] = props,
				})	
				xPlayer.removeMoney(cena)

				MySQL.Async.execute('UPDATE salon SET stanje = @stanje WHERE model = @model', {
					['@model'] = args,
					['@stanje'] = stanje - 1,
				})
			else 
				TriggerClientEvent('pSalon:notif', source, 'Nemate dovoljno novca','error')
			end
		end
	end
end)]]




RegisterCommand('test', function(source)
TriggerClientEvent('pSalon:notif', source, 'a','error')
end)
