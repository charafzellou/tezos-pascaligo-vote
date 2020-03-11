type action is
| Vote of int
| Reset of int

type storageType is record [
  admin: address;
  paused: bool;
  votes: map(address, bool);
]

function isAdmin (const storage : storageType) : bool is
  block {
    skip
  } with (sender = storage.admin)
    
function isPaused (const storage : storageType) : bool is
  block {
    skip
  } with (storage.paused)

function submitReset (const storage : storageType) : (list(operation) * storageType) is
  block {
    if ( isAdmin(storage) )
      then block {
        if ( isPaused(storage) )
          then block {
            for i in map storage.votes block {
              remove i from map storage.votes;
            };
            storage.paused := False;
          }
          else block {
            failwith("[PAUSED] Vote contract is in its paused state.");
          }
      }
      else block {
        failwith("[PAUSED] You need admin privileges to run this function.");
      }
  } with ((nil: list(operation)) , storage)

function submitVote (const vote : int; const storage : storageType) : (list(operation) * storageType) is
  block {
    var result : bool := False;
    if (isPaused(storage)) then block {
      // Start Vote
      skip
    }
    else block {
      // Contract is paused
      skip
    }
  } with ((nil: list(operation)) , storage)

function main (const p : action ; const s : storageType) :
  (list(operation) * storageType) is
  block { skip } with
  case p of
    | Vote(n) -> submitVote(n, s)
    | Reset(n) -> submitReset(s)
  end
