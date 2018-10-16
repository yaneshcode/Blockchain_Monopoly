pragma solidity 0.4.25;

contract Monopoly {
    
    address public owner;
    uint public gameID;
    
    struct Game {
        address game_master;
        uint turn;
        uint middle_pot;
        uint players;
        bool started;
        bool ended;
        uint dice_one;
        uint dice_two;
        mapping(address => Player) playerInfo;
        mapping(uint => Piece) pieceInfo;
        mapping(uint => Ownership) ownershipInfo;
        mapping(uint => bool) stillSolvent;
    }
    
    struct Ownership {
        bool owned;
        address owner;
        bool mortgaged;
        uint buildings;
    }

    struct Player {
        string name;
        uint num;
        uint piece;
        uint current_postion;
        uint doubles_rolled;
        uint cash;
        uint asset_value;
        uint total_value;
        uint get_out_of_jail_free;
        bool in_jail;
        bool solvent;
        
    }

    struct Piece {
        string name;
        bool taken;
        address owner;
    }
    
    struct Property {
        string name;
        string color;
        uint cost;
        uint rent;
        uint oneHouse_rent;
        uint twoHouse_rent;
        uint threeHouse_rent;
        uint fourHouse_rent;
        uint hotel_rent;
        uint mortgage_value;
        uint building_cost;
        uint8[2] set;
    }
    
    struct Utility {
        string name;
        uint cost;
        uint8[2] rent;
        uint mortgage_value;
        uint set;
    }
    
    struct Railroad {
        string name;
        uint cost;
        uint mortgage_value;
        uint8[3] set;
    }
    
    struct CommunityChest {
        string card_text;
        uint position_move;
        uint cost;
        uint gain;
    }
    
    struct Chance {
        string card_text;
        uint position_move;
        uint cost;
        uint gain;
    }
    
    struct Tax {
        string name;
        uint cost;
    }
    
    mapping(uint => Game) gameInfo;
    mapping(uint => Property) propertyInfo;
    mapping(uint => Utility) utilityInfo;
    mapping(uint => Railroad) railroadInfo;
    mapping(uint => CommunityChest) ccInfo;
    mapping(uint => Chance) chanceInfo;
    mapping(uint => Tax) taxInfo;
    mapping(uint => uint) board;
    
    
    constructor() public {
        
        owner = msg.sender;
        gameID = 0;
        
        
        // Build Board.
        
        // 0 = Go
        // 1 = Property
        // 2 = Community Chest
        // 3 = Tax
        // 4 = Railroad
        // 5 = Chance
        // 6 = Jail
        // 7 = Utility
        // 8 = Free Parking
        // 9 = Go To Jail
        
        
        board[0] = 0; // "Go"
        board[1] = 1; // "Property"
        propertyInfo[1] = Property({name: "Mediterranean Avenue",
            color: "Purple", cost: 60, rent: 2, oneHouse_rent: 10,
            twoHouse_rent: 30, threeHouse_rent: 90, fourHouse_rent: 160,
            hotel_rent: 250, mortgage_value: 30, building_cost: 50, 
            set: [3, 0]
        });
        board[2] = 2; // "Community Chest"
        board[3] = 1; // "Property"
        propertyInfo[3] = Property({name: "Baltic Avenue",
            color: "Purple", cost: 60, rent: 4, oneHouse_rent: 20,
            twoHouse_rent: 60, threeHouse_rent: 180, fourHouse_rent: 320,
            hotel_rent: 450, mortgage_value: 30, building_cost: 50,
            set: [1, 0]
        });
        board[4] = 3; // "Tax"
        taxInfo[4] = Tax({name: "Income Tax",
            cost: 200
        });
        board[5] = 4; // "Railroad"
        railroadInfo[5] = Railroad({name: "Reading Railroad",
            cost: 200, mortgage_value: 100, set: [15, 25, 35]
        });
        board[6] = 1; // "Property"
        propertyInfo[6] = Property({name: "Oriental Avenue",
            color: "Light Blue", cost: 100, rent: 6, oneHouse_rent: 30,
            twoHouse_rent: 90, threeHouse_rent: 270, fourHouse_rent: 400,
            hotel_rent: 550, mortgage_value: 50, building_cost: 50,
            set: [8, 9]
        });
        board[7] = 5; // "Chance"
        board[8] = 1; // "Property"
        propertyInfo[8] = Property({name: "Vermont Avenue",
            color: "Light Blue", cost: 100, rent: 6, oneHouse_rent: 30,
            twoHouse_rent: 90, threeHouse_rent: 270, fourHouse_rent: 400,
            hotel_rent: 550, mortgage_value: 50, building_cost: 50,
            set: [6, 9]
        });
        board[9] = 1; // "Property"
        propertyInfo[9] = Property({name: "Connecticut Avenue",
            color: "Light Blue", cost: 120, rent: 8, oneHouse_rent: 40,
            twoHouse_rent: 100, threeHouse_rent: 300, fourHouse_rent: 450,
            hotel_rent: 600, mortgage_value: 60, building_cost: 50,
            set: [6, 8]
        });
        board[10] = 6; // "Jail"
        
        
    }
    
    
    function createGame (uint _gameID) public {
        gameInfo[_gameID].game_master = msg.sender;
        gameInfo[_gameID].turn = 0;
        gameInfo[_gameID].middle_pot = 200;
        gameInfo[_gameID].players = 0;
        gameInfo[_gameID].started = false;
        gameInfo[_gameID].ended = false;
        gameInfo[_gameID].dice_one = 1;
        gameInfo[_gameID].dice_two = 1;
        
        
        // Initilize Pieces
        
        gameInfo[_gameID].pieceInfo[1] = Piece({name: "Top Hat", 
            taken: false, owner: 0x0
        });
        gameInfo[_gameID].pieceInfo[2] = Piece({name: "Race Car", 
            taken: false, owner: 0x0
        });
        gameInfo[_gameID].pieceInfo[3] = Piece({name: "Thimble", 
            taken: false, owner: 0x0
        });
        gameInfo[_gameID].pieceInfo[4] = Piece({name: "Wheelbarrow", 
            taken: false, owner: 0x0
        });
        gameInfo[_gameID].pieceInfo[5] = Piece({name: "Boot", 
            taken: false, owner: 0x0
        });
        gameInfo[_gameID].pieceInfo[6] = Piece({name: "Battleship", 
            taken: false, owner: 0x0
        });
        gameInfo[_gameID].pieceInfo[7] = Piece({name: "Iron", 
            taken: false, owner: 0x0
        });
        gameInfo[_gameID].pieceInfo[8] = Piece({name: "Horse & Rider", 
            taken: false, owner: 0x0
        });

        // Initilize Ownership
        
        gameInfo[_gameID].ownershipInfo[1] = Ownership({owned: false,
            owner: 0x0, mortgaged: false, buildings: 0
        });
        gameInfo[_gameID].ownershipInfo[3] = Ownership({owned: false,
            owner: 0x0, mortgaged: false, buildings: 0
        });
        gameInfo[_gameID].ownershipInfo[5] = Ownership({owned: false,
            owner: 0x0, mortgaged: false, buildings: 0
        });
        gameInfo[_gameID].ownershipInfo[6] = Ownership({owned: false,
            owner: 0x0, mortgaged: false, buildings: 0
        });
        gameInfo[_gameID].ownershipInfo[8] = Ownership({owned: false,
            owner: 0x0, mortgaged: false, buildings: 0
        });
        gameInfo[_gameID].ownershipInfo[9] = Ownership({owned: false,
            owner: 0x0, mortgaged: false, buildings: 0
        });
        
    }
    
    function newGame () public {
        gameID += 1;
        createGame(gameID);
    }
    
    
    function addPlayer (uint _gameID, uint _piece, string _name) public {
        require(gameInfo[_gameID].started == false);
        require(gameInfo[_gameID].players < 8);
        require(_piece > 0 && _piece < 9);
        require(gameInfo[_gameID].pieceInfo[_piece].taken == false);
        gameInfo[_gameID].pieceInfo[_piece].owner = msg.sender;
        gameInfo[_gameID].pieceInfo[_piece].taken = true;
        gameInfo[_gameID].players += 1;
        gameInfo[_gameID].playerInfo[msg.sender] = Player({
            name: _name, num: gameInfo[_gameID].players, piece: _piece, 
            current_postion: 0, doubles_rolled: 0, cash: 1500, asset_value: 0, 
            total_value: 1500, get_out_of_jail_free: 0, in_jail: false,
            solvent: true
        });
        gameInfo[_gameID].stillSolvent[gameInfo[_gameID].players] = true;
    }
    
    function nextTurn (uint _gameID, uint _turn) public view returns (uint) {
        for(uint i = _turn + 1; i < gameInfo[_gameID].players + 1; i++){
                if (gameInfo[_gameID].stillSolvent[i]) {
                    return i;
                }
        }
        for(uint k = 1; k < gameInfo[_gameID].players; k++){
                if (gameInfo[_gameID].stillSolvent[k]) {
                    return k;
                }
        }
        return 99;
    }
    
    function rollDice (uint _gameID) public {
        require(gameInfo[_gameID].playerInfo[msg.sender].num == 
        gameInfo[_gameID].turn && gameInfo[_gameID].started &&
        gameInfo[_gameID].ended == false);
        
        // Generate dice result
        uint random_number = (uint(blockhash(block.number-1)) % 36) + 1;
        gameInfo[_gameID].dice_one = (random_number % 6) + 1;
        if (random_number < 7) { gameInfo[_gameID].dice_two = 1; }
        if (random_number > 6 &&  random_number < 13) { 
            gameInfo[_gameID].dice_two = 2; }
        if (random_number > 12 &&  random_number < 19) { 
            gameInfo[_gameID].dice_two = 3; }
        if (random_number > 18 &&  random_number < 25) { 
            gameInfo[_gameID].dice_two = 4; }
        if (random_number > 24 &&  random_number < 31) { 
            gameInfo[_gameID].dice_two = 5; }
        if (random_number > 30 &&  random_number < 37) { 
            gameInfo[_gameID].dice_two = 6; }
        
        // Roll in/out of jail
        if (gameInfo[_gameID].dice_one == gameInfo[_gameID].dice_two) {
            // Roll out of jail
            if (gameInfo[_gameID].playerInfo[msg.sender].in_jail) {
                gameInfo[_gameID].playerInfo[msg.sender].in_jail = false;
                gameInfo[_gameID].turn = nextTurn(_gameID, gameInfo[_gameID].turn);
            } else {
                gameInfo[_gameID].playerInfo[msg.sender].doubles_rolled += 1;
            }
            // Roll into jail
            if (gameInfo[_gameID].playerInfo[msg.sender].doubles_rolled == 3) {
                gameInfo[_gameID].playerInfo[msg.sender].doubles_rolled = 0;
                gameInfo[_gameID].playerInfo[msg.sender].in_jail = true;
                gameInfo[_gameID].playerInfo[msg.sender].current_postion = 10;
            }
        }
        
        // Stay in jail
        if (gameInfo[_gameID].playerInfo[msg.sender].in_jail) {
            gameInfo[_gameID].turn = nextTurn(_gameID, gameInfo[_gameID].turn);
        }
        
        require(gameInfo[_gameID].playerInfo[msg.sender].num == 
        gameInfo[_gameID].turn);
        
        // Move piece
        uint new_position = (gameInfo[_gameID].playerInfo[msg.sender].current_postion +
            (gameInfo[_gameID].dice_one + gameInfo[_gameID].dice_two)) % 39;
        
        // Pass go
        if ((new_position < gameInfo[_gameID].playerInfo[msg.sender].current_postion &&
            new_position > 0) ||  gameInfo[_gameID].playerInfo[msg.sender].current_postion == 0){
                gameInfo[_gameID].playerInfo[msg.sender].cash += 200;
        }
        
        // Go to jail    
        if (new_position == 30) {
            gameInfo[_gameID].playerInfo[msg.sender].current_postion = 10;
            gameInfo[_gameID].playerInfo[msg.sender].in_jail = true;
            gameInfo[_gameID].turn = nextTurn(_gameID, gameInfo[_gameID].turn);
        }
        
        require(gameInfo[_gameID].playerInfo[msg.sender].in_jail == false);
        gameInfo[_gameID].playerInfo[msg.sender].current_postion = new_position;
        
        // Land property
        if (board[new_position] == 1) {
            // Property is Owned
            if (gameInfo[_gameID].ownershipInfo[new_position].owned) {
                uint rent_due = propertyInfo[new_position].rent;
            }
        }
        
        
        
    }
    
    
}
