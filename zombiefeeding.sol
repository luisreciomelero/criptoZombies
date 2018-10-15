pragma solidity ^0.4.19;

import "./zombiefactory.sol"; 
//este contrato esta heredado, por ello tenemos que importar el contrato padre.

contract KittyInterface { 
// interfaz contrato que traemos de las criptokittys
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory { 
//declaración del contrato hijo

  
  KittyInterface kittyContract ; 
  //Hemos borrado la dirección del contrato de forma que esta será dinámica, le pasaremos la dirección con el siguiente método. 
  //esta es una medida de seguridad ya que probablemente el contrato debamos cambiarlo en el futuro y si le damos una dirección fija en el futuro deberíamos informar a los usuarios de que la cambien.

  modifier ownerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }
  //Con este modificador nos ahorramos tener que comprobar esta condicion en cada método que necesitemos

  function setKittyContractAddress(address _address) external onlyOwner {
  // Se trata de la funcion para asignar a la interfaz la dirección del contrato que implementa.
  // se puede llamar desde fuera únicamente, sin embargo, debe ser el propietario. Esto lo comprobamos con el onlyOwner.
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
  // En esta función utilizamos la variable now y la constante cooldownTime para fijar el tiempo entre niveles que pueden subir los zombies.
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
  //comprobamos el contador
      return (_zombie.readyTime <= now);
  }

  
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    //comprobamos el contador antes de dejar que un zombie se alimente.
    _targetDna = _targetDna % dnaModulus; 
    //nos quedamos con las últimos 16 dígitos del ADN pasado
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if(keccak256(_species) == keccak256("kitty")){ 
    //como lo comentamos en la clase Factory, modificamos las 2 últimas cifras del ADN del kittyZombie
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
    //una vez creado, reiniciamos el contador
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public { //Este método nos permite acceder al ADN del kitty guardado en el contrato de las kittys.
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    //Únicamente nos quedamos con el último atributo del método que devuelve la interfaz
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
