//=============================================================================
// KvStorePropagator: Simple mutator that gives every player a KvStore.
// Enables use of the KvStoreChecker and KvStoreSetter triggers.
//=============================================================================
class KvStorePropagator extends Mutator;

var bool bPreBPInitialized;

function PreBeginPlay() {
  if (!bPreBPInitialized) {
    bPreBPInitialized = True;
    Self.NextMutator = Level.Game.BaseMutator.NextMutator;
    Level.Game.BaseMutator.NextMutator = Self;
  }
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
  local PlayerPawn pp;
  local Inventory i;

  if (PlayerPawn(other) != none) {
    pp = PlayerPawn(other);
    i = spawn(class'KvStore');
    i.touch(pp);
  }

  return true;
}

defaultproperties {
  
}