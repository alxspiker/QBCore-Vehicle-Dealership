# QBCore Vehicle Dealership

This resource provides a QBCore server-side script for managing a vehicle dealership.

**Features:**

* Integrates with qb-mechanic (optional)
* Allows filtering vehicles by brand (optional)

**Installation:**

1. Add this [resource](https://github.com/GasparMPereira/FiveMMediaHost) to your server.
2. Place vehicle images inside the `images` folder. (One image per vehicle model)
3. Configure `FiveMMediaHost` (See link below) to point to the `images` folder.
    * **Important:** Only set the directories in `FiveMMediaHost` configuration, do not modify other settings.
4. (Optional) Uncomment line 35 in `client.lua` if you use `qb-mechanic`.
5. (Optional) Uncomment line 28 in `web-files/script.js` to enable the "All Brands" filter.
6. Update lines 49 and 95 in your server files to point to your Cfx server URL.

**Image Handling:**

* This script utilizes `FiveMMediaHost` for image management.
* Configure `FiveMMediaHost` to serve images from the `images` folder within this resource.

**FiveMMediaHost:**

This script relies on a separate resource called `FiveMMediaHost` for image hosting. 

* Follow the installation instructions for `FiveMMediaHost` to set it up

**Troubleshooting:**

* Ensure the image file names match your vehicle models exactly.
* Verify your Cfx server URL is correct in lines 49 and 95.
* Double-check your `FiveMMediaHost` configuration.

**Additional Notes:**

* This script is designed to work with QBCore framework.
* The "All Brands" filter is an optional feature.
