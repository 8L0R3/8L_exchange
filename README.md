<h1 align="center" id="title">8L_exchange</h1>

<p id="description">System for exchanging items for vehicles and items for items. QBCore framework</p>

  
  
<h2>🧐 Features</h2>

Here're some of the project's best features:

*   You can exchange items for other items and you can exchange items for vehicles
*   To open the menu just interact with the ped
*   Everything is configurable
*   automatic plate generation
*   Vehicles are stored in the database

<h2>🛠️ Installation Steps:</h2>

<p>1. dependencies :</p>

```
qb-core / qb-menu / oxmysql / qb-vehiclekeys / qb-target
```

<p>2. Edit shared/config.lua</p>

<p>3. Edit client/menu.lua</p>

```
Change label menu : function OpenMainMenu()
```

<p>4. Edit server.cfg</p>

```
ensure 8L_exchange
```

<p>5. Reboot your FxServer</p>
