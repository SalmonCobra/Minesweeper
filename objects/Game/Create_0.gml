/// @description Insert description here
// You can write your code in this editor
enum tileType
{
	none = 0,
	mine = -1
}

mineCount = 0
gridWidth = 9
gridHeight = 9

firstMove = true

tileData = {
	isFlagged : false,
	tileIndex : tileType.none,
	isVisible : false
}

grid = ds_grid_create(gridWidth, gridHeight)

function instanciateGrid()
{
    randomize();
    var validCoordinates = [];

    // Fill the grid with default variable values and store all valid coordinates
    for (var gx = 0; gx < gridWidth; gx++) {
        for (var gy = 0; gy < gridHeight; gy++) {
            var tileData = {
                isFlagged : false,
                tileIndex : tileType.none,
                isVisible : 0
            };
            ds_grid_set(grid, gx, gy, tileData);
            array_push(validCoordinates, {x: gx, y: gy});
        }
    }

    // Fill the grid with the select number of mines in random locations
    var placedMines = 0;
    while (placedMines < mineCount && array_length(validCoordinates) > 0) {
        var index = irandom_range(0, array_length(validCoordinates) - 1);
        var coordinate = validCoordinates[index];

        var tileData = ds_grid_get(grid, coordinate.x, coordinate.y);
        tileData.tileIndex = tileType.mine;
        ds_grid_set(grid, coordinate.x, coordinate.y, tileData);

        array_delete(validCoordinates, index, 1);
        placedMines++;
    }
}
function toggleFlagTile(gx, gy)
{
    var tileData = ds_grid_get(grid, gx, gy);

    // Toggle the isFlagged property of the tile
    tileData.isFlagged = !tileData.isFlagged;
    ds_grid_set(grid, gx, gy, tileData);
}
function findNumbers()
{
    for (var gy = 0; gy < gridHeight; gy++) {
        for (var gx = 0; gx < gridWidth; gx++) {
            var currentTile = ds_grid_get(grid, gx, gy);
            if (currentTile.tileIndex == tileType.mine) {
                for (var ty = -1; ty <= 1; ty++) {
                    for (var tx = -1; tx <= 1; tx++) {
                        if (gx + tx >= 0 && gx + tx < gridWidth && gy + ty >= 0 && gy + ty < gridHeight) {
                            if (tx != 0 || ty != 0) {
                                var adjacentTile = ds_grid_get(grid, gx + tx, gy + ty);
                                if (adjacentTile.tileIndex != tileType.mine) {
                                    adjacentTile.tileIndex += 1;
                                    ds_grid_set(grid, gx + tx, gy + ty, adjacentTile);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

function revealTiles(gx, gy)
{
	var tileData = ds_grid_get(grid, gx, gy);
	gx -= 1
	gy -= 1
	// if not bomb
	if (tileData.tileIndex != -1)
	{
		//check the tiles in the x axis
		for (ix = gx; ix <= 1; ix++)
		{
			//check the tiles in the y axis
			for (iy = gy; iy <= 1; iy++)
			{
				//bounds checking iy >= 0 || iy < gridHeight || ix >= 0 || ix < gridWidth
				if (true)
				{
					//re-get the struct from the surrounding tiles (including the tile clicked)
					tileData = ds_grid_get(grid, ix, iy);
					//check if the surrounding tile is a bomb, if it is not then make it visible and then run the function again on that tile.
					if (tileData.tileIndex != -1)
					{
						tileData.isVisible = true
						ds_grid_set(grid, ix, iy, tileData)
						revealTiles(ix, iy)
					}
				}
			}
		}	
		firstMove = false
	} else {
		// OOPS YOU MESSED UP
		
		//pretty much if you hit a bomb redo everything and do it again from the same spot (IF its the first move!)
		if (firstMove)
		{
			instanciateGrid()
			findNumbers()
			revealTiles(gx, gy)
		}
	}
}

instanciateGrid()
findNumbers()
revealTiles(4, 4)

// ---DEBUG---
if true
{
    sa = ""
    for (gx = 0; gx < gridWidth; gx++)
    {
        for (gy = 0; gy < gridHeight; gy++)
        {
            tileData = ds_grid_get(grid, gx, gy)
            sa += string(tileData.isVisible) + ", "
            
            
        }
        sa += "\n"
    }
    show_message(sa)
    clipboard_set_text(sa)
}
//show_message()