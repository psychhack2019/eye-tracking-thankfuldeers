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

    let cnt = 0;

    function getOneResult() {
        cnt = cnt + 1;
        if(cnt == 3) {
            document.getElementById("inprogress").style.display="none";
            document.getElementById("analysis").disabled = false;
            document.getElementById("explain").style.display="block";
        }
    }

    api.onResultUpdate(function(id, url){
        document.getElementById(id).src=url;
        document.getElementById(id).style.display="block";
        document.getElementById('results').style.display = "grid";
        getOneResult();
    });
    
    window.addEventListener('load', function(){
        document.getElementById("analysis").addEventListener('click', (e) => {
            e.preventDefault();
            cnt = 0;
            document.getElementById("analysis").disabled = true;
            document.getElementById("inprogress").style.display="block";
            document.getElementById('results').style.display = "none";
            document.getElementById("explain").style.display="none";
            api.getAnalysis('result1');
            api.getAnalysis('result2');
            api.getAnalysis('result3');
        });
    });
}())

