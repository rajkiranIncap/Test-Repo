({
	setMapView : function(component, event,helper,map,latlng) {
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
           helper.setMapView(component,event,helper,map,e.latlng);
        }
        
        map.on('click', onMapClick);
        
	},recursiveCallHelper : function(component,event,map,latlng){
        this.setMapView(component,event,map,latlng);
    }
})