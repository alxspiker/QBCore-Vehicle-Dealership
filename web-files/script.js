var vehicles = [
  
];

var cash = 0;
var bank = 0;

async function populateFilters() {
  var brands = [];
  var categories = [];
  Object.keys(vehicles).forEach(function(key) {
    if (vehicles[key].brand) {
      if (!brands.includes(vehicles[key].brand)) {
        brands.push(vehicles[key].brand);
      }
    }
    if (vehicles[key].category) {
      if (!categories.includes(vehicles[key].category)) {
        categories.push(vehicles[key].category);
      }
    }
  });

  brands.sort();
  categories.sort();
  $('#brand').empty();
  $('#category').empty();
  //$('#brand').append(`<option value="">All Brands</option>`);
  $('#category').append(`<option value="">All Categories</option>`);
  brands.forEach(brand => {
    $('#brand').append(`<option value="${brand}">${brand.charAt(0).toUpperCase() + brand.slice(1)}</option>`);
  });

  categories.forEach(category => {
    $('#category').append(`<option value="${category}">${category.charAt(0).toUpperCase() + category.slice(1)}</option>`);
  });
  filterVehicles();
}

async function renderVehicles(filteredVehicles) {
  const grid = $('#vehicle-grid');
  grid.empty();
    var index = 0;
    Object.keys(filteredVehicles).forEach(function(key) {
      const vehicle = filteredVehicles[key];
      const card = $(`
        <div class="col">
          <div class="card h-100 bg-custom-dark border-0">
            <img src="https://yoururl.users.cfx.re/FiveMMediaHost/media/${vehicle.model}.jpg" class="card-img-top" alt="${vehicle.name}" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image';">
            <div class="card-body">
              <h5 class="card-title text-custom-accent">${vehicle.name}</h5>
              <div class="price-tag">$${vehicle.price.toLocaleString()}</div>
              <button class="btn btn-custom-accent w-100 buy-button" data-vehicle='${JSON.stringify(vehicle)}'>View Details</button>
            </div>
          </div>
        </div>
      `);
      grid.append(card);
      gsap.from(card[0], {
        duration: 0.5,
        opacity: 0,
        y: 50,
        delay: index * 0.1,
        ease: "power3.out"
      });
      index++;
    });
}

async function filterVehicles() {
  const searchTerm = $('#search').val().toLowerCase();
  const brandFilter = $('#brand').val();
  const categoryFilter = $('#category').val();

  var filteredVehicles = {};
  Object.keys(vehicles).forEach(function(key) {
    const vehicle = vehicles[key];
    const matchesSearch = vehicle.name.toLowerCase().includes(searchTerm);
    const matchesBrand = brandFilter === "" || vehicle.brand === brandFilter;
    const matchesCategory = categoryFilter === "" || vehicle.category === categoryFilter;

    if (matchesSearch && matchesBrand && matchesCategory) {
      filteredVehicles[key] = vehicle;
    }
  });

  renderVehicles(filteredVehicles);
}

function showVehicleDetails(vehicle) {
  const modalContent = $('#modalContent');
  modalContent.html(`
    <div class="row">
      <div class="col-md-6">
        <img src="https://yoururl.users.cfx.re/FiveMMediaHost/media/${vehicle.model}.jpg" class="img-fluid rounded" alt="${vehicle.name}" onerror="this.src='https://via.placeholder.com/400x300?text=No+Image';">
      </div>
      <div class="col-md-6">
        <p class="fw-bold fs-4 text-custom-accent">${vehicle.name}</p>
        <p><strong>Model:</strong> ${vehicle.model}</p>
        <p><strong>Brand:</strong> ${vehicle.brand.charAt(0).toUpperCase() + vehicle.brand.slice(1)}</p>
        <p><strong>Category:</strong> ${vehicle.category.charAt(0).toUpperCase() + vehicle.category.slice(1)}</p>
        <p><strong>Type:</strong> ${vehicle.type.charAt(0).toUpperCase() + vehicle.type.slice(1)}</p>
        <p><strong>Shop:</strong> ${vehicle.shop.charAt(0).toUpperCase() + vehicle.shop.slice(1)}</p>
        <p class="fs-4 fw-bold text-custom-accent">Price: $${vehicle.price.toLocaleString()}</p>
      </div>
    </div>
  `);

  const modal = new bootstrap.Modal(document.getElementById('purchaseModal'));
  modal.show();
  gsap.from("#modalContent > div", {
    duration: 0.5,
    opacity: 0,
    y: 20,
    stagger: 0.2,
    ease: "power3.out"
  });

  $('#confirmPurchase').off('click').on('click', function() {
    BuyVehicle(vehicle.model);
    console.log(`Purchase confirmed for ${vehicle.name}`);
    modal.hide();
  });
}

