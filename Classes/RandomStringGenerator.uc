//=============================================================================
// RandomStringGenerator: Generates random strings and writes them to the
// KvStore.
//=============================================================================
class RandomStringGenerator extends KvStoreSetter;

#exec texture import file=Textures\ikvrandom.pcx name=i_ikvrandom group=Icons mips=Off flags=2

var() int Length;
var() string Digits;

function Trigger (actor Other, pawn EventInstigator) {
  local int i;
  
  targetValue = "";
  for (i = 0; i < Length; i++) {
    targetValue $= mid(digits, rand(len(Digits)), 1);
  }

  super.trigger(other, eventInstigator);
}

defaultproperties {
  Digits="0123456789"
  Length=4
  Texture=Texture'i_ikvrandom'
}