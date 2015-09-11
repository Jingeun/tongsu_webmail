$(function(){

    function initFlot(){
        var data1 = [
                [1, 40],
                [2, 20],
                [3, 40],
                [4, 30],
                [5, 40],
                [6, 35],
                [7, 47]
            ],
            data2 = [
                [1, 10],
                [2, 8],
                [3, 17],
                [4, 10],
                [5, 17],
                [6, 15],
                [7, 16]
            ],
            data3 = [
                [1, 40],
                [2, 13],
                [3, 33],
                [4, 16],
                [5, 32],
                [6, 28],
                [7, 31]
            ],
            $chart = $("#flot-main"),
            $tooltip = $('#flot-main-tooltip');

        function _initChart(){
            var plot = $.plotAnimator($chart, [{
                label: "Traffic",
                data: data3,
                lines: {
                    fill: .3,
                    lineWidth: 0
                },
                color:['#ccc']
            },{
                label: "Traffic",
                data: data2,
				animator: {steps: 60, duration: 1000, start:0},
                lines: {lineWidth: 2},
				shadowSize:0,
                color:'black'
            },{
                label: "Traffic",
                data: data1,
                animator: {steps: 60, duration: 1000, start:0},
                lines: {lineWidth:2},
                shadowSize:0,
                color: '#F7553F'
            }],{
                xaxis: {
                    tickLength: 0,
                    tickDecimals: 0,
                    font :{
                        lineHeight: 13,
                        weight: "bold",
                        color: Sing.colors['gray-semi-light']
                    }
                },
                yaxis: {
                    tickDecimals: 0,
                    tickColor: "#f3f3f3",
                    font :{
                        lineHeight: 13,
                        weight: "bold",
                        color: Sing.colors['gray-semi-light']
                    }
                },
                grid: {
                    backgroundColor: { colors: [ "#fff", "#fff" ] },
                    borderWidth:1,
                    borderColor:"#f0f0f0",
                    margin:0,
                    minBorderMargin:0,
                    labelMargin:20,
                    hoverable: true,
                    clickable: true,
                    mouseActiveRadius:6
                },
                legend: false
            });

            $chart.on("plothover", function (event, pos, item) {
                if (item) {
                    var x = item.datapoint[0].toFixed(2),
                        y = item.datapoint[1].toFixed(2);

                    $tooltip.html(item.series.label + " at " + x + ": " + y)
                        .css({
                            top: item.pageY + 5 - window.scrollY,
                            left: item.pageX + 5 - window.scrollX
                        })
                        .fadeIn(200);
                } else {
                    $tooltip.hide();
                }
            });
        }

        _initChart();

        SingApp.onResize(_initChart);
    }

    function pageLoad(){
        $('.widget').widgster();
        $('.sparkline').each(function(){
            $(this).sparkline('html', $(this).data());
        });

        initFlot();

    }
    pageLoad();
    SingApp.onPageLoad(pageLoad);
});