function BuyVehicle(vehicle) {
  fetch(`https://${GetParentResourceName()}/buy_vehicle`, {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
          vehicle: vehicle
      })
  }).then(resp => resp.json()).then(data => {
      ToggleScreen(false);
  });
}

async function GetVehicles(dealership){
  fetch(`https://${GetParentResourceName()}/get_vehicles`, {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
          shop: dealership
      })
  }).then(resp => resp.json()).then(data => {
      vehicles = data.vehicles;
  }).then(() => {
    populateFilters();
  });
}

async function UpdateVehicles(dealership) {
  if(document.getElementById('purchaseModal') != null) {
    const modal = new bootstrap.Modal(document.getElementById('purchaseModal'));
    modal.hide();
  }
  const grid = $('#vehicle-grid');
  grid.empty();
  GetVehicles(dealership);
}

$(document).ready(() => {

  $('#search').on('input', filterVehicles);
  $('#brand, #category').on('change', filterVehicles);

  $(document).on('click', '.buy-button', function() {
    const vehicle = JSON.parse($(this).attr('data-vehicle'));
    showVehicleDetails(vehicle);
  });
  gsap.from(".sidebar", {
    duration: 1,
    opacity: 0,
    x: -50,
    ease: "power3.out"
  });
});



// Screen toggle //

function bindEscapeKey() {
    esc_keybinder = document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            if(document.body.style.opacity == 1){
                ToggleScreen(false);
            }
        }
    });
}

function sendToggleScreenRequest() {
    fetch(`https://${GetParentResourceName()}/toggle_screen`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            type: "toggle_screen"
        })
    }).then(resp => resp.json());
}

function ToggleScreen(value) {
    if (value == true) {
        showScreen();
    } else if (value == false) {
        hideScreen();
        sendToggleScreenRequest();
    }
}

var background_color = "#000000";

function showScreen() {
    document.body.style.opacity = 1;
    document.body.style.backgroundColor = background_color;
}

function hideScreen() {
    document.body.style.opacity = 0;
    document.body.style.backgroundColor = "#00000000";
    const grid = $('#vehicle-grid');
    grid.empty();
}

window.addEventListener('message', (event) => {
    if (event.data.type === 'toggle_screen' && event.data.value && event.data.dealership && event.data.dealerdata) {
        UpdateVehicles(event.data.dealership);
        var dealership_name = event.data.dealerdata.name;
        var dealership_color = event.data.dealerdata.marker.color; // This is a vector3
        document.getElementById('dealership_name').innerHTML = dealership_name;
        document.getElementById('dealership_name').style.color = `rgb(${dealership_color.x}, ${dealership_color.y}, ${dealership_color.z})`;
        document.documentElement.style.setProperty('--accent-color', `rgb(${dealership_color.x}, ${dealership_color.y}, ${dealership_color.z})`);
        background_color = `rgb(${dealership_color.x/2}, ${dealership_color.y/2}, ${dealership_color.z/2})`;
        ToggleScreen(event.data.value);
    }
});

document.body.style.opacity = 0;
bindEscapeKey();