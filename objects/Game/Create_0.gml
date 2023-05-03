/// @description Insert description here
// You can write your code in this editor
enum tileType
{
	none = 0,
	mine = -1
}

mineCount = 25

myArray = []
mxArray = []

gridWidth = 9
gridHeight = 9

tileData = {
	isFlagged : false,
	tileIndex : tileType.none,
	isVisible : false
}

grid = ds_grid_create(gridWidth, gridHeight)
function instanciateGrid() {
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
function toggleFlagTile(gx, gy) {
    var tileData = ds_grid_get(grid, gx, gy);

    // Toggle the isFlagged property of the tile
    tileData.isFlagged = !tileData.isFlagged;
    ds_grid_set(grid, gx, gy, tileData);
}
function findNumbers() {
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

function adjacentMines(gx, gy)
{
	var adjacent = false
	for (iy = -1; iy <= 1; iy++)
	{
		for (ix = -1; ix <= 1; ix++)
		{
			if (!(gx + ix < 0) || !(gx + ix > gridWidth) || !(gy + iy < 0) || !(gy + iy > gridHeight))
			{
				var tileData = ds_grid_get(grid, gx, gy);
				if (tileData.tileIndex == tileType.mine)
				{
					adjacent = true
				}
			}
		}
	}
	return adjacent
}
function revealAdjacent(gx, gy)
{
	for (iy = -1; iy <= 1; iy++)
	{
		for (ix = -1; ix <= 1; ix++)
		{
			if (!(gx + ix < 0) || !(gx + ix > gridWidth) || !(gy + iy < 0) || !(gy + iy > gridHeight))
			{
				var tileData = ds_grid_get(grid, gx, gy);
				tileData.isVisible = true
			}
		}
	}
}
function revealTiles(gx, gy) {
	var a = gx
	var b = gy
	function revealRight(gx, gy)
	{
		for(a = gx; a < gridWidth && !adjacentMines(a , gy); a++)
		{
			revealAdjacent(a, gy)
			return adjacentMines(a, gy)
		}
	}
	function revealLeft(gx, gy)
	{
		for(a = gx; a > 1 && !adjacentMines(a , gy); a--)
		{
			revealAdjacent(a, gy)
			return adjacentMines(a, gy)
		}
	}
	function revealUp(gx, gy)
	{
		for(a = gy; a > 1 && !adjacentMines(gx , a); a--)
		{
			revealAdjacent(gx, a)
			return adjacentMines(gx, a)
		}
	}
	function revealDown(gx, gy)
	{
		for(a = gy; a < gridHeight && !adjacentMines(gx , a); a++)
		{
			revealAdjacent(gx, a)
			return adjacentMines(gx, a)
		}
	}
	function revealX(gx, gy)
	{
		if (revealRight(gx, gy) || revealLeft(gx, gy) || revealUp(gx, gy) || revealDown(gx, gy))
		{
			return true
		}
	}
	do
	{
		a--
	}
	until (!revealX(a, gy))
	a = gx
	do
	{
		a++
	}
	until (!revealX(a, gy))
	b = gy
	do
	{
		b--
	}
	until (!revealX(gx, b))
	b = gy
	do
	{
		b++
	}
	until (!revealX(gx, b))
}



instanciateGrid()
findNumbers()
//revealTiles(4, 4)

// ---DEBUG---
// ---WARNING--- use only on small maps. will take forever to click all the "okay" buttons
if true
{
	sa = []
	for (gx = 0; gx < gridWidth; gx++)
	{
		for (gy = 0; gy < gridHeight; gy++)
		{
			tileData = ds_grid_get(grid, gx, gy)
			array_push(sa, tileData.tileIndex)
			
			
		}
	}
	show_message(sa)
	clipboard_set_text(sa)
}
//show_message()