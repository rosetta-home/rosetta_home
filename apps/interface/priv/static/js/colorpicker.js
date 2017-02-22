function rgbToHsv(r, g, b) {
    r /= 255, g /= 255, b /= 255;
    var max = Math.max(r, g, b), min = Math.min(r, g, b);
    var h, s, v = max;
    var d = max - min;
    s = max == 0 ? 0 : d / max;
    if (max == min) {
        h = 0; // achromatic
    } else {
        switch (max) {
            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
            case g: h = (b - r) / d + 2; break;
            case b: h = (r - g) / d + 4; break;
        }
        h /= 6;
    }
    return [ Math.round(h*360), Math.round(s*100), Math.round(v*100) ];
}

function getColor(id, x, y, ctx){
    var imgData = ctx.getImageData(x, y, 1, 1);
    var d = imgData.data;
    var hsv = rgbToHsv(d[0], d[1], d[2])
    app.ports.gotColor.send({id: id, h: hsv[0], s: hsv[1], v: hsv[2]});
}

function hideColorPicker(id){
    try{
        var el = document.getElementById(id);
        var c = el.getElementsByTagName('canvas')[0];
        el.removeChild(c);
    }catch(e){}
}

function showColorPicker(id){
    var el = document.getElementById(id);
    var w = el.scrollWidth;
    var h = 100;
    var c = document.createElement("canvas");
    c.width = w;
    c.height = h;
    c.className += "color-picker";
    c.id = id + "-color-picker";
    c.addEventListener("click", function(ev){
        getColor(id, ev.offsetX, ev.offsetY, ctx);
    });
    el.appendChild(c);
    var ctx = c.getContext("2d");
    ctx.clearRect(0, 0, w, h);
    var g = ctx.createLinearGradient(0,0,w,0);
    for(i=0; i<10; i++){
        g.addColorStop(((i+1)*0.1), "hsla("+(i*40)+", 100%, 50%, 1.0)")
    }
    ctx.fillStyle = g
    ctx.fillRect(0, 0, w, h);
    var g_a = ctx.createLinearGradient(0, 30, 0, h);
    g_a.addColorStop(0, "hsla("+(i*40)+", 100%, 100%, 0)");
    g_a.addColorStop(1, "hsla("+(i*40)+", 100%, 100%, 1)");
    ctx.fillStyle = g_a
    ctx.fillRect(0, 0, w, h);
}
