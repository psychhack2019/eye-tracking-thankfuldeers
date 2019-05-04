let api = (function(){
    "use strict";
    
    function send(method, url, data, callback){
        let xhr = new XMLHttpRequest();
        xhr.onload = function() {
            if (xhr.status !== 200) callback("[" + xhr.status + "]" + xhr.responseText, null);
            else callback(null, JSON.parse(xhr.responseText));
        };
        xhr.open(method, url, true);
        if (!data) xhr.send();
        else{
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.send(JSON.stringify(data));
        }
    }
    
    let module = {};
    
    let errorListeners = [];
    
    function notifyErrorListeners(err){
        errorListeners.forEach(function(listener){
            listener(err);
        });
    }
    
    module.onError = function(listener){
        errorListeners.push(listener);
    };

    module.getAnalysis = (id) => {
        send("GET", "/analysis/" + id + '/', null, function(err, res){
             if (err) return notifyErrorListeners(err);
             notifyResultListeners(id, res.url);
        });
    }
    
    let resultListeners = [];
    
    function notifyResultListeners(id, url){
        // console.log(url);
        resultListeners.forEach(function(listener){
            listener(id, url);
        });
    };
    
    module.onResultUpdate = function(listener){
        resultListeners.push(listener);
    }
    
    return module;
})();