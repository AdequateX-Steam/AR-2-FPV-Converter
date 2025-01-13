//Returns the appropriate drone Cfg class name for the player side
_side = "";

	switch (side player) do 
	{
		case west: {_side = "B_UAV_01_F"};
		case east: {_side = "O_UAV_01_F"};
		case resistance: {_side = "I_UAV_01_F"};
		default {_side = "invalid"};
	};

_side;