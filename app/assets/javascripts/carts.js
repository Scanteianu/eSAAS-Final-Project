let map;
const columbiaUniversityLatLng = {
    lat: 40.80756390195308,
    lng: -73.96260488871613
};

const foodCartCoords = [
    {
        name: 'Uncle Luoyang',
        position: { 
            lat: 40.80877070458994,
            lng: -73.96310377081672
        }
    },
    {
        name: 'Chicken Guys',
        position: {
            lat: 40.80680499795128,
            lng: -73.96078581662722
        }
    },
    {
        name: 'Shwarma Cart',
        position: {
            lat: 40.80753715418158,
            lng: -73.96469123200576
        }
    }
]

function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        center: columbiaUniversityLatLng,
        zoom: 15
    });

    foodCartCoords.forEach(foodCartCoord => {
        console.log(foodCartCoord)
        new google.maps.Marker({
            position: foodCartCoord.position,
            map,
            title: foodCartCoord.name
        });
    });
}