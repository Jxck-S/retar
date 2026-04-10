function get_pia_identity(icao, callback){
    $.ajax({
        url: "https://theairtraffic.com/iapi/pia_identity",
        headers: { "Icao": icao},
        success: function(data, status) {
            callback(data);
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log("No Identity Known for", icao);
            callback(null);
        }
    });
}
