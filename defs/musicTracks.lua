
local trackData = {
	useAsDurationForAllTracks = 'LD57',
	list = {
		'LD57',
	},
	initialTrack = 'LD57',
	WantTrack = function (cosmos, index)
		return (math.floor(cosmos.GetRealTime()/10)%1 + 1) == index
	end,
}

return trackData
