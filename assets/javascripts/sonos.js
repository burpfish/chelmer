
function sonosRequest(command, successFunct, failureFunct) {
	$.get(encodeURI("http://192.168.1.70:5005/kitchen/" + command),
		function(data) {
			if (successFunct) {
				successFunct.call(this, data)
			}
		}
	).fail(
		function() {
			if (failureFunct) {
				failureFunct.call(this)
			}
		}	
	);	
};	

function startPlaylist(playlist) {
	if (jQuery.inArray( playlist, justPlaylists) >= 0) {
		sonosRequest("playlist/" + playlist);
	} else {
		sonosRequest("favorite/" + playlist);
	}
	$( "#status" ).text("Playing: " + playlist)
};	

var justFaves
var justPlaylists
var playlists
function getPlaylistsAndFavourites() {
	return sonosRequest("playlists", 
		function(data) {		
			playlists = data
			justPlaylists = data

			return sonosRequest("Favorites", 
				function(data) {		
					justFaves = data
					playlists = playlists.concat(data)
					setTimeout(getPlaylistsAndFavourites, 60000)
				},
				function() {
					// $( "#status" ).text("FAILED to get favorites")
					// give sonos api a chance to start up
					setTimeout(getPlaylistsAndFavourites, 10000)
				}
			);
		},
		function() {
			// $( "#status" ).text("FAILED to get playlists")
			// give sonos api a chance to start up
			setTimeout(getPlaylistsAndFavourites, 10000)
		}
	);
}

getPlaylistsAndFavourites()

var lastWho
function getNextPlaylist(who) {
	if (who != lastWho && currentPlaylist[who]) {
		lastWho = who
		return playlists[currentPlaylist[who]]
	}

	lastWho = who
	var playlistsNotChecked = playlists.length
	var playlist = currentPlaylist[who] + 1 

	while( playlistsNotChecked > 0) {		
		if (playlist >= playlists.length) {
			playlist = 0;
		}

		if (playlists[playlist].toLowerCase().indexOf(who.toLowerCase()) >= 0) {
			currentPlaylist[who] = playlist
			return playlists[playlist]
		}

		playlistsNotChecked--
		playlist++
	}


	$( "#status" ).text("No playlists for " + who);
	return null
}

var currentPlaylist = []
currentPlaylist["anna"] = 0
currentPlaylist["dave"] = 0

var playing = false

function playOrPause() {
	if (playing) {
		sonosStop();
	} else {
		sonosPlay();
	}

	playing = !playing;
}

function isPlaying() {
	return playing;
}

function sonosStop() {
	sonosRequest('pause')
}

function sonosPlay() {
	sonosRequest('play')
}

function sonosNext() {
	sonosRequest('next')
}

function sonosPrevious() {
	sonosRequest('previous')
}

function sonosPlayPause() {
	sonosRequest('playpause')
}

function sonosDave() {
	var nextPlaylist = getNextPlaylist("dave")

	if (nextPlaylist) {
		startPlaylist(nextPlaylist)
	}
}

function sonosAnna() {
	var nextPlaylist = getNextPlaylist("anna")

	if (nextPlaylist) {
		startPlaylist(nextPlaylist)
	}
}

function sonosVolUp() {
	sonosRequest('volume/+4')
}

function sonosVolDown() {
	sonosRequest('volume/-4')
}
