function hideHistogram(obj){
    try{
        var id = obj.id;
        var type = obj.type;
        var el = document.getElementById(id+"-graph-"+type);
        var c = el.getElementsByTagName('svg')[0];
        el.removeChild(c);
    }catch(e){}
}

function showHistogram(obj){
    var id = obj.id;
    var type = obj.metric_type.replace(" ", "_")
    var objects = {};
    var dom_id = id+"-graph-"+type;
    var dom = document.getElementById(dom_id);
    dom.innerHTML = "<p>Loading Histogram...</p>";
    d3.json("http://"+hostname+":8081/metric_history?device_id="+id+"&sensor_type="+type, function(data) {
        console.log(data);
        var now = new Date().getTime();
        for(var series in data.history){
            var values = [];
            var s = data.history[series];
            var t = now;
            for(var p=0; p < s.values.length; p++){
                var v = s.values[p];
                values.push({x:t, y:v});
                t = now-(p*(1000*60*15));
            }
            var key = s.metric+"-"+s.datapoint;
            obj = {key: key, values: values.reverse()};
            objects[key] = objects[key] || obj;
        }
        if(!$.isEmptyObject(objects)){
            console.log(id, type, objects);
            nv.addGraph(function() {
                var chart = nv.models.lineChart()
                    .useInteractiveGuideline(true)
                    .showLegend(false)

                chart.xAxis.tickFormat(function(d) {
                    return d3.time.format('%H:%M')(new Date(d))
                });
                //objects[type+"-p999"].color = "red";
                //objects[type+"-p50"].color = "blue";
                //objects[type+"-mean"].color = "green";
                objects[type+"-value"].color = "yellow";
                chart.yAxis.tickFormat(d3.format(',.2f'));
                var d = [objects[type+"-value"]]//, objects[type+"-mean"], objects[type+"-p75"], objects[type+"-p999"]].reverse();
                setTimeout(function(){
                    dom.innerHTML = "<svg></svg>";
                    var foo = dom.offsetHeight;
                    d3.select("#"+dom_id+" svg")
                        .datum(d)
                        .call(chart);
                }, 50);
                nv.utils.windowResize(chart.update);
                return chart;
            });
        }else{
            setTimeout(function(){
                var elem = "<div>No historical data yet, please try again in 15 minutes.</div>";
                dom.innerHTML = elem;
            }, 50);

        }
    });
}
