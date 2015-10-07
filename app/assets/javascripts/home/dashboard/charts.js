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
        };

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