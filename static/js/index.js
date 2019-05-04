(function(){
    "use strict";
    
    api.onError(function(err){
        console.error("[error]", err);
    });
    
    api.onError(function(err){
        var error_box = document.querySelector('#error_box');
        error_box.innerHTML = err;
        error_box.style.visibility = 'visible';
    });
    
    api.onResultUpdate(function(url){
        document.getElementById('result').src=url;
        document.getElementById('result').style.display = "block";
    });
    
    window.addEventListener('load', function(){
        document.getElementById("analysis").addEventListener('click', (e) => {
            e.preventDefault();
            api.getAnalysis();
        });
    });
}())

