angular.module('optimizePlayer').factory 'Helpers', [() ->
  millisecondsToTimeString: (s) ->
    ms = s % 1000;
    s = (s - ms) / 1000;
    secs = s % 60;
    s = (s - secs) / 60;
    mins = s % 60;
    return mins + ':' + secs;

  timeStringToMilliseconds: (text) ->
    text = text.replace(/[^\d:]/g, '');
    vals = text.split(":").slice(0,2)

    if !vals[1]
      vals[1] = vals[0]
      vals[0] = 0
    return (vals[0]*60 + parseInt(vals[1]))*1000
]
