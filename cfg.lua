Salon = {}

Salon.Target = true  -- nije zavrseno ne dirati
Salon.Katalog = false -- ako je true morate dodati item u ox_inventory/data/items.lua (u readme mozete naci item)


Salon.TabliceRazmak = false -- false ako ne zelite razmak izmedju tablica
Salon.Slova  = 3 -- koliko slova ce biti na tablicama
Salon.Brojevi  = 3 -- koliko brojeva ce biti na tablicama


Salon.Lokacije = {
    spawn = vec3(909.248108, 3602.439941, 32.850979),
    kamera = vec3(909.248108, 3602.439941, 32.850979), -- trebalo bi da bude isto kao i spawn
    spawnKupljeno = vec3(902.331970, 3610.382568, 32.860050)
}

notifikacija = function(p,s)
    lib.defaultNotify({
        description = p,
        status = s
    })
end

RegisterNetEvent('pSalon:notif', function(p,s)
    notifikacija(p,s)
end)