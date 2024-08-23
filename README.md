# QBCore Vehicle Dealership
 QBCore Server Resource


Uncomment client.lua line 35 if you use qb-mechanic
```lua
TriggerServerEvent('qb-mechanicjob:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
```

Uncomment web-files/script.js line 28 if you want the All option for brands
```lua
$('#brand').append(`<option value="">All Brands</option>`);
```

Change lines 49 and 95 to your cfx url
```html
<img src="https://yoururl.users.cfx.re/FiveMMediaHost/media/${vehicle.model}.jpg" class="card-img-top" alt="${vehicle.name}" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image';">
```

Add this resource to your server and put vehicle images in the images folder
https://github.com/GasparMPereira/FiveMMediaHost

Ensure to follow FiveMMediaHost instructions to set ONLY the directories to the right folder but do not change anything else

Everything should now work!