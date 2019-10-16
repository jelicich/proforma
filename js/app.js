(function(){
    'use strict';

    var proformify = window.proformify = $.extend(window.proformify, {
        data: null,
        config: null,

        init: function() {
            
            this.getSheetJSON(function() {
                window.riot.mount('*');
            });

        },

        getSheetJSON: function(callback) {
            var url = 'https://www.shmit.com.ar/proformify/service/getJson.php';
            
            $.getJSON(url, function(data) {
                proformify.data = data;
                callback();
            });
                
        }
    });

    window.riot.observable(proformify);

    $(document).ready(proformify.init.bind(proformify));
})();