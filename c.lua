AddEventHandler('prikazi', function(args)
    print(args.stanje)
    local xyz = Salon.Lokacije.kamera
    local h = 100.0
    local d = 5.0

    if not args.vozilo then return end
    if args.stanje < 1 then return end 
    if xyz then
        local loaded = ucitajModel(args.vozilo)
        while not loaded do
            Wait(1)
            print('ucitavanje modela')
        end
        if ESX.Game.IsSpawnPointClear(vector3(xyz.x, xyz.y, xyz.z), 4.0) then 
            ESX.Game.SpawnLocalVehicle(args.vozilo, vector3(xyz.x, xyz.y, xyz.z), h, function(vehicle)
               currentVeh = vehicle
               napraviKameru(xyz, h, d)
               DisplayRadar(false)
               FreezeEntityPosition(PlayerPedId(), true )
               zigaBugule()
               exports['sCore']:notifikacija('[E] - da izadjes')
            end)
        else 
            exports['sCore']:notifikacija('Spawnpoint je blokiran, vozilo ce biti obrisano za 5 sekundi')
            Wait(5000)
            obrisiVozila(xyz)
        end
        return false
    end
end)

AddEventHandler('kupivozilo', function(args)
    ESX.TriggerServerCallback('proveristanje', function(jelima)
        if jelima then 
            ESX.Game.SpawnVehicle(args.vozilo, Salon.Lokacije.spawnKupljeno, 267.0, function(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                local tablice = generisiTablice()
                SetVehicleNumberPlateText(vehicle, tablice)
                Wait(500)
                local props = ESX.Game.GetVehicleProperties(vehicle)
                Wait(200)
                TriggerServerEvent('setajvozilo',args.vozilo, props, tablice)

            end)
        else
            notifikacija('Nemas dovoljno novca', 'info')   
        end
    end, args.vozilo)
end)

AddEventHandler('drugi', function(args)
    lib.registerContext({
        id = 'drugimenu',
        title = 'Salon',
        options = {
            ['Prikazi Vozilo'] = {
               event = 'prikazi',
               args = args
            },
            ['Kupi Vozilo'] = {
                event = 'kupivozilo',
                args = args
             },
             ['Test Voznja'] = {
                event = 'testvoznja',
                args = args
             },
        }
    })
    if args.stanje >= 1 then 
        lib.showContext('drugimenu')
    else 
        notifikacija('Nema vozila na stanju', 'error')   
    end
end)

AddEventHandler('testvoznja', function(args)
    notifikacija('Test voznja trenutno nije u funkciji', 'info')
end)

exports.qtarget:AddCircleZone("aa", vector3(895.76, 3617.58, 32.83),1.0, {
	name="aa",
	
	debugPoly=false,

	}, {
		options = {
			{
			action = function() otvoriSalon() end,
			label = "Lista Vozila",
			},
	
		},
		distance = 3.5
})

----------#----------#funkcije#----------#----------#
otvoriSalon = function()
    prikazai = {}
    ESX.TriggerServerCallback('getajvozila', function(vozilaa)
        if vozilaa ~= nil then
            for k, v in pairs(vozilaa) do
                prikazai[#prikazai + 1] = {
                    
                    title = v.ime,
                    image = v.slika,
                    metadata = {'Cena - '..v.cena..'$', 'Stanje: '..v.stanje}, 
                    event = 'drugi',
                    args = {vozilo = v.vozilo , stanje = v.stanje}
                }
            end
            lib.registerContext({
                id = 'prikazia',
                title = 'Vozila',
                options = prikazai
            })
            lib.showContext('prikazia')
        end
    end)
end

napraviKameru = function (xyz, h, d)
    if not _k and currentVeh then
        local c = GetOffsetFromEntityInWorldCoords(currentVeh, -0.0, d, 0.0)
        usao = true 
        _k = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        RenderScriptCams(true, true, 500, 1, 0)
        SetCamActive(_k, true)
        SetCamRot(_k, -3.0, 0.0, h - 180)
        SetCamFov(_k, 60.0)
        SetCamCoord(_k, c.x, c.y, c.z + 0.5)
    end
end

unistiKameru = function()
    if _k then
        usao = false 
        DestroyCam(_k)
        RenderScriptCams(false, true, 500, 1, 0)
        _k = false
    end
end


ucitajModel = function(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    print('model ucitan')
    return true
end

obrisiVozila = function(xyz)
    local vozila = ESX.Game.GetVehiclesInArea(vec3(xyz.x, xyz.y, xyz.z), 4.0)
    for k,entity in ipairs(vozila) do
        if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
            ESX.Game.DeleteVehicle(entity)
            notifikacija('Vozila su izbrisana, mozete prikazati vozilo sad', 'success')
        end
    end
end

zigaBugule = function()
    CreateThread(function()
        while true do 
            Wait(0)
            if usao then 
                if IsControlJustPressed(0, 38) then 
                    ESX.Game.DeleteVehicle(currentVeh)
                    Wait(100)
                    DisplayRadar(true)
                    unistiKameru()
                    otvoriSalon()
                    FreezeEntityPosition(PlayerPedId(), false)
                    break;
                end   
            end
        end
    end)
end

if Salon.Katalog then 
    exports('katalog', function(data, slot)
        exports.ox_inventory:useItem(data, function(data)
            if data then
                katalog = {}
                ESX.TriggerServerCallback('getajvozila', function(vozilaa)
                    if vozilaa ~= nil then
                        for k, v in pairs(vozilaa) do
                            katalog[#katalog + 1] = {
                                title = v.ime,
                                --metadata = {'Cena - '..v.cena..'$', 'Stanje: '..v.stanje},
                                --image = v.slika
                            }
                        end
                        lib.registerContext({
                            id = 'katalog',
                            title = 'Vozila',
                            options = katalog
                        })
                        lib.showContext('katalog')
                    end
                end)
            end
        end)
    end)
end



local br = {}
local sl = {}

for i = 48,  57 do table.insert(br, string.char(i)) end

for i = 65,  90 do table.insert(sl, string.char(i)) end
for i = 97, 122 do table.insert(sl, string.char(i)) end

function generisiTablice()
	local tablica
	local br = false
	while true do
		Wait(0)
		math.randomseed(GetGameTimer())
		if Salon.TabliceRazmak then
			tablica = string.upper(randomSlovo(Salon.Slova) .. ' ' .. randomBroj(Salon.Brojevi))
		else
			tablica = string.upper(randomSlovo(Salon.Slova) .. randomBroj(Salon.Brojevi))
		end

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
			if not isPlateTaken then
				br = true
			end
		end, tablica)

		if br then
			break
		end
	end

	return tablica
end


function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Wait(0)
	end

	return callback
end

function randomBroj(duzina)
	Wait(0)
	if duzina > 0 then
		return randomBroj(duzina - 1) .. br[math.random(1, #br)]
	else
		return ''
	end
end

function randomSlovo(duzina)
	Wait(0)
	if duzina > 0 then
		return randomSlovo(duzina - 1) .. sl[math.random(1, #sl)]
	else
		return ''
	end
end
-- exports['pSalon']:generisiTablice() ako nekom treba
exports('generisiTablice', generisiTablice);