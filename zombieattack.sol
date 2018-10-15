import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;
  //probabilidad de exito de un ataque 

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }
  //esta funcion nos permite obtener, de forma insegura fremnte ataque externos, un número aleatorio

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    //acontinuacion accedemos a los zombies que combaten
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      //comprobamos si nuestro atauqe tuvo exito
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    }else{ //Actualizamos contadores
      myZombie.lossCount++;
      enemyZombie.winCount++;
    }
    _triggerCooldown(myZombie);//iniciamos el contador
  }
}
