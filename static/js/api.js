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

    module.getAnalysis = () => {
        send("GET", "/analysis", null, function(err, res){
             if (err) return notifyErrorListeners(err);
             notifyResultListeners(res.url);
        });
    }
    
    let resultListeners = [];
    
    function notifyResultListeners(url){
        console.log(url);
        resultListeners.forEach(function(listener){
            listener(url);
        });
    };
    
    module.onResultUpdate = function(listener){
        resultListeners.push(listener);
    }
    
    return module;
})();