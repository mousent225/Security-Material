(function (namespace, $) {
    "use strict";

    var demoDashboard = function () {
        // Create reference to this instance
        var o = this;
        // Initialize app when document is ready
        $(document).ready(function () {
            o.initialize();
        });

    };
    var p = demoDashboard.prototype;

    // =========================================================================
    // MEMBERS
    // =========================================================================

    //p.rickshawSeries = [[], []];
    //p.rickshawGraph = null;
    //p.rickshawRandomData = null;
    //p.rickshawTimer = null;

    // =========================================================================
    // INIT
    // =========================================================================

    p.initialize = function () {
        this._initFlotRegistration();
    };

    // =========================================================================
    // FLOT
    // =========================================================================

    p._initFlotRegistration = function () {
        var o = this;
        var chart = $("#flot-registrations");

        // Elements check
        if (!$.isFunction($.fn.plot) || chart.length === 0) {
            return;
        }

        // Chart data
        var data = [
			{
			    label: 'Registrations',
			    data: [
					[moment().subtract(11, 'month').valueOf(), 11000],
					[moment().subtract(10, 'month').valueOf(), 24500],
					[moment().subtract(9, 'month').valueOf(), 38000],
					[moment().subtract(8, 'month').valueOf(), 26500],
					[moment().subtract(7, 'month').valueOf(), 39005],
					[moment().subtract(6, 'month').valueOf(), 52500],
					[moment().subtract(5, 'month').valueOf(), 36000],
					[moment().subtract(4, 'month').valueOf(), 49000],
					[moment().subtract(3, 'month').valueOf(), 6200],
					[moment().subtract(2, 'month').valueOf(), 8195],
					[moment().subtract(1, 'month').valueOf(), 6500],
					[moment().valueOf(), 7805]
			    ],
			    last: false
			}
        ];

        $.ajax({
            async: false,
            url: "Home/GetSiteActivity",
            data: { year: 2017 },
			success: function (response, textStatus, jqXhr) {
			    var dataResponse = [];
			    $.each(response,
					function (index, value) {
						var item = [];
						item.push(new Date(new Date().getFullYear(), value.month - 1, 1));
						item.push(value.value);
					    dataResponse.push(item);			            
					});
			    data[0].data = dataResponse;
			},
            error: function (jqXhr, testStatus, errorThrown) {
                console.log("Error - " + errorThrown);
            }
        });

        // Chart options
        var labelColor = chart.css('color');
        var options = {
            colors: chart.data('color').split(','),
            series: {
                shadowSize: 0,
                lines: {
                    show: true,
                    lineWidth: 2
                },
                points: {
                    show: true,
                    radius: 3,
                    lineWidth: 2
                }
            },
            legend: {
                show: false
            },
            xaxis: {
                mode: "time",
                timeformat: "%b %y",
                color: 'rgba(0, 0, 0, 0)',
                font: { color: labelColor }
            },
            yaxis: {
                font: { color: labelColor }
            },
            grid: {
                borderWidth: 0,
                color: labelColor,
                hoverable: true
            }
        };
        chart.width('100%');

        // Create chart
        var plot = $.plot(chart, data, options);

        // Hover function
        var tip, previousPoint = null;
        chart.bind("plothover", function (event, pos, item) {
            if (item) {
                if (previousPoint !== item.dataIndex) {
                    previousPoint = item.dataIndex;

                    var x = item.datapoint[0];
                    var y = item.datapoint[1];
                    var tipLabel = '<strong>' + $(this).data('title') + '</strong>';
                    var tipContent = y + " " + item.series.label.toLowerCase() + " on " + moment(x).format('MMM');

                    if (tip !== undefined) {
                        $(tip).popover('destroy');
                    }
                    tip = $('<div></div>').appendTo('body').css({ left: item.pageX, top: item.pageY - 5, position: 'absolute' });
                    tip.popover({ html: true, title: tipLabel, content: tipContent, placement: 'top' }).popover('show');
                }
            }
            else {
                if (tip !== undefined) {
                    $(tip).popover('destroy');
                }
                previousPoint = null;
            }
        });
    };

    // =========================================================================
    namespace.DemoDashboard = new demoDashboard;
// ReSharper disable once ThisInGlobalContext
}(this.materialadmin, jQuery)); // pass in (namespace, jQuery):
