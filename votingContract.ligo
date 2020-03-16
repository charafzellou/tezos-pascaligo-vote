type action is
| Vote of bool
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

function submitVote (const vote : bool; const storage : storageType) : (list(operation) * storageType) is
  block {
      var numberVotes : int := 0;
      if (isPaused(storage)) then block {
        if ( isAdmin(storage) )
          then block {
           case storage.votes[sender] of
             | Some (bool) -> failwith("[VOTER] Your address has already voted.")
             | None -> block {
               storage.votes[sender] := vote;
               for i in map storage.votes block {
                 numberVotes := numberVotes + 1;
               };
               if (numberVotes = 10) then block {
                 storage.paused := True;
               }
              else block {
                  skip
                }
            }
          end
        }
      else block {
        failwith("[ADMIN] You are the admin, you cannot vote.");
       }
     }
     else block {
       failwith("[PAUSED] Vote contract is in its paused state.");
    }
  } with ((nil: list(operation)) , storage)

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
        failwith("[ADMIN] You need admin privileges to run this function.");
      }
  } with ((nil: list(operation)) , storage)

function main (const p : action ; const s : storageType) :
  (list(operation) * storageType) is
  block { skip } with
  case p of
    | Vote(n) -> submitVote(n, s)
    | Reset(n) -> submitReset(s)
  end
