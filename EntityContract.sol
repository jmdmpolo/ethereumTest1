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
    address userAddress;   // user address that registered this status
    uint dataTime;         // timestamp when this entity was registered
    string status;         // status name
}
//struct for Entity
struct Entity {
    string entityAddress; 	// entity address (reference code)
    address userAddress;        // user address that registered this entity
    uint dataTime;              // timestamp when this entity was registered
    uint statusNumber;          // number of status
    mapping (uint => Status) statuses ; // array of status
}
//internal arrays
mapping (uint256 => Entity ) private entities ; // array of entities
mapping (string => uint256 ) private entitiesbyRef ; // array of entities ids using address as index

//crea una entidad
function createEntity(uint256 entityId, string entityAddress) public returns (bool) 
{
    //comprueba que no exista ya
    //recupera la entidad
    Entity memory a = entities[entityId];
    //si existe da error
    require(a.dataTime == 0);
    
	//crea la entidad
	entities[entityId].entityAddress = entityAddress; 
	entities[entityId].dataTime = now; //tiempo de creacion
    entities[entityId].userAddress = msg.sender; //usuario que lanza la transaccion
    entities[entityId].statusNumber = 0;
	
	//completa el array por referencia
	entitiesbyRef[entityAddress] = entityId;
    
    return true;
}

//crea un estado
function createEntityStatus(uint256 entityId, uint256 statusId, string _status) public returns (bool) 
{
    //si no existe la entidad da error
    require(entities[entityId].dataTime != 0);
	//si  existe el estatus id da error
	require(entities[entityId].statuses[statusId].dataTime == 0);
    
    entities[entityId].statusNumber++;
    
    entities[entityId].statuses[statusId].userAddress = msg.sender; //usuario que lanza la transaccion
    entities[entityId].statuses[statusId].dataTime = now;
    entities[entityId].statuses[statusId].status = _status;
    
    return true;
}

//recupera los datos de una entidad
function getEntity(uint256 entityId) public view returns (string, uint256, address, uint256) {

    //si no existe da error
    require(entities[entityId].dataTime != 0);
    
    //si existe devuelve sus datos
    return (entities[entityId].entityAddress , entities[entityId].dataTime,entities[entityId].userAddress, entities[entityId].statusNumber);
}

//recupera los datos de una entidad a partir de su referencia
function getEntityByRef(string entityAddress) public view returns (string, uint256, address, uint256) {
	
	return getEntity(entitiesbyRef[entityAddress]);
	
}

//recupera uno de los estados de una entidad
function getEntityStatus(uint256 entityId, uint256 statusId) public view returns (address, uint256, string ) {

    require(entities[entityId].dataTime != 0);
    
    //si existe devuelve sus datos
    return (entities[entityId].statuses[statusId].userAddress, entities[entityId].statuses[statusId].dataTime, entities[entityId].statuses[statusId].status);
}

} //end contract
