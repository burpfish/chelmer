var STATUS_ON = "value=\"1\""
var TEMP_PATTERN = /value=\"(\d+.\d)/
var LOXONE_BASE_URL = "http://192.168.1.77/dev/sps/io/"
var DASHING_BASE_URL = "http://localhost:3030/widgets/"
var DASHING_BODY_BASE = '{ "auth_token": "osdfidojvknoisgrskvbjnxvi"}'

function setupAuth(xhr) {
     xhr.setRequestHeader ("Authorization", "Basic " + btoa('dave' + ":" + 'olinda666'))
}

function loxPulse(device) { 
    $.ajax({
      url: LOXONE_BASE_URL + device + '/pulse',
      beforeSend: function(xhr) {
        setupAuth(xhr)
      },
      success: function(html) {
      }
    })
}

function loxSwitch(device, newState) {
    $.ajax({
      url: LOXONE_BASE_URL + device + '/' + newState,
      beforeSend: function(xhr) {
        setupAuth(xhr)
      },
      success: function(html) {
      }
    })
}

function isDeviceOn(caller, device, callback) {
  executeIsDeviceOn(caller, device, callback)
  setTimeout(executeIsDeviceOn, 10000, caller, device, callback)
}

function executeIsDeviceOn(caller, device, callback) {
    $.ajax({
      url: LOXONE_BASE_URL + device + '/all',
      beforeSend: function(xhr) {
        setupAuth(xhr)
      },
      success: function(html) {
        var deviceState = (new XMLSerializer().serializeToString(html).indexOf(STATUS_ON) !== -1);
        callback.call(caller, deviceState)
      }
    })
}

function getTemp(caller, device, callback) {
  executeGetTemp(caller, device, callback)
  setInterval(executeGetTemp, 10000, caller, device, callback);
}

function executeGetTemp(caller, device, callback) {
    $.ajax({
      url: LOXONE_BASE_URL + device,
      beforeSend: function(xhr) {
        setupAuth(xhr)
      },
      success: function(html) {
        var temp = (new XMLSerializer().serializeToString(html).match(TEMP_PATTERN)[1]);
        callback.call(caller, temp)
      } 
  })
}













