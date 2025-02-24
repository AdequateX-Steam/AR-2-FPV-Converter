/*
inventory display IDD = 602

inventory controls IDCs =
[
BackpackContainer = 619 --- can drag
BackpackLoad = 6306
BackpackSlot = 6191 --- can drag
BackpackTab = 6192

UniformContainer = 633 --- can drag
UniformLoad = 6304
UniformSlot = 6331  --- can drag
UniformTab = 6332

VestContainer = 638  --- can drag
VestLoad = 6305
VestSlot = 6381  --- can drag
VestTab = 6382
]

program flow:
1) inventory opened EH
2) inventory closed EH

*/
/* 
this addEventHandler ["InventoryOpened", {
	params ["_unit", "_container"];
}];


this addEventHandler ["InventoryClosed", {
	params ["_unit", "_container"];
}];






this addEventHandler ["Put", {
	params ["_unit", "_container", "_item"];
}];

this addEventHandler ["Take", {
	params ["_unit", "_container", "_item"];
}];
 */