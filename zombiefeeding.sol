pragma solidity ^0.4.19;

import "./zombiefactory.sol"; //este contrato esta heredado, por ello tenemos que importar el contrato padre.

contract KittyInterface { // interfaz contrato que traemos de las criptokittys
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

contract ZombieFeeding is ZombieFactory { //declaración del contrato hijo

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; //dirección del contrato de CryptoKitties, será el encargado de enlazar la interfaz Kitty con nuestro código
  KittyInterface kittyContract = KittyInterface(ckAddress); //una vez tenemos la direccion enlazamos.

  
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus; //nos quedamos con las últimos 16 dígitos del ADN pasado
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if(keccak256(_species) == keccak256("kitty")){ //como lo comentamos en la clase Factory, modificamos las 2 últimas cifras del ADN del kittyZombie
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public { //Este método nos permite acceder al ADN del kitty guardado en el contrato de las kittys.
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
