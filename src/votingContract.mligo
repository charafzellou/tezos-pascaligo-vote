type action =
  | Vote of bool
  | Reset of int

type storage =
{
  admin: address;
  paused: bool;
  votes: (address * bool) map;
}

type return = operation list * storage

let isAdmin (storage : storageType) : bool =
  if (storage.admin = sender)
    then True
    else False
    
let setPaused (storage : storageType) : return =
  ([], {storage with admin = storage.admin})

let setAdmin (admin : address)(storage : storageType) : return =
  ([], {storage with admin = storage.admin})
    
let setPaused (storage : storageType) : return =
  ([], {storage with admin = storage.admin})

let submitVote (vote : bool)(storage : storageType) : return =
      let numberVotes : int = 0 in
      let _ = if isPaused(storage) then {
        let _ = if isAdmin(storage) then {
           match storage.votes[sender] with
             | Some (bool) -> failwith("[VOTER] Your address has already voted.")
             | None -> block {
               storage.votes[sender] := vote;
               for i in map storage.votes block {
                 numberVotes := numberVotes + 1;
               };
               if (numberVotes = 10) {
                 storage.paused := True;
               }
            }
        }
      else {
        failwith("[ADMIN] You are the admin, you cannot vote.");
       }
     }
     else {
       failwith("[PAUSED] Vote contract is in its paused state.");
    }


let submitReset (storage : storageType) : return =
    if isAdmin(storage) {
        if isPaused(storage) {
            for i in map storage.votes block {
              remove i from map storage.votes;
            };
            storage.paused := False;
          }
          else {
            failwith("[PAUSED] Vote contract is in its paused state.");
          }
      else {
        failwith("[ADMIN] You need admin privileges to run this function.");
      }
    }

[@entry]
let main (p : action)(s : storageType) : return =
  match p with
    | Vote(n) -> submitVote(n, s)
    | Reset(n) -> submitReset(s)
