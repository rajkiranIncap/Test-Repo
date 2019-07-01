({
jsLoaded: function(component, event, helper) {
    setTimeout(function() {
        var latitude = 51.505;
            var  longitude= -0.09;
       /*  We need to make tile provider dynamic so that the organization using any tile provider can utilize there own tiles.
        //using arcgisonline tile for map display.
        var map = L.map('map', {zoomControl: false}).setView([37.784173, -122.401557], 14);
        L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
            {
                attribution: 'Tiles © Esri'
            }).addTo(map);

        // Add marker
        L.marker([37.784173, -122.401557]).addTo(map)
            .bindPopup('Home of Dreamforce');
        
        */
        
        /*var map = L.map('map').setView([51.505, -0.09], 13);
		//using openstreetmap tile for map display
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        
        L.marker([51.5, -0.09]).addTo(map)
            .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
            .openPopup();
        */
        
         var map = L.map('map').setView([latitude,longitude ], 13);
		//using mapbox tile for map display
		//access_token must be configurable from design attribute.
        L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoia2FrdWxhIiwiYSI6ImNqMmNidjVidzAxeWQycW83MngxMzc5OGkifQ.O8Ak0B0n5YYBhLpCwUdmbQ', {
                attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                maxZoom: 18,
                id: 'mapbox.streets', //mapbox.satellite,
                accessToken: 'your.mapbox.access.token'
            }).addTo(map);
        
        L.marker([latitude,longitude]).addTo(map)
            .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
            .openPopup();
        
        
        
        
        //adding the marker lets enable or disable this.
        var marker = L.marker([latitude,longitude]).addTo(map);
        
        //options we can configure as required, lets make this generic
        //Markers, circles and polygons
        var options = {
            color: 'red',
            fillColor: '#f03',
            fillOpacity: 0.5,
            radius: 500
        };
        var circle = L.circle([51.508, -0.11], options).addTo(map);
        var polygon = L.polygon([
            [51.509, -0.08],
            [51.503, -0.06],
            [51.51, -0.047]
        ]).addTo(map);
        
        
        marker.bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
        circle.bindPopup("I am a circle.");
        polygon.bindPopup("I am a polygon.");
        
        /*var popup = L.popup()
        .setLatLng([51.5, -0.09])
        .setContent("I am a standalone popup.")
        .openOn(map);*/
        
        
        
        var popup = L.popup();
        
        function onMapClick(e) {
            popup
                .setLatLng(e.latlng)
                .setContent("You clicked the map at " + e.latlng.toString())
                .openOn(map);
            helper.setMapView(component,event,helper,map,e.latlng);
        }
        
        map.on('click', onMapClick);
        
        
        });
},setMapViewxx : function(component, event,map,latlng) {
        component.set("v.isRendered",false);
        component.set("v.isRendered",true);
         map = null;
		 map = L.map('map').setView([latlng.lat, latlng.lng], 13);
		//using mapbox tile for map display
		//access_token must be configurable from design attribute.
        L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoia2FrdWxhIiwiYSI6ImNqMmNidjVidzAxeWQycW83MngxMzc5OGkifQ.O8Ak0B0n5YYBhLpCwUdmbQ', {
                attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                maxZoom: 18,
                id: 'mapbox.streets', //mapbox.satellite,
                accessToken: 'your.mapbox.access.token'
            }).addTo(map);
        
        L.marker([latlng.lat, latlng.lng]).addTo(map)
            .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
            .openPopup();
        
        
        
        
        //adding the marker lets enable or disable this.
        var marker = L.marker([latlng.lat, latlng.lng]).addTo(map);
        
        //options we can configure as required, lets make this generic
        //Markers, circles and polygons
        var options = {
            color: 'red',
            fillColor: '#f03',
            fillOpacity: 0.5,
            radius: 500
        };
        var circle = L.circle([51.508, -0.11], options).addTo(map);
        var polygon = L.polygon([
            [51.509, -0.08],
            [51.503, -0.06],
            [51.51, -0.047]
        ]).addTo(map);
        
        
        marker.bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
        circle.bindPopup("I am a circle.");
        polygon.bindPopup("I am a polygon.");
        var popup = L.popup();
        function onMapClick(e) {
            popup
                .setLatLng(e.latlng)
                .setContent("You clicked the map at " + e.latlng.toString())
                .openOn(map);
           setMapView(component,event,map,e.latlng);
        }
        
        map.on('click', onMapClick);
        
	},
    recursiveCall : function(component,event,helper){
        
    }
})