
local trackData = {
	useAsDurationForAllTracks = 'LD57',
	list = {
		'LD57',
		'LD57',
		'LD57',
		'LD57',
		'LD57',
		'LD57',
		'LD57',
		'LD57',
		'LD57',
	},
	PitchFunc = function (index)
		return (4^(1 - (index - 1)/8))
	end,
	initialTrack = 'LD57',
	WantTrack = function (cosmos, index)
		return GameHandler.GetDesiredTrack() == index
	end,
}

return trackData
