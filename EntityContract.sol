pragma solidity ^0.4.18;

contract EntityContract{
    
address private creator;    

//constructor
function EntityContract() public 
{
    creator = msg.sender; 
}

//Standard kill() function to recover funds 
function kill() public
{ 
    if (msg.sender == creator)
        selfdestruct(creator);  // kills this contract and sends remaining funds back to creator
}

//struct for status
struct Status {
    address userAddress;// user address that registered this status
    uint dataTime;      // timestamp when this entity was registered
    string status;      //status name
}
//struct for Entity
struct Entity {
	address userAddress;        // user address that registered this entity
    uint dataTime;              // timestamp when this entity was registered
    uint statusNumber;          // number of status
    mapping (uint => Status) statuses ; // array of status
}
//internal arrays
mapping (bytes32 => Entity ) private entities ; // array of entities

//crea una entidad
function createEntity(bytes32 entityAddress) public returns (bool) 
{
    //comprueba que no exista ya
    //recupera la entidad
    Entity memory a = entities[entityAddress];
    //si existe da error
    require(a.dataTime == 0);
    
	entities[entityAddress].dataTime = now; //tiempo de creacion
    entities[entityAddress].userAddress = msg.sender; //usuario que lanza la transaccion
    entities[entityAddress].statusNumber = 0;
    
    return true;
}

//crea un estado
function createEntityStatus(bytes32 entityAddress, string _status) public returns (bool) 
{
    //si no existe la esntidad da error
    require(entities[entityAddress].dataTime != 0);
    
    entities[entityAddress].statusNumber++;
    
    entities[entityAddress].statuses[entities[entityAddress].statusNumber].userAddress = msg.sender; //usuario que lanza la transaccion
    entities[entityAddress].statuses[entities[entityAddress].statusNumber].dataTime = now;
    entities[entityAddress].statuses[entities[entityAddress].statusNumber].status = _status;
    
    return true;
}

//recupera los datos de una entidad
function getEntity(bytes32 entityAddress) public view returns (uint, address, uint) {
	 //recupera la entidad
    Entity memory a = entities[entityAddress];
    //si no existe da error
    require(a.dataTime != 0);
    
    //si existe devuelve sus datos
    return (a.dataTime,a.userAddress, a.statusNumber);
}

//recupera los estados de una entidad
function getEntityStatus(bytes32 entityAddress, uint _statusNumber) public view returns (Status) {
	 //recupera la entidad
    //Entity memory a = entities[entityAddress];
    //si no existe da error
    //assert(a.dataTime == 0);
    require(entities[entityAddress].dataTime != 0);
    
    //Status memory b = statuses[_statusNumber];
    
    //si existe devuelve sus datos
    return (entities[entityAddress].statuses[_statusNumber]);
}


} //end contract
