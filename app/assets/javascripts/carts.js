const columbiaUniversityLatLng = {
    lat: 40.80756390195308,
    lng: -73.96260488871613
};

let highlightedFoodCartId = '';
let highlightedFoodCardElem;
const highlightedFoodCardClass = 'highlighted-food-cart-card';
let sameMarkerClicked = false;

// Gets Food Cart variable from controller passed as a data-cart HTML attribute
// and converts to json object
function getFoodCartDataFromDOM() {
    const jsonCartArray = [];
    cartElems = document.querySelectorAll('[data-cart]');
    cartElems.forEach(cartElem => {
        jsonCart = JSON.parse(cartElem.dataset.cart);
        const coordinates = jsonCart.coordinates.split(',');
        jsonCart.coordinates = { lat: parseFloat(coordinates[0]), lng: parseFloat(coordinates[1]) };
        jsonCartArray.push(jsonCart);
    });

    return jsonCartArray;
}

function initMap() {
    const foodCarts = getFoodCartDataFromDOM();
    console.log(foodCarts);

    const map = new google.maps.Map(document.getElementById('cart-list-gmap'), {
        center: columbiaUniversityLatLng,
        zoom: 15
    });

    // Info tooltip window for each marker
    const infoTooltipWindow = new google.maps.InfoWindow();

    // Create Food Cart markers on map
    foodCarts.forEach(foodCart => {
        const marker = new google.maps.Marker({
            position: foodCart.coordinates,
            map,
            title: foodCart.name
        });

        // Food Cart marker callback on click
        marker.addListener("click", () => {
            infoTooltipWindow.close();
            infoTooltipWindow.setContent(marker.getTitle());
            infoTooltipWindow.open(marker.getMap(), marker);

            const markerId = marker.getTitle().split(' ').join('-');

            // Highlight Food Cart card
            if (highlightedFoodCartId == markerId) {
                // If clicking on same marker, toggle highlighting class
                if (highlightedFoodCardElem.classList.contains(highlightedFoodCardClass)) {                   
                    highlightedFoodCardElem.classList.remove(highlightedFoodCardClass);
                } else {
                    highlightedFoodCardElem.classList.add(highlightedFoodCardClass);
                }
            } else {
                if (highlightedFoodCartId.length > 0) {
                    // If previously highlighted a Food Cart Card, remove that highlighting class
                    document.getElementById(highlightedFoodCartId);
                    highlightedFoodCardElem.classList.remove(highlightedFoodCardClass);
                }
                            
                highlightedFoodCartId = markerId;
                highlightedFoodCardElem = document.getElementById(highlightedFoodCartId);
                highlightedFoodCardElem.classList.add(highlightedFoodCardClass);                
            }
        });
    });
}