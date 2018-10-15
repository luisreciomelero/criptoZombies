pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
//Esta clase deriva de ZombieFeeding y por tanto tendrá todas las funciones y atributos definidos en las clases superiores

  uint levelUpFee = 0.001 ether; 
  //precio de subir el nivel sin luchar

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }
  //este modificador obliga a cumplir una condicion de nivel para poder llamar a ciertas funciones.

function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }
  //funcion para variar el precio de subir de nivel, pensado para evitar que el precio del juevo suba mucho. EL valor del ether puede variar.

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId){
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId){
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    //con el tipo memory, creamos un objeto que se guardará en memoria hasta que acabe la función. 
    //si ademas la funcion es de tipo view, no consumirá gas.
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
